module RegFile (
    input clk, reset,
    input RegWrite,
    input [4:0] ReadReg1, ReadReg2, WriteReg,
    input [31:0] WriteData,
    output [31:0] ReadData1, ReadData2
);
    reg [31:0] regs [31:0];
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 0;  // Initialize all registers
        end
        else if (RegWrite && WriteReg != 0) begin
            regs[WriteReg] <= WriteData;  // Skip $0
        end
    end

    assign ReadData1 = (ReadReg1 == 0) ? 0 : regs[ReadReg1];
    assign ReadData2 = (ReadReg2 == 0) ? 0 : regs[ReadReg2];
endmodule