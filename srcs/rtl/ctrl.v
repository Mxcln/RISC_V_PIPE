`include "define.v"


module ctrl(
    input   wire            clk_100MHz  ,
    input   wire            arst_n      ,
    input   wire            hold        ,

    input   wire                        hazard_hold_i     ,   //ex前端数据选择模块输出的解决数据冒险所需要的流水线冲刷信号
    input   wire                        ex_jump_i       ,   //ex模块输出的跳转信号
    input   wire    [`MEM_ADDR]         ex_jump_addr_i  ,   //ex模块输出的跳转地址
    
    output  wire                        hold_ena_o      ,       //实际上是系统暂停信号，对于pc,pc_id以外的模块
    output  wire                        jump_ena_o      ,       //跳转使能（对于pc）    
    output  wire    [`MEM_ADDR]         jump_addr_o     ,       //跳转地址

    output  wire                        pc_hold_o       ,       //系统暂停&解决数据冒险暂停，在pc,pc_id模块中
    output  wire                        pc_id_clr_o     ,       //跳转时需要冲刷
    output  wire                        id_ex_clr_o             //解决数据冒险时需要冲刷

);

    assign  hold_ena_o  =   hold;

    assign  jump_ena_o  =   ex_jump_i;

    assign  jump_addr_o =   ex_jump_addr_i;

    assign  pc_hold_o   =   hold | hazard_hold_i;

    assign  pc_id_clr_o =   ex_jump_i;

    assign  id_ex_clr_o =   hazard_hold_i | ex_jump_i ;

endmodule