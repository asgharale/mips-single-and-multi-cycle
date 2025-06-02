module ExecutionUnit (
    input clk, reset,
    input enableRegWrite, selectALUSrc, selectMemToReg,
    input enableMemRead, enableMemWrite, controlBranch, controlJump,
    input [3:0] ALUOperation,
    input [31:0] instruction,
    output [31:0] currentPC
);
    wire [31:0] readData1, readData2, ALUOutput, memoryData;
    wire [4:0] destinationReg;
    wire isZero;

    RegisterFile registerFile (
        .clk(clk),
        .reset(reset),
        .enableRegWrite(enableRegWrite),
        .readReg1(instruction[25:21]),
        .readReg2(instruction[20:16]),
        .writeReg(destinationReg),
        .writeData(selectMemToReg ? memoryData : ALUOutput),
        .readData1(readData1),
        .readData2(readData2)
    );

    // ALU (Arithmetic Logic Unit)
    ArithmeticUnit alu (
        .operand1(readData1),
        .operand2(selectALUSrc ? instruction[15:0] : readData2),
        .operation(ALUOperation),
        .result(ALUOutput),
        .isZero(isZero)
    );

    InstructionMemory instructionMemory (
        .PC(currentPC),
        .Instr(instruction)
    );

    MemoryUnit memoryUnit (
        .clk(clk),
        .enableMemRead(enableMemRead),
        .enableMemWrite(enableMemWrite),
        .addr(ALUOutput),
        .dataIn(readData2),
        .dataOut(memoryData)
    );

    CommandUnit commandUnit (
        .instructionOpcode(instruction[31:26]),
        .instructionFunct(instruction[5:0]),
        .useRegDst(),
        .useALUSrc(),
        .memoryToReg(),
        .enableRegWrite(),
        .enableMemRead(),
        .enableMemWrite(),
        .controlBranch(),
        .controlJump(),
        .ALUControl()
    );

    assign destinationReg = (instruction[31:26] == 6'b000000) ? instruction[15:11] : instruction[20:16];
    assign currentPC = (controlBranch && isZero) ? (currentPC + (instruction[15:0] << 2)) : (currentPC + 4);

endmodule
