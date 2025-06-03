module DataMemory (
    input clk,
    input MemRead, MemWrite,
    input [31:0] Address,
    input [31:0] WriteData,
    output [31:0] ReadData
);
    reg [31:0] mem [0:255];  // 256-word memory

    assign ReadData = MemRead ? mem[Address[31:2]] : 0;  // Word-aligned read

    always @(posedge clk) begin
        if (MemWrite)
            mem[Address[31:2]] <= WriteData;  // Word-aligned write
    end
endmodule