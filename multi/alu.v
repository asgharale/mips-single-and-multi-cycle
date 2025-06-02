module ALU (
    input [31:0] A, B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero
);
    always @(*) begin
        case(ALUControl)
            4'b0000: ALUResult = A & B;
            4'b0001: ALUResult = A | B;
            4'b0010: ALUResult = A + B;
            4'b0110: ALUResult = A - B;
            4'b0111: ALUResult = (A < B) ? 1 : 0;
            default: ALUResult = 0;
        endcase
        Zero = (ALUResult == 0);
    end
endmodule
