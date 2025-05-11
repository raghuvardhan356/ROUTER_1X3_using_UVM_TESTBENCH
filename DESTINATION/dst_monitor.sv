class dst_monitor extends uvm_monitor;
  virtual router_intf.dst_mon_mp vif;
  dst_agt_config dst_cfgh;
  dst_xtn req;
  uvm_analysis_port #(dst_xtn) apd;
  `uvm_component_utils(dst_monitor)
  function new(string name ,uvm_component parent);
  super.new(name , parent);
  apd=new("apd",this);
  endfunction
  function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db #(dst_agt_config)::get(this,"","dst_agt_config",dst_cfgh))
      `uvm_fatal("dst_monitor","configuration getting failed")
  endfunction
  function void connect_phase(uvm_phase phase); 
     super.connect_phase(phase);
    this.vif = dst_cfgh.vif;
  endfunction
  task run_phase(uvm_phase phase);
   super.run_phase(phase);
   forever
   begin
   req=dst_xtn::type_id::create("req");
  // @(vif.dst_mon_cb);
  // @(vif.dst_mon_cb);
   collect_data();
   apd.write(req);
   $display("destination monitor collected data is =");
   req.print();
   end
  endtask


  task collect_data();
   //$display("read_enb in monitor = %0d",vif.dst_mon_cb.read_enb);
   while(vif.dst_mon_cb.read_enb!==1)
   begin
    @(vif.dst_mon_cb);
   // $display("read_enb in monitor = %0d",vif.dst_mon_cb.read_enb);

   end
  //  $display("read_enb in monitor = %0d",vif.dst_mon_cb.read_enb);

   //wait(vif.dst_mon_cb.read_enb===1)
    //repeat(5)
    @(vif.dst_mon_cb);
    @(vif.dst_mon_cb);
     //@(vif.dst_mon_cb);
   req.header=vif.dst_mon_cb.data_out;
   req.payload=new[req.header[7:2]];
   @(vif.dst_mon_cb);
   foreach(req.payload[i])
   begin
   req.payload[i]=vif.dst_mon_cb.data_out;
   @(vif.dst_mon_cb);
   end
   req.parity=vif.dst_mon_cb.data_out;
   endtask
endclass
