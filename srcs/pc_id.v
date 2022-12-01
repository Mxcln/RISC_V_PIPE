`include "define.v"
`define INSTADDR 31:0
`define HOLD_ENA 3:0    
`define INST 31:0

module pc_id (
    input wire clk,
    input wire arst_n,

    input wire[`INST] inst_i,
    input wire[`INSTADDR] inst_addr_i,
    
    input wire[`HOLD_ENA] hold_ena_i,

    output wire[`INST] inst_o,
    output wire[`INSTADDR] inst_addr_o

);
    
endmodule