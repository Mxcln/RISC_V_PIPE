
`include "define.v"
`define INSTADDR 31:0
`define HOLD_ENA 3:0    //hold标志要几位?
`define INST 31:0
module pc(
    input wire  clk_100MHz,
    input wire  arst_n,
    input wire  jump_ena_i,                 // 跳转标志
    input wire  [`INSTADDR] jump_addr_i,    // 跳转地址
    input wire  [`HOLD_ENA] hold_ena_i,     // 流水线暂停标志
    output reg  [`INSTADDR] pc_addr_o       // 指令计数器地址
);

endmodule