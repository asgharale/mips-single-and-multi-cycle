module SimulationTestbench;
    reg clock, resetSignal;
    reg [31:0] programCounter;
    wire [31:0] instruction;

    InstructionMemoryUnit dut (
        .programCounter(programCounter),
        .instruction(instruction)
    );

    always #5 clock = ~clock;

    initial begin
        clock = 0;
        resetSignal = 1;
        programCounter = 32'h0;

        #10 resetSignal = 0;

        #10 programCounter = 32'h4;
        #10 programCounter = 32'h8;
        #10 programCounter = 32'hC;
        #10 programCounter = 32'h10;

        #100;
        $finish;
    end

    initial begin
        $dumpfile("simulation_results.vcd");
        $dumpvars(0, SimulationTestbench);
    end
endmodule
