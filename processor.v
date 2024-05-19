module processor;
    reg [31:0] pc; // 32-bit program counter
    reg clk; // clock
    reg [7:0] datmem[0:31], mem[0:31]; // data and instruction memory
    wire [31:0] dataa, datab, out2, out3, out4, out5, sum, extad, extzero, adder1out, adder2out, sextad;
    wire [5:0] inst31_26; // instruction[31:26]
    wire [4:0] inst25_21, inst20_16, inst15_11, out1; // instruction parts
    wire [15:0] inst15_0; // instruction[15:0]
    wire [31:0] instruc, dpack; // instruction and data memory outputs
    wire [2:0] gout; // ALU control output
    wire zout, pcsrc, not_zout, brnv_mux_out; // zero and branch signals
    wire regdest, alusrc, memtoreg, regwrite, memread, memwrite, branch, brnv, aluop1, aluop0; // control signals

    // Register file and other initializations
    reg [31:0] registerfile[0:31];
    integer i;

	reg status_register[0:2];

<<<<<<< Updated upstream
	always @(posedge clk)
        begin
			status[0]=zout;
			status[1]=sum[31];
			status[2]=overflow;
        end
=======
wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [2:0] gout;	//Output of ALU control unit

wire zout,	//Zero output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop0;

//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];
//Z, N, V flags
reg [2:0];
integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];
>>>>>>> Stashed changes


    // Data memory write
    always @(posedge clk)
        if (memwrite) begin
            datmem[sum[4:0]+3] = datab[7:0];
            datmem[sum[4:0]+2] = datab[15:8];
            datmem[sum[4:0]+1] = datab[23:16];
            datmem[sum[4:0]] = datab[31:24];
        end

    // Instruction memory fetch
    assign instruc = {mem[pc[4:0]], mem[pc[4:0]+1], mem[pc[4:0]+2], mem[pc[4:0]+3]};
    assign inst31_26 = instruc[31:26];
    assign inst25_21 = instruc[25:21];
    assign inst20_16 = instruc[20:16];
    assign inst15_11 = instruc[15:11];
    assign inst15_0 = instruc[15:0];

    // Register file read
    assign dataa = registerfile[inst25_21];
    assign datab = registerfile[inst20_16];
    always @(posedge clk)
        registerfile[out1] = regwrite ? out3 : registerfile[out1];

    // Data memory read
    assign dpack = {datmem[sum[5:0]], datmem[sum[5:0]+1], datmem[sum[5:0]+2], datmem[sum[5:0]+3]};

    // MUXes
    mult2_to_1_5 mult1(out1, instruc[20:16], instruc[15:11], regdest);
    mult2_to_1_32 mult2(out2, datab, out5, alusrc);
    mult2_to_1_32 mult3(out3, sum, dpack, memtoreg);
    mult2_to_1_32 mult4(out4, adder1out, adder2out, pcsrc);
    mult2_to_1_32 mult5(out5, extad, extzero, ori);

    // Program counter update
    always @(negedge clk)
        pc = out4;

    // ALU, adder, and control logic connections
    alu32 alu1(sum, dataa, out2, zout, gout);
    adder add1(pc, 32'h4, adder1out);
    adder add2(adder1out, sextad, adder2out);
    control cont(instruc[31:26], regdest, alusrc, memtoreg, regwrite, memread, memwrite, branch, brnv, aluop1, aluop0);
    signext sext(instruc[15:0], extad);
    alucont acont(aluop1, aluop0, instruc[3], instruc[2], instruc[1], instruc[0], gout);
    shift shift2(sextad, extad);

    // BRNV logic
    assign not_zout = ~zout;
    assign brnv_mux_out = brnv ? not_zout : zout;
    assign pcsrc = (branch & brnv_mux_out);

    // Initialization
    initial begin
        $readmemh("initDm.dat", datmem);
        $readmemh("initIM.dat", mem);
        $readmemh("initReg.dat", registerfile);

        for (i = 0; i < 31; i = i + 1)
            $display("Instruction Memory[%0d]= %h  ", i, mem[i], "Data Memory[%0d]= %h   ", i, datmem[i], "Register[%0d]= %h", i, registerfile[i]);
    end

    initial begin
        pc = 0;
        #400 $finish;
    end

    initial begin
        clk = 0;
        forever #20 clk = ~clk;
    end

    initial begin
        $monitor($time, "PC %h", pc, "  SUM %h", sum, "   INST %h", instruc[31:0], "   REGISTER %h %h %h %h ", registerfile[4], registerfile[5], registerfile[6], registerfile[1]);
    end
endmodule
