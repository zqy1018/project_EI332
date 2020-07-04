`default_nettype none

module pipe_reg_MEM_WB(
    input clock, 
    input resetn, 
    input MEM_wreg, 
    input MEM_m2reg, 
    input [31: 0] MEM_mem_out, 
    input [31: 0] MEM_alu, 
    input [4: 0] MEM_write_reg_number, 

    output reg WB_wreg, 
    output reg WB_m2reg, 
    output reg [31: 0] WB_mem_out, 
    output reg [31: 0] WB_alu,
    output reg [4: 0] WB_write_reg_number
);
    // EXE/WB 部分寄存器

    always @ (posedge clock or negedge resetn)
    begin
        if (resetn == 0) begin
            WB_wreg <= 0;
            WB_m2reg <= 0;
            WB_mem_out <= 0;
            WB_alu <= 0;
            WB_write_reg_number <= 0;
        end else begin
            WB_wreg <= MEM_wreg;
            WB_m2reg <= MEM_m2reg;
            WB_mem_out <= MEM_mem_out;
            WB_alu <= MEM_alu;
            WB_write_reg_number <= MEM_write_reg_number;
        end 
    end

endmodule