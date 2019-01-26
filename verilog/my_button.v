`include "fpga-tools/components/uart.v"


module top(input wire CLK,
	   input wire  PIO1_02,
	   input wire  PIO1_06,
           output wire LED0,
           output wire LED1,
           output wire LED2,
           output wire LED3,
           output wire LED4,
	   output wire RS232_Tx_TTL);
  wire pin;
  wire pin2;
  reg started;

  wire is_transmitting;
  wire transmit;
  wire [7:0] tx_byte;
  parameter n = 26;
  reg [n-1:0] clk_counter = 0;
  reg [n-1:0] last_result = 0;
  
  uart #(.baud_rate(9600), .sys_clk_freq(12000000))
  uart0(.clk(CLK),                        // The master clock for this module
        .tx(RS232_Tx_TTL),                // Outgoing serial line
        .transmit(transmit),              // Signal to transmit
        .tx_byte(tx_byte),             // Byte to transmit
	.is_transmitting(is_transmitting)
        ); 
  
  pullup1 pu1(PIO1_02, pin);
  pullup2 pu2(PIO1_06, pin2);
   
  always @(posedge CLK) begin
     if (~pin2) begin
	started <= 0;
	last_result <= clk_counter ? clk_counter : last_result;
	clk_counter <= 0;
     end
     if (~pin) begin
       started <= 1;
     end
     if (started)
       clk_counter <= clk_counter + 1;
  end

  assign LED0 = clk_counter[n-5];
  assign LED1 = clk_counter[n-4];
  assign LED2 = clk_counter[n-3];
  assign LED3 = clk_counter[n-2];
  assign LED4 = clk_counter[n-1];
  uart_node un(CLK, last_result, is_transmitting, ~pin2, transmit, tx_byte);

endmodule

module pullup1(input wire package_pin,
	      input wire data_in);
  // PIN_TYPE: <output_type=0>_<input=1>
  SB_IO #(.PIN_TYPE(6'b0000_01),
          .PULLUP(1'b1))
  io(.PACKAGE_PIN(package_pin), .D_IN_0(data_in));
endmodule

module pullup2(input wire package_pin,
	      input wire data_in);
  // PIN_TYPE: <output_type=0>_<input=1>
  SB_IO #(.PIN_TYPE(6'b0000_01),
          .PULLUP(1'b1))
  io(.PACKAGE_PIN(package_pin), .D_IN_0(data_in));
endmodule


module uart_node(input wire clk,
		 input wire [31:0] result,
                 input wire 	  is_transmitting,
		 input wire 	  enabled,
		 output reg 	  transmit,
                 output reg [7:0] tx_byte);
  reg transmit;

  parameter digits = 8;
  reg [3:0] idx = 0;
  wire [3:0] digit = (result >> (4*(digits-1-idx)));
  reg [7:0] digit_ascii;   

  always @(*) begin
    if (digit < 'hA)
      digit_ascii <= "0" + {4'b0, digit};
    else
      digit_ascii <= "A" - 8'hA + {4'b0, digit};
  end

  always @(posedge clk) begin
    // Only raise transmit for 1 cycle
    if (transmit)
      transmit <= 0;

    if (!transmit && !is_transmitting && enabled) begin
      transmit <= 1;
      tx_byte <= digit_ascii;
      if (idx == digits) begin
        tx_byte <= "\r\n";
        idx <= 0;
      end else
	idx <= idx + 1; 
      end
  end

endmodule
