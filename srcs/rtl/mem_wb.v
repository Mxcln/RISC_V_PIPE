`define     INSTC_WIDTH     31:0
`define     ADDR_WIDTH      31:0
`define     REG_ADDR_WIDTH  4:0
`define     REG_DATA_WIDTH  31:0
`define     DATA_WIDTH      31:0
`define     ZERO_WORD       32'd0

`define     INSTC_TYPE_I    7'b0000011
`define     INSTC_LB        3'b000
`define     INSTC_LH        3'b001
`define     INSTC_LW        3'b010
`define     INSTC_LBU       3'b100
`define     INSTC_LHU       3'B101

`define     ZERO_INSTC      32'd0
`define     ZERO_DATA       32'd0
`define     ZERO_ADDR       32'd0

`define     WRITE_DISABLE   1'b0
`define     READ_DISABLE    1'b0

module  mem_wb(
    input   wire                        clk_100MHz  ,           //系统清零
    input   wire                        arst_n      ,           //系统复位

    input   wire                        hold_ena_i  ,           //暂停(这里只有系统暂停)       
    
    input   wire    [`INSTC_WIDTH]      instc_i     ,           //指令输入                  
    
    input   wire                        mem_rena_i  ,           //访存使能输入
    input   wire    [`DATA_WIDTH]       mem_rdata_i ,           //访存得到的数据输入             
    
    input   wire                        reg_wena_i  ,           //写入通用寄存器的使能输入
    input   wire    [`REG_DATA_WIDTH]   reg_wdata_i ,           //写入通用寄存器的数据输入
    input   wire    [`REG_ADDR_WIDTH]   reg_waddr_i ,           //写入通用寄存器地址输入        
    
    input   wire                        mem_wena_i  ,           //写入使能输入              
    input   wire    [`ADDR_WIDTH]       mem_waddr_i ,           //写入的地址输入            
    input   wire    [`DATA_WIDTH]       mem_wdata_i ,           //写入的数据输入            
    
    output  reg     [`INSTC_WIDTH]      instc_o     ,           //指令输出

    output  reg                         mem_rena_o  ,           //访存使能输出
    output  reg     [`DATA_WIDTH]       mem_rdata_o ,           //访存得到的数据输出     

    output  reg                         reg_wena_o  ,           //写入通用寄存器的使能输出
    output  reg     [`REG_DATA_WIDTH]   reg_wdata_o ,           //写入通用寄存器数据输出        
    output  reg     [`REG_ADDR_WIDTH]   reg_waddr_o ,           //写入通用寄存器地址输出     

    output  reg                         mem_wena_o  ,           //写入使能输出              
    output  reg     [`ADDR_WIDTH]       mem_waddr_o ,           //写入的地址输出            
    output  reg     [`DATA_WIDTH]       mem_wdata_o             //写入的数据输出            
);

    always@(posedge clk_100MHz or negedge arst_n) begin
        if(!arst_n) begin
            instc_o     <= `ZERO_INSTC      ;
            mem_rena_o  <= `READ_DISABLE    ;
            mem_rdata_o <= `ZERO_WORD       ;
            reg_wena_o  <= `REG_WITER_ENABLE;
            reg_waddr_o <= `ZERO_ADDR       ;
            mem_wena_o  <= `WRITE_DISABLE   ;
            mem_waddr_o <= `ZERO_ADDR       ;
            mem_wdata_o <= `ZERO_DATA       ;
        end
        else if(hold_ena_i) begin
            instc_o     <= instc_o          ;
            mem_rena_o  <= mem_rena_o       ;
            mem_rdata_o <= mem_rdata_o      ;
            reg_waddr_o <= reg_waddr_o      ;
            mem_wena_o  <= mem_wena_o       ;
            mem_waddr_o <= mem_waddr_o      ;
            mem_wdata_o <= mem_wdata_o      ;
        end
        else begin
            instc_o     <= instc_i          ;
            mem_rena_o  <= mem_rena_i       ;
            mem_rdata_o <= mem_rdata_i      ;
            reg_waddr_o <= reg_waddr_i       ;
            mem_wena_o  <= mem_wena_i       ;
            mem_waddr_o <= mem_waddr_i      ;
            mem_wdata_o <= mem_wdata_i      ;
        end
        
    end

endmodule