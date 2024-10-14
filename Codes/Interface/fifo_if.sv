////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Interface_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
interface fifo_if(input clk);
	//input signals
	logic [FIFO_WIDTH-1:0] data_in;
	logic rst_n, wr_en, rd_en;
	//output signals
	logic [FIFO_WIDTH-1:0] data_out;
	logic wr_ack, overflow;
	logic full, empty, almostfull, almostempty, underflow;
endinterface : fifo_if