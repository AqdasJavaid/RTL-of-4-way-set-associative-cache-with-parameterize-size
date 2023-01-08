/*mode
---------------------------------------------------------------------------
| 000  |  word 
---------------------------------------------------------------------------
| 001  |  half word
---------------------------------------------------------------------------
| 010  |  byte
---------------------------------------------------------------------------
| 011  |  unsigned byte
---------------------------------------------------------------------------
| 100  |  unsigned half
---------------------------------------------------------------------------*/

module cacheWay #(

parameter tagSize,
parameter NoOfSets,
parameter bankWidth,
parameter dataWidth,
parameter indexWidth

)
(
input clk,
input reset,
input wEn,
input wEnMainMem,
input [31:0]wData,
input [tagSize-1:0]tag,
input [2:0]mode,
input [1:0]offset, //least two bits of offset
input [indexWidth-1:0]index,
output [dataWidth-1:0]readData,
input hit
);

integer i;
reg [31:0]dataMem[0:NoOfSets-1];
reg [31:0]dout;
//write logic
always@(posedge clk, negedge reset)
	begin
		if(!reset) //initilize
			begin
				for(i=0; i<NoOfSets; i=i+1'b1)
					begin
					dataMem[i] <= {32{1'b0}};
					end
			end
		else
		begin
		if(wEn)
			dataMem[index] = wData;
		else
			dout = dataMem[index];
		end
	end

assign readData = dout;//hit ? dout : 32'd0;

endmodule