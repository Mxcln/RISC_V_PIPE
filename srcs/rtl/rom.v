
`define     ADDR_WIDTH      32
`define     DATA_WIDTH      32
`define     ADDR_DEEPTH     4096
`define     ROM_CLR         0
`define     ZERO_WORD       32'd0

`define     RST_ENA         1'b0

module rom(
    input   wire    arst_n  ,
    input   wire    rena_i  ,

    input   wire    [`ADDR_WIDTH - 1 : 0]   raddr_i ,

    output  wire    [`DATA_WIDTH - 1 : 0]   rdata_o 
);
    reg     [`ADDR_WIDTH-1 : 0]     _rom[0 : `ADDR_DEEPTH - 1] ;

    reg     [`ADDR_WIDTH - 1 : 0]   rdata;

    always@(*) begin
        if(arst_n == `RST_ENA)
            rdata = `ZERO_WORD;
        else
            rdata = _rom[raddr_i[31:2]];
    end

    assign rdata_o = rdata;


endmodule