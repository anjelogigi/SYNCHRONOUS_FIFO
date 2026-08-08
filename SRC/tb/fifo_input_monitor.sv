class fifo_input_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_input_monitor)

  uvm_analysis_port #(fifo_trans) inp_monitor_port;

  virtual fifo_if.INP_MON vif;
  fifo_config m_cfg;
  fifo_trans drv2mon;

  function new(string name = "fifo_input_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fifo_config)::get(this, "", "fifo_config", m_cfg))
      `uvm_fatal(get_type_name(), "FIFO_Input_Monitor Getting Failed")

    inp_monitor_port = new("inp_monitor_port", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      drv2mon = fifo_trans::type_id::create("drv2mon");

      collect_input_monitor();

      `uvm_info("FIFO_INPUT_MONITOR", $sformatf("FIFO Input Monitor\n%s", drv2mon.sprint()), UVM_LOW)

      inp_monitor_port.write(drv2mon);
    end
  endtask

  virtual task collect_input_monitor();
    @(vif.inp_mon_cb);

    drv2mon.wr_cs   = vif.inp_mon_cb.wr_cs;
    drv2mon.rd_cs   = vif.inp_mon_cb.rd_cs;
    drv2mon.wr_en   = vif.inp_mon_cb.wr_en;
    drv2mon.rd_en   = vif.inp_mon_cb.rd_en;
    drv2mon.data_in = vif.inp_mon_cb.data_in;
  endtask

endclass
