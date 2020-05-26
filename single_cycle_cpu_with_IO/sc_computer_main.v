module sc_computer_main (resetn, clock, mem_clk, pc, inst, aluout, memout, imem_clk, dmem_clk, 
    in_port0, in_port1, out_port0, out_port1, out_port2);
   
    input               resetn, clock, mem_clk; 
    input   [31: 0]     in_port0, in_port1;

    // 现在由 clock_and_mem_clock 产生
    output  [31: 0]     pc, inst, aluout, memout;
    output              imem_clk, dmem_clk;
    output  [31: 0]     out_port0, out_port1, out_port2;
    // TODO：这里要不要把 mem_out 什么的加上去？
    
    wire    [31: 0]     pc, inst, aluout, memout;
    wire                imem_clk, dmem_clk;
    wire    [31: 0]     out_port0, out_port1, out_port2;
    wire    [31: 0]     data;
    wire                wmem; 

    sc_cpu              cpu(clock, resetn, inst, memout, pc, wmem, aluout, data); 
    // sc_cpu(clock, resetn, inst, mem, pc, wmem, alu, data);
    sc_instmem          imem(pc, inst, clock, mem_clk, imem_clk); 
    sc_datamem          dmem(resetn, aluout, data, memout, wmem, clock, mem_clk, dmem_clk, 
                            out_port0, out_port1, out_port2, in_port0, in_port1); 
    // sc_datamem (addr, datain, dataout, we, clock, mem_clk, dmem_clk, 
    // out_port0, out_port1, out_port2, in_port0, in_port1, 
    // mem_dataout, io_read_data);

endmodule

