class base_src_sequence extends uvm_sequence #(src_xtn);
  `uvm_object_utils(base_src_sequence)
   function new(string name="base_src_sequence");
     super.new(name);
  endfunction
endclass

//----------------------small packet sequence --------------------------------
class small_packet extends base_src_sequence;
  bit[1:0]addr;
 `uvm_object_utils(small_packet)
  function new(string name="small_packet");
    super.new(name);
  endfunction
  virtual task body();
 // `uvm_info("full_name",get_full_name(),"UVM_LOW")
   $display("name = %s",get_type_name());
  if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
    `uvm_fatal("small_packet","addressing getting failed")
  //repeat(5)
  begin
  `uvm_create(req)
  start_item(req);
  assert(req.randomize() with {header[1:0]==addr;header[7:2] inside {[1:20]};});
  finish_item(req);
  end
 endtask
endclass


//-----------------------medium packet sequence ------------------------------
class medium_packet extends base_src_sequence;
  bit[1:0]addr;
  	`uvm_object_utils(medium_packet)
         function new(string name="medium_packet");
              super.new(name);
         endfunction

  virtual task body();
 if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
   `uvm_fatal("medium_packet","addressing getting failed")
 //repeat(10)
 begin
 `uvm_create(req)
 start_item(req);
 //`uvm_info("sequence path",get_full_name())
 assert(req.randomize() with {header[1:0]==addr;header[7:2] inside {[21:40]};});
finish_item(req);
 end
 endtask
 
 endclass


//----------------------large packet sequence ----------------------------------------
class large_packet extends base_src_sequence;
  bit[1:0]addr;
  `uvm_object_utils(large_packet)
   function new(string name="large_packet");
    super.new(name);
  endfunction
 
  virtual task body();
  if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
    `uvm_fatal("large_packet","addressing getting failed")
  //repeat(10)
  begin
  `uvm_create(req)
  start_item(req);
  assert(req.randomize() with {header[1:0]==addr; header[7:2] inside {[41:63]};});
  finish_item(req);
  end
  endtask
endclass

class error_packet extends base_src_sequence;
 `uvm_object_utils(error_packet)
  bit [1:0]addr;
  function new(string name="error_packet");
    super.new(name);
  endfunction
  virtual task body();
  if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
    `uvm_fatal("error_packet","address getting failed")
  begin
  `uvm_create(req)
  start_item(req);
  assert(req.randomize());
  req.parity=8'd25;
  finish_item(req);
  end
  endtask
endclass
