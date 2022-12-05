`timescale 1ns/1ns

module risc_v_soc_tb();
	reg clk_100MHz;
	reg arst_n;
    reg hold;

    initial begin
        $readmemb ("inst.data", u_risc_v_soc.u_rom._rom);
    end

	initial
	begin
		clk_100MHz = 1'b1;
		forever #5 clk_100MHz = ~clk_100MHz;
	end
	
	initial
	begin
        hold = 1'b0;
		arst_n = 1'b0;
		#20 arst_n = 1'b1;
		#4000 $stop;
	end

	risc_v_soc u_risc_v_soc
	(	
		.clk_100MHz(clk_100MHz),
		.arst_n(arst_n),
        .hold(hold)
	);
endmodule
