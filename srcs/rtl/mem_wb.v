`include "../define.v"

module  mem_wb(
    input   wire                        clk_100MHz  ,           //系统清零
    input   wire                        arst_n      ,           //系统复位

    input   wire                        hold_ena_i  ,           //暂停(这里只有系统暂停)       
    
    input   wire    [`INST]             inst_i      ,           //指令输入                  
    
    input   wire                        mem_rena_i  ,           //访存使能输入
    input   wire    [`MEM]              mem_rdata_i ,           //访存得到的数据输入               
    input   wire    [`MEM_ADDR]         mem_raddr_i ,           //访存地址输入               
    
    input   wire                        reg_wena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG]              reg_wdata_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR]         reg_waddr_i ,           //写入通用寄存器地址输入        
    
    input   wire                        mem_wena_i  ,           //写入使能输入              
    input   wire    [`MEM_ADDR]         mem_waddr_i ,           //写入的地址输入            
    input   wire    [`MEM]              mem_wdata_i ,           //写入的数据输入            
    
    output  reg     [`INST]             inst_o      ,           //指令输出

    output  reg                         mem_rena_o  ,           //访存使能输出
    output  reg     [`MEM]              mem_rdata_o ,           //访存得到的数据输出
    output  reg     [`MEM_ADDR]         mem_raddr_o ,           //访存地址输出   

    output  reg                         reg_wena_o  ,           //写入通用寄存器的使能输出
    output  reg     [`REG]              reg_wdata_o ,           //写入通用寄存器数据输出        
    output  reg     [`REG_ADDR]         reg_waddr_o ,           //写入通用寄存器地址输出     

    output  reg                         mem_wena_o  ,           //写入使能输出              
    output  reg     [`MEM_ADDR]         mem_waddr_o ,           //写入的地址输出            
    output  reg     [`MEM]              mem_wdata_o             //写入的数据输出            
);

    always@(posedge clk_100MHz or negedge arst_n) begin
        if(!arst_n) begin
            inst_o      <= `ZERO_INST      ;
            mem_rena_o  <= `READ_DISABLE    ;
            mem_rdata_o <= `ZERO_WORD       ;
            mem_raddr_o <= `ZERO_WORD       ;
            reg_wena_o  <= `WRITE_DISABLE   ;
            reg_waddr_o <= `ZERO_WORD       ;
            mem_wena_o  <= `WRITE_DISABLE   ;
            mem_waddr_o <= `ZERO_WORD       ;
            mem_wdata_o <= `ZERO_WORD       ;
        end
        else if(hold_ena_i) begin
            inst_o      <= inst_o          ;
            mem_rena_o  <= mem_rena_o       ;
            mem_rdata_o <= mem_rdata_o      ;
            mem_raddr_o <= mem_raddr_i      ;
            reg_waddr_o <= reg_waddr_o      ;
            mem_wena_o  <= mem_wena_o       ;
            mem_waddr_o <= mem_waddr_o      ;
            mem_wdata_o <= mem_wdata_o      ;
        end
        else begin
            inst_o      <= inst_i          ;
            mem_rena_o  <= mem_rena_i       ;
            mem_rdata_o <= mem_rdata_i      ;
            mem_raddr_o <= mem_raddr_i      ;
            reg_waddr_o <= reg_waddr_i      ;
            mem_wena_o  <= mem_wena_i       ;
            mem_waddr_o <= mem_waddr_i      ;
            mem_wdata_o <= mem_wdata_i      ;
        end
        
    end

endmodule