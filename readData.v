
module readData (

input  [31:0] readDataBank,
input  [511:0] wDataMainMem,
input  [2:0]  mode,
input  [5:0]  offset,
input readMiss,
output reg [31:0] dout);

wire [7:0] byte;
wire [31:0]dataR;
wire [31:0]readDRam;

assign byte = (offset[1:0] == 2'd0) ? dataR[7:0]  :
			  (offset[1:0] == 2'd1) ? dataR[15:8] :
              (offset[1:0] == 2'd2) ? dataR[23:16]: dataR[31:24];

//incase of readmiss, readout will go directly to dout
assign readDRam = (offset[5:2]==4'd0) ? wDataMainMem[31:0]    :
				  (offset[5:2]==4'd1) ? wDataMainMem[63:32]   :
				  (offset[5:2]==4'd2) ? wDataMainMem[95:64]   :
				  (offset[5:2]==4'd3) ? wDataMainMem[127:96]  :
				  (offset[5:2]==4'd4) ? wDataMainMem[159:128] :
				  (offset[5:2]==4'd5) ? wDataMainMem[191:160] :
				  (offset[5:2]==4'd6) ? wDataMainMem[223:192] :
				  (offset[5:2]==4'd7) ? wDataMainMem[255:224] :
				  (offset[5:2]==4'd8) ? wDataMainMem[287:256] :
				  (offset[5:2]==4'd9) ? wDataMainMem[319:288] :
				  (offset[5:2]==4'd10)? wDataMainMem[351:320] :
				  (offset[5:2]==4'd11)? wDataMainMem[383:352] :
				  (offset[5:2]==4'd12)? wDataMainMem[415:384] :
				  (offset[5:2]==4'd13)? wDataMainMem[447:416] :
				  (offset[5:2]==4'd14)? wDataMainMem[479:448] : wDataMainMem[511:480];


assign dataR = readMiss ? readDRam :readDataBank; //select between processor data and Main Ram data

always@(*)
	begin
		case(mode)
		3'b000:	dout = dataR; //lw
		3'b001:  //lh
			begin	
				case(offset[1])
				1'b0:dout = {{16{dataR[15]}},dataR[15:0]};
				1'b1:dout = {{16{dataR[31]}},dataR[31:16]};
				endcase
			end
		3'b010: //lb
			begin
				case(offset[1:0])
				2'b00:dout = {{24{dataR[7]}},dataR[7:0]};
				2'b01:dout = {{24{dataR[15]}},dataR[15:8]};
				2'b10:dout = {{24{dataR[23]}},dataR[23:16]};
				2'b11:dout = {{24{dataR[31]}},dataR[31:24]};
				endcase
			end

		3'b011: //lbu
			begin
				case(offset[1:0])
				2'b00:dout = {24'd0,dataR[7:0]};
				2'b01:dout = {24'd0,dataR[15:8]};
				2'b10:dout = {24'd0,dataR[23:16]};
				2'b11:dout = {24'd0,dataR[31:24]};
				endcase
			end
		3'b100:  //lhu
			begin
				case(offset[1])
				1'b0:dout = {16'd0,dataR[15:0]};
				1'b1:dout = {16'd0,dataR[31:16]};
				endcase
			end

		default:dout = {32{1'b0}};
		endcase
	end
endmodule