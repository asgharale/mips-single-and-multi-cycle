// alu.v
// ALU module for Multi-Cycle MIPS Processor
// Supports add, sub, and, or, slt operations.

module ALU(
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUControl,
    output reg [31:0] Result,
    output Zero
);
    always @(*) begin
        case (ALUControl)
            3'b000: Result = A + B;                 // add
            3'b001: Result = A - B;                 // sub
            3'b010: Result = A & B;                 // and
            3'b011: Result = A | B;                 // or
            3'b100: Result = (A < B) ? 32'd1 : 32'd0; // slt (signed compare)
            default: Result = 32'd0;
        endcase
    end
    assign Zero = (Result == 32'd0);
endmodule
