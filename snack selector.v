module Snack_selector(
    input [5:0] selection, 
    output reg [8:0] price 
);

    // Output the price based on the selection
    always @(*) begin
    if (selection == 0)begin
    price = 0;
    end else 
    begin
        case(selection)
            6'd10: price = 9'b011001000; // $2.00
            6'd12, 6'd14, 6'd16: price = 9'b011001000; // $2.00 for positions 12, 14, 16
            6'd18: price = 9'b110010000; // $4.00
            6'd20, 6'd22, 6'd24, 6'd26, 6'd28, 6'd30, 6'd32, 6'd34, 6'd36, 6'd38: price = 9'b010101111; // $1.75 for positions 20-38
            6'd40: price = 9'b110010000; // $4.00
            6'd42: price = 9'b010010110; // $1.50
            6'd44, 6'd46, 6'd48: price = 9'b011001000; // $4.00 for positions 44, 46, 48
            6'd50, 6'd51, 6'd52, 6'd53, 6'd54, 6'd55, 6'd56, 6'd57: price = 9'b011001000; // $2.00 for positions 50-57
            6'd58: price = 9'b101011110; // $3.50
            6'd59: price = 9'b110010000; // $4.00
            6'd60, 6'd62, 6'd64, 6'd66, 6'd68: price = 9'b011001000; // $2.00 for positions 60, 62, 64, 66, 68
            6'd0: price = 9'b000000000; // Default price if selection is not listed
        endcase
        end
    end

endmodule
