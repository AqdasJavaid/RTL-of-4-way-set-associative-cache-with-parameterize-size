
module LRUMemBlock #(
parameter NoOfSets,
parameter indexWidth
)
(
input clk,
input reset,
input [1:0]lruIn0,lruIn1,lruIn2,lruIn3,
output [1:0]lruOut0,lruOut1,lruOut2,lruOut3,
input LRUwEn,
input [indexWidth-1:0]index

);


LRUMem #(NoOfSets,indexWidth)
LruWay0(.clk(clk),.reset(reset),.resetValue(2'd0),.lruIn(lruIn0),.lruOut(lruOut0),.wEn(LRUwEn),.index(index));

LRUMem #(NoOfSets,indexWidth)
LruWay1 (.clk(clk),.reset(reset),.resetValue(2'd1),.lruIn(lruIn1),.lruOut(lruOut1),.wEn(LRUwEn),.index(index));

LRUMem #(NoOfSets,indexWidth)
LruWay2 (.clk(clk),.reset(reset),.resetValue(2'd2),.lruIn(lruIn2),.lruOut(lruOut2),.wEn(LRUwEn),.index(index));

LRUMem #(NoOfSets,indexWidth)
LruWay3 (.clk(clk),.reset(reset),.resetValue(2'd3),.lruIn(lruIn3),.lruOut(lruOut3),.wEn(LRUwEn),.index(index));

endmodule