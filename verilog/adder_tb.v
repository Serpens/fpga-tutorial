`include "adder.v"

module Top;
  reg [7:0] x;
  reg [7:0] y;
  reg c_in;
  wire [7:0] s;
  wire c_out;

  adder8_decimal a(x, y, c_in, s, c_out);

  initial
    begin
      $monitor($time, " x = %x, y = %x, c_in = %x, s = %x, c_out = %x",
               x, y, c_in, s, c_out);
      $dumpfile(`VCD_FILE);
      $dumpvars;
      
      #5 x <= 'h0; y <= 'h0; c_in <= 'h0;
      #5 x <= 'h2; y <= 'h2; c_in <= 'h1;
      #5 x <= 'h5; y <= 'h9; c_in <= 'h0;
      #5 x <= 'h7; y <= 'h1; c_in <= 'h1;
      #5 x <= 'h6; y <= 'h4; c_in <= 'h0;
      #5 x <= 'h9; y <= 'h9; c_in <= 'h0;
      //x <= 'h00; y <= 'h00; c_in <= 1;    // sum = 'h01
      //#5 x <= 'h80; y <= 'h7F; c_in <= 1; // sum = 'h100
      //#5 x <= 'hA0; y <= 'h0B; c_in <= 0; // sum = 'hAB
      //#5 x <= 'h08; y <= 'h18; c_in <= 0; // sum = 'h20
      //#5 x <= 'h7F; y <= 'hA0; c_in <= 0; // sum = 'h11F
      #5 $finish;
    end
endmodule // Top
