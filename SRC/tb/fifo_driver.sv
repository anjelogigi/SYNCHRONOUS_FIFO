class fifo_driver extends uvm_driver #(fifo_trans);
  `uvm_component_utils(fifo_driver)

  virtual fifo_if.DRV vif;
  fifo_config m_cfg;

  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db#(fifo_config)::get(this, "", "fifo_config", m_cfg))
      `uvm_fatal(get_type_name(), "FIFO_DRIVER Getting Failed")
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    vif = m_cfg.vif;
  endfunction

  task run_phase(uvm_phase phase);
    @(vif.drv_cb);
    vif.drv_cb.rst     <= 1'b0;
    vif.drv_cb.wr_cs   <= 0;
    vif.drv_cb.rd_cs   <= 0;
    vif.drv_cb.wr_en   <= 0;
    vif.drv_cb.rd_en   <= 0;
    vif.drv_cb.data_in <= 0;

    @(vif.drv_cb);
    vif.drv_cb.rst     <= 1'b1;

    repeat(5) @(vif.drv_cb);

    vif.drv_cb.rst     <= 1'b0;

    @(vif.drv_cb);

    forever begin
      seq_item_port.get_next_item(req);
      drive(req);
      seq_item_port.item_done();
    end
  endtask

  task drive(fifo_trans data2duv);
    `uvm_info("FIFO_DRIVER", $sformatf("FIFO Driver\n%s", data2duv.sprint()), UVM_LOW)

    @(vif.drv_cb);
    vif.drv_cb.wr_cs   <= data2duv.wr_cs;
    vif.drv_cb.rd_cs   <= data2duv.rd_cs;
    vif.drv_cb.wr_en   <= data2duv.wr_en;
    vif.drv_cb.rd_en   <= data2duv.rd_en;
    vif.drv_cb.data_in <= data2duv.data_in;

    @(vif.drv_cb);
    vif.drv_cb.wr_en <= 0;
    vif.drv_cb.rd_en <= 0;
  endtask

endclass
