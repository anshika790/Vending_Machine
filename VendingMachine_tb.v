`timescale 1ns / 1ps

module VendingMachine_tb;

    // Inputs
    reg clk;
    reg reset;
    reg cancel;
    reg [1:0] coin;
    reg [3:0] sel;

    // Outputs
    wire Pr1, Pr2, Pr3, Pr4, Pr5, Pr6, Pr7, Pr8, Pr9, Pr10;
    wire change;

    // Instantiate the Vending Machine
    VendingMachine uut (
        .clk(clk), 
        .reset(reset), 
        .cancel(cancel), 
        .coin(coin), 
        .sel(sel), 
        .Pr1(Pr1), .Pr2(Pr2), .Pr3(Pr3), .Pr4(Pr4), .Pr5(Pr5), 
        .Pr6(Pr6), .Pr7(Pr7), .Pr8(Pr8), .Pr9(Pr9), .Pr10(Pr10), 
        .change(change)
    );

    // Clock Generation (Period = 10ns)
    always #5 clk = ~clk;

    // Helper task to insert a coin for exactly 1 cycle
    task insert_coin;
        input [1:0] c;
        begin
            @(negedge clk) coin = c;
            @(negedge clk) coin = 0;
            #10; // Wait a bit for state transition
        end
    endtask

    // Helper task to reset the machine between tests
    task reset_machine;
        begin
            sel = 4'b1111; // Deselect everything
            cancel = 1; 
            #10; 
            cancel = 0; 
            #20;
        end
    endtask

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        cancel = 0;
        coin = 0;
        sel = 4'b1111;

        // Global Reset
        #20 reset = 0;
        #20;

        // -------------------------------------------------------------
        // TEST CASE 1: Exact Change (Simple)
        // Goal: Buy Product 2 (10rs) using a 10rs coin.
        // -------------------------------------------------------------
        $display("--- Test Case 1: Exact Change (10rs for Pr2) ---");
        insert_coin(2'b10); // Insert 10rs
        
        // Machine is in S10
        sel = 4'b0001; // Select Pr2
        #20;
        
        // Verify: Pr2 should be 1, Change should be 0
        reset_machine(); // Clear for next test


        // -------------------------------------------------------------
        // TEST CASE 2: Returning Change
        // Goal: Buy Product 1 (5rs) using a 10rs coin.
        // -------------------------------------------------------------
        $display("--- Test Case 2: Returning Change (10rs for Pr1) ---");
        insert_coin(2'b10); // Insert 10rs
        
        // Machine is in S10
        sel = 4'b0000; // Select Pr1 (Cost 5rs)
        #20;

        // Verify: Pr1 should be 1, Change should be 1
        reset_machine();


        // -------------------------------------------------------------
        // TEST CASE 3: Accumulating Money
        // Goal: Buy Product 5 (25rs) by inserting 10 + 10 + 5.
        // -------------------------------------------------------------
        $display("--- Test Case 3: Accumulation (10+10+5 = 25rs for Pr5) ---");
        insert_coin(2'b10); // 10rs (Total: 10)
        insert_coin(2'b10); // 10rs (Total: 20)
        insert_coin(2'b01); // 5rs  (Total: 25)

        // Machine is in S25
        sel = 4'b0100; // Select Pr5
        #20;

        // Verify: Pr5 should be 1, Change should be 0
        reset_machine();


        // -------------------------------------------------------------
        // TEST CASE 4: Cancel / Refund
        // Goal: Insert money, change mind, press cancel, verify reset.
        // -------------------------------------------------------------
        $display("--- Test Case 4: Cancel Functionality ---");
        insert_coin(2'b10); // Insert 10rs
        insert_coin(2'b10); // Insert 10rs (Total: 20)
        
        #10;
        cancel = 1; // User presses cancel
        #10;
        cancel = 0;
        
        // Try to buy something now (should fail)
        sel = 4'b0000; // Try to buy Pr1 (5rs)
        #20;
        
        // Verify: Pr1 should remain 0 because state reset to S0
        reset_machine();


        // -------------------------------------------------------------
        // TEST CASE 5: Max State / High Cost
        // Goal: Reach S50 and buy Product 10 (50rs).
        // -------------------------------------------------------------
        $display("--- Test Case 5: Max State S50 (5x 10rs for Pr10) ---");
        insert_coin(2'b10); // 10
        insert_coin(2'b10); // 20
        insert_coin(2'b10); // 30
        insert_coin(2'b10); // 40
        insert_coin(2'b10); // 50

        // Machine is in S50
        sel = 4'b1001; // Select Pr10
        #20;
        
        // Verify: Pr10 should be 1, Change should be 0
        reset_machine();

        $display("--- All Tests Completed ---");
        #20 $finish;
    end
    
    // Monitor for debugging
    initial begin
         $monitor("Time=%0t | State=%d | Coin=%b | Sel=%h | Cancel=%b | Change=%b | Pr1=%b Pr2=%b Pr5=%b Pr10=%b", 
                  $time, uut.current_state, coin, sel, cancel, change, Pr1, Pr2, Pr5, Pr10);
    end

endmodule