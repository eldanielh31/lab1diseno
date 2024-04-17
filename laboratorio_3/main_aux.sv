module main_aux(
				input clock,
				input reset,
				input logic direction,
				input logic move_h,
				input logic move_v,
				input logic fire,
				input logic [2:0] amount_boats,
				output [6:0] segA,
				output [7:0] red,
				output [7:0] green,
				output [7:0] blue,
				output vgaclock,
				output hsync,
				output vsync,
				output n_blank);

	
	reg [49:0] array_player = 50'b1110011001_1110011010_1110011011_1110011001_1110011011;
	reg [49:0] array_pc;
	
	
	reg [2:0] select_row;
	reg [2:0] select_col;
	
	reg [2:0] current_row;
	reg [2:0] current_col;
	
   wire start; // Señal de inicio para comenzar el juego
	wire full_boat_placed; // Señal que indica si el jugador colocó un barco completo
	wire time_expired; // Señal que indica si se agotó el límite de tiempo
	wire boats_player; // Barcos restantes del jugador
	wire boats_pc; // Barcos restantes de la maquina
	wire player_mov; // Condicion que indica si el jugador se movio 
	wire play; 
	wire win; // Señal que indica victoria
	wire lose; // Señal que indica derrota
	
	Battleship_FSM Battleship_FSM_inst (
    .clk(clk),
    .rst(rst),
    .start(start),
    .full_boat_placed(full_boat_placed),
    .time_expired(time_expired),
    .boats_player(boats_player),
    .boats_pc(boats_pc),
    .player_mov(player_mov),
    .play(play),
    .win(win),
    .lose(lose)
  );
  
  SieteSeg seg_inst(
  .count(amount_boats),
  .segA(segA)
  );
  
  boats boats_inst (
	.amount_boats(amount_boats), 
	.boats_placed(boats_player), 
	.full_boat_placed(full_boat_placed)
  ); 
  
    move move_inst (
	 .move_h(move_h),
	 .move_v(move_v),
	 .direction(direction),
	 .clock(clock),
	 .reset(reset),
	 .current_row(current_row),
	 .current_col(current_col),
	 .select_row(select_row),
	 .select_col(select_col),
  );
  
  update_row_col update_inst(
    .clock(clock),
	 .reset(reset),
	 .current_row(current_row),
	 .current_col(current_col),
	 .select_row(select_row),
	 .select_col(select_col),
  
  );
  


  
	controlador_vga controlador_vga_inst(
				.clock(clock),
				.reset(reset),
				.array_player(array_player),
				.array_pc(array_pc),
				.win(win),
				.lose(lose),
				.select_row(select_row),
				.select_col(select_col),
				.red(red),
				.green(green),
				.blue(blue),
				.vgaclock(vgaclock),
				.hsync(hsync),
				.vsync(vsync),
				.n_blank(n_blank)
	);
  
	


endmodule 