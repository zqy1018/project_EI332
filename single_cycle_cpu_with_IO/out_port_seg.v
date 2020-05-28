`default_nettype none

module out_port_seg(
    input [31: 0] data_in, 
    output wire [6: 0] led_out_ten, 
    output wire [6: 0] led_out_mod
);
    // 模拟一个 I/O 输出设备
    // 在当前设定场景中，

    reg [3: 0] res_ten, res_mod;
    // 十位，个位

    sevenseg led_ten(
        .data(res_ten), 
        .led_segments(led_out_ten)
    );
    
    sevenseg led_mod(
        .data(res_mod), 
        .led_segments(led_out_mod)
    );

    always @ (data_in)
    begin
        res_mod = data_in % 10;
        res_ten = data_in / 10;
    end

endmodule