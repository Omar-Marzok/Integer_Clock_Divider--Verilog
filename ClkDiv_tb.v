`timescale 1ns/1ps

module ClkDiv_tb #( parameter RATIO_WD_tb = 8 )();
    reg          				i_ref_clk_tb;
    reg           				i_rst_n_tb;
    reg           				i_clk_en_tb;
    reg [RATIO_WD_tb-1:0] 		i_div_ratio_tb;
    wire         				o_div_clk_tb;

	
localparam CLK_PERIOD = 10;
integer div_ratio;

initial 
begin
	$dumpfile("ClkDiv.vcd") ;       
	$dumpvars;  
 
 ///////////////// initialize & reset /////////////
	initialize();
	reset ();

/////////// test div_ratio starting from 0 to 10 with clock enable = 1 //////////
	for (div_ratio = 1; div_ratio < 11; div_ratio = div_ratio + 1)
	begin
	set_div_ratio(div_ratio,1'b1);
	#500;
	end
	
	// test clock enable = 0 //
	set_div_ratio(div_ratio,1'b0);
	

	#200 $stop;  // end stimulus here
end
	
//----------------> initialization
task initialize ;
  begin
    i_ref_clk_tb   = 1'b0;
    i_rst_n_tb     = 1'b0;
    i_clk_en_tb    = 1'b0;
    i_div_ratio_tb =  'b0;
  end
endtask

//----------------> reset
task reset ;
  begin
    i_rst_n_tb = 1'b1;
    #CLK_PERIOD
    i_rst_n_tb = 1'b0;
    #CLK_PERIOD
    i_rst_n_tb = 1'b1;
    #CLK_PERIOD;
  end
endtask

//----------------> set_div_ratio
task set_div_ratio ;
	input [RATIO_WD_tb-1:0]  div_ratio;
	input 					 clk_en;
	begin
	i_div_ratio_tb = div_ratio;
	i_clk_en_tb = clk_en;
	#CLK_PERIOD;
	end
endtask


	
ClkDiv #(.RATIO_WD(RATIO_WD_tb))DUT (
        .i_ref_clk(i_ref_clk_tb),
        .i_rst_n(i_rst_n_tb),
        .i_clk_en(i_clk_en_tb),
        .i_div_ratio(i_div_ratio_tb),
        .o_div_clk(o_div_clk_tb)
    );

always #(CLK_PERIOD/2) i_ref_clk_tb = !i_ref_clk_tb;


endmodule