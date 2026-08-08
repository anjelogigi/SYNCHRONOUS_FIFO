class fifo_output_monitor extends uvm_monitor;
  `uvm_component_utils(fifo_output_monitor)

  uvm_analysis_port #(fifo_trans) out_monitor_port;

  virtual fifo_if.OUT_MON vif;
  fifo_config m_cfg;
  fifo_trans rd_data;

  function new(string name = "fifo_output_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fifo_config)::get(this, "", "fifo_config", m_cfg))
      `uvm_fatal(get_type_name(), "FIFO_Output_Monitor Getting Failed")

    out_monitor_port = new("out_monitor_port", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      rd_data = fifo_trans::type_id::create("rd_data");

      collect_data();

      `uvm_info("FIFO_OUTPUT_MONITOR", $sformatf("FIFO OUTPUT MONITOR\n%s", rd_data.sprint()), UVM_LOW)

      out_monitor_port.write(rd_data);
    end
  endtask

  virtual task collect_data();
    @(vif.out_mon_cb);

    rd_data.wr_cs    = vif.out_mon_cb.wr_cs;
    rd_data.rd_cs    = vif.out_mon_cb.rd_cs;
    rd_data.wr_en    = vif.out_mon_cb.wr_en;
    rd_data.rd_en    = vif.out_mon_cb.rd_en;
    rd_data.data_out = vif.out_mon_cb.data_out;
    rd_data.full     = vif.out_mon_cb.full;
    rd_data.empty    = vif.out_mon_cb.empty;
  endtask

endclass
