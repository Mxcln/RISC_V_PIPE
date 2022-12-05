

`include "define.v"

module ex_stage(
    input   wire    [`REG_ADDR] id_ex_reg1_r_addr_i ,
    input   wire    [`REG_ADDR] id_ex_reg2_r_addr_i ,
    input   wire    [`REG_ADDR] ex_mem_reg_w_addr_i ,
    input   wire    [`REG_ADDR] mem_wb_reg_w_addr_i ,    
    input   wire                ex_mem_reg_w_ena_i  ,
    input   wire                mem_wb_reg_w_ena_i  ,
    input   wire                id_ex_mem_w_ena_i   ,
    input   wire                ex_mem_mem_r_ena_i  ,    
    input   wire    [`REG_ADDR] id_reg1_r_addr_i    ,
    input   wire    [`REG_ADDR] id_reg2_r_addr_i    ,
    input   wire    [`REG_ADDR] id_ex_reg_w_addr_i  ,
    input   wire                id_ex_mem_r_ena_i   ,
    input   wire                id_mem_r_ena_i      ,
    input   wire                id_ex_reg_w_ena_i   ,

    input   wire    [`REG]      ex_mem_reg_w_data_i ,
    input   wire    [`REG]      mem_wb_reg_w_data_i ,
    input   wire    [`REG]      id_ex_reg1_r_data_i ,
    input   wire    [`REG]      id_ex_reg2_r_data_i ,

    output  wire                forwardC_o          ,
    output  wire                hazard_hold_o       ,
    output  wire    [`REG]      ex_in_reg1_r_data_o ,
    output  wire    [`REG]      ex_in_reg2_r_data_o

);

    wire    [1:0]   forwardA    ;
    wire    [1:0]   forwardB    ;




    //forward_unit模块：解决数据冲突
    forward_unit u_forward_unit(
        .rs1_id_ex_o_i          ( id_ex_reg1_r_addr_i ),          		
        .rs2_id_ex_o_i          ( id_ex_reg2_r_addr_i ),          		
        .rd_ex_mem_o_i          ( ex_mem_reg_w_addr_i ),          		
        .rd_mem_wb_o_i          ( mem_wb_reg_w_addr_i ),          		
        .reg_w_ena_ex_mem_o_i   ( ex_mem_reg_w_ena_i  ),                 
        .reg_w_ena_mem_wb_o_i   ( mem_wb_reg_w_ena_i  ),                 
        .mem_w_ena_id_ex_o_i    ( id_ex_mem_w_ena_i   ),                	
        .mem_r_ena_ex_mem_o_i   ( ex_mem_mem_r_ena_i  ),                 
        .rs1_id_ex_i_i          ( id_reg1_r_addr_i    ),          		
        .rs2_id_ex_i_i          ( id_reg2_r_addr_i    ),          		
        .rd_id_ex_o_i           ( id_ex_reg_w_addr_i  ),         		
        .mem_r_ena_id_ex_o_i    ( id_ex_mem_r_ena_i   ),                	
        .mem_w_ena_id_ex_i_i    ( id_mem_r_ena_i      ),                	
        .reg_w_ena_id_ex_o_i    ( id_ex_reg_w_ena_i   ),       

        .forwardA_o             ( forwardA            ),       			
        .forwardB_o             ( forwardB            ),       			
        .forwardC_o             ( forwardC_o          ),       			
        .hazard_hold_o          ( hazard_hold_o       )          
    );

    //数据冒险时的数据选择
    mux3_1  u_mex_3_1_A(
        .ex_mem_i           ( ex_mem_reg_w_data_i ),
        .mem_wb_i           ( mem_wb_reg_w_data_i ),
        .id_ex_i            ( id_ex_reg1_r_data_i ),
        .sel_i              ( forwardA            ),

        .dout               ( ex_in_reg1_r_data_o )
    );
    mux3_1  u_mex_3_1_B(
        .ex_mem_i           ( ex_mem_reg_w_data_i ),
        .mem_wb_i           ( mem_wb_reg_w_data_i ),
        .id_ex_i            ( id_ex_reg2_r_data_i ),
        .sel_i              ( forwardB            ),

        .dout               ( ex_in_reg2_r_data_o )
    );

endmodule