`include "define.v"

module  mem_wb(
    input   wire                        clk_100MHz  ,           //系统清零
    input   wire                        arst_n      ,           //系统复位

    input   wire                        hold_ena_i  ,           //暂停(这里只有系统暂停)       
    
    input   wire    [`INST]             inst_i      ,           //指令输入                  
    
    input   wire                        mem_r_ena_i  ,           //访存使能输入
    input   wire    [`MEM]              mem_r_data_i ,           //访存得到的数据输入               
    input   wire    [`MEM_ADDR]         mem_r_addr_i ,           //访存地址输入               
    
    input   wire                        reg_w_ena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG]              reg_w_data_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR]         reg_w_addr_i ,           //写入通用寄存器地址输入        
    
    input   wire                        mem_w_ena_i  ,           //写入使能输入              
    input   wire    [`MEM_ADDR]         mem_w_addr_i ,           //写入的地址输入            
    input   wire    [`MEM]              mem_w_data_i ,           //写入的数据输入            
    
    output  reg     [`INST]             inst_o      ,           //指令输出

    output  reg                         mem_r_ena_o  ,           //访存使能输出
    output  reg     [`MEM]              mem_r_data_o ,           //访存得到的数据输出
    output  reg     [`MEM_ADDR]         mem_r_addr_o ,           //访存地址输出   

    output  reg                         reg_w_ena_o  ,           //写入通用寄存器的使能输出
    output  reg     [`REG]              reg_w_data_o ,           //写入通用寄存器数据输出        
    output  reg     [`REG_ADDR]         reg_w_addr_o ,           //写入通用寄存器地址输出     

    output  reg                         mem_w_ena_o  ,           //写入使能输出              
    output  reg     [`MEM_ADDR]         mem_w_addr_o ,           //写入的地址输出            
    output  reg     [`MEM]              mem_w_data_o             //写入的数据输出            
);

    always@(posedge clk_100MHz or negedge arst_n) begin
        if(!arst_n) begin
            inst_o      <= `ZERO_INST      ;
            mem_r_ena_o  <= `READ_DISABLE    ;
            mem_r_data_o <= `ZERO_WORD       ;
            mem_r_addr_o <= `ZERO_WORD       ;
            reg_w_ena_o  <= `WRITE_DISABLE   ;
            reg_w_addr_o <= `ZERO_WORD       ;
            mem_w_ena_o  <= `WRITE_DISABLE   ;
            mem_w_addr_o <= `ZERO_WORD       ;
            mem_w_data_o <= `ZERO_WORD       ;
        end
        else if(hold_ena_i) begin
            inst_o      <= inst_o          ;
            mem_r_ena_o  <= mem_r_ena_o       ;
            mem_r_data_o <= mem_r_data_o      ;
            mem_r_addr_o <= mem_r_addr_i      ;
            reg_w_addr_o <= reg_w_addr_o      ;
            mem_w_ena_o  <= mem_w_ena_o       ;
            mem_w_addr_o <= mem_w_addr_o      ;
            mem_w_data_o <= mem_w_data_o      ;
        end
        else begin
            inst_o      <= inst_i          ;
            mem_r_ena_o  <= mem_r_ena_i       ;
            mem_r_data_o <= mem_r_data_i      ;
            mem_r_addr_o <= mem_r_addr_i      ;
            reg_w_addr_o <= reg_w_addr_i      ;
            mem_w_ena_o  <= mem_w_ena_i       ;
            mem_w_addr_o <= mem_w_addr_i      ;
            mem_w_data_o <= mem_w_data_i      ;
        end
        
    end

endmodule