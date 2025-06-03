// control.v
// Microprogrammed Control Unit for Multi-Cycle MIPS Processor
// Generates control signals for each microcycle state.

module control(
    input         clk,
    input         reset,
    input  [31:0] IR,          // instruction register
    input         Zero,        // ALU zero flag (for branch)
    output reg    PCWrite,
    output reg    PCWriteCond,
    output reg    IorD,
    output reg    MemRead,
    output reg    MemWrite,
    output reg    IRWrite,
    output reg    RegDst,
    output reg    MemtoReg,
    output reg    RegWrite,
    output reg    ALUSrcA,
    output reg [1:0] ALUSrcB,
    output reg [1:0] PCSource,
    output reg [2:0] ALUControl
);
    // State encoding
    parameter FETCH     = 4'd0;
    parameter DECODE    = 4'd1;
    parameter R_EXEC    = 4'd2;
    parameter R_WRITE   = 4'd3;
    parameter I_EXEC    = 4'd4;
    parameter MEM_ACCESS= 4'd5;
    parameter I_WRITE   = 4'd6;
    parameter BRANCH    = 4'd7;
    parameter JUMP      = 4'd8;

    reg [3:0] state, next_state;

    // Sequential state register
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= FETCH;
        else
            state <= next_state;
    end

    // Next-state logic and control outputs
    always @(*) begin
        // Default: all control signals low
        PCWrite      = 1'b0;
        PCWriteCond  = 1'b0;
        IorD         = 1'b0;
        MemRead      = 1'b0;
        MemWrite     = 1'b0;
        IRWrite      = 1'b0;
        RegDst       = 1'b0;
        MemtoReg     = 1'b0;
        RegWrite     = 1'b0;
        ALUSrcA      = 1'b0;
        ALUSrcB      = 2'b00;
        PCSource     = 2'b00;
        ALUControl   = 3'b000;
        next_state   = FETCH;

        case (state)
            FETCH: begin
                // Fetch instruction: M[PC] -> IR, PC <- PC+4
                MemRead   = 1'b1;
                IRWrite   = 1'b1;
                ALUSrcA   = 1'b0;
                ALUSrcB   = 2'b01;    // add 4
                ALUControl= 3'b000;   // add
                PCWrite   = 1'b1;
                next_state= DECODE;
            end

            DECODE: begin
                // Decode: compute branch target (ALUOut = PC + imm<<2)
                ALUSrcA   = 1'b0;
                ALUSrcB   = 2'b11;    // sign-imm << 2
                ALUControl= 3'b000;   // add
                // Dispatch based on opcode
                case (IR[31:26])
                    6'b000000: next_state = R_EXEC;    // R-type
                    6'b100011: next_state = I_EXEC;    // lw
                    6'b101011: next_state = I_EXEC;    // sw
                    6'b000100: next_state = BRANCH;    // beq
                    6'b001000: next_state = I_EXEC;    // addi
                    6'b000010: next_state = JUMP;      // j
                    default:   next_state = FETCH;
                endcase
            end

            R_EXEC: begin
                // R-type ALU execution: A op B
                ALUSrcA   = 1'b1;      // use register A = rs
                ALUSrcB   = 2'b00;     // use register B = rt
                // Determine ALU operation from funct field
                case (IR[5:0])
                    6'b100000: ALUControl = 3'b000; // add
                    6'b100010: ALUControl = 3'b001; // sub
                    6'b100100: ALUControl = 3'b010; // and
                    6'b100101: ALUControl = 3'b011; // or
                    6'b101010: ALUControl = 3'b100; // slt
                    default:   ALUControl = 3'b000;
                endcase
                next_state = R_WRITE;
            end

            R_WRITE: begin
                // Write result of R-type to regfile
                RegWrite  = 1'b1;
                RegDst    = 1'b1;      // write to rd
                MemtoReg  = 1'b0;      // from ALUOut
                next_state= FETCH;
            end

            I_EXEC: begin
                // I-type execution (lw/sw: compute address, addi: compute sum)
                ALUSrcA   = 1'b1;      // use register A = rs
                ALUSrcB   = 2'b10;     // sign-extended immediate
                ALUControl= 3'b000;    // add
                case (IR[31:26])
                    6'b100011: next_state = MEM_ACCESS; // lw
                    6'b101011: next_state = MEM_ACCESS; // sw
                    default:   next_state = I_WRITE;    // addi
                endcase
            end

            MEM_ACCESS: begin
                // Memory access for lw/sw
                IorD      = 1'b1;      // use ALUOut as address
                case (IR[31:26])
                    6'b100011: begin      // lw
                        MemRead = 1'b1;
                        next_state = I_WRITE;
                    end
                    6'b101011: begin      // sw
                        MemWrite= 1'b1;
                        next_state = FETCH;
                    end
                    default: begin
                        next_state = FETCH;
                    end
                endcase
            end

            I_WRITE: begin
                // Write-back for lw or addi
                RegWrite  = 1'b1;
                RegDst    = 1'b0;     // write to rt
                if (IR[31:26] == 6'b100011) begin
                    // lw
                    MemtoReg = 1'b1;  // write MDR
                end else begin
                    // addi
                    MemtoReg = 1'b0;  // write ALUOut
                end
                next_state = FETCH;
            end

            BRANCH: begin
                // Branch equal: if Zero, PC <- branch target
                PCWriteCond = 1'b1;
                PCSource    = 2'b01; // select ALUOut (branch target)
                next_state  = FETCH;
            end

            JUMP: begin
                // Jump: PC <- {PC+4[31:28], instr_index, 2'b00}
                PCWrite  = 1'b1;
                PCSource = 2'b10;
                next_state = FETCH;
            end

            default: begin
                next_state = FETCH;
            end
        endcase
    end

endmodule
