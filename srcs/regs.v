
`define INSTADDR 31:0
`define HOLD_ENA 3:0    //hold标志要几位?
`define INST 31:0
`define REG 31:0
`define REGADDR 4:0
`define MEMADDR 31:0
module regs (
    input wire  clk_100MHz,
    input wire  arst_n,
    //from ex

    //from mem

    //from wb

    //from id
    input wire[`REGADDR] reg1_raddr_i,
    input wire[`REGADDR] reg2_raddr_i,
    // to id
    output reg[`REG] reg1_rdata_o,
    output reg[`REG] reg2_rdata_o
);
    
endmodule