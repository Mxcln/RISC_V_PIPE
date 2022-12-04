`include "define.v"

module risc_v_pipe_top(
    input   wire                    clk_100MHz  ,
    input   wire                    arst_n      ,
    input   wire                    hold        ,

    input   wire    [`MEM]          ram_r_data_i    ,
    input   wire    [`MEM]          rom_r_data_i    ,

    output  wire                    ram_r_ena_o     ,
    output  wire    [`MEM_ADDR]     ram_r_addr_o    ,
    output  wire                    ram_w_ena_o     ,
    output  wire    [`MEM_ADDR]     ram_w_addr_o    ,
    output  wire    [`MEM]          ram_w_data_o    ,
    output  wire    [`MEM_ADDR]     rom_r_addr_i
);

    wire                    ex_hold_risk    ;       //ex输出的数据冒险信号
    wire                    ex_jump_ena     ;       //ex输出的跳转信号
    wire    [`INST_ADDR]    ex_jump_addr    ;       //ex输出的跳转地址
    
    wire                    ctrl_hold_ena   ;       //除了pc ,pc_id 的暂停信号（也就是系统暂停）
    wire                    ctrl_pc_hold    ;       //pc,pc_id 的暂停信号（系统暂停以及数据冒险的暂停）
    wire                    ctrl_pc_id_clr  ;       //pc_id的冲刷信号
    wire                    ctrl_id_ex_clr  ;       //id_ex的冲刷信号
    wire                    ctrl_jump_ena   ;       //跳转信号
    wire    [`INST_ADDR]    ctrl_jump_addr  ;       //跳转指令地址

    wire    []

    wire    [`INST_ADDR]    pc_pc_addr      ;       //当前指令地址


    //ctrl模块：流水线控制模块，组合逻辑
    ctrl  u_ctrl (
        .clk_100MHz                         ( clk_100MHz            ),
        .arst_n                             ( arst_n                ),
        .hold                               ( hold                  ),

        .ex_hold_risk_i                     ( ex_hold_risk          ),
        .ex_jump_i                          ( ex_jump_ena           ),
        .ex_jump_addr_i                     ( ex_jump_addr          ),

        .hold_ena_o                         ( ctrl_hold_ena         ),
        .jump_ena_o                         ( ctrl_jump_ena         ),
        .jump_addr_o                        ( ctrl_jump_addr        ),
        .pc_hold_o                          ( ctrl_pc_hold          ),
        .pc_id_clr_o                        ( ctrl_pc_id_clr        ),
        .id_ex_clr_o                        ( ctrl_id_ex_clr        )
    );


    //regs模块:通用寄存器
    regs  u_regs (
        .clk_100MHz         ( clk_100MHz        ),
        .arst_n             ( arst_n            ),

        .reg1_raddr_i       ( reg1_raddr_i      ),
        .reg2_raddr_i       ( reg2_raddr_i      ),

        .reg1_rdata_o       ( reg1_rdata_o      ),
        .reg2_rdata_o       ( reg2_rdata_o      )
    );


    //pc模块：程序计数器，时序逻辑
    pc  u_pc (
        .clk_100MHz                 ( clk_100MHz        ),
        .arst_n                     ( arst_n            ),

        .jump_ena_i                 ( ctrl_jump_ena     ),
        .jump_addr_i                ( ctrl_jump_addr    ),
        .hold_ena_i                 ( ctrl_pc_hold      ),

        .pc_addr_o                  ( pc_pc_addr        )
    );


    //pc_id模块：pc与id之间的连接寄存器，时序逻辑
    pc_id  u_pc_id (
        .clk_100MHz         ( clk_100MHz        ),
        .arst_n             ( arst_n            ),

        .inst_i             ( inst_i            ),
        .inst_addr_i        ( inst_addr_i       ),
        .hold_ena_i         ( hold_ena_i        ),
        .jump_ena_i         ( jump_ena_i        ),

        .inst_o             ( inst_o            ),
        .inst_addr_o        ( inst_addr_o       )
    );


    //id模块：译码，组合逻辑
    id  u_id (
        .arst_n             ( arst_n            ),
        .inst_i             ( inst_i            ),
    );


    //id_ex模块：id与ex之间的连接寄存器，时序逻辑



    //ex模块：执行模块，组合逻辑



    //ex_mem模块：ex与mem之间的连接寄存器，时序逻辑



    //mem模块：访存，组合逻辑



    //mem_wb模块：mem与wb之间的连接寄存器，时序逻辑



    //wb模块：写回（通用寄存器或RAM），组合逻辑

endmodule