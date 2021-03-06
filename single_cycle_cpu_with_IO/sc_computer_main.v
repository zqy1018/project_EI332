`default_nettype none

module sc_computer_main (
    input resetn, 
    input clock, 
    input mem_clk, 
    input [31: 0] in_port0, 
    input [31: 0] in_port1, 

    output wire [31: 0] pc, 
    output wire [31: 0] inst, 
    output wire [31: 0] aluout,
    output wire [31: 0] memout,
    output wire imem_clk, 
    output wire dmem_clk, 
    output wire [31: 0] out_port0, 
    output wire [31: 0] out_port1, 
    output wire [31: 0] out_port2
);
    wire    [31: 0]     data;
    wire                wmem; 

    sc_cpu              cpu(clock, resetn, inst, memout, pc, wmem, aluout, data); 
    // sc_cpu(clock, resetn, inst, mem, pc, wmem, alu, data);
    sc_instmem imem(
        .addr(pc), 
        .clock(clock), 
        .mem_clk(mem_clk), 
        .inst(inst), 
        .imem_clk(imem_clk)
    ); 

    sc_datamem dmem(
        .resetn(resetn),
        .we(wmem), 
        .clock(clock), 
        .mem_clk(mem_clk),  
        .addr(aluout), 
        .datain(data), 
        .in_port0(in_port0), 
        .in_port1(in_port1), 

        .dmem_clk(dmem_clk), 
        .dataout(memout), 
        .out_port0(out_port0), 
        .out_port1(out_port1), 
        .out_port2(out_port2)
    ); 

endmodule

