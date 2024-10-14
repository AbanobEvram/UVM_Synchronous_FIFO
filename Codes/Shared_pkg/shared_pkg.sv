////////////////////////////////////////////////////////////////////////////////
// Author: Abanob Evram
// Description: Sharedpkg_FIFO
// Date: October, 2024 
////////////////////////////////////////////////////////////////////////////////
package shared_pkg;
	parameter FIFO_WIDTH 	= 16;
	parameter FIFO_DEPTH 	= 8;
	parameter MAX_FIFO_ADDR = $clog2(FIFO_DEPTH);
	//For constraints
	parameter RD_EN_ON_DIST=30;
	parameter WR_EN_ON_DIST=70;
	parameter RESET_ON_DIST=5;

	parameter ACTIVE=1;
	parameter INACTIVE=0;

	parameter ACTIVE_RESET=0;
	parameter INACRIVE_RESET=1;

	parameter MAX=(2**FIFO_WIDTH)-1;
	parameter ZERO=0;
endpackage : shared_pkg