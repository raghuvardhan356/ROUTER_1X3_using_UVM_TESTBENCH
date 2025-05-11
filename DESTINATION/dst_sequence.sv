class base_sequence extends uvm_sequence #(dst_xtn);
  `uvm_object_utils(base_sequence)
   function new(string name="base_sequence");
    super.new(name);
  endfunction
endclass

class data_out_sequence extends base_sequence;
  `uvm_object_utils(data_out_sequence)
   function new(string name="data_out_sequence");
    super.new(name);
   endfunction
   
   task body();
   `uvm_create(req)
   start_item(req);
   
   assert(req.randomize() with {req.delay<=29;});
   $display("randomized delay value = %0d",req.delay);
   
   finish_item(req);
   endtask
endclass

class soft_reset_sequence extends base_sequence;
  `uvm_object_utils(soft_reset_sequence)
   function new(string name="soft_reset_sequence");
    super.new(name);
  endfunction
 
  task body();
  `uvm_create(req)
  start_item(req);
  
  assert(req.randomize() with {req.delay>=30;});
  //$display("randomized delay value = %0d",req.delay);
  `uvm_info(get_type_name(),$sformatf("Randomized delay value = %0d",req.delay),UVM_LOW)
  finish_item(req);
  endtask
endclass
