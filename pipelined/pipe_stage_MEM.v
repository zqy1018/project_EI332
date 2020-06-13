`default_nettype none

module pipe_stage_MEM(
    input mem_clock, 
    input resetn, 
    input MEM_wmem, 
    input [31: 0] MEM_datain, 
    input [31: 0] MEM_alu, 
    input [31: 0] real_in_port0, 
    input [31: 0] real_in_port1, 
    
    output wire [31: 0] MEM_mem_out, 
    output wire [31: 0] raw_out_port0,
    output wire [31: 0] raw_out_port1,
    output wire [31: 0] raw_out_port2
);
    // MEM 级

    wire write_enable; 
    wire [31: 0] mem_dataout, io_read_data;
    wire write_data_enable, write_io_enable;

    assign write_enable = MEM_wmem; 
    assign write_data_enable = write_enable & (~ MEM_alu[7]);
    assign write_io_enable = write_enable & MEM_alu[7];
    // 利用 addr[7] 选择 I/O 或者数据存储器

    mux2x32 io_data_mux(
       .a0(mem_dataout), 
       .a1(io_read_data), 
       .sel(MEM_alu[7]), 
       .y(MEM_mem_out)
    );
   
    lpm_ram_dq_dram dram(MEM_alu[6: 2], mem_clock, MEM_datain, write_data_enable, mem_dataout);
    // 利用宏定义的数据存储器
    // WARNING：最好不要改变相关代码

    io_output io_output_reg(
       .addr(MEM_alu), 
       .datain(MEM_datain), 
       .write_io_enable(write_io_enable), 
       .io_clk(mem_clock), 
       .resetn(resetn), 

       .out_port0(raw_out_port0), 
       .out_port1(raw_out_port1), 
       .out_port2(raw_out_port2)
    );
    // 用于完成对 I/O 地址空间的译码，以及构成 I/O 和 CPU 内部之间的数据输出通道
   
    io_input io_input_reg(
       .addr(MEM_alu), 
       .io_clk(mem_clock), 
       .in_port0(real_in_port0), 
       .in_port1(real_in_port1), 
       .resetn(resetn), 

       .io_read_data(io_read_data)
    );
    // 用于完成对 I/O 地址空间的译码，以及构成 I/O 和 CPU 内部之间的数据输入通道

endmodule