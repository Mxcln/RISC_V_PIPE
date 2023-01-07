`include "vga_define.v"

//调用所有图片的ip核来获取图片的 颜色信息

module pic_drive(

    input   wire            vga_clk             ,
    input	wire	[11:0]	addr_h              ,       //行地址
    input	wire	[11:0]	addr_v              ,       //列地址
    input   wire    [9:0]   cell_addr           ,

    output  wire    [15:0]  zero_cell_data      ,       //0个地雷的扫描颜色数据，以下同理
    output  wire    [15:0]  one_cell_data         

);



    //方格显示的ip

    zero_cell u_zero_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( zero_cell_data    )   // 输入地址对应的图片数据
    );

    one_cell u_one_cell (
        .clka   ( vga_clk           ),  // vga时钟信号
        .addra  ( cell_addr         ),  // 图片地址信号

        .douta  ( one_cell_data     )   // 输入地址对应的图片数据
    );


endmodule
