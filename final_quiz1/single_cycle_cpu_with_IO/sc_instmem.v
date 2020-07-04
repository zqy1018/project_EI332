`default_nettype none

module sc_instmem (
   input [31: 0] addr,
   input clock, 
   input mem_clk, 
   
   output wire [31: 0] inst, 
   output wire imem_clk
);

   assign imem_clk = clock & (~ mem_clk);      
   
   lpm_rom_irom irom (addr[7: 2], imem_clk, inst); 
   // 实际上只用了 8 位地址？
   // WARNING：不要擅自修改

endmodule 