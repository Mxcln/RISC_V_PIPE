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
    output  wire    [`MEM_ADDR]     rom_r_addr_o
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

    wire                    wb_reg_w_ena    ;       //写入通用寄存器的使能
    wire    [`REG_ADDR]     wb_reg_w_addr   ;       //写入通用寄存器的地址
    wire    [`REG]          wb_reg_w_data   ;       //写入通用寄存器的数据

    wire    [`INST]         origin_inst     ;       //从rom中读到的指令
    wire    [`INST_ADDR]    origin_inst_addr;       //从rom中读到的指令地址
    wire    [`INST]         pc_id_inst      ;       //从pc_id中输出的指令
    wire    [`INST_ADDR]    pc_id_inst_addr ;       //从pc_id中输出的指令地址   
    

    wire    [`INST_ADDR]    pc_pc_addr      ;       //当前指令地址

    wire    [`INST]         id_inst         ;       //从id中输出的指令
    wire    [`INST_ADDR]    id_inst_addr    ;       //从id中输出的指令地址
    wire    [`REG_ADDR]     id_reg1_r_addr  ;       //id输出的第一个操作数的地址
    wire    [`REG_ADDR]     id_reg2_r_addr  ;       //id输出的第二个操作数的地址
    wire    [`REG]          reg_reg1_r_addr  ;      //id输入的第一个操作数的地址
    wire    [`REG]          reg_reg2_r_addr  ;      //id输入的第二个操作数的地址
    wire    [`REG]          id_reg1_r_data  ;
    wire    [`REG]          id_reg2_r_data  ;   
    wire                    id_reg_w_ena    ;
    wire    [`REG_ADDR]     id_reg_w_addr   ;
    wire                    id_mem_w_ena    ;
    wire                    id_mem_r_ena    ;
    wire    [`REG]          id_op1          ;
    wire    [`REG]          id_op2          ;
    wire    [`REG]          id_op1_jump     ;
    wire    [`REG]          id_op2_jump     ;

    wire    [`INST]         id_ex_inst          ;       //从id_ex中输出的指令
    wire    [`INST_ADDR]    id_ex_inst_addr     ;       //从id_ex中输出的指令地址
    wire    [`REG_ADDR]     id_ex_reg1_r_addr   ;       //id_ex输出的第一个操作数的地址
    wire    [`REG_ADDR]     id_ex_reg2_r_addr   ;       //id_ex输出的第二个操作数的地址
    wire    [`REG]          id_ex_reg1_r_data   ;
    wire    [`REG]          id_ex_reg2_r_data   ;
    wire                    id_ex_reg_w_ena     ;
    wire    [`REG_ADDR]     id_ex_reg_w_addr    ;
    wire                    id_ex_mem_w_ena     ;
    wire                    id_ex_mem_r_ena     ;
    wire    [`REG]          id_ex_op1           ;
    wire    [`REG]          id_ex_op2           ;
    wire    [`REG]          id_ex_op1_jump      ;
    wire    [`REG]          id_ex_op2_jump      ;

    wire    [1:0]           forwardA        ;
    wire    [1:0]           forwardB        ;
    wire                    forwardC        ;
    wire                    hazard_hold_o   ;

    wire    [`REG]          ex_in_reg1_r_data;
    wire    [`REG]          ex_in_reg2_r_data;

    wire    [`INST]         ex_inst         ;       //从ex中输出的指令
    wire                    ex_reg_w_ena    ;
    wire    [`REG_ADDR]     ex_reg_w_addr   ;
    wire                    ex_mem_r_ena    ;
    wire    [`MEM_ADDR]     ex_mem_r_addr   ;
    wire                    ex_mem_w_ena    ;
    wire    [`MEM_ADDR]     ex_mem_w_addr   ;
    wire    [`MEM]          ex_mem_w_data   ;
    wire                    ex_forwardC     ;

    wire                    ex_mem_mem_r_ena    ;      
    wire    [`MEM_ADDR]     ex_mem_mem_r_addr   ;      
    wire    [`REG_ADDR]     ex_mem_reg_w_addr   ;      
    wire    [`INST]         ex_mem_inst         ;      
    wire                    ex_mem_reg_w_ena    ;      
    wire    [`MEM]          ex_mem_reg_w_data   ;     
    wire    [`MEM_ADDR]     ex_mem_mem_w_addr   ;      
    wire    [`MEM]          ex_mem_mem_w_data   ;      
    wire                    ex_mem_mem_w_ena    ;  
    wire                    ex_mem_forwardC     ; 

    wire    [`MEM]          mem_in_w_data       ;   

    wire    [`INST]         mem_inst            ;       //从mem中输出的指令  
    wire                    mem_mem_r_ena       ;
    wire    [`MEM]          mem_mem_r_data      ;
    wire    [`MEM_ADDR]     mem_mem_r_addr      ;
    wire                    mem_reg_w_ena       ;
    wire    [`MEM]          mem_reg_w_data      ;
    wire    [`MEM_ADDR]     mem_reg_w_addr      ;
    wire                    mem_mem_w_ena       ;
    wire    [`MEM_ADDR]     mem_mem_w_addr      ;
    wire    [`MEM]          mem_mem_w_data      ;     

    wire    [`INST]         mem_wb_inst            ;       //从mem_wb中输出的指令  
    wire                    mem_wb_mem_r_ena       ;
    wire    [`MEM]          mem_wb_mem_r_data      ;
    wire    [`MEM_ADDR]     mem_wb_mem_r_addr      ;
    wire                    mem_wb_reg_w_ena       ;
    wire    [`MEM]          mem_wb_reg_w_data      ;
    wire    [`MEM_ADDR]     mem_wb_reg_w_addr      ;
    wire                    mem_wb_mem_w_ena       ;
    wire    [`MEM_ADDR]     mem_wb_mem_w_addr      ;
    wire    [`MEM]          mem_wb_mem_w_data      ; 

    wire                    wb_mem_w_ena    ;
    wire    [`MEM_ADDR]     wb_mem_w_addr   ;
    wire    [`MEM]          wb_mem_w_data   ;

    assign  origin_inst         = rom_r_data_i  ;
    assign  origin_inst_addr    = pc_pc_addr    ;    

    assign  ram_r_ena_o     = mem_mem_r_ena     ;
    assign  ram_r_addr_o    = mem_mem_r_addr    ;
    assign  ram_w_ena_o     = wb_mem_w_ena      ;
    assign  ram_w_addr_o    = wb_mem_w_addr     ;
    assign  ram_w_data_o    = wb_mem_w_data     ;  

    assign  rom_r_addr_o    = pc_pc_addr        ;  

    


    //ctrl模块：流水线控制模块，组合逻辑
    ctrl  u_ctrl (
        .clk_100MHz                         ( clk_100MHz            ),
        .arst_n                             ( arst_n                ),
        .hold                               ( hold                  ),

        .hazard_hold_i                      ( hazard_hold           ),
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

        .w_ena_i            ( wb_w_ena          ),
        .w_addr_i           ( wb_w_addr         ),
        .w_data_i           ( wb_w_data         ),

        .reg1_r_addr_i       ( id_reg1_r_addr     ),
        .reg2_r_addr_i       ( id_reg2_r_addr     ),

        .reg1_r_data_o       ( reg_reg1_r_data    ),
        .reg2_r_data_o       ( reg_reg2_r_data    )
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

        .inst_i             ( origin_inst       ),
        .inst_addr_i        ( origin_inst_addr  ),
        .hold_ena_i         ( ctrl_pc_hold      ),
        .jump_ena_i         ( ctrl_pc_id_clr    ),

        .inst_o             ( pc_id_inst        ),
        .inst_addr_o        ( pc_id_inst_addr   )
    );


    //id模块：译码，组合逻辑
    id  u_id (
        .arst_n             ( arst_n            ),
        .inst_i             ( pc_id_inst        ),
        .inst_addr_i        ( pc_id_inst_addr   ),

        .reg1_r_data_i      ( reg_reg1_r_data   ),
        .reg2_r_data_i      ( reg_reg2_r_data   ),

        .ex_jump_ena_i      ( ctrl_jump_ena     ),

        .reg1_r_addr_o      ( id_reg1_r_addr    ),
        .reg2_r_addr_o      ( id_reg2_r_addr    ),
        
        .inst_o             ( id_inst           ),
        .inst_addr_o        ( id_inst_addr      ),

        .reg1_r_data_o      ( id_reg1_r_data    ),
        .reg2_r_data_o      ( id_reg2_r_data    ),
        .reg_w_ena_o        ( id_reg_w_ena      ),
        .reg_w_addr_o       ( id_reg_w_addr     ),

        .mem_w_ena_o        ( id_mem_w_ena      ),
        .mem_r_ena_o        ( id_mem_r_ena      ),

        .op1_o              ( id_op1            ),
        .op2_o              ( id_op2            ),
        .op1_jump_o         ( id_op1_jump       ),
        .op2_jump_o         ( id_op2_jump       )
    );


    //id_ex模块：id与ex之间的连接寄存器，时序逻辑
    id_ex   u_id_ex(
        .clk_100MHz         ( clk_100MHz    ),
        .arst_n             ( arst_n        ),

        .inst_i             ( id_inst      ), 
        .inst_addr_i        ( id_inst_addr      ), 
        .reg1_r_addr_i      ( id_reg1_r_addr),
        .reg2_r_addr_i      ( id_reg2_r_addr),
        .reg1_r_data_i      ( id_reg1_r_data      ),
        .reg2_r_data_i      ( id_reg2_r_data      ),
        .reg_w_ena_i        ( id_reg_w_ena      ), 
        .reg_w_addr_i       ( id_reg_w_addr      ), 
        .mem_r_ena_i        ( id_mem_r_ena      ),
        .mem_w_ena_i        ( id_mem_w_ena      ),
        .op1_i              ( id_op1      ), 
        .op2_i              ( id_op2      ), 
        .op1_jump_i         ( id_op1_jump      ), 
        .op2_jump_i         ( id_op2_jump      ), 
        .hold_ena_i         ( ctrl_hold_ena      ), 
        .jump_ena_i         ( ctrl_id_ex_clr      ), 

        .inst_o             ( id_ex_inst        ), 
        .inst_addr_o        ( id_ex_inst_addr   ), 
        .reg1_r_addr_o      ( id_ex_reg1_r_addr),
        .reg2_r_addr_o      ( id_ex_reg2_r_addr),
        .reg1_r_data_o      ( id_ex_reg1_r_data ),
        .reg2_r_data_o      ( id_ex_reg2_r_data ),
        .reg_w_ena_o          ( id_ex_reg_w_ena   ), 
        .reg_w_addr_o       ( id_ex_reg_w_addr  ), 
        .mem_r_ena_o        ( id_ex_mem_w_ena   ),
        .mem_w_ena_o        ( id_ex_mem_r_ena   ),
        .op1_o              ( id_ex_op1         ), 
        .op2_o              ( id_ex_op2         ), 
        .op1_jump_o         ( id_ex_op1_jump    ), 
        .op2_jump_o         ( id_ex_op2_jump    ) 
    );

    //ex_stage模块：解决数据冲突需要的ex前导模块
    ex_stage u_ex_stage(
        .id_ex_reg1_r_addr_i    ( id_ex_reg1_r_addr ),
        .id_ex_reg2_r_addr_i    ( id_ex_reg2_r_addr ),
        .ex_mem_reg_w_addr_i    ( ex_mem_reg_w_addr ),
        .mem_wb_reg_w_addr_i    ( mem_wb_reg_w_addr ),
        .ex_mem_reg_w_ena_i     ( ex_mem_reg_w_ena  ),
        .mem_wb_reg_w_ena_i     ( mem_wb_reg_w_ena  ),
        .id_ex_mem_w_ena_i      ( id_ex_mem_w_ena   ),
        .ex_mem_mem_r_ena_i     ( ex_mem_mem_r_ena  ),
        .id_reg1_r_addr_i       ( id_reg1_r_addr    ),
        .id_reg2_r_addr_i       ( id_reg2_r_addr    ),
        .id_ex_reg_w_addr_i     ( id_ex_reg_w_addr  ),
        .id_ex_mem_r_ena_i      ( id_ex_mem_r_ena   ),
        .id_mem_r_ena_i         ( id_mem_r_ena      ),
        .id_ex_reg_w_ena_i      ( id_ex_reg_w_ena   ),
        .ex_mem_reg_w_data_i    ( ex_mem_reg_w_data ),
        .mem_wb_reg_w_data_i    ( mem_wb_reg_w_data ),
        .id_ex_reg1_r_data_i    ( id_ex_reg1_r_data ),
        
        .forwardC_o             ( forwardC          ),
        .hazard_hold_o          ( hazard_hold       ),
        .ex_in_reg1_r_data_o    ( ex_in_reg1_r_data ),
        .ex_in_reg2_r_data_o    ( ex_in_reg2_r_data )

    );

    // //forward_unit模块：解决数据冲突
    // forward_unit u_forward_unit(
    //     .rs1_id_ex_o_i          ( id_ex_reg1_r_addr ),          		
    //     .rs2_id_ex_o_i          ( id_ex_reg2_r_addr ),          		
    //     .rd_ex_mem_o_i          ( ex_mem_reg_w_addr ),          		
    //     .rd_mem_wb_o_i          ( mem_wb_reg_w_addr ),          		
    //     .reg_w_ena_ex_mem_o_i   ( ex_mem_reg_w_ena  ),                 
    //     .reg_w_ena_mem_wb_o_i   ( mem_wb_reg_w_ena  ),                 
    //     .mem_w_ena_id_ex_o_i    ( id_ex_mem_w_ena   ),                	
    //     .mem_r_ena_ex_mem_o_i   ( ex_mem_mem_r_ena  ),                 
    //     .rs1_id_ex_i_i          ( id_reg1_r_addr    ),          		
    //     .rs2_id_ex_i_i          ( id_reg2_r_addr    ),          		
    //     .rd_id_ex_o_i           ( id_ex_reg_w_addr  ),         		
    //     .mem_r_ena_id_ex_o_i    ( id_ex_mem_r_ena   ),                	
    //     .mem_w_ena_id_ex_i_i    ( id_mem_r_ena      ),                	
    //     .reg_w_ena_id_ex_o_i    ( id_ex_reg_w_ena   ),       

    //     .forwardA_o             ( forwardA          ),       			
    //     .forwardB_o             ( forwardB          ),       			
    //     .forwardC_o             ( forwardC          ),       			
    //     .hazard_hold_o          ( hazard_hold       )          
    // );

    // //数据冒险时的数据选择
    // mux3_1  u_mex_3_1_A(
    //     .ex_mem_i           ( ex_mem_reg_w_data ),
    //     .mem_wb_i           ( mem_wb_reg_w_data ),
    //     .id_ex_i            ( id_ex_reg1_r_data ),
    //     .sel_i              ( forwardA          ),

    //     .dout               ( ex_in_reg1_r_data )
    // );
    // mux3_1  u_mex_3_1_B(
    //     .ex_mem_i           ( ex_mem_reg_w_data ),
    //     .mem_wb_i           ( mem_wb_reg_w_data ),
    //     .id_ex_i            ( id_ex_reg2_r_data ),
    //     .sel_i              ( forwardB          ),

    //     .dout               ( ex_in_reg2_r_data )
    // );


    //ex模块：执行模块，组合逻辑
    ex u_ex(
        .arst_n             ( arst_n        ),      
             
        .inst_i             ( id_ex_inst        ),     
        .inst_addr_i        ( id_ex_inst_addr   ),     
        .reg_w_ena_i        ( id_ex_reg_w_ena   ),     
        .reg_w_addr_i       ( id_ex_reg_w_addr  ),     
        .reg1_r_data_i      ( ex_in_reg1_r_data ),     
        .reg2_r_data_i      ( ex_in_reg2_r_data ),     
        .op1_i              ( id_ex_op1         ),     
        .op2_i              ( id_ex_op2         ),     
        .op1_jump_i         ( id_ex_op1_jump    ),     
        .op2_jump_i         ( id_ex_op2_jump    ),     
        .mem_r_ena_i        ( id_ex_mem_r_ena   ),     
        .mem_w_ena_i        ( id_ex_mem_w_ena   ),     

        .forwardC_i         ( forwardC          ),

        .mem_r_ena_o        ( ex_mem_r_ena      ),     
        .mem_r_addr_o       ( ex_mem_r_addr     ),     
        .reg_w_addr_o       ( ex_reg_w_addr     ),     
        .inst_o             ( ex_inst           ),     
        .reg_w_ena_o        ( ex_reg_w_ena      ),     
        .reg_w_data_o       ( ex_reg_w_data     ),     
        .jump_flag_o        ( ex_jump_ena       ),     
        .jump_addr_o        ( ex_jump_addr      ),     
        .mem_w_addr_o       ( ex_mem_w_addr     ),     
        .mem_w_data_o       ( ex_mem_w_data     ),     
        .mem_w_ena_o        ( ex_mem_w_ena      ),

        .forwardC_o         ( ex_forwardC       )                 
    );


    //ex_mem模块：ex与mem之间的连接寄存器，时序逻辑
    ex_mem u_ex_mem(
        .clk_100MHz         ( clk_100MHz        ),
        .arst_n             ( arst_n            ),
        .hold               ( ctrl_hold_ena     ),

        .mem_r_ena_i        ( ex_mem_r_ena      ),  
        .mem_r_addr_i       ( ex_mem_r_addr     ),  
        .reg_w_addr_i       ( ex_reg_w_addr     ),  
        .inst_i             ( ex_inst           ),  
        .reg_w_ena_i        ( ex_reg_w_ena      ),  
        .reg_w_data_i       ( ex_reg_w_data     ),  
        .mem_w_ena_i        ( ex_mem_w_ena      ),  
        .mem_w_addr_i       ( ex_mem_w_addr     ),  
        .mem_w_data_i       ( ex_mem_w_data     ),

        .forwardC_i         ( ex_forwardC       ),   

        .mem_r_ena_o        ( ex_mem_mem_r_ena  ),  
        .mem_r_addr_o       ( ex_mem_mem_r_addr ),  
        .reg_w_addr_o       ( ex_mem_reg_w_addr ),  
        .inst_o             ( ex_mem_inst       ),  
        .reg_w_ena_o        ( ex_mem_reg_w_ena  ),  
        .reg_w_data_o       ( ex_mem_reg_w_data ), 
        .mem_w_addr_o       ( ex_mem_mem_w_addr ),  
        .mem_w_data_o       ( ex_mem_mem_w_data ),  
        .mem_w_ena_o        ( ex_mem_mem_w_ena  ),  

        .forwardC_o         ( ex_mem_forwardC   )      
    );

    //mem_stage模块：mem的前导模块
    mem_stage u_mem_stage(
        .rd2_data_mem_i_i   ( ex_mem_mem_w_data ),
        .load_mem_wb_o_i    ( mem_wb_mem_w_data ),
        .forwardC_mem_i_i   ( ex_mem_forwardC   ),

        .mem_data_o         ( mem_in_w_data     )

    );
     

    //mem模块：访存，组合逻辑
    mem u_mem(
        .arst_n             ( arst_n),

        .inst_i             ( ex_mem_inst ),

        .mem_r_ena_i        ( ex_mem_mem_r_ena  ),       
        .mem_r_data_i       ( ram_r_data_i      ),
        .mem_r_addr_i       ( ex_mem_mem_r_addr ),

        .reg_w_ena_i        ( ex_mem_reg_w_ena  ),
        .reg_w_data_i       ( ex_mem_reg_w_data ),
        .reg_w_addr_i       ( ex_mem_reg_w_addr ),

        .mem_w_ena_i        ( ex_mem_mem_w_ena  ),
        .mem_w_addr_i       ( ex_mem_mem_w_addr ),
        .mem_w_data_i       ( mem_in_w_data     ),

        .inst_o             ( mem_inst          ),  

        .mem_r_ena_o        ( mem_mem_r_ena     ),
        .mem_r_data_o       ( mem_mem_r_data    ),
        .mem_r_addr_o       ( mem_mem_r_addr    ),

        .reg_w_ena_o        ( mem_reg_w_ena     ),
        .reg_w_data_o       ( mem_reg_w_data    ),
        .reg_w_addr_o       ( mem_reg_w_addr    ),

        .mem_w_ena_o        ( mem_mem_w_ena     ),
        .mem_w_addr_o       ( mem_mem_w_addr    ),
        .mem_w_data_o       ( mem_mem_w_data    )
    );


    //mem_wb模块：mem与wb之间的连接寄存器，时序逻辑
    mem_wb  u_mem_wb(
        .clk_100MHz         ( clk_100MHz    ),
        .arst_n             ( arst_n        ),
        .hold_ena_i         ( ctrl_hold_ena ),

        .inst_i             ( mem_inst          ),
        .mem_r_ena_i        ( mem_mem_r_ena     ),
        .mem_r_data_i       ( mem_mem_r_data    ),
        .mem_r_addr_i       ( mem_mem_r_addr    ),
        .reg_w_ena_i        ( mem_reg_w_ena     ),
        .reg_w_data_i       ( mem_reg_w_data    ),
        .reg_w_addr_i       ( mem_reg_w_addr    ),
        .mem_w_ena_i        ( mem_mem_w_ena     ),
        .mem_w_addr_i       ( mem_mem_w_addr    ),
        .mem_w_data_i       ( mem_mem_w_data    ),

        .inst_o             ( mem_wb_inst         ),
        .mem_r_ena_o        ( mem_wb_mem_r_ena    ),
        .mem_r_data_o       ( mem_wb_mem_r_data   ),
        .mem_r_addr_o       ( mem_wb_mem_r_addr   ),
        .reg_w_ena_o        ( mem_wb_reg_w_ena    ),
        .reg_w_data_o       ( mem_wb_reg_w_data   ),
        .reg_w_addr_o       ( mem_wb_reg_w_addr   ),
        .mem_w_ena_o        ( mem_wb_mem_w_ena    ),
        .mem_w_addr_o       ( mem_wb_mem_w_addr   ),
        .mem_w_data_o       ( mem_wb_mem_w_data   )
    );


    //wb模块：写回（通用寄存器或mem），组合逻辑
    wb  u_wb(
        .arst_n             ( arst_n                ),

        .inst_i             ( mem_wb_inst           ), 

        .mem_r_ena_i        ( mem_wb_mem_r_ena      ),
        .mem_r_data_i       ( mem_wb_mem_r_data     ),
        .mem_r_addr_i       ( mem_wb_mem_r_addr     ),

        .reg_w_ena_i        ( mem_wb_reg_w_ena      ),
        .reg_w_data_i       ( mem_wb_reg_w_data     ),
        .reg_w_addr_i       ( mem_wb_reg_w_addr     ),

        .mem_w_ena_i        ( mem_wb_mem_w_ena      ),
        .mem_w_addr_i       ( mem_wb_mem_w_addr     ),
        .mem_w_data_i       ( mem_wb_mem_w_data     ),

        .reg_w_ena_o        ( wb_reg_w_ena          ),
        .reg_w_data_o       ( wb_reg_w_addr         ),
        .reg_w_addr_o       ( wb_reg_w_data         ),

        .mem_w_ena_o        ( wb_mem_w_ena          ),
        .mem_w_addr_o       ( wb_mem_w_addr         ),
        .mem_w_data_o       ( wb_mem_w_data         )
    );



endmodule