`include "define.v" 
module ex_mem (
    input   wire                    arst_n,         //异步复位信号
    input   wire                    clk_100MHz,            //时钟信号100M
    input   wire                    hold,           //暂停
//输入信号
    //to    mem                                     //向访存模块发出指令
    input  wire                 mem_r_ena_i,     //向mem发出访存信号
    input  wire    [`MEM_ADDR]   mem_r_addr_i,    //需要写回的信号地址
    input  wire    [`REG_ADDR]   reg_w_addr_i,    //需要写回的寄存器地址
    input  wire    [`INST]      inst_i,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    input  wire                 reg_w_ena_i,    //将写寄存器的使能信号
    input  wire    [`REG]      reg_w_data_i,   //输出写回寄存器的数据，即不需要访存的数据    

    input   wire                forwardC_i,

    //to    wb
    input  wire                 mem_w_ena_i ,
    input  wire    [`MEM_ADDR]   mem_w_addr_i,    //需要写的地址                                  
    input  wire    [`REG]       mem_w_data_i,    //需要写回的寄存器数据

//输出信号   
    //to    mem                                     //向访存模块发出指令
    output  reg                  mem_r_ena_o,      //向mem请求访存的使能信号
    output  reg     [`MEM_ADDR]   mem_r_addr_o,    //需要写回的信号地址
    output  reg     [`REG_ADDR]   reg_w_addr_o,    //需要写回的寄存器地址
    output  reg     [`INST]      inst_o,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    output  reg                     reg_w_ena_o,    //将写寄存器的使能信号
    output  reg     [`REG]      reg_w_data_o,   //输出写回寄存器的数据，即不需要访存的数据    

    output  reg                 forwardC_o,
    
    //to    wb
    output  reg     [`MEM_ADDR]   mem_w_addr_o,    //需要写的地址                                  
    output  reg     [`REG]       mem_w_data_o,    //需要写回的寄存器数据
    output  reg                   mem_w_ena_o        //需要写回的使能信号，也需要判断指令类型
);
    always@(posedge clk_100MHz or negedge arst_n) begin
        if( !arst_n )
            begin
              //To mem
                mem_r_ena_o  <= `WRITE_DISABLE    ;
                mem_r_addr_o <= `ZERO_WORD   ;  
                reg_w_addr_o <= `ZERO_WORD   ;
                inst_o       <= `ZERO_INST_ADDR   ;
                reg_w_ena_o  <= `WRITE_DISABLE    ;
                reg_w_data_o <= `ZERO_WORD   ;
                forwardC_o   <= `FORWARDC_DISABLE;
                
                //To wb
                mem_w_ena_o   <= `WRITE_DISABLE    ;
                mem_w_addr_o  <= `ZERO_WORD   ;
                mem_w_data_o  <= `ZERO_WORD   ;
            end
        else if (hold)
            begin
                //To mem
                mem_r_ena_o  <= mem_r_ena_o    ;
                mem_r_addr_o <= mem_r_addr_o   ;
                reg_w_addr_o <= reg_w_addr_o   ;
                inst_o       <= inst_o     ;
                reg_w_ena_o  <= reg_w_ena_o    ;
                reg_w_data_o <= reg_w_data_o   ;
                forwardC_o   <= forwardC_o ;
                //To wb
                mem_w_ena_o   <= mem_w_ena_o    ;
                mem_w_addr_o  <= mem_w_addr_o   ;
                mem_w_data_o  <= mem_w_data_o   ;
            end
        else 
            begin
                //To mem
                mem_r_ena_o  <= mem_r_ena_i    ;
                mem_r_addr_o <= mem_r_addr_i   ;
                reg_w_addr_o <= reg_w_addr_i   ;
                inst_o       <= inst_i     ;
                reg_w_ena_o  <= reg_w_ena_i    ;
                reg_w_data_o <= reg_w_data_i   ;
                forwardC_o   <= forwardC_i ;
                        
                //To wb
                mem_w_ena_o     <= mem_w_ena_i    ;
                mem_w_addr_o  <= mem_w_addr_i   ;
                mem_w_data_o  <= mem_w_data_i   ;
            end
    end
endmodule
