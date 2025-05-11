class env_config extends uvm_object;
 int no_of_src_agents;
 int no_of_dst_agents;
 src_agt_config src_agt_h[];
 dst_agt_config dst_agt_h[];
 `uvm_object_utils(env_config)
 function new(string name="env_config");
  super.new(name);
 endfunction
endclass
