module MIPS (
    input clk, reset
);
    wire [31:0] PC, Instr, ReadData1, ReadData2, ALUResult, MemData, MemToRegData;
    wire [4:0] WriteReg;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [3:0] ALUOp;
    wire Zero;
    wire [31:0] SignImm;

    // Sign extension for the immediate field
    assign SignImm = {{16{Instr[15]}}, Instr[15:0]};  // Sign extend the immediate field

    RegFile regfile (clk, reset, RegWrite, Instr[25:21], Instr[20:16], WriteReg, MemToRegData, ReadData1, ReadData2);
    InstrMemory imem (PC, Instr);
    ALU alu (ReadData1, ALUSrc ? SignImm : ReadData2, ALUOp, ALUResult, Zero);
    Control control (Instr[31:26], RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUOp);
    DataMemory dmem (clk, MemRead, MemWrite, ALUResult, ReadData2, MemData);

    assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];
    assign PC = (Branch && Zero) ? (PC + (SignImm << 2)) : (PC + 4);  // Use sign-extended immediate for branch
    assign MemToRegData = MemToReg ? MemData : ALUResult;

endmodule
