class fifo_subscriber extends uvm_subscriber #(fifo_trans);
  `uvm_component_utils(fifo_subscriber)

  fifo_trans tr;

  covergroup fifo_cg;
    option.per_instance = 1;

    cp_wr_en: coverpoint tr.wr_en {
      bins low  = {1'b0};
      bins high = {1'b1};
    }

    cp_wr_cs: coverpoint tr.wr_cs {
      bins low  = {1'b0};
      bins high = {1'b1};
    }

    cp_rd_en: coverpoint tr.rd_en {
      bins low  = {1'b0};
      bins high = {1'b1};
    }

    cp_rd_cs: coverpoint tr.rd_cs {
      bins low  = {1'b0};
      bins high = {1'b1};
    }

    cross_wr  : cross cp_wr_en, cp_wr_cs;
    cross_rd  : cross cp_rd_en, cp_rd_cs;
    cross_all : cross cp_wr_en, cp_wr_cs, cp_rd_en, cp_rd_cs;
  endgroup

  function new(string name, uvm_component parent);
    super.new(name, parent);
    fifo_cg = new();
  endfunction

  function void write(fifo_trans t);
    tr = t;
    fifo_cg.sample();
  endfunction

endclass
