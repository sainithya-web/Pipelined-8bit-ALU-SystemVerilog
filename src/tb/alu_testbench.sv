`timescale 1ns/1ps

module tb_pipelined_alu;

    // --- 1. Signals ---
    logic clk;
    logic rst_n;
    logic [7:0] a_in, b_in;
    logic [2:0] op_in;
    logic [7:0] alu_out;
    logic       carry_out;

    // --- 2. Instantiate UUT ---
    pipelined_alu uut (.*); // This connects signals with the same names automatically

    // --- 3. Clock Gen ---
    always #5 clk = (clk === 1'b0); // Simple clock toggle

    // --- 4. THE TASK (Place it here) ---
    task check_result(input [7:0] a, input [7:0] b, input [2:0] op, input [8:0] expected);
        begin
            a_in = a; 
            b_in = b; 
            op_in = op;
            
            // Wait 2 cycles for pipeline
            repeat(2) @(posedge clk);
            
            #1; // Small offset to sample after the clock edge
            if (alu_out === expected[7:0] && carry_out === expected[8]) begin
                $display("[PASS] Time:%0t | Op:%b | A:%d B:%d | Result:%d Carry:%b", $time, op, a, b, alu_out, carry_out);
            end else begin
                $display("[FAIL] Time:%0t | Op:%b | Expected:%d Carry:%b | Got:%d Carry:%b", 
                         $time, op, expected[7:0], expected[8], alu_out, carry_out);
            end
        end
    endtask

    // --- 5. Stimulus (Updated calls) ---
    initial begin
        clk = 0; rst_n = 0;
        #20 rst_n = 1;

        // Test 1: Addition (10+5=15)
        check_result(8'd10, 8'd5, 3'b000, 9'd15);
        // TEST 2: Overflow/Carry Test (255 + 1)
        // Result should be 0 with Carry bit set (256 in decimal)
        check_result(8'd255, 8'd1, 3'b000, 9'd256);

        // Test 3: Subtraction (20-4=16)
        check_result(8'd20, 8'd4, 3'b001, 9'd16);
        // TEST 4: Negative Result / Underflow (0 - 1)
        // In 2's complement, 0-1 = 255 (8'hFF). 
        // Note: result_w[8] (the 9th bit) will be 1 for SUB to indicate a 'borrow'.
        check_result(8'd0, 8'd1, 3'b001, 9'h1FF);

        // TEST 5: Logical Shift Left (A << 1)
        // 8'b0000_1010 (10) shifted left becomes 8'b0001_0100 (20)
        check_result(8'd10, 8'd0, 3'b110, 9'd20);
        // TEST 6: Intentional Failure (10+5 != 20)
        // This is your homework! Let's see if the console catches it.
        check_result(8'd10, 8'd5, 3'b000, 9'd20); 

        #50;
        $finish;
    end

    // --- 6. Waveform Dump ---
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_pipelined_alu);
    end

endmodule
