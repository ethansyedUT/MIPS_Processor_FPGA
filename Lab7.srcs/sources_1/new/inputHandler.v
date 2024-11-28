`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/28/2024 10:04:56 AM
// Design Name: 
// Module Name: inputHandler
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


module inputHandler(clk, btnL, btnR, Hi);
input clk, btnL, btnR;
output Hi;
    
    wire debR, debL;
    debounce u_debounce_R(btnR, clk, debR);
    debounce u_debounce_L(btnL, clk, debL);
    
    assign Hi = (!debL && debR);

endmodule

// Debounce module
module debounce(
    input wire pb_1, clk,
    output wire pb_out
);
    wire Q1, Q2, Q2_bar, Q0;

    my_dff d0(clk, pb_1, Q0);
    my_dff d1(clk, Q0, Q1);
    my_dff d2(clk, Q1, Q2);

    assign Q2_bar = ~Q2;
    assign pb_out = Q1 & Q2_bar;
endmodule

// D-flip-flop for debouncing module 
module my_dff(
    input wire DFF_CLOCK, D,
    output reg Q
);
    always @(posedge DFF_CLOCK) begin
        Q <= D;
    end
endmodule