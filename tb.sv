module tb();

logic  clk;
logic reset;
logic hault;
logic  [31:0]address;
logic  write;
logic  [31:0]wData;
logic  [2:0]mode;
logic [31:0]dout;
logic [4:0]opcode;
logic writeMiss;
logic haultProcessor;
int inst;

top #() dut (.*);


initial
	begin
		//write
		clk =0;
		reset = 0;
		#10;
		@(posedge clk);
		inst = 1;
		reset = 1;
		write = 1;
		wData = 32'habcd_1234;
		mode = 3'b000;
		opcode = 5'd0;
		address = 32'hffff_fffc;
		
		//read miss
		@(posedge clk);
		inst = 2;
		write = 0;
		wData = 32'habcd_1234;
		mode = 3'b000;
		opcode = 5'd0;
		address = 32'hffff_fffc;
	end
initial 
	begin
		//read Hit
		#585;
		inst = 3;
		write = 0;
		wData = 32'habcd_1234;
		mode = 3'b000;
		opcode = 5'd0;
		address = 32'hffff_fffc;

		//write miss
		@(posedge clk);
		inst = 4;
		write = 1;
		wData = 32'h5678_9001;
		mode = 3'b000;
		opcode = 5'd0;
		address = 32'h0000_0000;

		//write Hit
		@(posedge clk);
		inst = 3;
		write = 1;
		wData = 32'h5555_5555;
		mode = 3'b000;
		opcode = 5'd0;
		address = 32'hffff_fffc;
	end
	
always #5 clk =~clk;
endmodule