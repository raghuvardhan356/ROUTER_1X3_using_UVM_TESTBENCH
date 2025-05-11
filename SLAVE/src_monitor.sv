class src_monitor extends uvm_monitor;
  `uvm_component_utils(src_monitor)
   virtual router_intf.src_mon_mp vif;
   uvm_analysis_port #(src_xtn) aps;
  src_agt_config src_cfgh;
  src_xtn req;
  src_xtn data2sb;
  function new(string name , uvm_component parent);
   super.new(name,parent);
   aps=new("aps",this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(src_agt_config)::get(this,"","src_agt_config",src_cfgh))
       `uvm_fatal("src_monitor","virtual interface getting failed")
  endfunction
 function void connect_phase(uvm_phase phase);
   super.connect_phase(phase);
   this.vif=src_cfgh.vif;
 endfunction


 task run_phase(uvm_phase phase);
 super.run_phase(phase);
 
 forever 
 begin
 req=src_xtn::type_id::create("req");
 collect_data();
 data2sb =new req;
 //req.print();
 aps.write(data2sb);
 end
 endtask
 
 task collect_data();
 while(vif.src_mon_cb.pkt_valid!==1)
 begin
 @(vif.src_mon_cb);
 end
 req.header=vif.src_mon_cb.data_in;
// $display("header is collected = %0d",req.header);
 req.payload=new[req.header[7:2]];
 @(vif.src_mon_cb);
 foreach(req.payload[i])
 begin
 while(vif.src_mon_cb.busy!=0)
 begin
  @(vif.src_mon_cb);
 end
 req.payload[i]=vif.src_mon_cb.data_in;
 //$display("payload[%0d] is collected = %0d",i,req.payload[i]);
 @(vif.src_mon_cb);
 end
 while(vif.src_mon_cb.busy!=0)
 begin
  @(vif.src_mon_cb);
 end
 req.parity=vif.src_mon_cb.data_in;
// $display("parity is collected =%0d",req.parity);
 repeat(2)
  @(vif.src_mon_cb);
 req.error=vif.src_mon_cb.error;
 $display("source monitor collected packet is = ");
 req.print();
 endtask
 
 
 
endclass
