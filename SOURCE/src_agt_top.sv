class src_agt_top extends uvm_env;
  src_agt agth[];
  env_config env_cfgh;
  `uvm_component_utils(src_agt_top)
  function new(string name , uvm_component parent);
   super.new(name,parent);
  endfunction
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfgh))
        `uvm_fatal("source_agt_top","getting configuration failed")
    agth=new[env_cfgh.no_of_src_agents];
    foreach(agth[i])
    begin
    agth[i] = src_agt::type_id::create($sformatf("agth[%0d]",i),this);
    uvm_config_db#(src_agt_config)::set(this,$sformatf("agth[%0d]*",i),"src_agt_config",env_cfgh.src_agt_h[i]);
    end
  endfunction
endclass
