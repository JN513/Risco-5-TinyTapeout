/*
 * Copyright (c) 2024 Julio Nunes Avelar
 * SPDX-License-Identifier: Apache-2.0
 */

//`define default_nettype none

module tt_um_JN513_Risco_5 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in

wire memory_read, memory_write, gpio_read, gpio_write,
    read, write;
wire [2:0] option;
wire [31:0] address, write_data, read_data, memory_read_data,
    gpio_read_data;


wire memory_response, clk_o;

assign memory_response = read | write;

assign clk_o = clk & ena;

Core #(
    .BOOT_ADDRESS(0)
) Core(
    .clk(clk_o),
    .reset(~rst_n),
    .option(option),
    .memory_response(memory_response),
    .memory_read(read),
    .memory_write(write),
    .write_data(write_data),
    .read_data(read_data),
    .address(address)
);

assign gpio_read = (address[31] == 1'b1) ? read : 1'b0;
assign memory_read = (address[31] == 1'b0) ? read : 1'b0;
assign gpio_write = (address[31] == 1'b1) ? write : 1'b0;
assign memory_write = (address[31] == 1'b0) ? write : 1'b0;
assign read_data = (address[31] == 1'b1) ? gpio_read_data : memory_read_data;

Memory #(
    //.MEMORY_FILE(1024),
    .MEMORY_SIZE(32)
) Memory(
    .clk(clk_o),
    .reset(~rst_n),
    .option(option),
    .memory_read(memory_read),
    .memory_write(memory_write),
    .write_data(write_data),
    .read_data(memory_read_data),
    .address(address)
);

GPIOS #(
    .WIDHT(8)
) GPIOS (
    .clk(clk),
    .reset(~rst_n),
    .read(gpio_write),
    .write(gpio_read),
    .write_data(write_data),
    .read_data(gpio_read_data),
    .address(address),
    .gpios_in(uio_in),
    .gpios_out(uio_out),
    .direction(uio_oe)
);

endmodule
