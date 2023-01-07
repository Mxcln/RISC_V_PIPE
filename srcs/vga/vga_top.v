`include "vga_define.v"

//vga显示的顶层模块
//实例化了三个模块：
//一是 时钟模块。由于vga需要25MHz的时钟，于是使用ip核生成。
//二是 扫描控制模块。这个模块用于控制场同步信号和行同步信号。
//三是 颜色数据输入模块。这个模块决定当前扫描的像素的颜色。

module vga_top (
    input	wire					clk                 ,
    input	wire					rst_n               ,
    input   wire    [31:0]          ram_data_1             ,   
    input   wire    [31:0]          ram_data_2             ,   
    
    output	wire					h_sync  ,       //行同步信号
    output	wire					v_sync  ,       //场同步信号
    output	wire	[ 3:0 ]			rgb_r   ,       //红色 
    output	wire	[ 3:0 ]			rgb_g   ,       //绿色
    output	wire	[ 3:0 ]			rgb_b           //蓝色
);

    wire		[ 11:0 ]		    addr_h              ;   //行有效地址：0-640
    wire		[ 11:0 ]		    addr_v              ;   //列有效地址：0-480
    wire		[ 15:0 ]			rgb_data			;   //当前方格的颜色数据，由vga_drive控制
    wire                            vga_clk             ;   //vga时钟：25MHz

    //使用ip核生成25MHz的时钟
    vga_clk u_vga_clk(
        .clk_in1                    ( clk           ),      //输入时钟：100MHz
        .resetn                     ( rst_n         ),

        .clk_out1                   ( vga_clk       )       //vga时钟：25MHz
    );

    //vga扫描控制模块
    vga_control  u_vga_control (
        .vga_clk                 ( vga_clk    ),
        .rst_n                   ( rst_n      ),
        .rgb_data                ( rgb_data   ),

        .h_sync                  ( h_sync     ),
        .v_sync                  ( v_sync     ),
        .addr_h                  ( addr_h     ),
        .addr_v                  ( addr_v     ),
        .rgb_r                   ( rgb_r      ),
        .rgb_g                   ( rgb_g      ),
        .rgb_b                   ( rgb_b      ) 
    );

    //vga颜色数据输入模块:根据行有效地址addr_h和列有效地址addr_v，决定当前输出的颜色数据
    vga_drive  u_vga_drive (
        .vga_clk                 ( vga_clk            ),
        .rst_n                   ( rst_n              ),
        .addr_h                  ( addr_h             ),
        .addr_v                  ( addr_v             ),
        .ram_data_1              ( ram_data_1         ),
        .ram_data_2              ( ram_data_2         ),

        .rgb_data                ( rgb_data           )
    );

endmodule


