class env extends uvm_env;
   `uvm_component_utils(env)
   sb sb_h;
   env_config env_cfgh;
   virtual_sequencer vseqrh;
   src_agt_top sagt_toph;
   dst_agt_top dagt_toph;
   function new(string name,uvm_component parent);
    super.new(name,parent);
   endfunction
   function void build_phase(uvm_phase phase);
     super.build_phase(phase);
     if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfgh))
         `uvm_fatal("config","getting configuration failed")
     //sb_h=new[3];
    // foreach(sb_h[i]) sb_h[i]=sb::type_id::create($sformatf("sb_h[%0d]",i),this);
     sagt_toph = src_agt_top::type_id::create("sagt_top",this);
     dagt_toph=dst_agt_top::type_id::create("dagt_top",this);
     vseqrh = virtual_sequencer::type_id::create("vseqrh",this);
     sb_h=sb::type_id::create("sb_h",this);
    // vseqrh.src_seqrh=sagt_toph.agth[0].seqrh;
  endfunction
  function void connect_phase(uvm_phase phase);
  //vseqrh.src_seqrh=new[env_cfgh.no_of_src_agents];
  //vseqrh.dst_seqrh=new[env_cfgh.no_of_dst_agents];
  foreach(vseqrh.src_seqrh[i])
     vseqrh.src_seqrh[i]=sagt_toph.agth[i].seqrh;
 
  foreach(vseqrh.dst_seqrh[i])
   vseqrh.dst_seqrh[i]=dagt_toph.agth[i].seqrh;

  //for(int i=0;i<env_cfgh.no_of_src_agents;i++)
  //begin
   sagt_toph.agth[0].monh.aps.connect(sb_h.src_fifo.analysis_export);
  //end
  for(int i=0;i<env_cfgh.no_of_dst_agents;i++)
  begin
    dagt_toph.agth[i].monh.apd.connect(sb_h.dst_fifo[i].analysis_export);
  end

  endfunction
endclass
  
