class dst_agt extends  uvm_agent;
  `uvm_component_utils(dst_agt);
   dst_driver drvh;
   dst_monitor monh;
   dst_sequencer seqrh;
   dst_agt_config dst_config;
   bit is_active;
   function new(string name,uvm_component parent);
    super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db #(dst_agt_config)::get(this,"","dst_agt_config",dst_config))
      `uvm_fatal("Destination agent","Configuration getting failed")
   
    is_active=dst_config.is_active;
    monh = dst_monitor::type_id::create("monh",this);
    if(is_active)
    begin
    drvh = dst_driver::type_id::create("drvh",this);
    seqrh = dst_sequencer::type_id::create("seqrh",this);
    end
  endfunction
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if(is_active)
      drvh.seq_item_port.connect(seqrh.seq_item_export);
  endfunction
endclass
   
   
