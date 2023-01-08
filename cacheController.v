module cacheController#(
parameter offsetWidth
)
(
input clk,
input reset,
input [2:0]mode,
input ready,
output reg hault,
input [31:0]wDataDFProcessor,
input ready1,
//LRU
output reg [1:0]lruIn0,lruIn1,lruIn2,lruIn3,
input  [1:0]lruOut0,lruOut1,lruOut2,lruOut3,
output reg LRUwEn,

//Tag Mem
output reg TWEnWay0,TWEnWay1,TWEnWay2,TWEnWay3,
input hitWay0,hitWay1,hitWay2,hitWay3,

//cacheBank
output reg [31:0]wDataProcessor,
output reg [63:0]wEnData,
output reg [3:0]wEnMainMemWen,
output reg readMiss,
output reg writeMiss,
output hit,
output reg haultWH,
output reg [1:0]waySelect,
//
input [offsetWidth-1:0]offset,
input write,
input [4:0]opcode,
input [31:0] readDataBank




//output WeBank0,
//output WeBank1,
//output WeBank2,
//output WeBank3,
//output WeBank4,
//output WeBank5,
//output WeBank6,
//output WeBank7,
//output WeBank8,
//output WeBank9,
//output WeBank10,
//output WeBank11,
//output WeBank12,
//output WeBank13,
//output WeBank14,
//output WeBank15

);

reg flag;
reg count = 0;
always@(posedge clk)
	begin
		if(haultWH)
			begin
			count = count +1;
			if(count == 2)
			flag = 0;
			else
			flag = 1;
			end
		else
			flag = 1;
	end
reg [63:0]mask=64'd1;
wire [31:0]temp_readDataBank;
assign temp_readDataBank = readDataBank;

assign hit = hitWay0 || hitWay1 || hitWay2 || hitWay3;

