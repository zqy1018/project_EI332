`default_nettype none

module pipe_reg_IF_ID(
    input [31: 0] pc_plus_4, 
    input [31: 0] inst, 
    input wpcir, 
    input clock, 
    input resetn, 
    
    output reg [31: 0] ID_pc_plus_4, 
    output reg [31: 0] inst_stored
);
    // IF/ID 级流水线寄存器
    // inst_stored 是 inst 的寄存器版本

    always @ (negedge resetn or posedge clock)
    begin
        if (resetn == 0) begin
            ID_pc_plus_4 <= 0;
            inst_stored <= 0;
        end else if (wpcir == 0) begin
            ID_pc_plus_4 <= pc_plus_4;
            inst_stored <= inst;
        end
    end

endmodule