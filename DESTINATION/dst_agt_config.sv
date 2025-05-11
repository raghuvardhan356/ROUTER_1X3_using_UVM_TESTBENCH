class dst_agt_config extends uvm_object;
  `uvm_object_utils(dst_agt_config)
  virtual router_intf vif;
  bit is_active;
  function new(string name="dst_agt_config");
   super.new(name);
  endfunction
endclass

