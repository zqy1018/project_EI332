`default_nettype none

module sc_datamem (
   input resetn, 
   input we, 
   input clock, 
   input mem_clk, 
   input [31: 0] addr, 
   input [31: 0] datain, 
   input [31: 0] in_port0, 
   input [31: 0] in_port1, 

   output wire dmem_clk, 
   output wire [31: 0] dataout, 
   output wire [31: 0] out_port0, 
   output wire [31: 0] out_port1, 
   output wire [31: 0] out_port2
);
   // 数据存储器模块
   // 增加了 2 个 32 位输入端口，3 个 32 位输出端口
 
   wire write_enable; 
   // 写入使能信号
   wire [31: 0] mem_dataout;
   wire [31: 0] io_read_data;
   // 用于选择输出来源的接线
   wire write_data_enable;
   // 向数据存储器写入的使能信号
   wire write_io_enable;
   // 向 I/O 写入的使能信号

   assign write_enable = we & ~clock; 
   assign dmem_clk = mem_clk & (~ clock) ;
   assign write_data_enable = write_enable & (~ addr[7]);
   // 相当于选择了数据存储器
   assign write_io_enable = write_enable & addr[7];
   // 相当于选择了 I/O

   mux2x32 io_data_mux(
      .a0(mem_dataout), 
      .a1(io_read_data), 
      .sel(addr[7]), 
      .y(dataout)
   );
   // 多选器模块的定义：mux2x32 (a0, a1, s, y)
   // 当 s 为 1 时选择 y = a1，否则 y = a0
   
   lpm_ram_dq_dram dram(addr[6: 2], dmem_clk, datain, write_data_enable, mem_dataout);
   // 利用宏定义的数据存储器
   // WARNING：最好不要改变相关代码

   io_output io_output_reg(
      .addr(addr), 
      .datain(datain), 
      .write_io_enable(write_io_enable), 
      .io_clk(dmem_clk), 
      .out_port0(out_port0), 
      .out_port1(out_port1), 
      .out_port2(out_port2)
   );
   // 用于完成对 I/O 地址空间的译码，以及构成 I/O 和 CPU 内部之间的数据输出通道
   
   io_input io_input_reg(
      .addr(addr), 
      .io_clk(dmem_clk), 
      .io_read_data(io_read_data), 
      .in_port0(in_port0), 
      .in_port1(in_port1)
   );
   // 用于完成对 I/O 地址空间的译码，以及构成 I/O 和 CPU 内部之间的数据输入通道

endmodule 