
`include "define.v"

module rom(
    input   wire    clk_100MHz  ,
    input   wire    arst_n      ,

    input   wire    [`MEM_ADDR]         r_addr_i ,

    input   wire                        w_ena_i  ,       //写入使能
    input   wire    [`MEM_ADDR]         w_addr_i ,       //写入地址
    input   wire    [`MEM]              w_data_i ,       //写入数据    

    output  wire    [`MEM]              r_data_o 
);
    reg     [`MEM_ADDR]     _rom[0 : `MEM_DEEPTH - 1] ;

    reg     [`MEM_ADDR]   r_data;

    always@(posedge clk_100MHz or negedge arst_n) begin
        if(arst_n == `RST_ENABLE) begin : block
            integer i;
            for(i = 0; i < `MEM_DEEPTH; i = i + 1) begin
                _rom[i] <= `ZERO_WORD;
            end
        end
        else if(w_ena_i) begin
            _rom[w_addr_i[31:2]] <= w_data_i;
        end
    end


    always@(*) begin
        if(arst_n == `RST_ENABLE)
            r_data = `ZERO_WORD;
        else
            r_data = _rom[r_addr_i[31:2]];
    end

    assign r_data_o = r_data;


endmodule