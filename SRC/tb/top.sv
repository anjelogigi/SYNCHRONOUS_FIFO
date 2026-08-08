`include "fifo_test_pkg.sv"
`include "fifo_if.sv"
`include "syn_fifo.v"
`include "ram_dp_ar_aw.v"

module top();
  import uvm_pkg::*;
  import fifo_test_pkg::*;

  reg clk;

  fifo_if vif(clk);

  syn_fifo DUV (
    .clk(clk),
    .rst(vif.rst),       
    .wr_cs(vif.wr_cs),
    .rd_cs(vif.rd_cs),
    .data_in(vif.data_in),
    .rd_en(vif.rd_en),
    .wr_en(vif.wr_en),
    .data_out(vif.data_out),
    .empty(vif.empty),
    .full(vif.full)
  );

  initial begin
    uvm_config_db#(virtual fifo_if)::set(null, "*", "fifo_if", vif);
    $dumpfile("waves.fsdb");
    $dumpvars;
    run_test("fifo_test1");
  end

  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
  end

endmodule
