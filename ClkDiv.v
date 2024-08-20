module ClkDiv #( parameter RATIO_WD = 8 )( 
    input wire           		i_ref_clk,
    input wire           		i_rst_n,
    input wire           		i_clk_en,
    input wire [RATIO_WD - 1:0] i_div_ratio,
    output wire           		o_div_clk
);

wire [RATIO_WD-2 :0]   edge_flip_half,edge_flip_full ;
wire clk_en;
reg 	tog,div_clk;
reg [RATIO_WD-1 : 0] count;

always @(posedge i_ref_clk or negedge i_rst_n) 
 begin
    if (!i_rst_n) 
    begin
		div_clk <= 1'b0;
		count <= 'b0;
		tog <= 1'b0;
    end 
    else if(clk_en)
    begin
		if (count == edge_flip_half && !i_div_ratio[0])
		begin
			div_clk <= ~div_clk;
			count <= 'b0;
		end	
		else if ((count == edge_flip_full && tog) || (count == edge_flip_half && !tog))
		begin
			div_clk <= ~div_clk;
			count <= 'b0;
			tog <= ~tog ;
		end
		else
			count <= count + 'b1;
    end
 end 

assign clk_en = i_clk_en && i_div_ratio != 1'b0 && i_div_ratio!=1'b1;
assign edge_flip_half = (i_div_ratio >> 1) - 1;
assign edge_flip_full = i_div_ratio - (i_div_ratio >> 1) - 1;
assign o_div_clk = clk_en ? div_clk : i_ref_clk ;


endmodule