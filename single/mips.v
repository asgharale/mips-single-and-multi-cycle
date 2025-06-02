module TopModule (
    input clk,
    input reset
);
    wire [31:0] PC, Instr, ReadData1, ReadData2, ALUResult, MemData;
    wire [4:0] WriteReg;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [3:0] ALUOp;
    wire Zero;

    RegFile regfile (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .ReadReg1(Instr[25:21]),
        .ReadReg2(Instr[20:16]),
        .WriteReg(WriteReg),
        .WriteData(ALUResult),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    
    InstrMemory imem (
        .PC(PC),
        .Instr(Instr)
    );
    
    ALU alu (
        .A(ReadData1),
        .B(ALUSrc ? Instr[15:0] : ReadData2),
        .ALUControl(ALUOp),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    
    Control control (
        .Opcode(Instr[31:26]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );
    
    DataMemory dmem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemData)
    );

    assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
    assign PC = (Branch && Zero) ? (PC + (Instr[15:0] << 2)) : (PC + 4);
    assign MemToRegData = MemToReg ? MemData : ALUResult;

endmodule
