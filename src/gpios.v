module GPIOS #(
    parameter WIDHT = 8
) (
    input wire clk,
    input wire reset,
    input wire read,
    input wire write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data,
    input wire [7:0] gpios_in,
    output wire [7:0] gpios_out,
    output wire [7:0] direction
);

reg [7:0] gpio_direction, gpio_value;
wire [7:0] gpio_out;

assign direction = gpio_direction;

parameter SET_DIRECTION = 1'b0;
parameter READ = 1'b1;

assign read_data = (read == 1'b1) ? gpio_out : 32'h00000000;

GPIO Gpios[7:0](
    .gpio_in(gpios_in),
    .gpio_out(gpios_out),
    .direction(gpio_direction),
    .data_in(gpio_value),
    .data_out(gpio_out)
);

always @(posedge clk) begin
    if(reset) begin
        gpio_direction <= 32'h00000000;
        gpio_value <= 32'h00000000;
    end else if(write) begin
        if(write_data[31] == SET_DIRECTION)
            gpio_direction <= write_data[7: 0];
        else
            gpio_value <= write_data[7: 0];
    end
end
    
endmodule
