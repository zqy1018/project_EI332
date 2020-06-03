module sc_datamem (resetn, addr, datain, dataout, we, clock, mem_clk, dmem_clk, 
   out_port0, in_port0);
   // 增加了 2 个 32 位输入端口，3 个 32 位输出端口
 
   input  [31: 0]    addr;
   // 输入的地址
   input  [31: 0]    datain;
   // 外部数据进入数据存储器和 I/O 的接线
   input  [31: 0]    in_port0;
   // 两个 I/O 输入端口
   input             we, clock, mem_clk;
   input             resetn;
   
   output [31: 0]    dataout;
   output            dmem_clk;
   output [31: 0]    out_port0;
   
   wire   [31: 0]    dataout;
	wire              dmem_clk;    
   wire              write_enable; 
   // 写入使能信号
   wire   [31: 0]    mem_dataout;
   wire   [31: 0]    io_read_data;
   // 用于选择输出来源的接线
   wire              write_data_enable;
   // 向数据存储器写入的使能信号
   wire              write_io_enable;
   // 向 I/O 写入的使能信号

   assign            write_enable = we & ~clock; 
   assign            dmem_clk = mem_clk & ( ~ clock) ;
   assign            write_data_enable = write_enable & (~ addr[7]);
   // 相当于选择了数据存储器
   assign            write_io_enable = write_enable & addr[7];
   // 相当于选择了 I/O

   mux2x32           io_data_mux(mem_dataout, io_read_data, addr[7], dataout);
   // 多选器模块的定义：mux2x32 (a0, a1, s, y)
   // 当 s 为 1 时选择 y = a1，否则 y = a0
   
   lpm_ram_dq_dram   dram(addr[6: 2], dmem_clk, datain, write_data_enable, mem_dataout);
   // 利用宏定义的数据存储器

   io_output         io_output_reg(addr, datain, write_io_enable, dmem_clk, out_port0);
   // 用于完成对 I/O 地址空间的译码，以及构成 I/O 和 CPU 内部之间的数据输出通道
   // io_output(addr, datain, write_io_enable, io_clk, out_port0, out_port1, out_port2);
   
   io_input          io_input_reg(addr, dmem_clk, io_read_data, in_port0);
   // 用于完成对 I/O 地址空间的译码，以及构成 I/O 和 CPU 内部之间的数据输入通道
   // io_input(addr, io_clk, io_read_data, in_port0, in_port1);

endmodule 