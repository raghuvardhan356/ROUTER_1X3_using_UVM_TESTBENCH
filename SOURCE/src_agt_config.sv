class src_agt_config extends uvm_object;
 virtual router_intf vif;
 bit is_active;
 `uvm_object_utils(src_agt_config)
 function new(string name="src_agt_config");
  super.new(name);
 endfunction
endclass
