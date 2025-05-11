class src_driver extends uvm_driver #(src_xtn);
  `uvm_component_utils(src_driver)
  virtual router_intf.src_drv_mp vif;
  src_agt_config src_cfgh;
  function new(string name , uvm_component parent);
    super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
   if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",src_cfgh))
     `uvm_fatal("driver","getting virtual interface failed")
   super.build_phase(phase);
  endfunction
  function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   vif=src_cfgh.vif;
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever 
    begin
    seq_item_port.get_next_item(req);
    //req.print();
    $display("Source driver driven packet is ");
    req.print();
    send_to_dut(req);
  //  req.print();
    seq_item_port.item_done();
    end 
 endtask
   
  task send_to_dut(src_xtn req);
  //reset driving
 
  @(vif.src_drv_cb);
  @(vif.src_drv_cb);
  vif.src_drv_cb.rst<=1'b0;
  @(vif.src_drv_cb);
  vif.src_drv_cb.rst<=1'b1;
  @(vif.src_drv_cb);
  //header driving
  vif.src_drv_cb.pkt_valid<=1'b1;
  vif.src_drv_cb.data_in<=req.header;
  //$display("header is driven =%0d",req.header);
  @(vif.src_drv_cb);
 //payload driving
  foreach(req.payload[i])
  begin
    while(vif.src_drv_cb.busy!=1'b0)
  begin
    @(vif.src_drv_cb);
  end
  vif.src_drv_cb.data_in<=req.payload[i];
  //$display("payload[%0d] is driven = %0d",i,req.payload[i]);
  @(vif.src_drv_cb);
  end
  //parity driving logic
  while(vif.src_drv_cb.busy!=1'b0)
  begin
   @(vif.src_drv_cb);
  end
  vif.src_drv_cb.pkt_valid<=1'b0;
  vif.src_drv_cb.data_in<=req.parity;
  //$display("parity is driven =%0d",req.parity);
  @(vif.src_drv_cb);
  @(vif.src_drv_cb);
@(vif.src_drv_cb);
@(vif.src_drv_cb);
@(vif.src_drv_cb);
@(vif.src_drv_cb);


  endtask
endclass
