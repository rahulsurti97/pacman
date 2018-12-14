//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module pacman_top_level(
	input               	CLOCK_50,
	input        [3:0]  	KEY,          //bit 0 is set up as Reset
	output logic [6:0]  	HEX0, HEX1, HEX2, HEX3, HEX4,
	// VGA Interface 
	output logic [7:0]  	VGA_R,        //VGA Red
								VGA_G,        //VGA Green
								VGA_B,        //VGA Blue
	output logic        	VGA_CLK,      //VGA Clock
								VGA_SYNC_N,   //VGA Sync signal
								VGA_BLANK_N,  //VGA Blank signal
								VGA_VS,       //VGA virtical sync signal
								VGA_HS,       //VGA horizontal sync signal
	// CY7C67200 Interface
	inout  wire  [15:0] 	OTG_DATA,     //CY7C67200 Data bus 16 Bits
	output logic [1:0]  	OTG_ADDR,     //CY7C67200 Address 2 Bits
	output logic        	OTG_CS_N,     //CY7C67200 Chip Select
								OTG_RD_N,     //CY7C67200 Write
								OTG_WR_N,     //CY7C67200 Read
								OTG_RST_N,    //CY7C67200 Reset
	input               	OTG_INT,      //CY7C67200 Interrupt
	// SDRAM Interface for Nios II Software
	output logic [12:0] 	DRAM_ADDR,    //SDRAM Address 13 Bits
	inout  wire  [31:0] 	DRAM_DQ,      //SDRAM Data 32 Bits
	output logic [1:0]  	DRAM_BA,      //SDRAM Bank Address 2 Bits
	output logic [3:0]  	DRAM_DQM,     //SDRAM Data Mast 4 Bits
	output logic        	DRAM_RAS_N,   //SDRAM Row Address Strobe
								DRAM_CAS_N,   //SDRAM Column Address Strobe
								DRAM_CKE,     //SDRAM Clock Enable
								DRAM_WE_N,    //SDRAM Write Enable
								DRAM_CS_N,    //SDRAM Chip Select
								DRAM_CLK      //SDRAM Clock
);
    
    logic Reset_h, Clk, Reset_vga, Restart, Reset_game;
    logic [7:0] keycode;
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
        Reset_vga <=  ~(KEY[1]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
    
    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc lab8_soc(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),
									  .ghost_direction_export_export(ghost_direction_export),
									  .ghost_status_export_export(ghost_status),
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
	 
	ghost_direction_reader reader(
		.ghost_direction_nios(ghost_direction_export),
		.ghost_direction_fpga(direction_ghost_next)
	);
	
	ghost_direction_writer writer(
		.ghost_direction_fpga(direction_ghost),
		.ghost_direction_nios(ghost_status)
	);
	 
	 
	 logic [9:0] vga_x, vga_y;
	 logic [9:0] pacman_x, pacman_y;
	 logic [10:0] vga_index, pacman_index;
	 logic is_wall, is_pellet;
    logic [2:0]	direction;
	 logic [3:0] adjacent_walls, adjacent_walls_vga;
	 logic [15:0] score;
	 logic [15:0] ghost_direction_export, ghost_status;
	 
	 logic [3:0][9:0] ghost_x;
	 logic [3:0][9:0] ghost_y;
	 logic [3:0][10:0] ghost_index;
	 logic [3:0][2:0] direction_ghost, direction_ghost_next;
	 logic [3:0][3:0] adjacent_walls_ghost;
	 
	 logic [1:0] lives_display;


    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
		.Clk(Clk),
		.Reset(Reset_vga),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_CLK(VGA_CLK),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_SYNC_N(VGA_SYNC_N),
		.DrawX(vga_x),
		.DrawY(vga_y)
	 );
   
	 pacman pacman_instance(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Restart(Restart),
		.frame_clk(VGA_VS),
		.direction(direction),
		.pacman_x(pacman_x), 
		.pacman_y(pacman_y),
		.id(3'b100)
	);
	
	pacman ghost_0(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Restart(Restart),
		.frame_clk(VGA_VS),
		.direction(direction_ghost[0]),
		.pacman_x(ghost_x[0]), 
		.pacman_y(ghost_y[0]),
		.id(3'b000)
	);
	
	pacman ghost_1(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Restart(Restart),
		.frame_clk(VGA_VS),
		.direction(direction_ghost[1]),
		.pacman_x(ghost_x[1]), 
		.pacman_y(ghost_y[1]),
		.id(3'b001)
	);
	
	pacman ghost_2(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Restart(Restart),
		.frame_clk(VGA_VS),
		.direction(direction_ghost[2]),
		.pacman_x(ghost_x[2]), 
		.pacman_y(ghost_y[2]),
		.id(3'b010)
	);
	
	pacman ghost_3(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Restart(Restart),
		.frame_clk(VGA_VS),
		.direction(direction_ghost[3]),
		.pacman_x(ghost_x[3]), 
		.pacman_y(ghost_y[3]),
		.id(3'b011)
	);
	
	game_logic game_logic_pacman(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Restart(Restart),
		.pacman_x(pacman_x),
		.pacman_y(pacman_y),
		.adjacent_walls(adjacent_walls),
		.keyboard_direction(keycode),
		.direction(direction)
	);
	
	ghost_movement_logic ghost0_movement(
		.Clk(Clk),
		.Reset(Reset_vga),
		.pacman_x(ghost_x[0]),
		.pacman_y(ghost_y[0]),
		.adjacent_walls(adjacent_walls_ghost[0]),
		.direction_input(direction_ghost_next[0]),
		.direction(direction_ghost[0])
	);
	
	ghost_movement_logic ghost1_movement(
		.Clk(Clk),
		.Reset(Reset_vga),
		.pacman_x(ghost_x[1]),
		.pacman_y(ghost_y[1]),
		.adjacent_walls(adjacent_walls_ghost[1]),
		.direction_input(direction_ghost_next[1]),
		.direction(direction_ghost[1])
	);
	
	ghost_movement_logic ghost2_movement(
		.Clk(Clk),
		.Reset(Reset_vga),
		.pacman_x(ghost_x[2]),
		.pacman_y(ghost_y[2]),
		.adjacent_walls(adjacent_walls_ghost[2]),
		.direction_input(direction_ghost_next[2]),
		.direction(direction_ghost[2])
	);
	
	ghost_movement_logic ghost3_movement(
		.Clk(Clk),
		.Reset(Reset_vga),
		.pacman_x(ghost_x[3]),
		.pacman_y(ghost_y[3]),
		.adjacent_walls(adjacent_walls_ghost[3]),
		.direction_input(direction_ghost_next[3]),
		.direction(direction_ghost[3])
	);
	
	score_reg score_reg(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Reset_game(Reset_game),
		.increment(seen_pellet),
		.out(score)
	);
	
	index_calculator pacman_index_calculator (
		.x(pacman_x+7),
		.y(pacman_y+7),
		.index(pacman_index)
	 );
	 
	 index_calculator ghost0_index_calculator (
		.x(ghost_x[0]+7),
		.y(ghost_y[0]+7),
		.index(ghost_index[0])
	 );
	 
	 index_calculator ghost1_index_calculator (
		.x(ghost_x[1]+7),
		.y(ghost_y[1]+7),
		.index(ghost_index[1])
	 );
	 
	 index_calculator ghost2_index_calculator (
		.x(ghost_x[2]+7),
		.y(ghost_y[2]+7),
		.index(ghost_index[2])
	 );
	 
	 index_calculator ghost3_index_calculator (
		.x(ghost_x[3]+7),
		.y(ghost_y[3]+7),
		.index(ghost_index[3])
	 );

	 index_calculator vga_index_calculator (
		.x(vga_x),
		.y(vga_y),
		.index(vga_index)
	 );
	 
	 maze maze_instance(
		.Clk(Clk),
		.index(vga_index),
		.pacman_index(pacman_index),
		.ghost_index(ghost_index),
		.is_wall(is_wall),
		.adjacent_walls(adjacent_walls),
		.adjacent_walls_vga(adjacent_walls_vga),
		.adjacent_walls_ghost(adjacent_walls_ghost)
		);
	 
	 pellets pellets_instance(
		.Clk(Clk),
		.Reset(Reset_vga),
		.Reset_game(Reset_game),
		.index(vga_index),
		.is_pellet(is_pellet),
		.pacman_index(pacman_index),
		.seen_pellet(seen_pellet)
	 );
	 
	 
	 collision_detector collision_detector_instance( 
		.pacman_index(pacman_index),
		.ghost_index(ghost_index),
		.Restart(Restart)
	);
	
	lives_reg lives(
		.Clk(Clk), 
		.Reset(Reset_vga), 
		.Restart(Restart),
		.out(lives_display),
		.Reset_game(Reset_game)
	);
	
    color_mapper color_instance(
		.pacman_x(pacman_x),
		.pacman_y(pacman_y),
		.ghost_x(ghost_x),
		.ghost_y(ghost_y),
		.is_wall(is_wall),
		.is_pellet(is_pellet),
		.adjacent_walls_vga(adjacent_walls_vga),
		.DrawX(vga_x),
		.DrawY(vga_y),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
	 );
    
    // Display keycode on hex display	 
	 HexDriver hex_inst_0 (score[3:0], HEX0);
    HexDriver hex_inst_1 (score[7:4], HEX1);
	 HexDriver hex_inst_2 (score[11:8], HEX2);
    HexDriver hex_inst_3 (score[15:12], HEX3);
	 
	 HexDriver hex_inst_4 ({2'b0, lives_display[1:0]}, HEX4);
    
    /**************************************************************************************
        ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
        Hidden Question #1/2:
        What are the advantages and/or disadvantages of using a USB interface over PS/2 interface to
             connect to the keyboard? List any two.  Give an answer in your Post-Lab.
    **************************************************************************************/
endmodule
