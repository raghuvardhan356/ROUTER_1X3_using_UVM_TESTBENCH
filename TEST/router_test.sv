class router_test extends uvm_test;
   `uvm_component_utils(router_test)
    env envh;
    env_config env_cfgh;
    src_agt_config src_agt_cfgh[];
    dst_agt_config dst_agt_cfgh[];
    int no_src_agents=1;
    int no_dst_agents=3;
    bit[1:0]addr;
    function new(string name,uvm_component parent);
     super.new(name,parent);
    endfunction

   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     src_agt_cfgh=new[no_src_agents];
     dst_agt_cfgh=new[no_dst_agents];
     env_cfgh=env_config::type_id::create("env_cfgh",this);
     env_cfgh.no_of_src_agents=1;
     env_cfgh.no_of_dst_agents=3;
     env_cfgh.src_agt_h=new[no_src_agents];
     env_cfgh.dst_agt_h=new[no_dst_agents];
     foreach(src_agt_cfgh[i])
     begin
     src_agt_cfgh[i]=src_agt_config::type_id::create($sformatf("src_agt_cfgh[%0d]",i));
     if(!uvm_config_db #(virtual router_intf)::get(this,"","in",src_agt_cfgh[i].vif))
          `uvm_fatal("config","configuration getting failed")
     src_agt_cfgh[i].is_active=1;
     env_cfgh.src_agt_h[i]=src_agt_cfgh[i];
     end
     foreach(dst_agt_cfgh[i])
     begin
     dst_agt_cfgh[i]=dst_agt_config::type_id::create($sformatf("dst_agt_cfgh[%0d]",i));
     if(!uvm_config_db #(virtual router_intf)::get(this,"",$sformatf("in%0d",i),dst_agt_cfgh[i].vif))
         `uvm_fatal("config","congiguration getting failed")
     dst_agt_cfgh[i].is_active=1;
     env_cfgh.dst_agt_h[i]=dst_agt_cfgh[i];
     end
     uvm_config_db #(env_config)::set(this,"*","env_config",env_cfgh);
     envh = env::type_id::create("envh",this);
   endfunction
   function void end_of_elaboration_phase(uvm_phase phase);
      uvm_top.print_topology();
   endfunction
endclass

//-------------------------------small packet with normal output  test---------------------------------
class small_test extends router_test;
   `uvm_component_utils(small_test)
    bit[1:0]addr;
    
   small_packet seqs;
   data_out_sequence seqd;
   soft_reset_sequence seq_soft;
   small_virtual vseq;
   //---------new constructor--------
   function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //---------build phase--------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
       
  endfunction 

  //--------end of elaboration----------
  function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
  endfunction

 //---------run phase ----------------
 task run_phase(uvm_phase phase);
   super.run_phase(phase);
  // seqs=small_packet::type_id::create("seqs");
   //seqd=data_out_sequence::type_id::create("seqd");
   //seq_soft=soft_reset_sequence::type_id::create("seq_soft");
  $display("----------------------normal output operation checking with small packet--------------------");

  // repeat(5)
   begin
   addr={$urandom}%3;

   uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
  `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)


     vseq=small_virtual::type_id::create("vseq");
     phase.raise_objection(this);
   //fork
   vseq.start(envh.vseqrh);
  // #100;
  // seqs.start(envh.sagt_toph.agth[0].seqrh);
  // seqd.start(envh.dagt_toph.agth[2].seqrh);
   //seq_soft.start(envh.dagt_toph.agth[2].seqrh);
  // join
   phase.drop_objection(this);
  end
 endtask
endclass

//------------------------medium packet with normal output test------------------------------------------
class medium_test extends router_test;
  `uvm_component_utils(medium_test)
  bit[2:0]addr;
  medium_packet seqm;
   data_out_sequence seqd;
   soft_reset_sequence seq_soft;
   medium_virtual vseq;

 //-----------new constructor------------------
 function new(string name,uvm_component parent);
  super.new(name,parent);
 endfunction

 //----------build phase----------------------

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  
 endfunction

 //---------end of elboration phase----------
 function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
 endfunction 

//-----------run phase---------------------------
virtual task run_phase(uvm_phase phase);
 super.run_phase(phase);
 //repeat(2)
   begin
   addr={$urandom}%3;
  uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

$display("------------------normal output operation checking with medium packet---------------");

  `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)

 vseq=medium_virtual::type_id::create("vseq");
 phase.raise_objection(this);
// seqm.start(envh.sagt_toph.agth[0].seqrh);
 vseq.start(envh.vseqrh);
 phase.drop_objection(this);
 end
 endtask
endclass


//--------------------------large packet with normal output test-----------------------
class large_test extends router_test;
 `uvm_component_utils(large_test)
  bit[1:0]addr;
  large_packet seql;
   data_out_sequence seqd;
   soft_reset_sequence seq_soft;
   large_virtual vseq;

 
 //--------------new constructor----------------
 function new(string name,uvm_component parent);
  super.new(name,parent);
 endfunction


 //-----------build phase-------------------------
 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
 
 endfunction

 //----------end of elaboration phasse ----------
 function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
 endfunction

 //--------run phase ----------------------
 virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
 // repeat(5)
  begin
 $display("--------------normal output operation checking with large packet------------------------- ");
    addr={$urandom}%3;
  uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);


    `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)
  vseq=large_virtual::type_id::create("vseq");
  phase.raise_objection(this);
  vseq.start(envh.vseqrh);
  phase.drop_objection(this);
  end
 endtask

endclass
  

//-------------------------------small packet test with soft reset test---------------------------------
class small_soft_test extends router_test;
   `uvm_component_utils(small_soft_test)
    bit[1:0]addr;
    
   small_packet seqs;
   data_out_sequence seqd;
   soft_reset_sequence seq_soft;
   small_soft_virtual vseq;
   //---------new constructor--------
   function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  //---------build phase--------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
         endfunction 

  //--------end of elaboration----------
  function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
  endfunction

 //---------run phase ----------------
 task run_phase(uvm_phase phase);
   super.run_phase(phase);
  // seqs=small_packet::type_id::create("seqs");
   //seqd=data_out_sequence::type_id::create("seqd");
   //seq_soft=soft_reset_sequence::type_id::create("seq_soft");
   //repeat(3)
   begin
 $display("----------------------soft reset  output operation checking with small packet--------------------");
     addr={$urandom}%3;

     uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);


   `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)
   vseq=small_soft_virtual::type_id::create("vseq");
     phase.raise_objection(this);
   //fork
   vseq.start(envh.vseqrh);
  // seqs.start(envh.sagt_toph.agth[0].seqrh);
  // seqd.start(envh.dagt_toph.agth[2].seqrh);
   //seq_soft.start(envh.dagt_toph.agth[2].seqrh);
  // join
   phase.drop_objection(this);
   end
 endtask
endclass

 //-----------------------------------medium packet with soft reset test------------------//
class medium_soft_test extends router_test;
  `uvm_component_utils(medium_soft_test)
  bit[2:0]addr;
   medium_soft_virtual vseq;

 //-----------new constructor------------------
 function new(string name,uvm_component parent);
  super.new(name,parent);
 endfunction

 //----------build phase----------------------

 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
    endfunction

 //---------end of elboration phase----------
 function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
 endfunction 

