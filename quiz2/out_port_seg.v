module out_port_seg(data_in, led_out_ten, led_out_mod);
    // 模拟一个 I/O 输出设备
    // 在当前设定场景中，

    input   [31: 0]     data_in;
    // 输入为 32 位数

    output  [6: 0]      led_out_ten, led_out_mod;
    
    wire    [6: 0]      led_out_ten, led_out_mod;

    reg     [3: 0]      res_ten, res_mod;
    // 十位，个位

    sevenseg            led_ten(res_ten, led_out_ten);
    sevenseg            led_mod(res_mod, led_out_mod);

    always @ (data_in)
    begin
        res_mod = data_in % 10;
        res_ten = data_in / 10;
    end

endmodule