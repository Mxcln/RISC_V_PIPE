module top_module(
    input   wire           clk_100MHz  ,
    input   wire           arst_n      ,
    input   wire           hold        ,

    //VGA 输出
    output	wire					h_sync  ,       //行同步信号
    output	wire					v_sync  ,       //场同步信号
    output	wire	[3:0]			rgb_r   ,       //红色
    output	wire	[3:0]			rgb_g   ,       //绿色
    output	wire	[3:0]			rgb_b           //蓝色
);

    wire    [31:0]      ram_data_1;
    wire    [31:0]      ram_data_2;

    risc_v_soc  u_risc_v_soc (
        .clk_100MHz              ( clk_100MHz   ),
        .arst_n                  ( arst_n       ),
        .hold                    ( hold         ),

        .ram_data_1              ( ram_data_1   ),
        .ram_data_2              ( ram_data_2   )
    );

    vga_top  u_vga_top (
        .clk                     ( clk_100MHz   ),
        .rst_n                   ( arst_n       ),
        .ram_data_1              ( ram_data_1   ),
        .ram_data_2              ( ram_data_2   ),

        .h_sync                  ( h_sync       ),
        .v_sync                  ( v_sync       ),
        .rgb_r                   ( rgb_r        ),
        .rgb_g                   ( rgb_g        ),
        .rgb_b                   ( rgb_b        )
    );
    // assign h_sync=0;
    // assign v_sync=0;
    // assign rgb_r =0;
    // assign rgb_g =0;
    // assign rgb_b =0;

    // display_seg #(
    //     .LIMIT ( 50000 ))
    //  u_display_seg (
    //     .clk                     ( clk_100MHz      ),
    //     .rst_n                   ( arst_n          ),
    //     .seg_8421_code           ( seg_8421_code   ),

    //     .seg                     ( seg             ),
    //     .display_digit           ( display_digit   )
    // );


endmodule