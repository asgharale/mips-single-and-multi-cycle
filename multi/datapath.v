// datapath.v
// Datapath module for Multi-Cycle MIPS Processor
//
// Contains PC, IR, MDR, register file A/B, ALU, and ALUOut register.
// Controlled by control signals to perform fetch, decode, execute, memory, and write-back steps.

module datapath(
    input         clk,             // clock
    input         reset,           // reset to initialize PC and registers
    input         PCWrite,         // enable PC write
    input         PCWriteCond,     // enable PC write on condition (branch)
    input         IorD,            // 0: use PC for memory addr (fetch), 1: use ALUOut (data access)
    input         MemRead,         // memory read
    input         MemWrite,        // memory write
    input         IRWrite,         // write to instruction register
    input         RegWrite,        // write to register file
    input         RegDst,          // 1: write to rd field, 0: write to rt field
    input         MemtoReg,        // 1: write memory data to reg, 0: write ALUOut to reg
    input         ALUSrcA,         // 0: ALU A = PC, 1: ALU A = A register
    input  [1:0]  ALUSrcB,         // 00: B reg, 01: constant 4, 10: sign-imm, 11: sign-imm<<2
    input  [1:0]  PCSource,        // 00: ALU result (PC+4), 01: ALUOut (branch target), 10: jump address
    input  [2:0]  ALUControl,      // ALU operation code (000=add,001=sub,010=and,011=or,100=slt)
    // Instruction memory interface
    output [31:0] PC,             // current program counter
    output [31:0] IR_out,         // current instruction (for control unit)
    input  [31:0] Instr,          // instruction fetched from instruction memory
    // Data memory interface
    output [31:0] ALUAddr,        // address for data memory (from ALUOut or PC)
    input  [31:0] MemDataIn,      // data read from data memory
    output [31:0] MemDataOut,     // data to write to data memory (from register B)
    output        MemReadOut,     // (unused externally)
    output        MemWriteOut,    // (unused externally)
    output        Zero            // ALU zero flag (for branch)
);

    // Internal registers
    reg [31:0] PC_reg;            // Program Counter register
    reg [31:0] IR;                // Instruction Register
    reg [31:0] MDR;               // Memory Data Register
    reg [31:0] A_reg;             // A register (first ALU operand from regfile)
    reg [31:0] B_reg;             // B register (second ALU operand from regfile)
    reg [31:0] ALUOut;            // ALU Output Register

    // MUX to select destination register (rd or rt)
    wire [4:0] WriteReg = RegDst ? IR[15:11] : IR[20:16];
    // MUX to select data to write to register file (from ALUOut or from memory via MDR)
    wire [31:0] WriteData = MemtoReg ? MDR : ALUOut;

    // Output assignments
    assign PC = PC_reg;
    assign IR_out = IR;
    assign ALUAddr = IorD ? ALUOut : PC_reg;  // Mem address = PC or ALUOut
    assign MemDataOut = B_reg;
    assign MemReadOut = MemRead;
    assign MemWriteOut = MemWrite;

    // Sign-extend immediate
    wire [31:0] SignImm = {{16{IR[15]}}, IR[15:0]};

    // ALU source multiplexers
    wire [31:0] ALU_src_A = ALUSrcA ? A_reg : PC_reg;
    reg  [31:0] ALU_src_B;
    always @(*) begin
        case (ALUSrcB)
            2'b00: ALU_src_B = B_reg;
            2'b01: ALU_src_B = 32'd4;
            2'b10: ALU_src_B = SignImm;
            2'b11: ALU_src_B = SignImm << 2;
            default: ALU_src_B = 32'd0;
        endcase
    end

    // Instantiate ALU
    wire [31:0] ALU_result;
    wire ALU_zero;
    ALU alu_inst (
        .A(ALU_src_A),
        .B(ALU_src_B),
        .ALUControl(ALUControl),
        .Result(ALU_result),
        .Zero(ALU_zero)
    );
    assign Zero = ALU_zero;

    // Instantiate register file
    wire [31:0] rd1, rd2;
    regfile regfile_inst (
        .clk(clk),
        .RegWrite(RegWrite),
        .ra1(IR[25:21]),  // rs
        .ra2(IR[20:16]),  // rt
        .wa(WriteReg),
        .wd(WriteData),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Sequential logic
    // Update PC: either PC+4, branch target, or jump
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC_reg <= 32'b0;
        end else if (PCWrite || (PCWriteCond && ALU_zero)) begin
            case (PCSource)
                2'b00: PC_reg <= ALU_result;  // PC + 4 (ALU result)
                2'b01: PC_reg <= ALUOut;      // branch target (ALUOut computed earlier)
                2'b10: PC_reg <= {PC_reg[31:28], IR[25:0], 2'b00}; // jump
                default: PC_reg <= ALU_result;
            endcase
        end
    end

    // Update IR on fetch
    always @(posedge clk) begin
        if (IRWrite) begin
            IR <= Instr;
        end
    end

    // Update MDR on memory read
    always @(posedge clk) begin
        if (MemRead) begin
            MDR <= MemDataIn;
        end
    end

    // Latch register file outputs into A and B each cycle
    always @(posedge clk) begin
        A_reg <= rd1;
        B_reg <= rd2;
    end

    // Capture ALU result
    always @(posedge clk) begin
        ALUOut <= ALU_result;
    end

endmodule
