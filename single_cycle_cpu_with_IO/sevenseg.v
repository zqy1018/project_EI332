module sevenseg(data, led_segments);
    // 七段译码器
    
    input   [3: 0]      data;
    // 0-9，至少需要 4 个 bit

    output  [6: 0]      led_segments;
    // 输出，7 段

    reg     [6: 0]      led_segments;
    
    always @ (*)
    begin
        case(data)
            0:          led_segments = 7'b100_0000;
            1:          led_segments = 7'b111_1001;
            2:          led_segments = 7'b010_0100;
            3:          led_segments = 7'b011_0000;
            4:          led_segments = 7'b001_1001;
            5:          led_segments = 7'b001_0010;
            6:          led_segments = 7'b000_0010;
            7:          led_segments = 7'b111_1000;
            8:          led_segments = 7'b000_0000;
            9:          led_segments = 7'b001_0000;
            default:    led_segments = 7'b100_0000;  
            // 默认 1
        endcase
    end

endmodule