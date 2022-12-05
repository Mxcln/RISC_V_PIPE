
`include "define.v"

module rom(
    input   wire    arst_n  ,

    input   wire    [`MEM_ADDR]         r_addr_i ,

    output  wire    [`MEM]              r_data_o 
);
    reg     [`MEM_ADDR]     _rom[0 : `MEM_DEEPTH - 1] ;

    reg     [`MEM_ADDR]   r_data;

    always@(*) begin
        if(arst_n == `RST_ENABLE)
            r_data = `ZERO_WORD;
        else
            r_data = _rom[r_addr_i[31:2]];
    end

    assign r_data_o = r_data;


endmodule