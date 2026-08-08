class fifo_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(fifo_scoreboard)

  uvm_tlm_analysis_fifo #(fifo_trans) inp_mon_fifo;
  uvm_tlm_analysis_fifo #(fifo_trans) out_mon_fifo;

  fifo_trans inp_tx;
  fifo_trans out_tx;

  bit [`DATA_WIDTH-1:0] ref_fifo[$];
  bit [`DATA_WIDTH-1:0] expected_data;
  bit [`DATA_WIDTH-1:0] last_data_out;
  int unsigned max_depth;

  int unsigned pass_count;
  int unsigned fail_count;
  int unsigned total_count;

  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    inp_mon_fifo = new("inp_mon_fifo", this);
    out_mon_fifo = new("out_mon_fifo", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    max_depth     = `RAM_DEPTH;
    last_data_out = '0;
    pass_count    = 0;
    fail_count    = 0;
    total_count   = 0;
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      inp_mon_fifo.get(inp_tx);
      ref_model(inp_tx);

      out_mon_fifo.get(out_tx);
      check_data(out_tx);
    end
  endtask

  task ref_model(fifo_trans t);
    bit wr_valid = t.wr_cs && t.wr_en && (ref_fifo.size() < max_depth);
    bit rd_valid = t.rd_cs && t.rd_en && (ref_fifo.size() > 0);

    if (wr_valid)
      ref_fifo.push_back(t.data_in);

    if (rd_valid) begin
      expected_data = ref_fifo.pop_front();
      last_data_out = expected_data;
    end
    else begin
      expected_data = last_data_out;
    end
  endtask

  task check_data(fifo_trans ch);
    bit data_ok  = (expected_data == ch.data_out);
    bit full_ok  = (ch.full  == (ref_fifo.size() == max_depth));
    bit empty_ok = (ch.empty == (ref_fifo.size() == 0));
    bit txn_pass = data_ok && full_ok && empty_ok;

    total_count++;
    if (txn_pass) pass_count++;
    else          fail_count++;

    if (txn_pass) begin
      `uvm_info("FIFO_SB", $sformatf(
        "PASS [%0d] | DIN: 0%0h | DOUT: 0x%0h (Exp: 0x%0h) | Full: %0b | Empty: %0b | Size: %0d",total_count, inp_tx.data_in, ch.data_out, expected_data, ch.full, ch.empty, ref_fifo.size()), UVM_HIGH)
    end
    else begin
      `uvm_error("FIFO_SB", $sformatf(
        "\n========================================\n" \
        "  FAIL: Transaction #%0d Mismatch Detected\n" \
        "========================================\n" \
        "  Inputs   : wr_cs=%0b, wr_en=%0b, rd_cs=%0b, rd_en=%0b, data_in=0x%0h\n" \
        "  Expected : data_out=0x%0h, full=%0b, empty=%0b\n" \
        "  Actual   : data_out=0x%0h, full=%0b, empty=%0b\n" \
        "  Status   : data_ok=%0b, full_ok=%0b, empty_ok=%0b\n" \
        "  Ref Size : %0d\n" \
        "========================================",
        total_count,inp_tx.wr_cs, inp_tx.wr_en, inp_tx.rd_cs, inp_tx.rd_en, inp_tx.data_in,expected_data, (ref_fifo.size() == max_depth),
(ref_fifo.size() == 0), ch.data_out, ch.full, ch.empty,data_ok, full_ok, empty_ok,
        ref_fifo.size()
      ))
    end
  endtask

  function void report_phase(uvm_phase phase);
    `uvm_info("FIFO_SB", $sformatf(
      "\n========================================\n" \
      "         SCOREBOARD SUMMARY             \n" \
      "========================================\n" \
      "  Total Checked : %0d\n" \
      "  Passed        : %0d\n" \
      "  Failed        : %0d\n" \
      "  Pass Rate     : %.2f%%\n" \
      "========================================",
      total_count, pass_count, fail_count, (total_count > 0) ? (100.0 * pass_count / total_count) : 0.0), UVM_NONE)
  endfunction

endclass
