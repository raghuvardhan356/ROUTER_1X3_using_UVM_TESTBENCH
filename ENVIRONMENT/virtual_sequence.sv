class virtual_sequence extends uvm_sequence#(uvm_sequence_item);
   `uvm_object_utils(virtual_sequence)
    function new(string name="virtual_sequence");
     super.new(name);
   endfunction
  //declaration virtual sequencer handle
   virtual_sequencer vseqrh;
  //declaration source sequence handles
   small_packet seqs;
   medium_packet seqm;
   large_packet seql;
   error_packet seqe;
 //declaration destination sequence handles
   data_out_sequence seq_out;
   soft_reset_sequence seq_soft;
   //src_sequencer srs_;
   task body();
   assert($cast(vseqrh,m_sequencer))
   else
     $fatal("Casting failed");
   endtask
endclass

class small_virtual extends virtual_sequence;
   `uvm_object_utils(small_virtual)
    bit [1:0]addr;
    function new(string name="small_virtual");
      super.new(name);
    endfunction
    task body();
    super.body();
    if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_type_name(),"address getting failed")

    seqs=small_packet::type_id::create("seqs");
    seq_out=data_out_sequence::type_id::create("seq_out");
    seq_soft=soft_reset_sequence::type_id::create("seq_soft");
    begin
    //normal output operation checking with small packet
    fork
    seqs.start(vseqrh.src_seqrh[0]);
    seq_out.start(vseqrh.dst_seqrh[addr]);
    join
  //soft reset checking with small packet
    /*fork
    $display("----------------------soft reset checking with small packet----------------------------------");
    seqs.start(vseqrh.src_seqrh[0]);
    seq_soft.start(vseqrh.dst_seqrh[addr]);
    join*/
    end
    endtask
endclass

class medium_virtual extends virtual_sequence;
  `uvm_object_utils(medium_virtual)
  bit [1:0] addr;
   function new(string name="medium_virtual");
   super.new(name);
   endfunction
   task body();
   super.body();
   if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
       `uvm_fatal(get_type_name(),"Address getting failed")
   
   seqm=medium_packet::type_id::create("seqm");
   seq_out=data_out_sequence::type_id::create("seq_out");
   seq_soft=soft_reset_sequence::type_id::create("seq_soft");
   //normal output operation checking with medium packet
   fork
   seqm.start(vseqrh.src_seqrh[0]);
   seq_out.start(vseqrh.dst_seqrh[addr]);
   join
   //soft reset checking with medium packet
  /* fork
   $display("-----------------soft reset checking with medium packet----------------------------");
   seqm.start(vseqrh.src_seqrh[0]);
   seq_soft.start(vseqrh.dst_seqrh[addr]);
   join*/
   endtask
endclass

class large_virtual extends virtual_sequence;
  `uvm_object_utils(large_virtual)
   bit[1:0]addr;
  function new(string name="large_virtual");
   super.new(name);
 endfunction
 task body();
 super.body();
 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
    `uvm_fatal(get_type_name(),"Address getting failed")
 seql =large_packet::type_id::create("seql");
 seq_out=data_out_sequence::type_id::create("seq_out");
 seq_soft=soft_reset_sequence::type_id::create("seq_soft");

 //normal output operation checking with large packet 
 fork
 seql.start(vseqrh.src_seqrh[0]);
 seq_out.start(vseqrh.dst_seqrh[addr]);
 join
//soft reset operation checking with large packet
 /*fork
 $display("--------------soft reset operation checking with large packet-----------------------------");
 seql.start(vseqrh.src_seqrh[0]);
 seq_soft.start(vseqrh.dst_seqrh[addr]);
 join*/
 endtask
endclass

class small_soft_virtual extends virtual_sequence;
   `uvm_object_utils(small_soft_virtual)
    bit [1:0]addr;
    function new(string name="small_soft_virtual");
      super.new(name);
    endfunction
    task body();
    super.body();
    if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
        `uvm_fatal(get_type_name(),"address getting failed")

    seqs=small_packet::type_id::create("seqs");
    seq_soft=soft_reset_sequence::type_id::create("seq_soft");
    begin
    //normal output operation checking with small packet
    fork
    seqs.start(vseqrh.src_seqrh[0]);
    seq_soft.start(vseqrh.dst_seqrh[addr]);
    join
    end
    endtask
endclass

class medium_soft_virtual extends virtual_sequence;
  `uvm_object_utils(medium_soft_virtual)
  bit [1:0] addr;
   function new(string name="medium_soft_virtual");
   super.new(name);
   endfunction
   task body();
   super.body();
   if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
       `uvm_fatal(get_type_name(),"Address getting failed")
   
   seqm=medium_packet::type_id::create("seqm");
   seq_soft=soft_reset_sequence::type_id::create("seq_soft");
   //soft reset checking with medium packet
   fork
   seqm.start(vseqrh.src_seqrh[0]);
   seq_soft.start(vseqrh.dst_seqrh[addr]);
   join
   endtask
endclass

class large_soft_virtual extends virtual_sequence;
  `uvm_object_utils(large_soft_virtual)
   bit[1:0]addr;
  function new(string name="large_soft_virtual");
   super.new(name);
 endfunction
 task body();
 super.body();
 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
    `uvm_fatal(get_type_name(),"Address getting failed")
 seql =large_packet::type_id::create("seql");
  seq_soft=soft_reset_sequence::type_id::create("seq_soft");

 //soft reset operation checking with large packet
 fork
 seql.start(vseqrh.src_seqrh[0]);
 seq_soft.start(vseqrh.dst_seqrh[addr]);
 join
 endtask
endclass

class error_virtual extends virtual_sequence;
  `uvm_object_utils(error_virtual)
  bit [1:0]addr;
  function new(string name="error_virtual");
    super.new(name);
 endfunction
  task body();
  super.body();
  if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
   `uvm_fatal(get_type_name(),"Address getting failed")
  seqe=error_packet::type_id::create("seqe");
  seq_out=data_out_sequence::type_id::create("seq_out");
  fork
  seqe.start(vseqrh.src_seqrh[0]);
  seq_out.start(vseqrh.dst_seqrh[addr]);
  join
  endtask
endclass
 


   


