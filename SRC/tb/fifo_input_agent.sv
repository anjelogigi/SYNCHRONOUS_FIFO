class fifo_input_agent extends uvm_agent;
  `uvm_component_utils(fifo_input_agent)

  fifo_driver dr_h;
  fifo_input_monitor mon_h;
  fifo_sequencer seqr_h;
  fifo_config m_cfg;

  function new(string name = "fifo_input_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fifo_config)::get(this, "", "fifo_config", m_cfg))
      `uvm_fatal(get_type_name(), "FIFO_Input_agt Getting Failed")

    mon_h = fifo_input_monitor::type_id::create("mon_h", this);

    if (m_cfg.input_agent_is_active == UVM_ACTIVE) begin
      dr_h = fifo_driver::type_id::create("dr_h", this);
      seqr_h = fifo_sequencer::type_id::create("seqr_h", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (m_cfg.input_agent_is_active == UVM_ACTIVE) begin
      dr_h.seq_item_port.connect(seqr_h.seq_item_export);
    end
  endfunction

endclass
