class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  fifo_env env_h;
  fifo_config m_cfg;

  function new(string name = "fifo_test", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_cfg = fifo_config::type_id::create("m_cfg");
    
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", m_cfg.vif))
      `uvm_fatal(get_type_name(), "Can't get fifo interface")
      
    m_cfg.input_agent_is_active  = UVM_ACTIVE;
    m_cfg.output_agent_is_active = UVM_PASSIVE;
    uvm_config_db#(fifo_config)::set(this, "*", "fifo_config", m_cfg);
    
    env_h = fifo_env::type_id::create("env_h", this);
  endfunction

  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction

endclass

class fifo_test1 extends fifo_test;
  `uvm_component_utils(fifo_test1)

  fifo_seq seq_h;

  function new(string name = "fifo_test1", uvm_component parent);
    super.new(name, parent);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    
    seq_h = fifo_seq::type_id::create("seq_h");
    seq_h.start(env_h.inp_agt_h.seqr_h);

    repeat(2) @(m_cfg.vif.drv_cb);
    phase.drop_objection(this);
  endtask

endclass
