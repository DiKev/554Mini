// tpumac Testbench

module tpumac_tb();

	// Clock
	logic clk;
	logic rst_n;
	logic en;
	logic WrEn;
	logic signed [7:0] Ain;
	logic signed [7:0] Bin;
	logic signed [15:0] Cin;
	logic signed [7:0] Aout;
	logic signed [7:0] Bout;
	logic signed [15:0] Cout;
	logic signed [15:0] temp;
		
	always #5 clk = ~clk; 

	integer errors;
	integer i;

	tpumac DUT(.clk(clk), .rst_n(rst_n), .WrEn(WrEn), .en(en),
	        .Ain(Ain), .Bin(Bin), .Cin(Cin), .Aout(Aout), .Bout(Bout), .Cout(Cout));

	initial begin
		clk = 1'b0;
		rst_n = 1'b0;
		en = 1'b0;
		WrEn = 1'b0;
		errors = 0;
		
		@(negedge clk);
		rst_n = 1'b1;
		en = 1'b1;

		for(i = 0; i < 4; ++lind) begin
			Ain = $random;
			Bin = $random;
		
			#1 if(Cout !== 16'h0) begin
				errors++;
				$display("Error! Reset was not conducted properly. Expected: 0, Got: %d", Cout); 
			end
		end
		
		@(posedge clk);
		temp = Ain * Bin;
		if (Cout !== Ain*Bin) begin
			errors++;
			$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", (Ain + Bin), Cout); 
		end
		
		@(negedge clk);
		en = 1'b0;

		for(i = 0; i < 4; ++lind) begin
			Ain = $random;
			Bin = $random;
			
			#1 if(Cout !== temp) begin
				errors++;
				$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", temp, Cout); 
			end
		end
		
		@(posedge clk);
		if (Cout == Ain*Bin) begin
			errors++;
			$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", temp, Cout); 
		end
		
		@(negedge clk);
		en = 1'b1;

		for(i = 0; i < 4; ++lind) begin
			#1 if(Cout !== temp) begin
				errors++;
				$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", temp, Cout); 
			end
		end
		
		@(posedge clk);
		if (Cout !== Ain*Bin) begin
			errors++;
			$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", (Ain + Bin), Cout); 
		end

		@(negedge clk);
		en = 1'b0;
		WrEn = 1'b1;
		
		for(i = 0; i < 4; ++lind) begin
			Cin = $random;
			#1 if(Cout !== (Ain + Bin)) begin
				errors++;
				$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", (Ain + Bin), Cout); 
			end
		end
		
		@(posedge clk);
		if (Cout !== Ain*Bin) begin
			errors++;
			$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", (Ain + Bin), Cout); 
		end
		
		@(negedge clk);
		en = 1'b1;
		
		for(i = 0; i < 4; ++lind) begin
			#1 if(Cout !== (Ain + Bin)) begin
				errors++;
				$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", (Ain + Bin), Cout); 
			end
		end
		
		@(posedge clk);
		if (Cout !== Cin) begin
			errors++;
			$display("Error! Reset was not conducted properly. Expected: %d, Got: %d", Cin, Cout); 
		end

		//Random value test
		@(negedge clk);
		rst_n = 1'b0;
		
		$display("Errors: %d", errors);

		if(!errors) begin
			$display("YAHOO!!! All tests passed.");
		end
		else begin
			$display("ARRRR!  Ye codes be blast! Aye, there be errors. Get debugging!");
		end

		$stop;

	end

endmodule
