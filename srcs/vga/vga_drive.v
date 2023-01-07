`include "vga_define.v"

//决定当前扫描到的像素的颜色。
//调用了多个储存图片ip核，根据扫描位置决定输出颜色。

module vga_drive (
    input	wire					                    vga_clk             ,
    input	wire					                    rst_n               ,

    input   wire    [31:0]  ram_data_1,
    input   wire    [31:0]  ram_data_2,

    input	wire	[11:0]	addr_h,     //行有效地址
    input	wire	[11:0]	addr_v,     //列有效地址
    
    output	reg 	[15:0]		rgb_data    //16位RGB值
);

    wire    [15:0]  zero_cell_data    ;
    wire    [15:0]  one_cell_data     ;

    reg     [9:0]   cell_addr         ;


    wire    cell_area_1 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH); 

    wire    cell_area_2 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH * 2); 

    wire    cell_area_3 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*2)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*3); 

    wire    cell_area_4 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*3)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*4); 
    
    wire    cell_area_5 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*4)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*5); 

    wire    cell_area_6 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*5)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*6 ); 

    wire    cell_area_7 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*6)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*7); 

    wire    cell_area_8 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*7 )&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*8); 

    wire    cell_area_9 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*8)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*9 ); 

    wire    cell_area_10 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*9)&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*10); 

    wire    cell_area_11 = (addr_v >= `NUM_POS_HEIGHT)&&(addr_v < `NUM_POS_HEIGHT + `CELL_HEIGHT)&&
                          (addr_h >= `NUM_POS_WIDTH + `CELL_WIDTH*10 )&&(addr_h < `NUM_POS_WIDTH + `CELL_WIDTH*11); 
    
    wire    blank_area = ~cell_area_1 && ~cell_area_2 && ~cell_area_3 && ~cell_area_4 && ~cell_area_5 && ~cell_area_6 &&~cell_area_7 && ~cell_area_8 
                        &&~cell_area_9 && ~cell_area_10 && ~cell_area_11;  

    //rgb_data驱动
    always@(posedge vga_clk) begin
        if(!rst_n) begin
            rgb_data <= `BLACK;
            cell_addr <= 0;
        end

        else if (blank_area)            //空白区域：都为黑色
            rgb_data <= `BLACK;

        else if (cell_area_1)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 0);
            case(ram_data_1[10])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
                default : rgb_data <= zero_cell_data    ;
            endcase
        end
        else if (cell_area_2)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 1);
            case(ram_data_1[9])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
                default : rgb_data <= zero_cell_data    ;
            endcase
        end
        else if (cell_area_3)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 2);
            case(ram_data_1[8])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
                default : rgb_data <= zero_cell_data    ;
            endcase
        end
        else if (cell_area_4)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 3);
            case(ram_data_1[7])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
            endcase
        end
        else if (cell_area_5)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 4);
            case(ram_data_1[6])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
            endcase
        end
        else if (cell_area_6)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 5);
            case(ram_data_1[5])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
            endcase
        end
        else if (cell_area_7)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 6);
            case(ram_data_1[4])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
                default : rgb_data <= zero_cell_data    ;
            endcase
        end
        else if (cell_area_8)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 7);
            case(ram_data_1[3])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
                default : rgb_data <= zero_cell_data    ;
            endcase
        end
        else if (cell_area_9)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 8);
            case(ram_data_1[2])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
                default : rgb_data <= zero_cell_data    ;
            endcase
        end
        else if (cell_area_10)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 9);
            case(ram_data_1[1])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
            endcase
        end
        else if (cell_area_11)
        begin
            cell_addr <= (addr_v - `NUM_POS_HEIGHT)*(`CELL_WIDTH) + (addr_h - `NUM_POS_WIDTH - `CELL_WIDTH * 10);
            case(ram_data_1[0])
                1'd0    : rgb_data <= zero_cell_data    ;
                1'd1    : rgb_data <= one_cell_data     ;
            endcase
        end
        else begin
            rgb_data <= `BLACK;
            cell_addr <= 0;
        end
    end

    //该模块实例化了所有储存图片的ip核
    //调用ip核，导入图片的颜色信息
    pic_drive  u_pic_drive (
        .vga_clk                 ( vga_clk             ),
        .addr_h                  ( addr_h              ),
        .addr_v                  ( addr_v              ),
        .cell_addr               ( cell_addr           ),

        .zero_cell_data          ( zero_cell_data      ),
        .one_cell_data           ( one_cell_data       )

    );

endmodule