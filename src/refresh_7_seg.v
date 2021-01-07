
module refresh(
    input clk,
    input [3:0] seconds, t_secs, minutes, t_mins, hours, t_hours,
    output [7:0] SEG,
    output reg [5:0] ENABLE
    );

localparam refresh_rate = 50000;	 
reg [3:0] digit_data;
reg [2:0] digit_posn;
reg [23:0] prescaler;
	 
to_7_seg decoder(.clk (clk), .SEG	(SEG), .count (digit_data));   

always @(posedge clk)
begin
  prescaler <= prescaler + 24'd1;
  if (prescaler == refresh_rate)
  begin
	 ENABLE <= 6'b111111;	
    prescaler <= 0;
    digit_posn <= digit_posn + 3'd1;
	 
    if (digit_posn == 0)
    begin
		ENABLE <= 6'b111110;
      digit_data <= seconds;
    end
	 
    else if (digit_posn == 3'd1)
    begin
		ENABLE <= 6'b111101;
      digit_data <= t_secs;
    end
	 
    else if (digit_posn == 3'd2)
    begin
		ENABLE <= 6'b111011;
      digit_data <= minutes;
    end
	 
    else if (digit_posn == 3'd3)
    begin
		ENABLE <= 6'b110111;
      digit_data <= t_mins;	
    end
	 
    else if (digit_posn == 3'd4)
    begin
		ENABLE <= 6'b101111;
      digit_data <= hours;
	
    end
	 
    else //(digit_posn == 3'd5)
    begin
		ENABLE <= 6'b011111;
      digit_data <= t_hours;
		digit_posn <= 0;
		
    end

  end
end

endmodule


