module Paymenthandler (
    input clk,          // Clock signal
    input reset,        // Reset signal
    input [2:0] coins,  //
    input accumulator,
    output wire [8:0] total_amount // Total amount of money accumulated (in cents)
);

    // Register to store the total amount
    reg [8:0] total_amount_reg;
    

    // Counter for each coin denomination
    reg [8:0] nickels_counter;
    reg [8:0] dimes_counter;
    reg [8:0] quarters_counter;
    reg [8:0] halfdollar_counter;
    reg [8:0] dollar_counter;
    
    
    

   
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            total_amount_reg <= 0;
            quarters_counter <= 0;
            dimes_counter <= 0;
            nickels_counter <= 0;
            halfdollar_counter <= 0;
            dollar_counter <= 0;
        end else begin
        if (accumulator)begin
      case(coins)
             3'b001: nickels_counter <= nickels_counter + 1;
             3'b010: dimes_counter <= dimes_counter + 1;
             3'b011: quarters_counter <= quarters_counter + 1;
             3'b100: halfdollar_counter <= halfdollar_counter + 1;
             3'b101: dollar_counter <= dollar_counter + 1;
              endcase
           
           total_amount_reg <= (quarters_counter * 25) + (dimes_counter * 10) + (nickels_counter * 5) + (halfdollar_counter * 50) + (dollar_counter * 100);
           end else 
           total_amount_reg <= 0;
           
        end
    end

    // Output total amount
    assign total_amount = total_amount_reg;

endmodule
