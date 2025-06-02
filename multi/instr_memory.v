module InstructionMemoryUnit (
    input [31:0] programCounter, 
    output [31:0] instruction
);
    reg [31:0] instructionMemory [0:255];

    initial begin
        instructionMemory[0] = 32'b00000000000000010000000000100000;
        instructionMemory[1] = 32'b10001100000000010000000000000100;
        instructionMemory[2] = 32'b10101100001000100000000000000000;
        instructionMemory[3] = 32'b00010000001000100000000000000000;
        instructionMemory[4] = 32'b00001000000000000000000000000000;
    end

    assign instruction = instructionMemory[programCounter >> 2];
endmodule
