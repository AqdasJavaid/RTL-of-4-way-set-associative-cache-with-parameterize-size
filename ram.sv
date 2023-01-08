

module RAM

//parameter
# ( parameter Addr_width = 12,//32, // 32 bits/word
          Datao_width = 512, // 512 bits /16 words
          Datain_width = 32, // word/32bits
          // Depth = 4194304 // 4mb
	 	  Depth = 1024 // 2**10 words
  )
(        
// input ports
input logic clk, 
input logic reset,
input logic Psel,
input logic Penable,
input logic [Addr_width-1:0] addr,
input logic [Datain_width-1:0] data_in ,
input logic readwrite,
input logic [1:0] dsize, // byte halfword and word which size 

//output ports
output logic [Datao_width-1:0] data_out,
output logic ready
);

//logic [ 512:0] p_data;
logic [ Datao_width-1 : 0] t_data;


logic [5:0] counter;


//memory
reg [7:0] ram  [ 0: (Depth*4) -1 ]; // byte addressable memory 

// counter
always @ ( posedge clk)
begin

if (readwrite == 0 && Psel == 1)
    begin
            if (counter < 6'b110_010 ) // if counter < 50
            counter = counter+1;
            else
            counter = 6'b000_000;
    end
end

// if counter is 50 then ready is high
assign ready =  ( Psel==0 && Penable==0 ) ? 1'b0 : ( Psel==1 && Penable==0 ) ? 1'b0 : (readwrite==0 && counter == 6'b110_010) ? 1'b1 : ( readwrite == 1 && Penable==1) ? 1'b1 : 1'b0 ;



 
assign data_out = (ready == 1) ?  t_data : 512'd0 ;


// READ / WRITE LOGIC
always @ ( posedge clk,negedge reset)
begin
    if(!reset)
        for (int i=0; i< Depth*4 ; i=i+1)
         ram [i] = 8'h00;
	 //ready =1'b0;

    if ( readwrite == 0 && Psel == 1 ) // read
    begin
        
//for (i=0;i<512;i+=8)
//	begin
//	t_data[(i+7) : i] = ram [addr + ((i+1)/8)];
	//p_data = {p_data[64:64-i],t_data[i+7:i],p_data[i:0]}
//	end
                t_data [ 7 : 0]   = ram [{addr[11:6],6'b000000}]; 
                t_data [ 15 : 8]  = ram [{addr[11:6],6'b000001}];
                t_data [ 23 : 16] = ram [{addr[11:6],6'b000010}];
                t_data [ 31 : 24] = ram [{addr[11:6],6'b000011}]; 
                t_data [ 39 : 32] = ram [{addr[11:6],6'b000100}];
                t_data [ 47 : 40] = ram [{addr[11:6],6'b000101}];
                t_data [ 55 : 48] = ram [{addr[11:6],6'b000110}];
                t_data [ 63 : 56] = ram [{addr[11:6],6'b000111}];
                t_data [ 71 : 64] = ram [{addr[11:6],6'b001000}]; 
                t_data [ 79 : 72] = ram [{addr[11:6],6'b001001}];  
                t_data [ 87 : 80] = ram [{addr[11:6],6'b001010}];  
                t_data [ 95 : 88] = ram [{addr[11:6],6'b001011}]; 
                t_data [ 103 : 96] = ram [{addr[11:6],6'b001100}]; 
                t_data [ 111 : 104] = ram [{addr[11:6],6'b001101}];
                t_data [ 119 : 112] = ram [{addr[11:6],6'b001110}];
                t_data [ 127 : 120] = ram [{addr[11:6],6'b001111}];
                t_data [ 135 : 128] = ram [{addr[11:6],6'b010000}];
                t_data [ 143 : 136] = ram [{addr[11:6],6'b010001}];
                t_data [ 151 : 144] = ram [{addr[11:6],6'b010010}];
                t_data [ 159 : 152] = ram [{addr[11:6],6'b010011}];
                t_data [ 167 : 160] = ram [{addr[11:6],6'b010100}];
                t_data [ 175 : 168] = ram [{addr[11:6],6'b010101}];
                t_data [ 183 : 176] = ram [{addr[11:6],6'b010110}];
                t_data [ 191 : 184] = ram [{addr[11:6],6'b010111}];//23
                t_data [ 199 : 192] = ram [{addr[11:6],6'b011000}];//24
                t_data [ 207 : 200] = ram [{addr[11:6],6'b011001}];//25
                t_data [ 215 : 208] = ram [{addr[11:6],6'b011010}];//26
                t_data [ 223 : 216] = ram [{addr[11:6],6'b011011}];//27
                t_data [ 231 : 224] = ram [{addr[11:6],6'b011100}];//28
                t_data [ 239 : 232] = ram [{addr[11:6],6'b011101}];//29
                t_data [ 247 : 240] = ram [{addr[11:6],6'b011110}];//30
                t_data [ 255 : 248] = ram [{addr[11:6],6'b011111}];//31
                t_data [ 263 : 256] = ram [{addr[11:6],6'b100000}];//32
                t_data [ 271 : 264] = ram [{addr[11:6],6'b100001}];
                t_data [ 279 : 272] = ram [{addr[11:6],6'b100010}];
                t_data [ 287 : 280] = ram [{addr[11:6],6'b100011}];
                t_data [ 295 : 288] = ram [{addr[11:6],6'b100100}];
                t_data [ 303 : 296] = ram [{addr[11:6],6'b100101}];
                t_data [ 311 : 304] = ram [{addr[11:6],6'b100110}];
                t_data [ 319 : 312] = ram [{addr[11:6],6'b100111}];
                t_data [ 327 : 320] = ram [{addr[11:6],6'b101000}];
                t_data [ 335 : 328] = ram [{addr[11:6],6'b101001}];
                t_data [ 343 : 336] = ram [{addr[11:6],6'b101010}];
                t_data [ 351 : 344] = ram [{addr[11:6],6'b101011}];
                t_data [ 359 : 352] = ram [{addr[11:6],6'b101100}];
                t_data [ 367 : 360] = ram [{addr[11:6],6'b101101}];
                t_data [ 375 : 368] = ram [{addr[11:6],6'b101110}];
                t_data [ 383 : 376] = ram [{addr[11:6],6'b101111}];
                t_data [ 391 : 384] = ram [{addr[11:6],6'b110000}];
                t_data [ 399 : 392] = ram [{addr[11:6],6'b110001}];
                t_data [ 407 : 400] = ram [{addr[11:6],6'b110010}];
                t_data [ 415 : 408] = ram [{addr[11:6],6'b110011}];
                t_data [ 423 : 416] = ram [{addr[11:6],6'b110100}];
                t_data [ 431 : 424] = ram [{addr[11:6],6'b110101}];
                t_data [ 439 : 432] = ram [{addr[11:6],6'b110110}];
                t_data [ 447 : 440] = ram [{addr[11:6],6'b110111}];
                t_data [ 455 : 448] = ram [{addr[11:6],6'b111000}];
                t_data [ 463 : 456] = ram [{addr[11:6],6'b111001}];
                t_data [ 471 : 464] = ram [{addr[11:6],6'b111010}];
                t_data [ 479 : 472] = ram [{addr[11:6],6'b111011}];
                t_data [ 487 : 480] = ram [{addr[11:6],6'b111100}];
                t_data [ 495 : 488] = ram [{addr[11:6],6'b111101}];
                t_data [ 503 : 496] = ram [{addr[11:6],6'b111110}];
                t_data [ 511 : 504] = ram [{addr[11:6],6'b111111}];
		
		

    end
    else 
    begin
        if ( readwrite == 1 && Psel == 1 && Penable == 1) // write when Penable is 1 then write data will be available from bridge
        begin
           if (dsize == 2'b10) //byte
				begin
				case(addr[1:0])
				2'b00:ram [{addr[11:2],2'b00}] = data_in[7:0];
				2'b00:ram [{addr[11:2],2'b01}] = data_in[7:0];
				2'b00:ram [{addr[11:2],2'b10}] = data_in[7:0];
				2'b00:ram [{addr[11:2],2'b11}] = data_in[7:0];
				endcase
				end
                ram [addr] = data_in[7:0] ;

            if (dsize == 2'b01) // halfword
            begin
				case(addr[1])
                1'b0: 
					begin
					ram [{addr[11:2],2'b00}] = data_in[7:0] ;
                	ram [{addr[11:2],2'b01}] = data_in [15:8];
					end
				1'b1: 
					begin
					ram [{addr[11:2],2'b10}] = data_in[7:0] ;
                	ram [{addr[11:2],2'b11}] = data_in [15:8];
					end
				endcase

            end
	    	
            if (dsize == 2'b00) // word
            begin
                ram [{addr[11:2],2'b00}] = data_in[7:0] ;
                ram [{addr[11:2],2'b01}] = data_in [15:8];
                ram [{addr[11:2],2'b10}] = data_in[23:16] ;
                ram [{addr[11:2],2'b11}] = data_in [31:24];
		//ready = 1'b1;
            end
        end
    end

end

endmodule