// register_file.v
// 32x32 Register File (MIPS) for Multi-Cycle Processor
// Register 0 is hardwired to 0.

module regfile(
    input         clk,
    input         RegWrite,
    input  [4:0]  ra1,    // read address 1 (rs)
    input  [4:0]  ra2,    // read address 2 (rt)
    input  [4:0]  wa,     // write address (rd or rt)
    input  [31:0] wd,     // write data
    output [31:0] rd1,    // read data 1
    output [31:0] rd2     // read data 2
);
    reg [31:0] regs [31:0];
    integer i;
    initial begin
        // Initialize registers to zero (R0 remains 0 always)
        for (i = 0; i < 32; i = i + 1) begin
            regs[i] = 32'd0;
        end
    end

    // Combinational read ports
    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

    // Synchronous write port
    always @(posedge clk) begin
        if (RegWrite && (wa != 0)) begin
            regs[wa] <= wd;
        end
    end
endmodule
