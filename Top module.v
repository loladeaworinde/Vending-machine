module vendingmachineTop(
    input  clk,
    input  reset,
    input  [2:0] coins,
    input  [5:0] selection,
    input cancel,
    input available,
    output reg [8:0] change_in,
    output reg item_dispensed,
    output reg [8:0] change_output
); 
    
    reg [3:0] current_state;
    reg [8:0] total_amount_reg;
    reg go;
    reg accumulator;
    reg  item_select;
    wire [8:0] total_amount;
    wire [8:0] Price;
    wire [3:0] changeDollars; // Number of dollars to return
    wire [3:0] changeHalfDollars; // Number of half dollars to return
    wire [3:0] changeQuarters; // Number of quarters to return
    wire [3:0] changeDimes; // Number of dimes to return
    wire [3:0] changeNickels; // Number of nickels to return
    wire [8:0] change;
    wire done;
    
    parameter IDLE = 0;
    parameter SELECT_ITEM = 1;
    parameter DISPENSE_ITEM = 2;
    parameter RETURN_CHANGE = 3;
    parameter CANCEL_TRANSACTION = 4;
    parameter RESET_SYSTEM = 5;
    
    Paymenthandler u1(
        .clk(clk),
        .reset(reset),
        .coins(coins),
        .accumulator(accumulator),
        .total_amount(total_amount)
    );

    changecalculator u2(
        .clk(clk),
        .reset(reset),
        .go(go),
        .change_amount(change_in), 
        .changeDollars(changeDollars),
        .changeHalfDollars(changeHalfDollars),
        .changeQuarters(changeQuarters),
        .changeDimes(changeDimes),
        .changeNickels(changeNickels),
        .change(change),
        .done(done)
    ); 

    Snack_selector u3(
        .selection(selection), 
        .price(Price) 
    );

    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
            go <= 0;
            item_select <= 0;
            item_dispensed <= 0;
            change_output <= 0;
            change_in <= 0;
            total_amount_reg <= 0;
             
        end else begin
            case (current_state)
                IDLE: begin               
                     accumulator <= 1;          
                    if (total_amount > 0)                                        
                        current_state <= SELECT_ITEM;
                        
                end
                SELECT_ITEM: begin
                    // Assuming Price is correctly assigned by Snack_selector  
                     accumulator <= 0;
                     total_amount_reg <= total_amount; 
                      if (!selection)begin
                        current_state <= CANCEL_TRANSACTION;
                    end else                   
                    if (selection > 0) begin                                         
                         item_select <= 1;
                         end
                      if (selection && total_amount >= Price) begin                                                
                         change_in <= total_amount - Price;                                                                                         
                        current_state <= DISPENSE_ITEM;
                    end else 
                    if (selection > 0 && total_amount < Price) begin
                        accumulator <= 1;
                        change_in <= 0;
                        current_state <= SELECT_ITEM; // Not enough money
                        end                        
                    if (cancel) begin
                        item_select <= 0;
                        current_state <= CANCEL_TRANSACTION;    
                    end
                    end
              
                DISPENSE_ITEM: begin
                    if (available && item_select) begin
                        item_dispensed <= 1;
                         go <= 1;
                        current_state <= RETURN_CHANGE;
                    end else if (!available || !item_select) begin
                        item_dispensed <= 0;
                        current_state <= CANCEL_TRANSACTION;
                    end else 
                    if (cancel) begin
                        current_state <= CANCEL_TRANSACTION;    
                    end
                end
                RETURN_CHANGE: begin                      
                    change_output <= change;
                    if (done)begin
                        item_select <= 0;
                        go <= 0;
                        current_state <= RESET_SYSTEM;
                        end
                end
                CANCEL_TRANSACTION: begin
                    item_dispensed <= 0;
                    item_select <= 0;
                    change_output <= total_amount_reg; // Return all the money inserted
                    current_state <= RESET_SYSTEM; // Return to IDLE state after canceling transaction
                end
                RESET_SYSTEM: begin
                    item_dispensed <= 0;
                    change_output <= 0;
                    item_select <= 0;
                    change_in <= 0;
                    current_state <= IDLE;
                end
            endcase
        end
    end
endmodule
