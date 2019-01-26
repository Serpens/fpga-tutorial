module dff(input wire clk,
           input wire data,
	   input wire store,
           output wire out);
  reg stored;
  // You can also just declare "output reg out" above.
  assign out = stored;

  always @(posedge clk) begin
    // stored <= store ? data : stored
    if (store) begin
      stored <= data;
    end 
  end
endmodule
