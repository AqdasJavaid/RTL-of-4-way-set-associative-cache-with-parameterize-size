module cacheBankBlock #(

parameter tagSize,
parameter associativity,
parameter NoOfSets,
parameter bankWidth,
parameter dataWidth,
parameter indexWidth
)
(
input  clk,
input reset,
input [31:0]wDataProcessor,
input [tagSize-1:0]tag,
input [indexWidth-1:0]index,
input [511:0]wDataMainMem,
input [3:0] wEnMainMemWen,
input [63:0] wEnData, //[3:0] B0 and so on
input readMiss,
input [2:0]mode,
input [5:0]offset,
input [1:0]waySelect,
input hit,
output [31:0]readDataBank

);

wire [31:0]readDataB0,readDataB1,readDataB2,readDataB3,readDataB4,readDataB5,readDataB6,readDataB7,readDataB8,
					readDataB9,readDataB10,readDataB11,readDataB12,readDataB13,readDataB14,readDataB15;

wire [31:0]wdataB0,wdataB1,wdataB2,wdataB3,wdataB4,wdataB5,wdataB6,wdataB7,wdataB8,wdataB9,
					wdataB10,wdataB11,wdataB12,wdataB13,wdataB14,wdataB15;

assign wdataB0 = readMiss ? wDataMainMem[31:0]: wDataProcessor; //bank0
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B0 (.clk(clk),.reset(reset),.wData(wdataB0),.tag(tag),.index(index),.wEnDWay0(wEnData[0]),.wEnDWay1(wEnData[1]),
 			.wEnDWay2(wEnData[2]),.wEnDWay3(wEnData[3]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB0));

assign wdataB1 = readMiss ? wDataMainMem[63:32]: wDataProcessor; //bank1
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B1 (.clk(clk),.reset(reset),.wData(wdataB1),.tag(tag),.index(index),.wEnDWay0(wEnData[4]),.wEnDWay1(wEnData[5]),
 			.wEnDWay2(wEnData[6]),.wEnDWay3(wEnData[7]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB1));

assign wdataB2 = readMiss ? wDataMainMem[95:64]: wDataProcessor; //bank2
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B2 (.clk(clk),.reset(reset),.wData(wdataB2),.tag(tag),.index(index),.wEnDWay0(wEnData[8]),.wEnDWay1(wEnData[9]),
 			.wEnDWay2(wEnData[10]),.wEnDWay3(wEnData[11]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB2));

assign wdataB3 = readMiss ? wDataMainMem[127:96]: wDataProcessor; //bank3
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B3 (.clk(clk),.reset(reset),.wData(wdataB3),.tag(tag),.index(index),.wEnDWay0(wEnData[12]),.wEnDWay1(wEnData[13]),
 			.wEnDWay2(wEnData[14]),.wEnDWay3(wEnData[15]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB3));

assign wdataB4 = readMiss ? wDataMainMem[159:128]: wDataProcessor; //bank4
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B4 (.clk(clk),.reset(reset),.wData(wdataB4),.tag(tag),.index(index),.wEnDWay0(wEnData[16]),.wEnDWay1(wEnData[17]),
 			.wEnDWay2(wEnData[18]),.wEnDWay3(wEnData[19]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB4));

assign wdataB5 = readMiss ? wDataMainMem[191:160]: wDataProcessor; //bank5
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B5 (.clk(clk),.reset(reset),.wData(wdataB5),.tag(tag),.index(index),.wEnDWay0(wEnData[20]),.wEnDWay1(wEnData[21]),
 			.wEnDWay2(wEnData[22]),.wEnDWay3(wEnData[23]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB5));

assign wdataB6 = readMiss ? wDataMainMem[223:192]: wDataProcessor; //bank6
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B6 (.clk(clk),.reset(reset),.wData(wdataB6),.tag(tag),.index(index),.wEnDWay0(wEnData[24]),.wEnDWay1(wEnData[25]),
 			.wEnDWay2(wEnData[26]),.wEnDWay3(wEnData[27]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB6));

assign wdataB7 = readMiss ? wDataMainMem[255:224]: wDataProcessor; //bank7
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B7 (.clk(clk),.reset(reset),.wData(wdataB7),.tag(tag),.index(index),.wEnDWay0(wEnData[28]),.wEnDWay1(wEnData[29]),
 			.wEnDWay2(wEnData[30]),.wEnDWay3(wEnData[31]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB7));

