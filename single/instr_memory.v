module InstrMemory (
    input [31:0] PC,
    output [31:0] Instr
);
    reg [31:0] mem [0:255];

    initial begin
        // Test program:
        mem[0] = 32'h20010005;  // addi $1, $0, 5     ($1 = 5)
        mem[1] = 32'h20020005;  // addi $2, $0, 5     ($2 = 5)
        mem[2] = 32'h10220001;  // beq $1, $2, 1     (Branch to PC+4+4 if $1==$2)
        mem[3] = 32'h08000003;  // j 0x0000000C      (Jump to halt if branch fails)
        mem[4] = 32'h20030001;  // addi $3, $0, 1    ($3 = 1, branch taken)
        //mem[5] = 32'h08000005;  // j 0x00000014      (Infinite halt)
        
    end

    assign Instr = mem[PC[31:2]];
endmodule