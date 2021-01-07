`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:32:41 12/30/2020 
// Design Name: 
// Module Name:    count 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module clock(
input clk,
input hours_increment,
input hours_decrement,
input mins_increment,
input mins_decrement,
output [7:0] SEG,
output [5:0] ENABLE
    );
localparam  one_sec = 11999999; //elbert v2 has a 12MHZ clock 
reg [23:0] count = 0;
reg [3:0] seconds = 0;
reg [3:0] t_secs = 0;
reg [3:0] minutes = 0;
reg [3:0] t_mins = 0;
reg [3:0] hours = 0;
reg [3:0] t_hours = 0;

wire hour_inc, hour_dec, min_inc, min_dec;

//instances to debounce switches
debouncer inst1 (.CLK(clk), .switch_input(hours_increment), .trans_dn(hour_inc));
debouncer inst2 (.CLK(clk), .switch_input(hours_decrement), .trans_dn(hour_dec));
debouncer inst3 (.CLK(clk), .switch_input(mins_increment), .trans_dn(min_inc));
debouncer inst4 (.CLK(clk), .switch_input(mins_decrement), .trans_dn(min_dec));

refresh in(.clk(clk), .seconds(seconds), .t_secs(t_secs), .minutes(minutes), .t_mins(t_mins), .hours(hours), .t_hours(t_hours) ,  .SEG(SEG), .ENABLE(ENABLE)); //multiplexing 7-segments instance

always @(posedge clk)
begin

// Allow switch inputs to increment and decrement hours or minutes
	if(hour_inc)
	 begin
		hours <= hours + 1;
		if (hours == 9 && t_hours == 0)
		 begin
			hours <= 0;
			t_hours <= 1;
		 end
		if (hours == 2 && t_hours == 1)
		 begin
			hours <= 1;
			t_hours <= 0;
		 end
	 end
		 
	else if (hour_dec)
	 begin
		hours <= hours - 1;
		if (t_hours == 1 && hours == 0)
		 begin
			t_hours <= 0;
			hours <= 9;
		 end
		
		if (t_hours == 0 && hours == 1)
		 begin
			t_hours <= 1;
			hours <= 2;
		 end
	 end
	 
	 
	else if (min_inc)
	 begin
		minutes <= minutes + 1;
		if (minutes == 9 && t_mins < 5)
		 begin
			minutes <= 0;
			t_mins <= t_mins + 1;
		 end
		if (minutes == 9 && t_mins == 5)
		 begin
			minutes <= 0;
			t_mins <= 0;
		 end
	 end
	 
	 
	else if (min_dec)
	 begin
		minutes <= minutes - 1;
		if (minutes == 0 && t_mins > 0)
		 begin
			minutes <= 9;
			t_mins <= t_mins - 1;
		 end
		 
		if (minutes == 0 && t_mins == 0)
		 begin
			t_mins <= 5;
			minutes <= 9;
		 end
		
	 end
		
// end of inc/dec


// main clock implementation
	count <= count + 1;
	if (count == one_sec)
	begin
		count <= 0;
		seconds <= seconds + 1;
		if (seconds == 9)
		begin
			seconds <= 0;
			t_secs <= t_secs + 1;
			if (t_secs == 5)
			 begin
				t_secs <= 0;
				minutes <= minutes + 1;
				if (minutes == 9)
			    	begin
					minutes <= 0;
					t_mins <= t_mins + 1;
					if (t_mins == 5)
						begin
						t_mins <= 0;
						hours <= hours + 1;
						
						if (hours == 9 && t_hours == 0)
							begin
								hours <= 0;
								t_hours <= t_hours + 1;	
							end
						
						if (hours == 2 && t_hours == 1)
							begin
								t_hours <= 0;
								hours <= 1;
							end
							
						end	
				 end
			end
		end
	end
	
// end of clock implementation


end

endmodule



