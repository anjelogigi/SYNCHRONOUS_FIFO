`include "defines.svh"

class fifo_trans extends uvm_sequence_item;
  `uvm_object_utils(fifo_trans)

  rand bit wr_cs;
  rand bit rd_cs;
  rand bit wr_en;
  rand bit rd_en;
  rand bit [`DATA_WIDTH-1:0] data_in;

  bit [`DATA_WIDTH-1:0] data_out;
  bit full;
  bit empty;

  constraint c_cs {
    wr_cs dist {1 := 50, 0 := 50};
    rd_cs dist {1 := 50, 0 := 50};
  }

  constraint c_en {
    wr_en dist {1 := 50, 0 := 50};
    rd_en dist {1 := 50, 0 := 50};
  }

  function new(string name = "fifo_trans");
    super.new(name);
  endfunction

endclass
