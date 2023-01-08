module LRUMem #(
parameter NoOfSets,
parameter indexWidth
)
(
input clk,
input reset,
input [1:0]resetValue,
input [1:0]lruIn,
output [1:0]lruOut,
input wEn,
input [indexWidth-1:0]index
);
reg [1:0]lruDOut;
integer i;
reg [1:0]LruMem[0:NoOfSets-1];
//reg [31:0]lruDOut;
always @(posedge clk, negedge reset)
	begin
	if(!reset)
		begin
			for(i=0; i<NoOfSets; i=i+1'b1)
				begin
				LruMem[i] <= resetValue;
				end
		end
	else if (wEn)
		begin
			LruMem[index] <= lruIn;
		end
	else
		begin
			//LruMem[index] <= LruMem[index];
			lruDOut <= LruMem[index];
		end
	end

//assign lruOut =LruMem[index]; 
assign lruOut = lruDOut;//LruMem[index];

endmodule 