module RegFile (
    input clk, 
    input reset,
    input RegWrite,
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
);
    reg [31:0] regs [31:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            regs[0] <= 0;
            regs[1] <= 0;
            regs[2] <= 0;
            regs[3] <= 0;
            regs[4] <= 0;
            regs[5] <= 0;
            regs[6] <= 0;
            regs[7] <= 0;
            regs[8] <= 0;
            regs[9] <= 0;
            regs[10] <= 0;
            regs[11] <= 0;
            regs[12] <= 0;
            regs[13] <= 0;
            regs[14] <= 0;
            regs[15] <= 0;
            regs[16] <= 0;
            regs[17] <= 0;
            regs[18] <= 0;
            regs[19] <= 0;
            regs[20] <= 0;
            regs[21] <= 0;
            regs[22] <= 0;
            regs[23] <= 0;
            regs[24] <= 0;
            regs[25] <= 0;
            regs[26] <= 0;
            regs[27] <= 0;
            regs[28] <= 0;
            regs[29] <= 0;
            regs[30] <= 0;
            regs[31] <= 0;
        end else if (RegWrite) begin
            regs[WriteReg] <= WriteData;
        end
    end

    assign ReadData1 = regs[ReadReg1];
    assign ReadData2 = regs[ReadReg2];
endmodule
