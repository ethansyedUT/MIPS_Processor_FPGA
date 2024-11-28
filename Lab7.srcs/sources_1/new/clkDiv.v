`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 05:47:35 PM
// Design Name: 
// Module Name: clkDiv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module clkdiv #(
    parameter RELOAD_TIME = 50_000_000  // Default: 100MHz to 1Hz
)(
  input clk, //fast clock
  output reg slowClk //slow clock
);
  reg[27:0] counter;

  initial begin
    counter = 0;
    slowClk = 0;
  end

  always @ (posedge clk)
  begin
    if(counter == RELOAD_TIME) begin
      counter <= 0;
      slowClk <= ~slowClk;  // Toggle the clock
    end
    else begin
      counter <= counter + 1;
      slowClk <= 0;
    end
  end

endmodule