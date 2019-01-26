`include "dff.v"

module Top;
  reg clk;
  reg data;
  reg store;
  wire out;

  dff dff0(clk, data, store, out);

  initial
    begin
      $monitor($time, " clk = %b, data = %b, stored = %b, out = %b",
               clk, data, dff0.stored, out);
      $dumpfile(`VCD_FILE);
      $dumpvars;

      // Your test code here:
      clk <= 0; data <= 0;
      # 1 clk <= 1; data <= 0; store <= 0;
      # 1 clk <= 0; data <= 1; store <= 1;
      # 1 clk <= 1; data <= 0; store <= 1; 
      # 1 clk <= 0; data <= 1; store <= 1;
      # 1 clk <= 1; data <= 1; store <= 1;
      # 1 clk <= 1; data <= 1; store <= 1;
      # 1 clk <= 0; data <= 1; store <= 0; 
      # 1 clk <= 1; data <= 0; store <= 0;

      #2 $finish;
    end
endmodule // Top
