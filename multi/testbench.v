`timescale 1ns/1ps

module testbench;
    reg clk, reset;

    // Instantiate the processor
    mips_multicycle dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    // VCD waveform output for GTKWave
    initial begin
        $dumpfile("simulation.vcd");
        $dumpvars(0, testbench);
    end

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        #10;
        reset = 0;

        $display("Time\tPC\tInstr\t\t$1\t$2\t$3");

        // Simulate up to 200 cycles unless HALT is hit
        repeat (200) begin
            @(posedge clk);
            #1;

            $display("%0t\t%h\t%h\t%0d\t%0d\t%0d",
                $time,
                dut.PC,
                dut.Instr,
                dut.dp.regfile_inst.regs[1],
                dut.dp.regfile_inst.regs[2],
                dut.dp.regfile_inst.regs[3]
            );

            // HALT detection: custom instruction fc000000
            if (dut.Instr == 32'hfc000000) begin
                $display("\nHALT instruction encountered at PC = %h", dut.PC);
                if (dut.dp.regfile_inst.regs[3] == 7)
                    $display("✅ PASS: $3 = 7 as expected");
                else
                    $display("❌ FAIL: $3 = %0d (expected 7)", dut.dp.regfile_inst.regs[3]);
                $finish;
            end
        end

        $display("\n❌ FAIL: Simulation timed out without encountering HALT.");
        $finish;
    end
endmodule
