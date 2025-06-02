module MemoryUnit (
    input clk,
    input enableMemRead, enableMemWrite,
    input [31:0] addr, dataIn,
    output reg [31:0] dataOut
);
    reg [31:0] storage [0:255];

    always @(posedge clk) begin
        if (enableMemWrite) begin
            storage[addr >> 2] <= dataIn;
        end
        if (enableMemRead) begin
            dataOut <= storage[addr >> 2];
        end
    end
endmodule
