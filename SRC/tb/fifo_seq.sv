class fifo_seq extends uvm_sequence #(fifo_trans);
  `uvm_object_utils(fifo_seq)

  function new(string name = "fifo_seq");
    super.new(name);
  endfunction

  task body();
    fifo_trans req;

    repeat (200) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      req.wr_cs = 1'b0;
      req.wr_en = 1'b1;
      req.rd_cs = 1'b0;
      req.rd_en = 1'b0;
      finish_item(req);
    end

    repeat (200) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      req.wr_cs = 1'b1;
      req.wr_en = 1'b1;
      req.rd_cs = 1'b0;
      req.rd_en = 1'b0;
      finish_item(req);
    end

    repeat (200) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      req.wr_cs = 1'b0;
      req.wr_en = 1'b0;
      req.rd_cs = 1'b0;
      req.rd_en = 1'b1;
      finish_item(req);
    end

    repeat (200) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      req.wr_cs = 1'b0;
      req.wr_en = 1'b0;
      req.rd_cs = 1'b1;
      req.rd_en = 1'b1;
      finish_item(req);
    end

    repeat (270) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      req.wr_cs = 1'b1;
      req.wr_en = 1'b1;
      req.rd_cs = 1'b0;
      req.rd_en = 1'b0;
      finish_item(req);
    end

    repeat (270) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      req.wr_cs = 1'b0;
      req.wr_en = 1'b0;
      req.rd_cs = 1'b1;
      req.rd_en = 1'b1;
      finish_item(req);
    end

    repeat (5000) begin
      req = fifo_trans::type_id::create("req");
      start_item(req);
      if (!req.randomize()) `uvm_fatal(get_type_name(), "Randomization failed")
      finish_item(req);
    end
  endtask

endclass
