module Control (
    input [5:0] Opcode,
    output reg RegDst, ALUSrc, MemToReg, RegWrite,
    output reg MemRead, MemWrite, Branch, Jump,
    output reg [3:0] ALUOp
);
    always @(*) begin
        case (Opcode)
            6'b000000: begin // R-type
                RegDst = 1; ALUSrc = 0; MemToReg = 0;
                RegWrite = 1; MemRead = 0; MemWrite = 0;
                Branch = 0; Jump = 0; ALUOp = 4'b0010;
            end
            6'b100011: begin // lw
                RegDst = 0; ALUSrc = 1; MemToReg = 1;
                RegWrite = 1; MemRead = 1; MemWrite = 0;
                Branch = 0; Jump = 0; ALUOp = 4'b0010;
            end
            6'b101011: begin // sw
                RegDst = 0; ALUSrc = 1; MemToReg = 0;
                RegWrite = 0; MemRead = 0; MemWrite = 1;
                Branch = 0; Jump = 0; ALUOp = 4'b0010;
            end
            6'b000100: begin // beq
                RegDst = 0; ALUSrc = 0; MemToReg = 0;
                RegWrite = 0; MemRead = 0; MemWrite = 0;
                Branch = 1; Jump = 0; ALUOp = 4'b0110;
            end
            6'b000010: begin // j
                RegDst = 0; ALUSrc = 0; MemToReg = 0;
                RegWrite = 0; MemRead = 0; MemWrite = 0;
                Branch = 0; Jump = 1; ALUOp = 4'b0000;
            end
            default: begin // Default (addi-like)
                RegDst = 0; ALUSrc = 1; MemToReg = 0;
                RegWrite = 1; MemRead = 0; MemWrite = 0;
                Branch = 0; Jump = 0; ALUOp = 4'b0010;
            end
        endcase
    end
endmodule