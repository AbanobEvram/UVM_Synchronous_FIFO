////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: TOP_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
import fifo_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
module top();
 bit clk;
initial begin
	clk=0;
	forever
		#1 clk=~clk;
end

fifo_if f_if(clk);

FIFO DUT(
	     .data_in(f_if.data_in),
	     .wr_en(f_if.wr_en),
	     .rd_en(f_if.rd_en),
	     .clk(f_if.clk),
	     .rst_n(f_if.rst_n),
	     .full(f_if.full),
	     .empty(f_if.empty),
	     .almostfull(f_if.almostfull),
	     .almostempty(f_if.almostempty),
	     .wr_ack(f_if.wr_ack),
	     .overflow(f_if.overflow),
	     .underflow(f_if.underflow),
	     .data_out(f_if.data_out)
	    );

bind FIFO fifo_sva SVA(
	     .data_in(f_if.data_in),
	     .wr_en(f_if.wr_en),
	     .rd_en(f_if.rd_en),
	     .clk(f_if.clk),
	     .rst_n(f_if.rst_n),
	     .full(f_if.full),
	     .empty(f_if.empty),
	     .almostfull(f_if.almostfull),
	     .almostempty(f_if.almostempty),
	     .wr_ack(f_if.wr_ack),
	     .overflow(f_if.overflow),
	     .underflow(f_if.underflow),
	     .data_out(f_if.data_out),
	     .wr_ptr(DUT.wr_ptr),
	     .rd_ptr(DUT.rd_ptr),
	     .count(DUT.count)
	    );

initial begin
	uvm_config_db#(virtual fifo_if)::set(null, "uvm_test_top", "fifo_IF", f_if);
	run_test("fifo_test");
end

endmodule	