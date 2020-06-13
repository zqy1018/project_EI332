`default_nettype none

module regfile (
    input [4: 0] reg_n1,
    input [4: 0] reg_n2, 
    input [31: 0] d, 
    input write_enable, 
    input [4: 0] write_reg_number, 
    input clk, 
    input clrn, 
    
    output wire [31: 0] q1, 
    output wire [31: 0] q2
);
    // 寄存器堆模块
   
    reg [31: 0] register [1: 31];
    // 1 到 31 号寄存器
    // 0 号并不显式定义，采用硬编码实现读
   
    assign q1 = (reg_n1 == 0) ? 0 : register[reg_n1];
    assign q2 = (reg_n2 == 0) ? 0 : register[reg_n2];
    // 采用组合逻辑的方式读

    always @ (posedge clk or negedge clrn)
    begin
        if (clrn == 0) 
        begin 
            integer i;
            for (i = 1; i < 32; i = i + 1)
                register[i] <= 0;
            // 上电时置零
        end 
        else 
        begin
            if ((write_reg_number != 0) && (write_enable == 1)) 
                register[write_reg_number] <= d;
            // 写入
        end
    end

endmodule