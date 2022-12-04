
`include "../define.v"

module ram(
    input   wire    clk_100MHz  ,
    input   wire    arst_n      ,                           //系统复位

    input   wire                            rena_i  ,       //访存使能    
    input   wire    [`MEM_ADDR]             raddr_i ,       //访存地址（注意：[31:2]才是有效地址）

    input   wire                            wena_i  ,       //写入使能
    input   wire    [`MEM_ADDR]             waddr_i ,       //写入地址
    input   wire    [`MEM]                  wdata_i ,       //写入数据

    output  wire    [`MEM]                  rdata_o         //访存输出数据
);
    reg     [`MEM_ADDR]     _ram[0 : `MEM_DEEPTH - 1] ;

    reg     [`MEM_ADDR]   rdata;


    //访存：组合逻辑
    always@(*) begin
        if(arst_n == `RST_ENABLE) begin
            rdata = `ZERO_WORD;
        end
        else if(rena_i) begin
            if(raddr_i == waddr_i) begin            //同时读和写时：直接把要写的数据作为读的输出
                rdata = wdata_i;
            end
            else begin
                rdata = _ram[raddr_i[31:2]];
            end
        end
        else begin
            rdata = `ZERO_WORD;
        end
    end

    assign rdata_o = rdata;

    //写入：时序逻辑
    always@(posedge clk_100MHz or negedge arst_n) begin
        if(arst_n == `RST_ENABLE) begin : block
            integer i;
            for(i = 0; i < `MEM_DEEPTH; i = i + 1) begin
                _ram[i] <= `ZERO_WORD;
            end
        end
        if(arst_n != `RST_ENABLE) begin
            _ram[waddr_i[31:2]] <= wdata_i;
        end
    end

endmodule