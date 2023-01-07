
`include "define.v"

module ram(
    input   wire    clk_100MHz  ,
    input   wire    arst_n      ,                           //系统复位

    input   wire                            r_ena_i  ,       //访存使能    
    input   wire    [`MEM_ADDR]             r_addr_i ,       //访存地址（注意：[31:2]才是有效地址）

    input   wire                            w_ena_i  ,       //写入使能
    input   wire    [`MEM_ADDR]             w_addr_i ,       //写入地址
    input   wire    [`MEM]                  w_data_i ,       //写入数据

    output  wire    [`MEM]                  r_data_o ,       //访存输出数据

    output  wire    [31:0]                  ram_data_1,
    output  wire    [31:0]                  ram_data_2
);
    reg     [`MEM_ADDR]     _ram[0 : `MEM_DEEPTH - 1] ;

    reg     [`MEM_ADDR]   r_data;

    //访存：组合逻辑
    always@(*) begin
        if(arst_n == `RST_ENABLE) begin
            r_data = `ZERO_WORD;
        end
        else if(r_ena_i) begin
            if(r_addr_i == w_addr_i) begin            //同时读和写时：直接把要写的数据作为读的输出
                r_data = w_data_i;
            end
            else begin
                r_data = _ram[r_addr_i[7:2]];
            end
        end
        else begin
            r_data = `ZERO_WORD;
        end
    end

    assign r_data_o = r_data;

    //写入：时序逻辑
    always@(posedge clk_100MHz or negedge arst_n) begin
        if(arst_n == `RST_ENABLE) begin : block
            integer i;
            for(i = 0; i < `MEM_DEEPTH; i = i + 1) begin
                _ram[i] <= `ZERO_WORD;
            end
        end
        else if(w_ena_i) begin
            _ram[w_addr_i[7:2]] <= w_data_i;
        end
    end

    assign  ram_data_1 = _ram[59];
    assign  ram_data_2 = _ram[58];

endmodule