assign wdataB8 = readMiss ? wDataMainMem[287:256]: wDataProcessor; //bank8
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B8 (.clk(clk),.reset(reset),.wData(wdataB8),.tag(tag),.index(index),.wEnDWay0(wEnData[32]),.wEnDWay1(wEnData[33]),
 			.wEnDWay2(wEnData[34]),.wEnDWay3(wEnData[35]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB8));

assign wdataB9 = readMiss ? wDataMainMem[319:288]: wDataProcessor; //bank9
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B9 (.clk(clk),.reset(reset),.wData(wdataB9),.tag(tag),.index(index),.wEnDWay0(wEnData[36]),.wEnDWay1(wEnData[37]),
 			.wEnDWay2(wEnData[38]),.wEnDWay3(wEnData[39]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB9));

assign wdataB10 = readMiss ? wDataMainMem[351:320]: wDataProcessor; //bank10
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B10 (.clk(clk),.reset(reset),.wData(wdataB10),.tag(tag),.index(index),.wEnDWay0(wEnData[40]),.wEnDWay1(wEnData[41]),
 			.wEnDWay2(wEnData[42]),.wEnDWay3(wEnData[43]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB10));

assign wdataB11 = readMiss ? wDataMainMem[383:352]: wDataProcessor; //bank11
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B11 (.clk(clk),.reset(reset),.wData(wdataB11),.tag(tag),.index(index),.wEnDWay0(wEnData[44]),.wEnDWay1(wEnData[45]),
 			.wEnDWay2(wEnData[46]),.wEnDWay3(wEnData[47]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB11));

assign wdataB12 = readMiss ? wDataMainMem[415:384]: wDataProcessor; //bank12
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B12 (.clk(clk),.reset(reset),.wData(wdataB12),.tag(tag),.index(index),.wEnDWay0(wEnData[48]),.wEnDWay1(wEnData[49]),
 			.wEnDWay2(wEnData[50]),.wEnDWay3(wEnData[51]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB12));

assign wdataB13 = readMiss ? wDataMainMem[447:416]: wDataProcessor; //bank13
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B13 (.clk(clk),.reset(reset),.wData(wdataB13),.tag(tag),.index(index),.wEnDWay0(wEnData[52]),.wEnDWay1(wEnData[53]),
 			.wEnDWay2(wEnData[54]),.wEnDWay3(wEnData[55]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB13));

assign wdataB14 = readMiss ? wDataMainMem[479:448]: wDataProcessor; //bank14
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B14 (.clk(clk),.reset(reset),.wData(wdataB14),.tag(tag),.index(index),.wEnDWay0(wEnData[56]),.wEnDWay1(wEnData[57]),
 			.wEnDWay2(wEnData[58]),.wEnDWay3(wEnData[59]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB14));

assign wdataB15 = readMiss ? wDataMainMem[511:480]: wDataProcessor; //bank15
cacheBank #(tagSize,NoOfSets,bankWidth,dataWidth,indexWidth) 
		B15 (.clk(clk),.reset(reset),.wData(wdataB15),.tag(tag),.index(index),.wEnDWay0(wEnData[60]),.wEnDWay1(wEnData[61]),
 			.wEnDWay2(wEnData[62]),.wEnDWay3(wEnData[63]),.wEnMainMemW0(wEnMainMemWen[0]),.wEnMainMemW1(wEnMainMemWen[1]),
			.wEnMainMemW2(wEnMainMemWen[2]),.wEnMainMemW3(wEnMainMemWen[3]),.mode(mode),.offset(offset[1:0]),.waySelect(waySelect),.hit(hit),
			.readDataBank(readDataB15));


assign readDataBank = (offset[5:2]==4'd0) ? readDataB0 :
					  (offset[5:2]==4'd1) ? readDataB1 :
					  (offset[5:2]==4'd2) ? readDataB2 :
					  (offset[5:2]==4'd3) ? readDataB3 :
					  (offset[5:2]==4'd4) ? readDataB4 :
					  (offset[5:2]==4'd5) ? readDataB5 :
					  (offset[5:2]==4'd6) ? readDataB6 :
					  (offset[5:2]==4'd7) ? readDataB7 :
					  (offset[5:2]==4'd8) ? readDataB8 :
					  (offset[5:2]==4'd9) ? readDataB9 :
					  (offset[5:2]==4'd10)? readDataB10:
					  (offset[5:2]==4'd11)? readDataB11:
					  (offset[5:2]==4'd12)? readDataB12:
					  (offset[5:2]==4'd13)? readDataB13:
					  (offset[5:2]==4'd14)? readDataB14: readDataB15;


endmodule
