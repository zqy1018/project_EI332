`default_nettype none

module pipe_reg_PC(
    input [31: 0] next_pc, 
    input wpcir, 
    input clock, 
    input resetn, 
    
    output reg [31: 0] pc
);
    // PC 寄存器模块。由原来的 dff32 修改而来。

    always @ (negedge resetn or posedge clock)
    begin
        if (resetn == 0) 
            pc <= -4;
        else if (wpcir == 0)
            pc <= next_pc;
    end

endmodule