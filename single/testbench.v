module testbench;
    reg clk, reset;
    
    TopModule dut (.clk(clk), .reset(reset));
    
    always #5 clk = ~clk;
    
    initial begin
        clk = 0; reset = 1;
        $dumpfile("mips.vcd");
        $dumpvars(0);
        #10 reset = 0;
        
        $display("Time\tPC\t\tInstruction\tReg1\tReg2\tReg3\tALURes\tZero");
        $display("------------------------------------------------------------------");
        
        forever begin
            @(posedge clk);
            #1;
            $display("%0t\t%h\t%h\t%h\t%h\t%h\t%h\t%b", 
                    $time,
                    dut.PC,
                    dut.Instr,
                    dut.regfile.regs[1],
                    dut.regfile.regs[2],
                    dut.regfile.regs[3],
                    dut.alu.ALUResult,
                    dut.alu.Zero);
            
            // Check for halt condition
            if (dut.PC == 32'h00000014 && dut.Instr == 32'h08000005) begin
                $display("\nTest completed:");
                if (dut.regfile.regs[3] == 32'h1)
                    $display("PASS: $3 = 1 (branch taken correctly)");
                else
                    $display("FAIL: $3 = %h (branch failed)", dut.regfile.regs[3]);
                $finish;
            end
            
            if ($time > 200) begin
                $display("Timeout!");
                $finish;
            end
        end
    end
endmodule