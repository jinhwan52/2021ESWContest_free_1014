// jh_PE4FDTD  
module jh_PE4FDTD
#(
	parameter Z_SIZE = 7'd110,		// Z_SIZE must over 6d10
				 R_SIZE = 5'd20
)
(
	input 			clk,
	input 			rst,
	input	 [31:0]	pe_number32,
	input	 [5:0]	target_pe,
	input	 [26:0]	r,
	input  [15:0]  iteration_number,
	input	 [26:0]	data,
	input	 [6:0]	addr,
	input 			we,
	input  			computing_on,
	input  [26:0]	n_top,			// n, n1 value from top PE
	input	 [26:0]	n_bottom,		// n, n1 value from bottom PE 
	output [26:0]	out_n,
	output [6:0]	out_n_addr,
	output [26:0]	Vn1,
	output [6:0]	Vn1_addr,
	output 			starting_write,
	output 			finishing_fdtd
);
	wire [5:0] pe_number;
	assign pe_number = pe_number32[5:0];
	
	///////////////////////
	// Declare M10K for PE	
	
	// M10K for voltage value
	wire [26:0]	M10K1_q;
	wire [26:0] M10K1_data;
	wire [6:0] M10K1_readaddr, M10K1_writeaddr;
	wire M10K1_we;
	
	M10K_27 mem_voltage_value(
		.data(M10K1_data),
		.read_addr(M10K1_readaddr),
		.write_addr(M10K1_writeaddr),
		.we(M10K1_we), 
		.clk(clk), 
		.q(M10K1_q)
	);

	///////////////////////////////
	// FDTD computation
	reg [26:0] 	fdtd_data;
	reg [6:0]  	fdtd_readaddr, fdtd_writeaddr;
	reg 			fdtd_we;
	reg [3:0] 	state_fdtd;
	reg [3:0]	repeat_cycle;
	reg [26:0] 	V_right;
	reg [26:0] 	V_left;	
	reg [26:0] 	V_center;
	wire [26:0] V_top;
	wire [26:0] V_bottom;
	wire [26:0] fdtd_result;
	reg [15:0]	itration;
	reg [26:0] 	second_node, last_second_node;

	// FDTD computation unit
	jh_efield ce(
		.rst(rst),
		.clock(clk), 
		.r(r),
		.V_right(V_right),							// V_r,z+1
		.V_left(V_left),								// V_r,z-1
		.V_top(V_top), 								// V_r+1,z (top of V_r,z)
		.V_bottom(V_bottom), 						// V_r-1,z (bottom of V_r,z)
		.fdtd_result(fdtd_result)
	);	// takes 3 clocks.
		
	reg 	start_trigger;
	assign V_top = n_top;
	assign V_bottom = n_bottom;
	assign finishing_fdtd = (itration == iteration_number) ? 1'b1 : 1'b0;
	assign starting_write = start_trigger;
	
	always @(posedge clk) begin
		if(rst) begin
			fdtd_readaddr <= 0;
			fdtd_writeaddr <= 0;
			fdtd_data <= 0;
			fdtd_we <= 0;
			itration <= 0;
			repeat_cycle <= 0;
			start_trigger <= 0; 
			state_fdtd <= 4'd0;
		end
		// Single iteration takes 119 clocks. Ex) 5000 iteration takes 595,000 = At 100 Mhz (10 nsec/1 clk), about 5.95 msec. 
		if (state_fdtd == 4'd0 && computing_on) begin	
			fdtd_we <= 0;
			itration	<= itration + 16'd1;	
			state_fdtd <= 4'd1;
		end
		if (state_fdtd == 4'd1 && !finishing_fdtd) begin
			fdtd_readaddr <= fdtd_readaddr + 6'd1;
			state_fdtd <= 4'd2;
		end
		// Wait the first FDTD result
		if (state_fdtd == 4'd2) begin
			fdtd_readaddr <= fdtd_readaddr + 6'd1;
			V_right <= M10K1_q;
			V_center <= V_right;
			V_left <= V_center;
			repeat_cycle <= (repeat_cycle == 3'd7) ? 1'd0 : repeat_cycle + 3'd1;
			state_fdtd <= (repeat_cycle == 3'd7)  ? 6'd3 : 6'd2;
		end
		//Start to write FDTD results
		if (state_fdtd == 4'd3) begin
			fdtd_readaddr <= fdtd_readaddr + 6'd1;	
			V_right <= M10K1_q;
			V_center <= V_right;
			V_left <= V_center;
			fdtd_we <= 1;								// Start to write FDTD results
			fdtd_data <= fdtd_result;
			fdtd_writeaddr <= fdtd_writeaddr + 6'd1;
			second_node <= fdtd_result;
			start_trigger <= 1'b1;
			state_fdtd <=4'd4;							  
		end
		// Start to save FDTD results to M10K block
		if (state_fdtd == 4'd4) begin
			V_right <= M10K1_q;
			V_center <= V_right;
			V_left <= V_center;	
			fdtd_we <= 1;
			fdtd_readaddr <= fdtd_readaddr + 6'd1;
			fdtd_data <= fdtd_result;
			fdtd_writeaddr <= fdtd_writeaddr+6'd1;
			state_fdtd <= (fdtd_readaddr == Z_SIZE-2) ? 4'd5 : 4'd4;								  
		end
		// In this state, fdtd_readaddr is Z_SIZE-2
		if (state_fdtd == 4'd5) begin 
			V_right <= M10K1_q;
			V_center <= V_right;
			V_left <= V_center;
			fdtd_readaddr <= fdtd_readaddr + 6'd1;			// one more read for boundary condition
			fdtd_we <= 1;
			fdtd_data <= fdtd_result;
			fdtd_writeaddr <= fdtd_writeaddr+6'd1;
			state_fdtd <= 4'd6;							  
		end
		// load z[end-2], z[end-1], z[end] to FDTD computing unit
		if (state_fdtd == 4'd6) begin
			V_right <= M10K1_q;
			V_center <= V_right;
			V_left <= V_center;	
			fdtd_readaddr <= 0;		// Stop read M10K, Start update M10K
			fdtd_we <= 1;
			fdtd_data <= fdtd_result;
			fdtd_writeaddr <= fdtd_writeaddr+6'd1;
			state_fdtd <= 4'd7;							  
		end
		// Save the FDTD result before three clks to M10K block 
		if (state_fdtd == 4'd7) begin
			fdtd_we <= 1;
			fdtd_data <= fdtd_result;
			fdtd_writeaddr <= fdtd_writeaddr+6'd1;
			repeat_cycle <= (repeat_cycle == 3'd4) ? 1'd0 : repeat_cycle + 3'd1;
			state_fdtd <= (repeat_cycle == 3'd4)  ? 4'd8 : 4'd7;						  
		end
		// Save the FDTD result before three clks to M10K block
		if (state_fdtd == 4'd8) begin
			fdtd_we <= 1;
			fdtd_data <= fdtd_result;
			fdtd_writeaddr <= fdtd_writeaddr+6'd1;
			last_second_node <= fdtd_result;
			state_fdtd <= 4'd9;							  
		end
		// Save the FDTD result before three clks to M10K block
		if (state_fdtd == 4'd9) begin
			fdtd_we <= 1;
			fdtd_data <= last_second_node;
			fdtd_writeaddr <= fdtd_writeaddr+6'd1;
			state_fdtd <= 4'd10;							  
		end
		// Boundary condition at the last node
		if (state_fdtd == 4'd10) begin							
			fdtd_we <= 1;
			fdtd_data <= second_node;
			fdtd_writeaddr <= 6'd0;
			state_fdtd <= 4'd11;							  
		end
		// Boundary condition at the first node
		if (state_fdtd == 4'd11) begin							
			fdtd_we <= 0;
			start_trigger <= 1'b0;
			state_fdtd <= 4'd0;							  
		end
	end
	
	///////////////////////
	// Declare MUX to connect HPS and CU in PE
	
	// mux for mem_voltage_value		
	wire [26:0] mux1_data;
	wire [6:0] 	mux1_readaddr, mux1_writeaddr;
	wire 			mux1_we;
   assign mux1_data = computing_on ? fdtd_data : data;	
	assign mux1_readaddr = computing_on ? fdtd_readaddr : addr;
	assign mux1_writeaddr = computing_on ? fdtd_writeaddr : addr;
	assign mux1_we = computing_on ? fdtd_we : we;
	mux_inpe mux1(
		.computing_on(computing_on),
		.target_pe(target_pe),
		.pe_number(pe_number),
		.in_we(mux1_we),
		.in_readaddr(mux1_readaddr), 
		.in_writeaddr(mux1_writeaddr), 
		.in_data(mux1_data),	
		.out_we(M10K1_we),
		.out_readaddr(M10K1_readaddr),
		.out_writeaddr(M10K1_writeaddr),
		.out_data(M10K1_data)
	);
			
	////////////////////////////
	// Output of PE4FDTD module
	assign out_n = computing_on ? V_center : M10K1_q; 	
	assign out_n_addr = fdtd_readaddr;
	assign Vn1 = fdtd_data;
	assign Vn1_addr = fdtd_writeaddr;
	
endmodule
module mux_inpe
(
	input				computing_on,
	input	 [5:0]	target_pe,
	input	 [5:0]	pe_number,
	// input 1 = HPS, input 2 = PE
	input 			in_we,
	input	 [6:0]	in_readaddr, in_writeaddr,
	input  [26:0]	in_data,	
	output reg			out_we,
	output reg [6:0] 	out_readaddr, out_writeaddr,
	output reg [26:0] out_data
);
	always @(*) begin
		if(computing_on) begin // All PEs operates at the same time
			out_we = in_we;
			out_readaddr = in_readaddr;
			out_writeaddr = in_writeaddr;
			out_data = in_data;
		end
		else begin
			if(pe_number == target_pe) begin // PEs operates seperatelly.
				out_we = in_we ;
				out_readaddr = in_readaddr ;
				out_writeaddr = in_writeaddr ;
				out_data = in_data ;
			end
		end
	end // end always module

endmodule


// Quartus Prime Verilog Template
// Simple Dual Port RAM with separate read/write addresses and
// single read/write clock

module M10K_27
#(parameter DATA_WIDTH=27, parameter ADDR_WIDTH=7)
(
	input [(DATA_WIDTH-1):0] data,
	input [(ADDR_WIDTH-1):0] read_addr, write_addr,
	input we, clk,
	output reg [(DATA_WIDTH-1):0] q
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0] 	/* synthesis ramstyle = "no_rw_check, M10K" */;

	always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[write_addr] <= data;

		// Read (if read_addr == write_addr, return OLD data).	To return
		// NEW data, use = (blocking write) rather than <= (non-blocking write)
		// in the write assignment.	 NOTE: NEW data may require extra bypass
		// logic around the RAM.
		q <= ram[read_addr];
	end

endmodule

