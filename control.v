module control(
    input [5:0] in,
    output regdest, alusrc, memtoreg, regwrite, memread, memwrite, branch, brnv, aluop1, aluop2, ori
);
    wire rformat, lw, sw, beq, brnv_signal;
    
    assign rformat = ~|in;
    assign lw = in[5] & (~in[4]) & (~in[3]) & (~in[2]) & in[1] & in[0];
    assign sw = in[5] & (~in[4]) & in[3] & (~in[2]) & in[1] & in[0];
    assign beq = ~in[5] & (~in[4]) & (~in[3]) & in[2] & (~in[1]) & (~in[0]);
    assign brnv_signal = (~in[5]) & (in[4]) & (~in[3]) & (in[2]) & (~in[1]) & in[0]; // Example opcode for BRNV
    assign ori = (~in[5]) & (~in[4]) & (in[3]) & (in[2]) & (~in[1]) & (in[0]);
    
    assign regdest = rformat;
    assign alusrc = lw | sw;
    assign memtoreg = lw;
    assign regwrite = rformat | lw;
    assign memread = lw;
    assign memwrite = sw;
    assign branch = beq;
    assign brnv = brnv_signal;
    assign aluop1 = rformat;
    assign aluop2 = beq | brnv_signal;
    assign ori = ori;
endmodule
