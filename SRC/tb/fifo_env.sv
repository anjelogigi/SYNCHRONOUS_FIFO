class fifo_env extends uvm_env;
  `uvm_component_utils(fifo_env)

  fifo_input_agent  inp_agt_h;
  fifo_output_agent out_agt_h;
  fifo_scoreboard   sb_h;
  fifo_subscriber   sub_h;

  function new(string name = "fifo_env", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    inp_agt_h = fifo_input_agent::type_id::create("inp_agt_h", this);
    out_agt_h = fifo_output_agent::type_id::create("out_agt_h", this);
    sb_h      = fifo_scoreboard::type_id::create("sb_h", this);
    sub_h     = fifo_subscriber::type_id::create("sub_h", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    inp_agt_h.mon_h.inp_monitor_port.connect(sb_h.inp_mon_fifo.analysis_export);
    out_agt_h.mon_h.out_monitor_port.connect(sb_h.out_mon_fifo.analysis_export);
    inp_agt_h.mon_h.inp_monitor_port.connect(sub_h.analysis_export);
  endfunction

endclass
