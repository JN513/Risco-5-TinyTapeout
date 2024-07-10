module GPIO (
    input wire gpio_in,
    input wire data_in,
    input wire direction,
    output wire data_out,
    output wire gpio_out
);

assign data_out = (data_in & direction) | (gpio_in & ~direction);
assign gpio_out = (direction == 1'b1) ? 1'bz : data_in;
    
endmodule
