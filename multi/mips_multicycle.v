// mips_multicycle.v
// Top-level module for the Multi-Cycle MIPS Processor (Verilog).
// Instantiates the datapath, control unit, and memory modules.

module mips_multicycle(
    input        clk,
    input        reset
);
    // Wires for interconnecting modules
    wire [31:0] PC, Instr, ALUAddr, MemDataOut, MemDataIn, IR;
    wire Zero;
    // Control signals
    wire PCWrite, PCWriteCond, IorD, MemRead, MemWrite, IRWrite, RegDst, MemtoReg, RegWrite, ALUSrcA;
    wire [1:0] ALUSrcB, PCSource;
    wire [2:0] ALUControl;

    // Instantiate the Control Unit
    control ctrl_unit(
        .clk(clk),
        .reset(reset),
        .IR(IR),
        .Zero(Zero),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .IorD(IorD),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .PCSource(PCSource),
        .ALUControl(ALUControl)
    );

    // Instruction Memory (read-only)
    instr_mem instr_memory(
        .address(PC),
        .instr(Instr)
    );

    // Datapath
    datapath dp(
        .clk(clk),
        .reset(reset),
        .PCWrite(PCWrite),
        .PCWriteCond(PCWriteCond),
        .IorD(IorD),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .RegWrite(RegWrite),
        .RegDst(RegDst),
        .MemtoReg(MemtoReg),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .PCSource(PCSource),
        .ALUControl(ALUControl),
        .PC(PC),
        .IR_out(IR),
        .Instr(Instr),
        .ALUAddr(ALUAddr),
        .MemDataIn(MemDataIn),
        .MemDataOut(MemDataOut),
        .MemReadOut(),       // not used externally
        .MemWriteOut(),      // not used externally
        .Zero(Zero)
    );

    // Data Memory
    data_mem data_memory(
        .clk(clk),
        .MemWrite(MemWrite),
        .address(ALUAddr),
        .write_data(MemDataOut),
        .read_data(MemDataIn)
    );

endmodule
