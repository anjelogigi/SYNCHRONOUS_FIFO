`include "defines.svh"
`timescale 1ns/1ps

interface fifo_if (input bit clk);
  logic rst;
  logic wr_cs;
  logic rd_cs;
  logic wr_en;
  logic rd_en;
  logic [`DATA_WIDTH-1:0] data_in;
  logic [`DATA_WIDTH-1:0] data_out;
  logic full;
  logic empty;

  clocking drv_cb @(posedge clk);
    default input #1 output #1;
    output rst;
    output wr_cs;
    output rd_cs;
    output wr_en;
    output rd_en;
    output data_in;
    input full;
    input empty;
  endclocking

  clocking inp_mon_cb @(posedge clk);
    default input #1 output #1;
    input rst;
    input wr_cs;
    input rd_cs;
    input wr_en;
    input rd_en;
    input data_in;
  endclocking

  clocking out_mon_cb @(posedge clk);
    default input #1 output #1;
    input rst;
    input wr_cs;
    input rd_cs;
    input wr_en;
    input rd_en;
    input data_in;
    input data_out;
    input full;
    input empty;
  endclocking

  modport DRV (clocking drv_cb);
  modport INP_MON (clocking inp_mon_cb);
  modport OUT_MON (clocking out_mon_cb);
endinterface
