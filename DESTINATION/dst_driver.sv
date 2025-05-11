class dst_driver extends uvm_driver#(dst_xtn);
  virtual router_intf.dst_drv_mp vif;
  `uvm_component_utils(dst_driver)
  dst_agt_config dst_cfgh;
  function new(string name,uvm_component parent);
  super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db#(dst_agt_config)::get(this,"","dst_agt_config",dst_cfgh))
      `uvm_fatal("dst_driver","configuration getting failed")
   endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    this.vif = dst_cfgh.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
  seq_item_port.get_next_item(req);
 // $display("randomized delay value =%0d",req.delay);
  //$display("printinf from destination driver");
 // req.print();
  send_to_dut(req);
  seq_item_port.item_done();
  endtask

  task send_to_dut(dst_xtn req);
  while(vif.dst_drv_cb.valid_out!==1)
  begin
    @(vif.dst_drv_cb);
  end
  repeat(req.delay)
  begin
   @(vif.dst_drv_cb);
  end
  // @(vif.dst_drv_cb);
   vif.dst_drv_cb.read_enb<=1'b1;
 // $display("valid out = %0d",vif.dst_drv_cb.valid_out);
  //$display("read_enb  = %0d",1'b1);
  while(vif.dst_drv_cb.valid_out!==0)
  begin
   @(vif.dst_drv_cb);
  end
  vif.dst_drv_cb.read_enb<=1'b0;
  @(vif.dst_drv_cb);
  @(vif.dst_drv_cb);
 
 //  $display("valid out = %0d",vif.dst_drv_cb.valid_out);
 // $display("read_enb  = %0d",1'b0);
  endtask
endclass
