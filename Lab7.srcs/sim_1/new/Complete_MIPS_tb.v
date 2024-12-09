`timescale 1ns / 1ps

module MIPS_tb();
    reg CLK;
    reg [3:0] SW;
    wire CS, WE;
    wire [6:0] ADDR;
    wire [31:0] data_in, data_out;
    wire [31:0] reg1, reg2;
    
    // Instantiate MIPS processor
    MIPS uut (
        .CLK(CLK),
        .SW(SW),
        .CS(CS),
        .WE(WE),
        .ADDR(ADDR),
        .data_in(data_in),
        .data_out(data_out),
        .reg1(reg1),
        .reg2(reg2)
    );
    
    // Instantiate Memory
    Memory mem (
        .CS(CS),
        .WE(WE),
        .CLK(CLK),
        .ADDR(ADDR),
        .data_in(data_out),
        .data_out(data_in)
    );
    
    // Clock generation
    always begin
        #5 CLK = ~CLK;
    end
    
    integer test_num = 0;
    
    initial begin
        // Initialize signals
        CLK = 0;
        SW = 4'b0000;  // No reset, switches at 000
        
        // Initial reset
        SW[3] = 1'b1;
        #20
        SW[3] = 1'b0;
        
        // Wait for system to stabilize
        #500;
        
         //Test add8 instruction (switch value 000)
        $display("\nTest %0d: Testing add8 instruction (switches = 000)", test_num);
        SW[2:0] = 3'b000;
        #1500  // Extended wait time
        test_num = test_num + 1;
        $display("add8 result (reg2) = %h", reg2);
        
        // Test lui instruction (switch value 001)
        $display("\nTest %0d: Testing lui instruction (switches = 001)", test_num);
        SW[2:0] = 3'b001;
        #500  // Extended wait time
        test_num = test_num + 1;
        $display("lui result (reg2) = %h", reg2);
        
        // Test rbit instruction (switch value 010)
        $display("\nTest %0d: Testing rbit instruction (switches = 010)", test_num);
        SW[2:0] = 3'b010;
        #500  // Extended wait time
        test_num = test_num + 1;
        $display("rbit result (reg2) = %h", reg2);
        
        // Test rev instruction (switch value 011)
        $display("\nTest %0d: Testing rev instruction (switches = 011)", test_num);
        SW[2:0] = 3'b011;
        #500  // Extended wait time
        test_num = test_num + 1;
        $display("rev result (reg2) = %h", reg2);
        
        // Test sadd instruction (switch value 100)
        $display("\nTest %0d: Testing sadd instruction (switches = 100)", test_num);
        SW[2:0] = 3'b100;
        #500  // Extended wait time
        test_num = test_num + 1;
        $display("sadd result (reg2) = %h", reg2);
        
        // Test ssub instruction (switch value 101)
        $display("\nTest %0d: Testing ssub instruction (switches = 101)", test_num);
        SW[2:0] = 3'b101;
        #500  // Extended wait time
        test_num = test_num + 1;
        $display("ssub result (reg2) = %h", reg2);
        
        // Final wait to observe last result
        #100;
        
        $display("\nTestbench completed");

    end
    
    // More detailed monitoring
//    always @(posedge CLK) begin
//        $display("Time %0t: State=%0d, PC=%0d, ADDR=%0d, reg1=%h, reg2=%h", 
//                 $time, uut.state, uut.pc, ADDR, reg1, reg2);
//        if (uut.state == 0) begin
//            $display("Instruction fetched: %h", data_in);
//        end
//    end
    
    // Monitor program execution
//    always @(uut.state) begin
//        case(uut.state)
//            0: $display("\nTime %0t: --- Fetch ---", $time);
//            1: $display("Time %0t: --- Decode ---\n  Instruction: %h", $time, uut.instr);
//            2: $display("Time %0t: --- Execute ---", $time);
//            3: $display("Time %0t: --- Memory Write ---", $time);
//            4: $display("Time %0t: --- Memory Read ---", $time);
//        endcase
//    end

endmodule