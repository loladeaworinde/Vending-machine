
module changecalculator(
    input clk,
    input reset,
    input go,
    input [8:0] change_amount, // Total change received inserted in cents
    output reg [3:0] changeDollars, // Number of dollars to return
    output reg [3:0] changeHalfDollars, // Number of half dollars to return
    output reg [3:0] changeQuarters, // Number of quarters to return
    output reg [3:0] changeDimes, // Number of dimes to return
    output reg [3:0] changeNickels,// Number of nickels to return
    output reg [8:0] change,
    output reg done // Done signal
);

    always @(posedge clk) begin
        if (reset) begin
            changeDollars = 0;
            changeHalfDollars = 0;
            changeQuarters = 0;
            changeDimes = 0;
            changeNickels = 0;
            done = 0;
        end else if (go) begin
            // Reset change
            change = change_amount;
            
            // Calculate number of dollars
            if (change >= 100) begin
                changeDollars = change / 100;
                change = change % 100;
            end
    
            // Calculate number of half dollars
            if (change >= 50) begin
                changeHalfDollars = change / 50;
                change = change % 50;
            end
    
            // Calculate number of quarters
            if (change >= 25) begin
                changeQuarters = change / 25;
                change = change % 25;
            end
    
            // Calculate number of dimes
            if (change >= 10) begin
                changeDimes = change / 10;
                change = change % 10;
            end
    
            // Calculate number of nickels
            if (change >= 5) begin
                changeNickels = change / 5;
                change = change % 5;
            end
            
            // Check if change is fully dispensed
            if (change == 0)
                done = 1;
        end else begin
            // Reset all outputs when go is not asserted
            changeDollars = 0;
            changeHalfDollars = 0;
            changeQuarters = 0;
            changeDimes = 0;
            changeNickels = 0;
            done = 0;
        end
    end
endmodule
