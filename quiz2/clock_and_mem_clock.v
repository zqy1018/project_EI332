module clock_and_mem_clock(main_clk, clock_out, mem_clk);
    // 采用 main_clk 作为主时钟输入，内部二分频成 clock_out 和 mem_clk
    // 分别作为 CPU 的工作时钟和对 CPU 模块内含的存储器进行读写控制

    input       main_clk;
    output      clock_out; 
    // 和仿真中的名称对上
    output      mem_clk;
    
    reg         clock_out;

    assign      mem_clk = main_clk;
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