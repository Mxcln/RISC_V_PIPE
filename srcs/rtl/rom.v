
`include "define.v"

module rom(
    input   wire    clk_100MHz  ,
    input   wire    arst_n      ,
    input   wire    hold,

    input   wire    [`MEM_ADDR]         r_addr_i ,

    input   wire                        w_ena_i  ,       //写入使能
    input   wire    [`MEM_ADDR]         w_addr_i ,       //写入地址
    input   wire    [`MEM]              w_data_i ,       //写入数据    

    output  wire    [`MEM]              r_data_o 
);
    reg     [`MEM_ADDR]     _rom[0 : `MEM_DEEPTH - 1] ;

    reg     [`MEM_ADDR]   r_data;

    wire     [31:0]  init;

    reg     [10:0]  counter;
    always@(posedge clk_100MHz or negedge arst_n) begin
        if(!arst_n)
            counter <= 0;
        else if(counter == `MEM_DEEPTH - 1)
            counter <= 0;
        else
            counter = counter +1;
    end

    always@(posedge clk_100MHz) begin
        if(hold)
            _rom[counter - 1] <= init;
    end


    always@(*) begin
        if(arst_n == `RST_ENABLE)
            r_data = `ZERO_WORD;
        else
            r_data = _rom[r_addr_i[31:2]];
    end

    assign r_data_o = r_data;

    code u_code (
      .clka (clk_100MHz),    // input wire clka
      .addra(counter),  // input wire [4 : 0] addra
      .douta(init)  // output wire [31 : 0] douta
    );


endmodule