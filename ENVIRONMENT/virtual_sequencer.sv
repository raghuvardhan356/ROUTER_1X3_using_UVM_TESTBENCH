class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)
   env_config env_cfg;
   function new(string name,uvm_component parent);
     super.new(name,parent);
   endfunction
   src_sequencer src_seqrh[];
   dst_sequencer dst_seqrh[];
   function void build_phase(uvm_phase phase);
     if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
       `uvm_fatal(get_type_name(),"Configuration getting failed")
     src_seqrh=new[env_cfg.no_of_src_agents];
     dst_seqrh=new[env_cfg.no_of_dst_agents];
  endfunction
   
endclass

