module CommandUnit (
    input [5:0] instructionOpcode,
    input [5:0] instructionFunct,
    output reg useRegDst, useALUSrc, memoryToReg, enableRegWrite, enableMemRead, enableMemWrite, controlBranch, controlJump,
    output reg [3:0] ALUControl
);
    always @(*) begin
        case(instructionOpcode)
            6'b000000: begin
                useRegDst = 1;
                useALUSrc = 0;
                memoryToReg = 0;
                enableRegWrite = 1;
                enableMemRead = 0;
                enableMemWrite = 0;
                controlBranch = 0;
                controlJump = 0;
                ALUControl = 4'b0010;
            end
            6'b100011: begin
                useRegDst = 0;
                useALUSrc = 1;
                memoryToReg = 1;
                enableRegWrite = 1;
                enableMemRead = 1;
                enableMemWrite = 0;
                controlBranch = 0;
                controlJump = 0;
                ALUControl = 4'b0010;
            end
            6'b101011: begin
                useRegDst = 0;
                useALUSrc = 1;
                memoryToReg = 0;
                enableRegWrite = 0;
                enableMemRead = 0;
                enableMemWrite = 1;
                controlBranch = 0;
                controlJump = 0;
                ALUControl = 4'b0010;
            end
            6'b000100: begin
                useRegDst = 0;
                useALUSrc = 0;
                memoryToReg = 0;
                enableRegWrite = 0;
                enableMemRead = 0;
                enableMemWrite = 0;
                controlBranch = 1;
                controlJump = 0;
                ALUControl = 4'b0110;
            end
            6'b000010: begin
                useRegDst = 0;
                useALUSrc = 0;
                memoryToReg = 0;
                enableRegWrite = 0;
                enableMemRead = 0;
                enableMemWrite = 0;
                controlBranch = 0;
                controlJump = 1;
                ALUControl = 4'bxxxx;
            end
            default: begin
                useRegDst = 0;
                useALUSrc = 0;
                memoryToReg = 0;
                enableRegWrite = 0;
                enableMemRead = 0;
                enableMemWrite = 0;
                controlBranch = 0;
                controlJump = 0;
                ALUControl = 4'bxxxx;
            end
        endcase
    end
endmodule
