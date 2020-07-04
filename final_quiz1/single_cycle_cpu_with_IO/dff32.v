`default_nettype none

module dff32 (
    input [31: 0] d,
    input clk,
    input resetn,
    output reg [31: 0] q
);
    // 一个四位 D Flip Flop

    always @ (negedge resetn or posedge clk)
    begin
        if (resetn == 0) 
            // q <=0;
            q <= -4;
        else 
            q <= d;
    end

endmodule