class sb extends uvm_scoreboard;
  `uvm_component_utils(sb)
   src_xtn exp;
   dst_xtn act;
   src_xtn src_cgh;
   dst_xtn dst_cgh;
   uvm_tlm_analysis_fifo #(src_xtn) src_fifo;
   uvm_tlm_analysis_fifo #(dst_xtn) dst_fifo[];
   env_config cfgh;
   bit [1:0]addr;
   int err_count;
   covergroup src_coverage;
   ADDR:coverpoint src_cgh.header[1:0]
       {
        bins addr0={0};
        bins addr1={1};
        bins addr2={2};
       }
  PAYLOAD_SIZE:coverpoint src_cgh.header[7:2]
        {
         bins small_pkt={[1:20]};
         bins medium_pkt = {[21:40]};
         bins large_pkt = {[41:63]};
       }
  ERROR:coverpoint src_cgh.error
       {
        bins low={0};
        bins high={1};
      }
  CROSS:cross ADDR,PAYLOAD_SIZE,ERROR;
  endgroup
  covergroup dst_coverage;
  ADDR:coverpoint dst_cgh.header[1:0]
      {
       bins addr0={0};
       bins addr1={1};
       bins addr2={2};
      }
  PAYLOAD_SIZE:coverpoint dst_cgh.header[7:2]
      {
        bins small_pkt={[1:20]};
        bins medium_pkt = {[21:40]};
        bins large_pkt = {[41:63]};
      }
  CROSS:cross ADDR,PAYLOAD_SIZE;
  endgroup
 

   function new(string name,uvm_component parent);
    super.new(name,parent);
    src_coverage = new();
    dst_coverage = new();
    src_fifo=new("src_fifo",this);
   endfunction
   
   function void build_phase(uvm_phase phase);
    if(!uvm_config_db#(env_config)::get(this,"","env_config",cfgh))
        `uvm_fatal(get_type_name(),"Configuration getting failed ")
    dst_fifo=new[cfgh.no_of_dst_agents];
    foreach(dst_fifo[i])
    begin
      dst_fifo[i]=new($sformatf("dst_fifo[%0d]",i),this);
    end 
   // if(!uvm_config_db#(bit[1:0])::get(this,"","addr",addr))
     //  `uvm_fatal(get_type_name(),"Address getting failed")
   endfunction

   task run_phase(uvm_phase phase);
   forever 
    begin
          fork
      begin:src
      src_fifo.get(exp);
      src_cgh= new exp;
      src_coverage.sample();
      end
      begin:dst
      if(!uvm_config_db#(bit[1:0])::get(this,"","addr",addr))
       `uvm_fatal(get_type_name(),"Address getting failed")
      dst_fifo[addr].get(act);
            dst_cgh= new act;
      dst_coverage.sample();
      end
     join 
     `uvm_info(get_type_name(),"Actual output is  = ",UVM_LOW)
      act.print();
    `uvm_info(get_type_name(),"Expected output is = ",UVM_LOW)
      exp.print();
     check_output(exp,act);
   end
   endtask
   function void check_output(src_xtn exp,dst_xtn act);
   if(act.header==exp.header)  $display("Header matched");
   else $display("Header not matched");
   if(act.payload==exp.payload) $display("Payload matched");
   else $display("Payload not matched");
   if(act.parity==exp.parity) $display("Parity matched");
   else $display("Parity not matched");
   endfunction
endclass
