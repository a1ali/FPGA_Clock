// Module Name:    to_seven_seg 
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
module to_7_seg(
		input clk,
		input  [3:0] count,
		output reg [7:0] SEG
    );

//wire [2:0] enable;
//assign enable = 3'b110;



always @(posedge clk)
begin
	case(count)
	4'd0: SEG <= 8'b11111100;
	4'd1: SEG <= 8'b01100000;
	4'd2: SEG <= 8'b11011010;
	4'd3: SEG <= 8'b11110010;
	4'd4: SEG <= 8'b01100110;
	4'd5: SEG <= 8'b10110110;
	4'd6: SEG <= 8'b10111110;
	4'd7: SEG <= 8'b11100000;
	4'd8: SEG <= 8'b11111110;
	4'd9: SEG <= 8'b11110110;
	default: SEG <= 8'b00000000;
	endcase
end

endmodule



