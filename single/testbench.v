module testbench;
    reg clk, reset;
    reg [31:0] PC;
    wire [31:0] Instr;

    InstrMemory dut (
        .PC(PC),
        .Instr(Instr)
    );

    always #5 clk = ~clk;  // Clock with a period of 10 time units

    // Apply reset and test the design with random inputs
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        PC = 32'h0;  // Initialize PC to 0 (start from the first instruction)

        // Apply reset for some time
        #5 reset = 1;
        #10 reset = 0; // Apply reset for enough time

        // Simulate some PC changes
        #10 PC = 32'h4;
        #10 PC = 32'h8;
        #10 PC = 32'hC;
        #10 PC = 32'h10;

        // Optionally simulate a branch or jump (this part is random too)
        #20 PC = 32'h20; // Jump to a new location (example of a jump)

        #100;  // Wait for 100 time units
        $finish; // Finish the simulation
    end

    // Monitor signal values to help debug
    initial begin
        $monitor("At time %0t: PC = %h, Instr = %h, reset = %b", $time, PC, Instr, reset);
    end

    // Generate the VCD file for waveform visualization
    initial begin
        $dumpfile("simulation.vcd");  // The VCD output file name
        $dumpvars(0, testbench);      // Dump all variables in the testbench
    end
endmodule