//-----------run phase---------------------------
virtual task run_phase(uvm_phase phase);
 super.run_phase(phase); 
// repeat(2)
 begin
 $display("-----------------soft reset checking with medium packet----------------------------");
 addr={$urandom}%3;
  uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);



  `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)

 vseq=medium_soft_virtual::type_id::create("vseq");
 phase.raise_objection(this);
// seqm.start(envh.sagt_toph.agth[0].seqrh);
 vseq.start(envh.vseqrh);
 phase.drop_objection(this);
 end
 endtask
endclass

//--------------------------large packet with soft reset test------------------------//
class large_soft_test extends router_test;
 `uvm_component_utils(large_soft_test)
  bit[1:0]addr;
    large_soft_virtual vseq;

 
 //--------------new constructor----------------
 function new(string name,uvm_component parent);
  super.new(name,parent);
 endfunction


 //-----------build phase-------------------------
 function void build_phase(uvm_phase phase);
  super.build_phase(phase);
 
 endfunction

 //----------end of elaboration phasse ----------
 function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
 endfunction

 //--------run phase ----------------------
 virtual task run_phase(uvm_phase phase);
  super.run_phase(phase);
  //repeat(5)
  begin
 $display("--------------soft reset operation checking with large packet-----------------------------");
 addr={$urandom}%3;
  uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);


    `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)
  vseq=large_soft_virtual::type_id::create("vseq");
  phase.raise_objection(this);
  vseq.start(envh.vseqrh);
   phase.drop_objection(this);
   end
 endtask

endclass

class error_test extends router_test;
  `uvm_component_utils(error_test)
  error_virtual err_vseq;
  bit[1:0]addr;
  function new(string name="error_test",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
   super.build_phase(phase);
  endfunction

 function void end_of_elaboration_phase(uvm_phase phase);
   super.end_of_elaboration_phase(phase);
 endfunction
 
 virtual task run_phase(uvm_phase phase);
  $display("------------normal output operation checking error packet--------------------");
  addr={$urandom}%3;
   uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

  `uvm_info(get_type_name(),$sformatf("Destionation %0d is testing ",addr),UVM_LOW)
  err_vseq=error_virtual::type_id::create("err_vseq");
  phase.raise_objection(this);
  err_vseq.start(envh.vseqrh);
  phase.drop_objection(this);
 endtask
endclass
  
  
  
   






 
 
   
   
