class src_agt extends uvm_agent;
 `uvm_component_utils(src_agt)
  src_driver drvh;
  src_monitor monh;
  src_sequencer seqrh;
  src_agt_config src_cfgh;
  bit is_active;
 function new(string name,uvm_component parent);
  super.new(name,parent);
 endfunction
 function void build_phase(uvm_phase phase);
   super.build_phase(phase);
   if(!uvm_config_db #(src_agt_config)::get(this,"","src_agt_config",src_cfgh))
       `uvm_fatal("Configuration","Configuration getting failed")
   is_active=src_cfgh.is_active;
   monh = src_monitor::type_id::create("monh",this);
   if(is_active)
   begin
   seqrh = src_sequencer::type_id::create("seqrh",this);
   drvh = src_driver::type_id::create("drvh",this);
   end
 endfunction 
 function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(is_active)
   drvh.seq_item_port.connect(seqrh.seq_item_export);
 endfunction
  
endclass
