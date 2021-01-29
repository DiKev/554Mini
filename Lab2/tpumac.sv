// Spec v1.1
module tpumac
 #(parameter BITS_AB=8,
   parameter BITS_C=16)
  (
   input clk, rst_n, WrEn, en,
   input signed [BITS_AB-1:0] Ain,
   input signed [BITS_AB-1:0] Bin,
   input signed [BITS_C-1:0] Cin,
   output reg signed [BITS_AB-1:0] Aout,
   output reg signed [BITS_AB-1:0] Bout,
   output reg signed [BITS_C-1:0] Cout
  );
  
  reg signed [BITS_C-1:0] Mult;
  reg [BITS_C-1:0] Adder, CMux;
  
  assign Mult = Ain * Bin;
  assign Adder = Mult + Cout;
  assign CMux = WrEn ? Cin : Adder;
  
  always@(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		Aout <= '0;
		Bout <= '0;
		Cout <= '0;
	end
	else if (en) begin
		Aout <= Ain;
		Bout <= Bin;
		Cout <= CMux;
	end
  end
endmodule
  
// NOTE: added register enable in v1.1
// Also, Modelsim prefers "reg signed" over "signed reg"