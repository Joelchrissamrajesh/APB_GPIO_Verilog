`timescale 1ns/1ps

module tb_apb_gpio;

  reg PCLK;
  reg PRESETn;
  reg [7:0] PADDR;
  reg PSEL;
  reg PENABLE;
  reg PWRITE;
  reg [31:0] PWDATA;

  wire [31:0] PRDATA;
  wire PREADY;
  wire [31:0] xpins;
  wire irq;

  reg [31:0] ext_drive;

  assign xpins = (PADDR == 8'h08) ? ext_drive : 32'hz;

  gpio_top dut (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PADDR(PADDR),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .xpins(xpins),
    .irq(irq)
  );

  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  task apb_write(input [7:0] addr, input [31:0] data);
  begin
    @(posedge PCLK);
    PADDR   = addr;
    PWDATA  = data;
    PWRITE  = 1'b1;
    PSEL    = 1'b1;
    PENABLE = 1'b0;

    @(posedge PCLK);
    PENABLE = 1'b1;

    @(posedge PCLK);
    PSEL    = 1'b0;
    PENABLE = 1'b0;
    PWRITE  = 1'b0;
  end
  endtask

  task apb_read(input [7:0] addr);
  begin
    @(posedge PCLK);
    PADDR   = addr;
    PWRITE  = 1'b0;
    PSEL    = 1'b1;
    PENABLE = 1'b0;

    @(posedge PCLK);
    PENABLE = 1'b1;

    @(posedge PCLK);
    $display("Read Address = %h, Read Data = %h", addr, PRDATA);
    PSEL    = 1'b0;
    PENABLE = 1'b0;
  end
  endtask

  initial begin
    PADDR = 0;
    PSEL = 0;
    PENABLE = 0;
    PWRITE = 0;
    PWDATA = 0;
    ext_drive = 32'h000000AA;

    PRESETn = 0;
    #20;
    PRESETn = 1;

    apb_write(8'h04, 32'h000000FF); // direction: lower 8 bits output
    apb_write(8'h00, 32'h0000000A); // dataout

    apb_read(8'h00);
    apb_read(8'h04);

    apb_write(8'h04, 32'h00000000); // all input
    apb_read(8'h08);                // read external pins

    #100;
    $finish;
  end

endmodule
