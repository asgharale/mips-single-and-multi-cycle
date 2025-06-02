module DataMemory (
    input clk,
    input MemRead, MemWrite,
    input [31:0] Address, WriteData,
    output reg [31:0] ReadData
);
    reg [31:0] mem [0:255];

    always @(posedge clk) begin
        if (MemWrite) begin
            mem[Address] <= WriteData;
        end
        if (MemRead) begin
            ReadData <= mem[Address];
        end
    end
endmodule
