////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
// Description: FIFO Design 
////////////////////////////////////////////////////////////////////////////////
import shared_pkg::*;
module FIFO(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
output reg [FIFO_WIDTH-1:0] data_out;
output reg wr_ack, overflow, underflow;
output full, empty, almostfull, almostempty;


logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

logic [MAX_FIFO_ADDR-1:0] wr_ptr, rd_ptr;
logic [MAX_FIFO_ADDR:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack<=0;//reset the wr_ack when rst_n is active
		overflow<=0;//reset the overflow when rst_n is active
	end
	else begin//Edit this condition and handle the overflow cases
		if (wr_en && count < FIFO_DEPTH) begin
			mem[wr_ptr] <= data_in;
			wr_ack <= 1;
			wr_ptr <= wr_ptr + 1;
		end
		else begin 
			wr_ack <= 0; 
		end
		if(wr_en&&count==FIFO_DEPTH)
			overflow<=1;
		else
			overflow<=0;
	end
end

always @(posedge clk or negedge rst_n) begin//Add the underflow flag because it is sequential
	if (!rst_n) begin
		rd_ptr <= 0;
		underflow<=0;//reset the underflow when rst_n is active
	end
	else begin//Edit this condition and handle the underflow cases
		if (rd_en && count != 0) begin
			data_out <= mem[rd_ptr];
			rd_ptr <= rd_ptr + 1;
		end	
		if(rd_en&&count==0)
			underflow<=1;
		else
			underflow<=0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin//Add two cases for the count
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if ( ({wr_en, rd_en} == 2'b11) && full)//1
			count <= count -1;
		else if ( ({wr_en, rd_en} == 2'b11) && empty)//2
			count <= count + 1;
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; //fix the condition of this flag
assign almostempty = (count == 1)? 1 : 0;

endmodule