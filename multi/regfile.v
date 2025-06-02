module RegisterBank (
    input clk, reset,
    input enableWrite,
    input [4:0] readReg1, readReg2, writeReg,
    input [31:0] dataToWrite,
    output [31:0] dataOut1, dataOut2
);
    reg [31:0] registers [31:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            registers[0] <= 32'b0;
            registers[1] <= 32'b0;
            registers[2] <= 32'b0;
            registers[3] <= 32'b0;
            registers[4] <= 32'b0;
            registers[5] <= 32'b0;
            registers[6] <= 32'b0;
            registers[7] <= 32'b0;
            registers[8] <= 32'b0;
            registers[9] <= 32'b0;
            registers[10] <= 32'b0;
            registers[11] <= 32'b0;
            registers[12] <= 32'b0;
            registers[13] <= 32'b0;
            registers[14] <= 32'b0;
            registers[15] <= 32'b0;
            registers[16] <= 32'b0;
            registers[17] <= 32'b0;
            registers[18] <= 32'b0;
            registers[19] <= 32'b0;
            registers[20] <= 32'b0;
            registers[21] <= 32'b0;
            registers[22] <= 32'b0;
            registers[23] <= 32'b0;
            registers[24] <= 32'b0;
            registers[25] <= 32'b0;
            registers[26] <= 32'b0;
            registers[27] <= 32'b0;
            registers[28] <= 32'b0;
            registers[29] <= 32'b0;
            registers[30] <= 32'b0;
            registers[31] <= 32'b0;
        end else if (enableWrite) begin
            registers[writeReg] <= dataToWrite;
        end
    end

    assign dataOut1 = registers[readReg1];
    assign dataOut2 = registers[readReg2];
endmodule
