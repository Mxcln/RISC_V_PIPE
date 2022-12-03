
`define     RST_ENA         1'b0
`define     ZERO_RAM        0

`define     ADDR_WIDTH      32
`define     DATA_WIDTH      32
`define     ADDR_DEEPTH     4096
`define     ROM_CLR         0
`define     ZERO_WORD       32'd0

module ram(
    input   wire    clk_100MHz  ,
    input   wire    arst_n      ,                           //系统复位

    input   wire                            rena_i  ,       //访存使能    
    input   wire    [`ADDR_WIDTH - 1 : 0]   raddr_i ,       //访存地址（注意：[31:2]才是有效地址）

    input   wire                            wena_i  ,       //写入使能
    input   wire    [`ADDR_WIDTH - 1 : 0]   waddr_i ,       //写入地址
    input   wire    [`DATA_WIDTH - 1 : 0]   wdata_i ,       //写入数据

    output  wire    [`DATA_WIDTH - 1 : 0]   rdata_o         //访存输出数据
);
    reg     [`ADDR_WIDTH-1 : 0]     _ram[0 : `ADDR_DEEPTH - 1] ;

    reg     [`ADDR_WIDTH - 1 : 0]   rdata;


    //访存：组合逻辑
    always@(*) begin
        if(arst_n == `RST_ENA) begin
            rdata = `ZERO_WORD;
        end
        else begin
            rdata = _ram[raddr_i[31:2]];
        end
    end

    assign rdata_o = rdata;

    //写入：时序逻辑
    always@(posedge clk_100MHz or negedge arst_n) begin
        if(arst_n != `RST_ENA) begin
            _ram[waddr_i[31:2]] <= wdata_i;
        end
    end

endmodule