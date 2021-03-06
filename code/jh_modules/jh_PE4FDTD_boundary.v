
// jh_PE4FDTD  
module jh_PE4FDTD_boundary
(
	input 			clk,
	input 			rst,
	input	 [31:0]	pe_number32,
	input	 [5:0]	target_pe,
	input	 [26:0]	data,
	input	 [6:0]	addr,
	input 			we,
	input 			computing_on, 
	output [26:0]	out_n,
	input	 [6:0]	n_addr,
	input	 [26:0]	Vn1,
	input	 [6:0]	Vn1_addr,
	input 			starting_write,
	input 			finishing_fdtd
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
	
	M10K_27 mem_boundary_condition(
		.data(M10K1_data),
		.read_addr(M10K1_readaddr),
		.write_addr(M10K1_writeaddr),
		.we(M10K1_we), 
		.clk(clk), 
		.q(M10K1_q)
	);
	
	// mux for mem_voltage_value
	wire [26:0] boudary_data;
	wire [6:0] 	boudary_readaddr, boudary_writeaddr;
	wire			boudary_we;	
	wire [26:0] mux1_data;
	wire [6:0] 	mux1_readaddr, mux1_writeaddr;
	wire 			mux1_we;
   assign mux1_data = computing_on ? boudary_data : data;	
	assign mux1_readaddr = computing_on ? boudary_readaddr : addr;
	assign mux1_writeaddr = computing_on ? boudary_writeaddr : addr;
	assign mux1_we = computing_on ? boudary_we : we;
	
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
	assign boudary_data = Vn1;
	assign boudary_writeaddr = Vn1_addr;
	assign boudary_readaddr = n_addr - 7'd2;
	assign boudary_we = 	~(starting_write & ~finishing_fdtd) ? 1'b0 :
								(pe_number == 6'd0) 	? 1'b1 :
								(Vn1_addr < 7'd4) 	? 1'b1 :					//********** Vn1_addr < 7'd4
								(Vn1_addr > 7'd105) 	? 1'b1 : 1'b0;			// *********** Vn1_addr > 7'd105
	assign out_n = M10K1_q;
	
endmodule
