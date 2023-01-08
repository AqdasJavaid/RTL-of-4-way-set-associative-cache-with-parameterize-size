module tagMemBlock
#(
parameter tagSize,
parameter NoOfSets,
parameter indexWidth
)
(
input clk,
input reset,
input [tagSize-1:0]tag,
input [indexWidth-1:0]index,
input TWEnWay0,TWEnWay1,TWEnWay2,TWEnWay3,
output hitWay0,hitWay1,hitWay2,hitWay3
);

//gated clock
wire gatedClockWay0,gatedClockWay1,gatedClockWay2,gatedClockWay3;
and(gatedClockWay0,WEnWay0,clk);
and(gatedClockWay1,WEnWay1,clk);
and(gatedClockWay2,WEnWay2,clk);
and(gatedClockWay3,WEnWay3,clk);

tagMem #(tagSize,NoOfSets,indexWidth)
  way0  (.clk(clk),.reset(reset),.wEn(TWEnWay0),.tag(tag),.index(index),.hit(hitWay0));

tagMem #(tagSize,NoOfSets,indexWidth)
  way1  (.clk(clk),.reset(reset),.wEn(TWEnWay1),.tag(tag),.index(index),.hit(hitWay1));

tagMem #(tagSize,NoOfSets,indexWidth)
  way2  (.clk(clk),.reset(reset),.wEn(TWEnWay2),.tag(tag),.index(index),.hit(hitWay2));

tagMem #(tagSize,NoOfSets,indexWidth)
  way3  (.clk(clk),.reset(reset),.wEn(TWEnWay3),.tag(tag),.index(index),.hit(hitWay3));

endmodule