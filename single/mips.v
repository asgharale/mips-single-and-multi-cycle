module TopModule (
    input clk,
    input reset
);
    wire [31:0] Instr, ReadData1, ReadData2, ALUResult, MemData, MemToRegData;
    wire [4:0] WriteReg;
    wire RegDst, ALUSrc, MemToReg, RegWrite, MemRead, MemWrite, Branch, Jump;
    wire [3:0] ALUOp;
    wire Zero;
    wire [31:0] SignImm;

    reg [31:0] PC;
    reg [31:0] PCNext;

    // Sign-extend immediate
    assign SignImm = {{16{Instr[15]}}, Instr[15:0]};

    // Register File
    RegFile regfile (
        .clk(clk),
        .reset(reset),
        .RegWrite(RegWrite),
        .ReadReg1(Instr[25:21]),
        .ReadReg2(Instr[20:16]),
        .WriteReg(WriteReg),
        .WriteData(MemToRegData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
    );
    
    // Instruction Memory
    InstrMemory imem (
        .PC(PC),
        .Instr(Instr)
    );
    
    // ALU
    ALU alu (
        .A(ReadData1),
        .B(ALUSrc ? SignImm : ReadData2),
        .ALUControl(ALUOp),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );
    
    // Control Unit
    Control control (
        .Opcode(Instr[31:26]),
        .RegDst(RegDst),
        .ALUSrc(ALUSrc),
        .MemToReg(MemToReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );
    
    // Data Memory
    DataMemory dmem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Address(ALUResult),
        .WriteData(ReadData2),
        .ReadData(MemData)
    );

    // Write register selection
    assign WriteReg = RegDst ? Instr[15:11] : Instr[20:16];

    // PCNext logic
    always @(*) begin
        if (reset) begin
            PCNext = 32'b0;
        end
        else if (Jump) begin
            PCNext = {PC[31:28], Instr[25:0], 2'b00};  // Jump
        end 
        else if (Branch && Zero) begin
            PCNext = PC + 4 + (SignImm << 2);  // Branch
        end 
        else begin
            PCNext = PC + 4;  // Default
        end
    end

    // PC update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 32'b0;
        end else begin
            PC <= PCNext;
        end
    end

    // Data write-back
    assign MemToRegData = MemToReg ? MemData : ALUResult;
endmodule