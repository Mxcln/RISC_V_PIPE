
`include "../define.v"

module rom(
    input   wire    arst_n  ,
    input   wire    rena_i  ,

    input   wire    [`MEM_ADDR]         raddr_i ,

    output  wire    [`MEM]              rdata_o 
);
    reg     [`MEM_ADDR]     _rom[0 : `MEM_DEEPTH - 1] ;

    reg     [`MEM_ADDR]   rdata;

    always@(*) begin
        if(arst_n == `RST_ENABLE)
            rdata = `ZERO_WORD;
        else
            rdata = _rom[raddr_i[31:2]];
    end

    assign rdata_o = rdata;


endmodule