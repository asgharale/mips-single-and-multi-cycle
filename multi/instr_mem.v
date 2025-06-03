// instr_mem.v
// Instruction Memory (read-only) for Multi-Cycle Processor
// Initialized with test instructions as needed.

module instr_mem(
    input  [31:0] address, 
    output [31:0] instr
);
    reg [31:0] memory [255:0];
    initial begin
        // Initialize instruction memory (e.g., from a test program)
        // Example: memory[0] = 32'hXXXXXXXX;
        //memory[0] = 32'h20010005; // addi $1, $0, 5      => $1 = 5
    //    memory[1] = 32'h20020005; // addi $2, $0, 5      => $2 = 5
      //  memory[2] = 32'h10220001; // beq $1, $2, 1       => if equal, branch to PC+8
        //memory[3] = 32'h08000006; // j to address 0x18   => should be skipped
     //   memory[4] = 32'h20030001; // addi $3, $0, 1      => $3 = 1 (if branch taken)
       // memory[5] = 32'h08000006; // j 0x00000018        => HALT loop
    memory[0] = 32'h20010003; // addi $1, $0, 3
    memory[1] = 32'h20020004; // addi $2, $0, 4
    memory[2] = 32'h00221820; // add  $3, $1, $2
    memory[3] = 32'h00000000; // nop
    memory[4] = 32'hfc000000; // HALT (custom pattern)
    end
    // Word-aligned read
    assign instr = memory[address[31:2]];
endmodule

// data_mem.v
// Data Memory for Multi-Cycle Processor
// Supports synchronous write and asynchronous read (word-aligned).

module data_mem(
    input         clk,
    input         MemWrite,
    input  [31:0] address,
    input  [31:0] write_data,
    output [31:0] read_data
);
    reg [31:0] memory [255:0];
    // Write on rising clock edge if enabled
    always @(posedge clk) begin
        if (MemWrite) begin
            memory[address[31:2]] <= write_data;
        end
    end
    // Always output the data at the given address
    assign read_data = memory[address[31:2]];
endmodule
