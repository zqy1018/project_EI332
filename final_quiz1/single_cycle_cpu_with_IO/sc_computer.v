`default_nettype none

module sc_computer (
    input resetn, 
    input clk,
    
    output wire [31: 0] ZhaoQiYuan
);
    // 第一行对应一些接线，第二行对应 I/O 接口

    wire    [31: 0]     pc, inst, aluout, memout;
    wire                imem_clk, dmem_clk;
    wire    [31: 0]     data;
    wire                wmem; 
    wire                clock_out, mem_clk;
    wire    [31: 0]     out_port0;

    clock_and_mem_clock inst3(
        .main_clk(clk), 
        .clock_out(clock_out), 
        .mem_clk(mem_clk)
    );

    sc_computer_main    inst4(
        .resetn(resetn), 
        .clock(clock_out), 
        .mem_clk(mem_clk), 

        .pc(pc), 
        .inst(inst), 
        .aluout(aluout), 
        .memout(memout), 
        .imem_clk(imem_clk), 
        .dmem_clk(dmem_clk), 
        .out_port0(ZhaoQiYuan)
    );

    // assign ZhaoQiYuan = out_port0;
    // out_port_seg(data_in, led_out_ten, led_out_mod);

endmodule

// Connected to dangling logic. Logic that only feeds a dangling port will be removed.
