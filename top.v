
module top #(

parameter				lineSize		= 64,
parameter				cacheSize		= 1024,//1KB
parameter				associativity	= 4,
parameter				dataWidth		= 32, 
parameter				bankWidth		= 4  // 4 bytes
)
(
input					clk,
input					reset,
output   				hault,
input	[4:0]			opcode,
input	[dataWidth-1:0]	address,
input  					write,
input	[dataWidth-1:0]	wData,
input	[2:0]			mode,
output writeMiss,
output  [dataWidth-1:0]dout,
output haultProcessor
);

reg a;

always@(clk) begin
  a = 0;
  a <= 1;
  $display(a);
end

wire [511:0]wDataMainMem;
//----------------------------------TIO------------------------------------------------

wire [$clog2(lineSize)-1:0] offset;
wire [$clog2(cacheSize/(lineSize*associativity))-1:0] index;
wire [dataWidth-$clog2(cacheSize/(lineSize*associativity))-$clog2(lineSize)-1:0] tag;

assign offset = address[$clog2(lineSize)-1:0];
assign index = address[($clog2(cacheSize/(lineSize*associativity)))+($clog2(lineSize))-1:$clog2(lineSize)-1]; //min bit of index  = max bit of offset
assign tag = address[dataWidth-1:$clog2(cacheSize/(lineSize*associativity))+$clog2(lineSize)-1];


wire [3:0]wEnMainMemWen;
wire [1:0]lruIn0,lruIn1,lruIn2,lruIn3,lruOut0,lruOut1,lruOut2,lruOut3,waySelect;
wire [63:0]wEnData;
wire [31:0]wDataProcessor,readDataBank;

wire hault1,haultWH;

reg hault2;
wire ready;
reg readyDelayed;
always@(posedge clk)
	readyDelayed = ready;

reg [31:0] dout1;
always @(posedge clk)
		dout1 = dout;

assign hault = haultWH || hault2;

always @(posedge clk)
		hault2 = hault1;
or(haultProcessor, hault,hault1);
//Controller
cacheController #($clog2(lineSize))
IcacheController (.clk(clk),.reset(reset),.wDataDFProcessor(wData),.write(write),.opcode(opcode),.offset(offset),
				  .mode(mode),.ready(ready),.hault(hault1), //from tb
				  .lruIn0(lruIn0),.lruIn1(lruIn1),.lruIn2(lruIn2),.lruIn3(lruIn3),
			      .lruOut0(lruOut0),.lruOut1(lruOut1),.lruOut2(lruOut2),.lruOut3(lruOut3),.LRUwEn(LRUwEn),//lru

				  .TWEnWay0(TWEnWay0),.TWEnWay1(TWEnWay1),.TWEnWay2(TWEnWay2),.TWEnWay3(TWEnWay3),.hitWay0(hitWay0),
				  .hitWay1(hitWay1),.hitWay2(hitWay2),.hitWay3(hitWay3), //tag Mem
				  .wDataProcessor(wDataProcessor),.wEnData(wEnData),.wEnMainMemWen(wEnMainMemWen),.readMiss(readMiss),.waySelect(waySelect),
				  .hit(hit),.writeMiss(writeMiss),.readDataBank(readDataBank),.haultWH(haultWH)//Cache bank
					);

//Tag Memory
tagMemBlock #(dataWidth-$clog2(cacheSize/(lineSize*associativity))-$clog2(lineSize),
			 (cacheSize/(lineSize*associativity)),
			 ($clog2(cacheSize/(lineSize*associativity)))
			 )
 ITagMem     (.clk(clk),.reset(reset),.tag(tag),.index(index),.TWEnWay0(TWEnWay0),.TWEnWay1(TWEnWay1),
			  .TWEnWay2(TWEnWay2),.TWEnWay3(TWEnWay3),.hitWay0(hitWay0),.hitWay1(hitWay1),.hitWay2(hitWay2),
			  .hitWay3(hitWay3));
//LRU Memory
LRUMemBlock #( (cacheSize/(lineSize*associativity)), // # of sets
			   	($clog2(cacheSize/(lineSize*associativity))) 
			 )
ILRUMemBlock (.clk(clk),.reset(reset),.lruIn0(lruIn0),.lruIn1(lruIn1),.lruIn2(lruIn2),.lruIn3(lruIn3),
              .lruOut0(lruOut0),.lruOut1(lruOut1),.lruOut2(lruOut2),.lruOut3(lruOut3),.LRUwEn(LRUwEn),
			  .index(index) );

//CacheBank
cacheBankBlock #(dataWidth-$clog2(cacheSize/(lineSize*associativity))-$clog2(lineSize), //tag address width
			     associativity, // # of ways
			    (cacheSize/(lineSize*associativity)), //# of sets
			    bankWidth,
			    dataWidth,
			    ($clog2(cacheSize/(lineSize*associativity))) //indexwidth
			    )
IcacheBankBlock ( .clk(clk),.reset(reset),.wDataProcessor(wDataProcessor),.tag(tag),.index(index),
                  .wDataMainMem(wDataMainMem),.wEnMainMemWen(wEnMainMemWen),.wEnData(wEnData),.readMiss(readMiss),
				  .mode(mode),.waySelect(waySelect),.hit(hit),.readDataBank(readDataBank),.offset(offset));


wire [511:0]Prdata,ramData2APB;
wire [31:0]Pwdata;
wire [11:0]Paddr;
wire Psel;
wire [1:0]dsizeout;


//assign trans = write || hault1;

readData IreadData (.readDataBank(readDataBank),.mode(mode),.offset(offset),.readMiss(readMiss),.wDataMainMem(wDataMainMem),.dout(dout));

APB_Bridge i_APB_Bridge (.clk(clk),.reset(reset),.dsize(mode[1:0]),.readwrite1(write),.addr(address[11:0]),.transfer(hault1||write),.write_data(wData),
						 .Prdata(ramData2APB),.Pready(Pready),.Psel(Psel),.Pwrite(Pwrite),.Penable(Penable),.Paddr(Paddr),
                         .Pwdata(Pwdata),.dsizeout(dsizeout),.apb_dataout(wDataMainMem),.apb_preadyw(readyw),.apb_preadyr(ready));

RAM iRam (.clk(clk),.reset(reset),.Psel(Psel),.Penable(Penable),.addr(Paddr),.data_in(Pwdata),.readwrite(Pwrite),.dsize(dsizeout),
		  .data_out(ramData2APB),.ready(Pready));


endmodule
