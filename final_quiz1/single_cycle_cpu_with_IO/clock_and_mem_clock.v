`default_nettype none

module clock_and_mem_clock(
    input main_clk, 
    output reg clock_out, 
    output wire mem_clk
);
    // 采用 main_clk 作为主时钟输入，内部二分频成 clock_out 和 mem_clk
    // 分别作为 CPU 的工作时钟和对 CPU 模块内含的存储器进行读写控制

    assign mem_clk = main_clk;
    // 直接连通到 mem_clk
    
    initial
    begin
        clock_out <= 1'b0;
    end
    
    always @ (posedge main_clk)
    begin
        clock_out <= !clock_out;
        // 二分频
    end
    
endmodule