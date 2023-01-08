module cacheBank #(

parameter tagSize,
parameter NoOfSets,
parameter bankWidth,
parameter dataWidth,
parameter indexWidth
)
(
input  clk,
input reset,
input  [31:0]wData,
input  [tagSize-1:0]tag,
input  [indexWidth-1:0]index,

input wEnDWay0,
input wEnDWay1,
input wEnDWay2,
input wEnDWay3,

input wEnMainMemW0,wEnMainMemW1,wEnMainMemW2,wEnMainMemW3,
input [2:0]mode,
input [1:0]offset,

input [1:0]waySelect,
input hit,
output [dataWidth-1:0]readDataBank
);

wire [dataWidth-1:0]readDataWay0,readDataWay1,readDataWay2,readDataWay3;
cacheWay #( tagSize,NoOfSets,bankWidth,dataWidth,indexWidth)
	way0  ( .clk(clk),.reset(reset),.wEn(wEnDWay0),.wEnMainMem(wEnMainMemW0),.wData(wData),
			.tag(tag),.mode(mode),.offset(offset),.index(index),.readData(readDataWay0),.hit(hit));

cacheWay #( tagSize,NoOfSets,bankWidth,dataWidth,indexWidth)
	way1  ( .clk(clk),.reset(reset),.wEn(wEnDWay1),.wEnMainMem(wEnMainMemW1),.wData(wData),
			.tag(tag),.mode(mode),.offset(offset),.index(index),.readData(readDataWay1),.hit(hit));

cacheWay #( tagSize,NoOfSets,bankWidth,dataWidth,indexWidth)
	way2  ( .clk(clk),.reset(reset),.wEn(wEnDWay2),.wEnMainMem(wEnMainMemW2),.wData(wData),
			.tag(tag),.mode(mode),.offset(offset),.index(index),.readData(readDataWay2),.hit(hit));

cacheWay #( tagSize,NoOfSets,bankWidth,dataWidth,indexWidth)
	way3  ( .clk(clk),.reset(reset),.wEn(wEnDWay3),.wEnMainMem(wEnMainMemW3),.wData(wData),
			.tag(tag),.mode(mode),.offset(offset),.index(index),.readData(readDataWay3),.hit(hit));

assign readDataBank = (waySelect == 2'b00)?readDataWay0:
					  (waySelect == 2'b01)?readDataWay1:
					  (waySelect == 2'b10)?readDataWay2:readDataWay3;
endmodule
