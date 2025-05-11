class dst_agt_top extends uvm_env;
  `uvm_component_utils(dst_agt_top)
   dst_agt agth[];
   env_config env_cfgh;
   function new(string name,uvm_component parent);
    super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     //agth = new[3];
     if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfgh))
         `uvm_fatal("destination_top","configuration getting failed")
      
     agth=new[env_cfgh.no_of_dst_agents];
     foreach(agth[i])  
     begin
     agth[i]=dst_agt::type_id::create($sformatf("agth[%0d]",i),this);
     uvm_config_db#(dst_agt_config)::set(this,$sformatf("agth[%0d]*",i),"dst_agt_config",env_cfgh.dst_agt_h[i]);
     end
   endfunction
endclass
