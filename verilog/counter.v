module counter(input wire       clk,
               input wire       en,
               input wire       rst,
               output reg [3:0] count);
   reg 				started;
   
   
   always @(posedge clk) begin
      
      started <= started | en;
      if (enable)
	count <= count + 1;
      if (rst)
	 count <= 0;
   end
endmodule
