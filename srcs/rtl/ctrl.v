`include "../define.v"


module ctrl(
    input   wire            clk_100MHz  ,
    input   wire            arst_n      ,
    input   wire            hold        ,

    input   wire                        ex_jump_i       ,   //ex模块输出的跳转信号
    input   wire    [`MEM_ADDR]         ex_jump_addr_i  ,   //ex模块输出的跳转地址
    
    output  wire                        hold_ena_o  ,       //系统暂停信号
    output  wire                        jump_ena_o  ,       //跳转使能（对于pc）    
    output  wire    [`MEM_ADDR]         jump_addr_o         //跳转地址
);

    assign  hold_ena_o = hold;

    assign  jump_ena_o = ex_jump_i;

    assign  jump_addr_o = ex_jump_addr_i;

endmodule