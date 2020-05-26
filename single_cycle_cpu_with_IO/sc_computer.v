module sc_computer (resetn, clk, 
    sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw8, sw9,
    HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    // 第一行对应一些接线，第二行对应 I/O 接口
   
    input               resetn, clk;
    input               sw0, sw1, sw2, sw3, sw4, sw5, sw6, sw7, sw8, sw9;

    output  [6: 0]      HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

    wire    [31: 0]     pc, inst, aluout, memout;
    wire                imem_clk, dmem_clk;
    wire    [31: 0]     data;
    wire                wmem; 
    wire                clock_out, mem_clk;
    wire    [31: 0]     in_port0, in_port1;
    wire    [31: 0]     out_port0, out_port1, out_port2;

    in_port             inst1(sw0, sw1, sw2, sw3, sw4, in_port1);
    in_port             inst2(sw5, sw6, sw7, sw8, sw9, in_port0);

    clock_and_mem_clock inst3(clk, clock_out, mem_clk);
    // clock_and_mem_clock(main_clk, clock_out, mem_clk);

    sc_computer_main    inst4(resetn, clock_out, mem_clk, pc, inst, aluout, memout, imem_clk, dmem_clk, 
                                in_port0, in_port1, out_port0, out_port1, out_port2);
    // sc_computer_main (resetn, clock, mem_clk, pc, inst, aluout, memout, imem_clk, dmem_clk, 
    // in_port0, in_port1, out_port0, out_port1, out_port2, 
    // mem_dataout, io_read_data);

    out_port_seg        inst5(out_port0, HEX1, HEX0);
    out_port_seg        inst6(out_port1, HEX3, HEX2);
    out_port_seg        inst7(out_port2, HEX5, HEX4);
    // out_port_seg(data_in, led_out_ten, led_out_mod);

endmodule

// Connected to dangling logic. Logic that only feeds a dangling port will be removed.