always@(*)
	begin
		if(write)
			begin
				if(hit)
					begin
					writeMiss = 1'b0;
					wEnData   = 64'd0;
					wEnMainMemWen = 4'd0;
					TWEnWay0  = 1'b0;
					TWEnWay1  = 1'b0;
					TWEnWay2  = 1'b0;
					TWEnWay3  = 1'b0;
					//waySelect = 2'd0;
					LRUwEn = 1'b0;
					hault  = 1'b0;
					readMiss = 1'b0;
					haultWH = 1'b1;
					if(hitWay0 && !hitWay1 && !hitWay2 && !hitWay3) //write hit way0
						begin
						waySelect = 2'd0;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << (4*offset[5:2]);				//shifting 1 bit offset*4 times to enable the bank
					    lruIn0 = 3;
							//lru algo
						if(lruOut1 > lruOut0)
							lruIn1 = lruOut1 - 1;
						else
							lruIn1 = lruOut1;

				
						if(lruOut2 > lruOut0)
							lruIn2 = lruOut2 - 1;
						else
							lruIn2 = lruOut2;
						
						if(lruOut3 > lruOut0)
							lruIn3 = lruOut3 - 1;
						else
							lruIn3 = lruOut3;
						
						LRUwEn = 1'b1;
						haultWH = 0;

						end
					else if(!hitWay0 && hitWay1 && !hitWay2 && !hitWay3)		//write hit way1 
						begin
						waySelect = 2'd1;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << ((4*offset[5:2])+1);
						
						lruIn1 = 3;
							//lru algo
						if(lruOut0 > lruOut1)
							lruIn0 = lruOut0 - 1;
						else
							lruIn0 = lruOut0;

				
						if(lruOut2 > lruOut1)
							lruIn2 = lruOut2 - 1;
						else
							lruIn2 = lruOut2;
						
						if(lruOut3 > lruOut1)
							lruIn3 = lruOut3 - 1;
						else
							lruIn3 = lruOut3;

						LRUwEn = 1'b1;
						haultWH = 0;

						end
					else if (!hitWay0 && !hitWay1 && hitWay2 && !hitWay3) //write hit way2
						begin
						waySelect = 2'd2;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << ((4*offset[5:2])+2);
						lruIn2 = 3;

							//lru algo
						if(lruOut0 > lruOut2)
							lruIn0 = lruOut0 - 1;
						else
							lruIn0 = lruOut0;

				
						if(lruOut1 > lruOut2)
							lruIn1 = lruOut1 - 1;
						else
							lruIn1 = lruOut1;
						
						if(lruOut3 > lruOut2)
							lruIn3 = lruOut3 - 1;
						else
							lruIn3 = lruOut3;

						LRUwEn = 1'b1;
						haultWH = 0;
						end
					else
						begin
						waySelect = 2'd3;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << ((4*offset[5:2])+3);

						lruIn3 = 3;
							//lru algo
						if(lruOut0 > lruOut3)
							lruIn0 = lruOut0 - 1;
						else
							lruIn0 = lruOut0;

				
						if(lruOut1 > lruOut3)
							lruIn1 = lruOut1 - 1;
						else
							lruIn1 = lruOut1;
						
						if(lruOut2 > lruOut3)
							lruIn2 = lruOut2 - 1;
						else
							lruIn2 = lruOut2;
						LRUwEn = 1'b1;
						haultWH = 0;
					end
					end
				else //write not hit
					begin
					writeMiss = 1'b1;
					wEnData   = 64'd0;
					wEnMainMemWen = 4'd0;
					TWEnWay0  = 1'b0;
					TWEnWay1  = 1'b0;
					TWEnWay2  = 1'b0;
					TWEnWay3  = 1'b0;
					waySelect = 2'd0;
					LRUwEn = 1'b0;
					hault  = 1'b0;
					readMiss = 1'b0;
					haultWH = 1'b0;
					end
			end
		else //read
			begin
			if(opcode == 5'd0) //load
				begin
				writeMiss = 1'b0;
				haultWH = 1'b0;
				readMiss = 1'b1;
					if(hit) //read hit
						begin
						wEnData  = 64'd0;
						TWEnWay0 = 1'b0;
						TWEnWay1 = 1'b0;
						TWEnWay2 = 1'b0;
						TWEnWay3 = 1'b0;
						//waySelect = 2'd0;
						LRUwEn = 1'b1;
						hault = 1'b0;
						readMiss = 1'b0;
						//read hit way 0
						if(hitWay0 && !hitWay1 && !hitWay2 && !hitWay3)
							begin
							waySelect = 2'd0;
							lruIn0 = 3;

							//lru algo
							if(lruOut1 > lruOut0)
								lruIn1 = lruOut1 - 1;
							else
								lruIn1 = lruOut1;
	
					
							if(lruOut2 > lruOut0)
								lruIn2 = lruOut2 - 1;
							else
								lruIn2 = lruOut2;
							
							if(lruOut3 > lruOut0)
								lruIn3 = lruOut3 - 1;
							else
								lruIn3 = lruOut3;

							end
					
						//read hit way 1
						else if(!hitWay0 && hitWay1 && !hitWay2 && !hitWay3)
							begin
							waySelect = 2'd1;
							lruIn1 = 3;

							//lru algo
							if(lruOut0 > lruOut1)
								lruIn0 = lruOut0 - 1;
							else
								lruIn0 = lruOut0;
	
					
							if(lruOut2 > lruOut1)
								lruIn2 = lruOut2 - 1;
							else
								lruIn2 = lruOut2;
							
							if(lruOut3 > lruOut1)
								lruIn3 = lruOut3 - 1;
							else
								lruIn3 = lruOut3;
							end

						//read hit way 2
						else if(!hitWay0 && !hitWay1 && hitWay2 && !hitWay3)
							begin
							waySelect = 2'd2;
							lruIn2 = 3;

							//lru algo
							if(lruOut0 > lruOut2)
								lruIn0 = lruOut0 - 1;
							else
								lruIn0 = lruOut0;
	
					
							if(lruOut1 > lruOut2)
								lruIn1 = lruOut1 - 1;
							else
								lruIn1 = lruOut1;
							
							if(lruOut3 > lruOut2)
								lruIn3 = lruOut3 - 1;
							else
								lruIn3 = lruOut3;
							end	

						//read hit way 3
						else if(!hitWay0 && !hitWay1 && !hitWay2 && hitWay3)
							begin
							waySelect = 2'd3;
							lruIn3 = 3;

							//lru algo
							if(lruOut0 > lruOut3)
								lruIn0 = lruOut0 - 1;
							else
								lruIn0 = lruOut0;
	
					
							if(lruOut1 > lruOut3)
								lruIn1 = lruOut1 - 1;
							else
								lruIn1 = lruOut1;
							
							if(lruOut2 > lruOut3)
								lruIn2 = lruOut2 - 1;
							else
								lruIn2 = lruOut2;
							end								
						end

					else //read miss
						begin
						hault =1'b1;
						wEnData  = 64'd0;
						wEnMainMemWen = 4'd0;
						TWEnWay0 = 1'b0;
						TWEnWay1 = 1'b0;
						TWEnWay2 = 1'b0;
						TWEnWay3 = 1'b0;
						waySelect = 2'd0;
						LRUwEn = 1'b0;
						readMiss = 1'b1;
						
						if(ready) //wait till the main mem is ready to send data
							begin
							//lru update
							if(lruOut0 == 0) 
								begin
								lruIn0 = 3;
								lruIn1 = lruOut1 - 1;
								lruIn2 = lruOut2 - 1;
								lruIn3 = lruOut3 - 1;
								TWEnWay0 = 1'b1;
								TWEnWay1 = 1'b0;
								TWEnWay2 = 1'b0;
								TWEnWay3 = 1'b0;
								LRUwEn = 1'b1;
								waySelect = 2'd0;
								wEnData = 64'h1111_1111_1111_1111;
								hault =1'b0;
								readMiss = 1'b1;
							
								end
							else if(lruOut1 == 0)
								begin
								lruIn1 = 3;
								lruIn0 = lruOut0 - 1;
								lruIn2 = lruOut2 - 1;
								lruIn3 = lruOut3 - 1;
								TWEnWay0 = 1'b0;
								TWEnWay1 = 1'b1;
								TWEnWay2 = 1'b0;
								TWEnWay3 = 1'b0;
								LRUwEn = 1'b1;
								waySelect = 2'd1;
								wEnData = 64'h2222_2222_2222_2222;
								hault =1'b0;
								readMiss = 1'b1;
								
								end
						    else if(lruOut2 == 0)
								begin
								lruIn2 = 3;
								lruIn0 = lruOut0 - 1;
								lruIn1 = lruOut1 - 1;
								lruIn3 = lruOut3 - 1;
								TWEnWay0 = 1'b0;
								TWEnWay1 = 1'b0;
								TWEnWay2 = 1'b1;
								TWEnWay3 = 1'b0;
								LRUwEn = 1'b1;
								waySelect = 2'd2;
								wEnData = 64'h4444_4444_4444_4444;
								hault =1'b0;
								readMiss = 1'b1;
								end
							else
								begin
								lruIn3 = 3;
								lruIn0 = lruOut0 - 1;
								lruIn1 = lruOut1 - 1;
								lruIn2 = lruOut2 - 1;
								TWEnWay0 = 1'b0;
								TWEnWay1 = 1'b0;
								TWEnWay2 = 1'b0;
								TWEnWay3 = 1'b1;
								LRUwEn = 1'b1;
								hault =1'b0;
								readMiss = 1'b1;
								waySelect = 2'd3;
								wEnData = 64'h8888_8888_8888_8888;
								hault =1'b0;
								readMiss = 1'b1;
								end

							end
						else
							begin
							//hault = 1'b1;
							wEnData  = 64'd0;
							wEnMainMemWen = 4'd0;
							TWEnWay0 = 1'b0;
							TWEnWay1 = 1'b0;
							TWEnWay2 = 1'b0;
							TWEnWay3 = 1'b0;
							waySelect = 2'd0;
							LRUwEn = 1'b0;
							readMiss = 1'b1;
							end
						end
				end
			else //instruction is not load
				begin
					wEnData  = 64'd0;
					TWEnWay0 = 1'b0;
					TWEnWay1 = 1'b0;
					TWEnWay2 = 1'b0;
					TWEnWay3 = 1'b0;
					waySelect = 2'd0;
					LRUwEn = 1'b0;
					hault = 1'b0;
					readMiss = 1'b0;
				end
			end
	end


task writeHit(
	input [1:0]mode,
	input [31:0]ProcData,
	input [31:0]readData, //READ DATA BANK
	input [1:0]offset2Bits,
	output reg [31:0]outData 
);
	begin
		case(mode)
		2'b00:	outData = ProcData; //sw
		2'b01:  //shw
			begin	
				case(offset[1])
				1'b0:outData = {readData[31:16],ProcData[15:0]};
				1'b1:outData = {ProcData[15:0],readData[15:0]};
				endcase
			end
		2'b10: //sb
			begin
				case(offset[1:0])
				2'b00:outData = {readData[31:8],ProcData[7:0]};
				2'b01:outData = {readData[31:16],ProcData[7:0],readData[7:0]};
				2'b10:outData = {readData[31:24],ProcData[7:0],readData[15:0]};
				2'b11:outData = {ProcData[31:24],readData[23:0]};
				endcase
			end

		default:outData = {32{1'b0}};
		endcase
	end

endtask

endmodule



/*
module cacheController#(
parameter offsetWidth
)
(
input clk,
input reset,
input [2:0]mode,
input ready,
output reg hault,
input [31:0]wDataDFProcessor,
//LRU
output reg [1:0]lruIn0,lruIn1,lruIn2,lruIn3,
input  [1:0]lruOut0,lruOut1,lruOut2,lruOut3,
output reg LRUwEn,

//Tag Mem
output reg TWEnWay0,TWEnWay1,TWEnWay2,TWEnWay3,
input hitWay0,hitWay1,hitWay2,hitWay3,

//cacheBank
output reg [31:0]wDataProcessor,
output reg [63:0]wEnData,
output reg [3:0]wEnMainMemWen,
output reg readMiss,
output reg writeMiss,
output hit,
output reg haultWH,
output reg [1:0]waySelect,
//
input [offsetWidth-1:0]offset,
input write,
input [4:0]opcode,
input [31:0] readDataBank




//output WeBank0,
//output WeBank1,
//output WeBank2,
//output WeBank3,
//output WeBank4,
//output WeBank5,
//output WeBank6,
//output WeBank7,
//output WeBank8,
//output WeBank9,
//output WeBank10,
//output WeBank11,
//output WeBank12,
//output WeBank13,
//output WeBank14,
//output WeBank15

);

reg flag;
reg count = 0;
always@(posedge clk)
	begin
		if(haultWH)
			begin
			count = count +1;
			if(count == 2)
			flag = 0;
			else
			flag = 1;
			end
		else
			flag = 1;
	end
reg [63:0]mask=64'd1;
wire [31:0]temp_readDataBank;
assign temp_readDataBank = readDataBank;

assign hit = hitWay0 || hitWay1 || hitWay2 || hitWay3;

always@(*)
	begin
		if(write)
			begin
				if(hit)
					begin
					writeMiss = 1'b0;
					wEnData   = 64'd0;
					wEnMainMemWen = 4'd0;
					TWEnWay0  = 1'b0;
					TWEnWay1  = 1'b0;
					TWEnWay2  = 1'b0;
					TWEnWay3  = 1'b0;
					//waySelect = 2'd0;
					LRUwEn = 1'b0;
					hault  = 1'b0;
					readMiss = 1'b0;
					haultWH = 1'b1;
					if(hitWay0 && !hitWay1 && !hitWay2 && !hitWay3) //write hit way0
						begin
						waySelect = 2'd0;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << (4*offset[5:2]);				//shifting 1 bit offset*4 times to enable the bank
					    lruIn0 = 3;
							//lru algo
						if(lruOut1 > lruOut0)
							lruIn1 = lruOut1 - 1;
						else
							lruIn1 = lruOut1;

				
						if(lruOut2 > lruOut0)
							lruIn2 = lruOut2 - 1;
						else
							lruIn2 = lruOut2;
						
						if(lruOut3 > lruOut0)
							lruIn3 = lruOut3 - 1;
						else
							lruIn3 = lruOut3;
						
						LRUwEn = 1'b1;
						haultWH = 0;

						end
					else if(!hitWay0 && hitWay1 && !hitWay2 && !hitWay3)		//write hit way1 
						begin
						waySelect = 2'd1;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << ((4*offset[5:2])+1);
						
						lruIn1 = 3;
							//lru algo
						if(lruOut0 > lruOut1)
							lruIn0 = lruOut0 - 1;
						else
							lruIn0 = lruOut0;

				
						if(lruOut2 > lruOut1)
							lruIn2 = lruOut2 - 1;
						else
							lruIn2 = lruOut2;
						
						if(lruOut3 > lruOut1)
							lruIn3 = lruOut3 - 1;
						else
							lruIn3 = lruOut3;

						LRUwEn = 1'b1;
						haultWH = 0;

						end
					else if (!hitWay0 && !hitWay1 && hitWay2 && !hitWay3) //write hit way2
						begin
						waySelect = 2'd2;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << ((4*offset[5:2])+2);
						lruIn2 = 3;

							//lru algo
						if(lruOut0 > lruOut2)
							lruIn0 = lruOut0 - 1;
						else
							lruIn0 = lruOut0;

				
						if(lruOut1 > lruOut2)
							lruIn1 = lruOut1 - 1;
						else
							lruIn1 = lruOut1;
						
						if(lruOut3 > lruOut2)
							lruIn3 = lruOut3 - 1;
						else
							lruIn3 = lruOut3;

						LRUwEn = 1'b1;
						haultWH = 0;
						end
					else
						begin
						waySelect = 2'd3;
						writeHit(mode[1:0],wDataDFProcessor,temp_readDataBank,offset[1:0],wDataProcessor); 
						wEnData   = mask << ((4*offset[5:2])+3);

						lruIn3 = 3;
							//lru algo
						if(lruOut0 > lruOut3)
							lruIn0 = lruOut0 - 1;
						else
							lruIn0 = lruOut0;

				
						if(lruOut1 > lruOut3)
							lruIn1 = lruOut1 - 1;
						else
							lruIn1 = lruOut1;
						
						if(lruOut2 > lruOut3)
							lruIn2 = lruOut2 - 1;
						else
							lruIn2 = lruOut2;
						LRUwEn = 1'b1;
						haultWH = 0;
					end
					end
				else //write not hit
					begin
					writeMiss = 1'b1;
					wEnData   = 64'd0;
					wEnMainMemWen = 4'd0;
					TWEnWay0  = 1'b0;
					TWEnWay1  = 1'b0;
					TWEnWay2  = 1'b0;
					TWEnWay3  = 1'b0;
					waySelect = 2'd0;
					LRUwEn = 1'b0;
					hault  = 1'b0;
					readMiss = 1'b0;
					haultWH = 1'b0;
					end
			end
		else //read
			begin
			if(opcode == 5'd0) //load
				begin
				writeMiss = 1'b0;
				haultWH = 1'b0;
				readMiss = 1'b1;
					if(hit) //read hit
						begin
						wEnData  = 64'd0;
						TWEnWay0 = 1'b0;
						TWEnWay1 = 1'b0;
						TWEnWay2 = 1'b0;
						TWEnWay3 = 1'b0;
						//waySelect = 2'd0;
						LRUwEn = 1'b1;
						hault = 1'b0;
						readMiss = 1'b0;
						//read hit way 0
						if(hitWay0 && !hitWay1 && !hitWay2 && !hitWay3)
							begin
							waySelect = 2'd0;
							lruIn0 = 3;

							//lru algo
							if(lruOut1 > lruOut0)
								lruIn1 = lruOut1 - 1;
							else
								lruIn1 = lruOut1;
	
					
							if(lruOut2 > lruOut0)
								lruIn2 = lruOut2 - 1;
							else
								lruIn2 = lruOut2;
							
							if(lruOut3 > lruOut0)
								lruIn3 = lruOut3 - 1;
							else
								lruIn3 = lruOut3;

							end
					
						//read hit way 1
						else if(!hitWay0 && hitWay1 && !hitWay2 && !hitWay3)
							begin
							waySelect = 2'd1;
							lruIn1 = 3;

							//lru algo
							if(lruOut0 > lruOut1)
								lruIn0 = lruOut0 - 1;
							else
								lruIn0 = lruOut0;
	
					
							if(lruOut2 > lruOut1)
								lruIn2 = lruOut2 - 1;
							else
								lruIn2 = lruOut2;
							
							if(lruOut3 > lruOut1)
								lruIn3 = lruOut3 - 1;
							else
								lruIn3 = lruOut3;
							end

						//read hit way 2
						else if(!hitWay0 && !hitWay1 && hitWay2 && !hitWay3)
							begin
							waySelect = 2'd2;
							lruIn2 = 3;

							//lru algo
							if(lruOut0 > lruOut2)
								lruIn0 = lruOut0 - 1;
							else
								lruIn0 = lruOut0;
	
					
							if(lruOut1 > lruOut2)
								lruIn1 = lruOut1 - 1;
							else
								lruIn1 = lruOut1;
							
							if(lruOut3 > lruOut2)
								lruIn3 = lruOut3 - 1;
							else
								lruIn3 = lruOut3;
							end	

						//read hit way 3
						else if(!hitWay0 && !hitWay1 && !hitWay2 && hitWay3)
							begin
							waySelect = 2'd3;
							lruIn3 = 3;

							//lru algo
							if(lruOut0 > lruOut3)
								lruIn0 = lruOut0 - 1;
							else
								lruIn0 = lruOut0;
	
					
							if(lruOut1 > lruOut3)
								lruIn1 = lruOut1 - 1;
							else
								lruIn1 = lruOut1;
							
							if(lruOut2 > lruOut3)
								lruIn2 = lruOut2 - 1;
							else
								lruIn2 = lruOut2;
							end								
						end

					else //read miss
						begin
						hault =1'b1;
						wEnData  = 64'd0;
						wEnMainMemWen = 4'd0;
						TWEnWay0 = 1'b0;
						TWEnWay1 = 1'b0;
						TWEnWay2 = 1'b0;
						TWEnWay3 = 1'b0;
						waySelect = 2'd0;
						LRUwEn = 1'b0;
						readMiss = 1'b0;
						if(ready) //wait till the main mem is ready to send data
							begin
							//lru update
							if(lruOut0 == 0) 
								begin
								lruIn0 = 3;
								lruIn1 = lruOut1 - 1;
								lruIn2 = lruOut2 - 1;
								lruIn3 = lruOut3 - 1;
								TWEnWay0 = 1'b1;
								TWEnWay1 = 1'b0;
								TWEnWay2 = 1'b0;
								TWEnWay3 = 1'b0;
								LRUwEn = 1'b1;
								waySelect = 2'd0;
								wEnData = 64'h1111_1111_1111_1111;
								hault =1'b0;
								readMiss = 1'b1;
								end
							else if(lruOut1 == 0)
								begin
								lruIn1 = 3;
								lruIn0 = lruOut0 - 1;
								lruIn2 = lruOut2 - 1;
								lruIn3 = lruOut3 - 1;
								TWEnWay0 = 1'b0;
								TWEnWay1 = 1'b1;
								TWEnWay2 = 1'b0;
								TWEnWay3 = 1'b0;
								LRUwEn = 1'b1;
								waySelect = 2'd1;
								wEnData = 64'h2222_2222_2222_2222;
								hault =1'b0;
								readMiss = 1'b1;
								end
						    else if(lruOut2 == 0)
								begin
								lruIn2 = 3;
								lruIn0 = lruOut0 - 1;
								lruIn1 = lruOut1 - 1;
								lruIn3 = lruOut3 - 1;
								TWEnWay0 = 1'b0;
								TWEnWay1 = 1'b0;
								TWEnWay2 = 1'b1;
								TWEnWay3 = 1'b0;
								LRUwEn = 1'b1;
								waySelect = 2'd2;
								wEnData = 64'h4444_4444_4444_4444;
								hault =1'b0;
								readMiss = 1'b1;
								end
							else
								begin
								lruIn3 = 3;
								lruIn0 = lruOut0 - 1;
								lruIn1 = lruOut1 - 1;
								lruIn2 = lruOut2 - 1;
								TWEnWay0 = 1'b0;
								TWEnWay1 = 1'b0;
								TWEnWay2 = 1'b0;
								TWEnWay3 = 1'b1;
								LRUwEn = 1'b1;
								hault =1'b0;
								readMiss = 1'b1;
								waySelect = 2'd3;
								wEnData = 64'h8888_8888_8888_8888;
								hault =1'b0;
								readMiss = 1'b1;
								end

							end
						else
							begin
							hault =1'b1;
							wEnData  = 64'd0;
							wEnMainMemWen = 4'd0;
							TWEnWay0 = 1'b0;
							TWEnWay1 = 1'b0;
							TWEnWay2 = 1'b0;
							TWEnWay3 = 1'b0;
							waySelect = 2'd0;
							LRUwEn = 1'b0;
							readMiss = 1'b0;
							end
						end
				end
			else //instruction is not load
				begin
					wEnData  = 64'd0;
					TWEnWay0 = 1'b0;
					TWEnWay1 = 1'b0;
					TWEnWay2 = 1'b0;
					TWEnWay3 = 1'b0;
					waySelect = 2'd0;
					LRUwEn = 1'b0;
					hault = 1'b0;
					readMiss = 1'b0;
				end
			end
	end


task writeHit(
	input [1:0]mode,
	input [31:0]ProcData,
	input [31:0]readData, //READ DATA BANK
	input [1:0]offset2Bits,
	output reg [31:0]outData 
);
	begin
		case(mode)
		2'b00:	outData = ProcData; //sw
		2'b01:  //shw
			begin	
				case(offset[1])
				1'b0:outData = {readData[31:16],ProcData[15:0]};
				1'b1:outData = {ProcData[15:0],readData[15:0]};
				endcase
			end
		2'b10: //sb
			begin
				case(offset[1:0])
				2'b00:outData = {readData[31:8],ProcData[7:0]};
				2'b01:outData = {readData[31:16],ProcData[7:0],readData[7:0]};
				2'b10:outData = {readData[31:24],ProcData[7:0],readData[15:0]};
				2'b11:outData = {ProcData[31:24],readData[23:0]};
				endcase
			end

		default:outData = {32{1'b0}};
		endcase
	end

endtask

endmodule
*/