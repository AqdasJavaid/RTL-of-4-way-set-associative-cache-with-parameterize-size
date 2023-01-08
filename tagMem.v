module tagMem
#(
parameter tagSize,
parameter NoOfSets,
parameter indexWidth
)
(
input clk,
input reset,
input wEn,
input [tagSize-1:0]tag,
input [indexWidth-1:0]index,
output hit
);

reg [tagSize-1:0]tagMem[0:NoOfSets-1];
reg valid[0:NoOfSets-1];
reg [tagSize-1:0]tagMemOut;
reg validMemOut;
integer i;

always @(posedge clk, negedge reset)
	if(!reset)
		begin
			for(i=0; i<NoOfSets; i=i+1'b1)
				begin
				tagMem[i] <= {tagSize{1'b0}};
				valid[i]  <= 1'b0;
				end
		end
	else if (wEn)
		begin
			tagMem[index] <= tag;   
			valid[index]  <= 1'b1;
		end
	else
		begin
			//tagMem[index] <= tagMem[index];   
			//valid[index]  <= valid[index];
			tagMemOut <= tagMem[index];
			validMemOut <= valid[index];
		end

//assign hit = (tagMem[index] == tag && valid[index]) ? 1'b1:1'b0;
assign hit = ( tagMemOut== tag && validMemOut) ? 1'b1:1'b0;
endmodule
