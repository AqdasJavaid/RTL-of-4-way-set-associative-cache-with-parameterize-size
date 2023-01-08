


module APB_Bridge #(parameter AddWidth = 12) 
(
//clk and reset
input logic clk,
input logic reset,
input logic [1:0] dsize,
//from core
input logic readwrite1,
input logic [AddWidth-1:0] addr,
input logic [31:0] write_data,

input logic transfer,

//from slave(ram)
input logic [511:0] Prdata,
input logic Pready,

// outputs to APB
output logic Psel,
output logic Pwrite,
output logic Penable,
output logic [AddWidth-1:0] Paddr,
output logic [31:0] Pwdata, // write data to ram
output logic [1:0] dsizeout,
output logic [511:0] apb_dataout, //read data to core
output logic apb_preadyw, // pready to processor
output logic apb_preadyr
) ;

/// Logic Implementation
// we will implement it through state machine

//delay
logic readwrite,readwrite2;
always@(posedge clk)
		readwrite2 = readwrite1;

always@(posedge clk)
		readwrite = readwrite2;
//////////////////////////////////////////
//fsm Variables
logic [1:0] current_state;
logic [1:0] next_state;  

localparam IDLE = 2'b00 ;
localparam SETUP = 2'b01 ;
localparam ACCESS = 2'b10 ;

//Sequential logic
always @ ( posedge clk )
    begin
        if ( !reset )
        current_state <= IDLE;

        else
        current_state <= next_state;
    end

//combinational logic
always@(*)
    begin
        
        case (current_state)
        
        IDLE: 
        	begin
             if (transfer) 
             next_state = SETUP ;
             else
             next_state = current_state;
         
         //outputs
             Penable = 1'b0;
             Psel = 1'b0;
             //apb_valid = 1'b0;
             Pwrite   = 1'b0; 
             Pwdata   = 32'd0;
			 Paddr    = {AddWidth{1'b0}};//32'd0;
	         dsizeout = dsize;
	         apb_preadyw = Pready;
             apb_preadyr = Pready;
                      
              end
        SETUP: begin
                    next_state = ACCESS ; // on next clock edge it will go to access state
                    
                    Penable = 1'b0;
                    Psel = 1'b1;
                   // apb_valid = 1'b0;
                    Pwrite = readwrite; 
                    Pwdata = write_data;
                    Paddr  = addr;
		    apb_preadyw = ( readwrite && Pready	) ? 1'b1 : 1'b0 ;
		    apb_preadyr = ( !readwrite && Pready ) ? 1'b1 : 1'b0 ;
		               
                end

        ACCESS: begin
                    if (!Pready)
                    next_state = current_state;    
                    else 
                    begin
                        if (transfer) // pready 1 && transfer 1
                            next_state = SETUP;
                        else
                            next_state = IDLE;
                    end

                            Penable = 1'b1;
                            Psel = 1'b1;
                            Pwrite = readwrite; 
                            Pwdata = write_data;
			    Paddr  = addr;

                            //to core
                            apb_dataout = Prdata ;
                            
		    apb_preadyw = ( readwrite && Pready) ? 1'b1 : 1'b0 ;
		    apb_preadyr = ( !readwrite && Pready ) ? 1'b1 : 1'b0 ;
                            
                end
            
            default: next_state <= IDLE; 
        endcase

    end
endmodule