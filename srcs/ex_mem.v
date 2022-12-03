`define         MEMADDR     31:0
`define         ZEROADDR    32'h0
`define         ZERODATA    32'h0
`define         ENABLE      1'b1
`define         DISABLE     1'b0

module ex_mem (
    input   wire                    arst_n,         //异步复位信号
    input   wire                    clk_100M,            //时钟信号100M
    input   wire                    clear,          //复位信号
    input   wire                    hold,           //暂停
//输入信号
    //to    mem                                     //向访存模块发出指令
    input  wire                 ram_r_ena_i,     //向ram发出访存信号
    input  wire    [`MEMADDR]   ram_r_addr_i,    //需要写回的信号地址
    input  wire    [`REGADDR]   reg_w_addr_i,    //需要写回的寄存器地址
    input  wire    [`INST]      inst_i,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    input  wire                 reg_w_ena_i,    //将写寄存器的使能信号
    input  wire    [`INST]      reg_w_data_i,   //输出写回寄存器的数据，即不需要访存的数据    

    //to    ctrl
    input  wire                 jump_flag_i,    //是否跳转
    input  wire    [`INSTADDR]  jump_addr_i,    //跳转的位置;  
    
    //to    wb
    input  wire                 ram_w_ena_i ,
    input  wire    [`MEMADDR]   ram_w_addr_i,    //需要写的地址                                  
    input  wire    [`REG]       ram_w_data_i,    //需要写回的寄存器数据

//输出信号   
    //to    mem                                     //向访存模块发出指令
    output  reg                  ram_r_ena_o,      //向ram请求访存的使能信号
    output  reg     [`MEMADDR]   ram_r_addr_o,    //需要写回的信号地址
    output  reg     [`REGADDR]   reg_w_addr_o,    //需要写回的寄存器地址
    output  reg     [`INST]      inst_o,         //将指令传到下一级，让访存和写回操作判定需要读写类型
    output  reg                     reg_w_ena_o,    //将写寄存器的使能信号
    output  reg     [`INST]      reg_w_data_o,   //输出写回寄存器的数据，即不需要访存的数据    

    //to    ctrl
    output  reg                  jump_flag_o,    //是否跳转
    output  reg     [`INSTADDR]  jump_addr_o,     //跳转的位置;  
    
    //to    wb
    output  reg     [`MEMADDR]   ram_w_addr_o,    //需要写的地址                                  
    output  reg     [`REG]       ram_w_data_o,    //需要写回的寄存器数据
    output  reg                   ram_w_ena_o        //需要写回的使能信号，也需要判断指令类型
);
    always@(posedge clk_100M or negedge arst_n)
        if( !arst_n | clear )
            begin
                //To mem
                ram_r_ena_o  <= "DISABLE"    ;
                ram_r_addr_o <= "ZEROADDR"   ;  
                reg_w_addr_o <= "ZEROREG"   ;
                inst_o       <= "ZERODATA"   ;
                reg_w_ena_o  <= "ZEROENA"    ;
                reg_w_data_o <= "ZERODATA"   ;
                
                //To ctrl
                jump_flag_o  <= "ZEROENA"    ;
                jump_addr_o  <= "ZEROADDR"   ;
                
                //To wb
                ram_w_ena_o   <= "ZEROENA"    ;
                ram_w_addr_o  <= "ZEROADDR"   ;
                ram_w_data_o  <= "ZERODATA"   ;
            end
            else if (hold)
            begin
                //To mem
                ram_r_ena_o  <= ram_r_ena_o    ;
                ram_r_addr_o <= ram_r_addr_o   ;
                reg_w_addr_o <= reg_w_addr_o   ;
                inst_o       <= inst_o     ;
                reg_w_ena_o  <= reg_w_ena_o    ;
                reg_w_data_o <= reg_w_data_o   ;
                
                //To ctrl
                jump_flag_o  <= jump_flag_o    ;
                jump_addr_o  <= jump_addr_o   ;
                
                //To wb
                ram_w_ena_o   <= ram_w_ena_o    ;
                ram_w_addr_o  <= ram_w_addr_o   ;
                ram_w_data_o  <= ram_w_data_o   ;
            end
                else 
                    begin
                        //To mem
                        ram_r_ena_o  <= ram_r_ena_i    ;
                        ram_r_addr_o <= ram_r_addr_i   ;
                        reg_w_addr_o <= reg_w_addr_i   ;
                        inst_o       <= inst_i     ;
                        reg_w_ena_o  <= reg_w_ena_i    ;
                        reg_w_data_o <= reg_w_data_i   ;
                        
                        //To ctrl
                        jump_flag_o  <= jump_flag_i    ;
                        jump_addr_o  <= jump_addr_i   ;
                        
                        //To wb
                        ram_w_ena_o     <= ram_w_ena_i    ;
                        ram_w_addr_o  <= ram_w_addr_i   ;
                        ram_w_data_o  <= ram_w_data_i   ;
                    end

endmodule
