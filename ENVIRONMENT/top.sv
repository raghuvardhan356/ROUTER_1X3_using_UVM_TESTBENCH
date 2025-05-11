module top;
  import router_pkg::*;
  import uvm_pkg::*;
  bit clk;
  always #10 clk=~clk;
  router_intf in(clk);
  router_intf in0(clk);
  router_intf in1(clk);
  router_intf in2(clk);

top_block dut(.clk(clk),.pkt_valid(in.pkt_valid),.rst(in.rst),.error(in.error),.data_in(in.data_in),.busy(in.busy),.valid_out_0(in0.valid_out),.valid_out_1(in1.valid_out),.valid_out_2(in2.valid_out),.read_enb_0(in0.read_enb),.read_enb_1(in1.read_enb),.read_enb_2(in2.read_enb),.dout_out_0(in0.data_out),.dout_out_1(in1.data_out),.dout_out_2(in2.data_out));
  initial begin
   `ifdef VCS
    $fsdbDumpvars(0, top);
    `endif



  uvm_config_db #(virtual router_intf)::set(null,"*","in",in);
  uvm_config_db #(virtual router_intf)::set(null,"*","in0",in0);
  uvm_config_db #(virtual router_intf)::set(null,"*","in1",in1);
  uvm_config_db #(virtual router_intf)::set(null,"*","in2",in2);
  //initial 
 // begin
  run_test();
  end
 property stable_data;
   @(posedge clk) in.busy|=>$stable(in.data_in);
  endproperty
  property busy_check;
   @(posedge clk) $rose(in.pkt_valid)|=>in.busy;
  endproperty
  property valid_signal;
  @(posedge clk) $rose(in.pkt_valid)|->##3 (in0.valid_out|in1.valid_out|in2.valid_out);
  endproperty
  property read_enable0;
  @(posedge clk) in0.valid_out |=> ##[1:29] in0.read_enb;
  endproperty
  property read_enable1;
  @(posedge clk) in1.valid_out |=> ##[1:29] in1.read_enb;
  endproperty
  property read_enable2;
  @(posedge clk) in2.valid_out |=> ##[1:29] in2.read_enb;
  endproperty
  property read_enb0_low;
  @(posedge clk) $fell(in0.valid_out) |=>$fell(in0.read_enb);
  endproperty
  property read_enb1_low;
  @(posedge clk) $fell(in1.valid_out) |=> $fell(in1.read_enb);
  endproperty
  property read_enb2_low;
  @(posedge clk) $fell(in2.valid_out) |=> $fell(in2.read_enb);
  endproperty
  
 /* C1:assert property(stable_data)
       $display("Assertion passed: Data is stable when busy is high");
     else
      $display("Assertion faield : Data is not stable when busy is high");
  C2:assert property(busy_check)
      $display("Assertion passed : Busy is high when header is driven ");
      else
       $display("Assertion failed :Busy is not high when header is driven ");
 C3:assert property(valid_signal)
      $display("Assertion passed : Valid signal becomes high after data send ");
      else
       $display("Assertion failed : Valid signal not becoming high after data send");
  C4:assert property(read_enable0)
       $display("Assertion passed : Read enable0 signal is high within 30 clock cycles");
     else
       $display("Assertion failed : Read enable0 signal is not high within 30 clock cycles");
  C5:assert property(read_enable1)
      $display("Assertion passed : Read enable 1 signal is high within 30 clock cycles");
     else
      $display("Assettion faield : Read enable 1 signal is not high within 30 clock cycles");
  C6:assert property(read_enable2)
        $display("Assertion passed: Read enable 2 is high within 30 clock cycles");
     else
       $display("Assertion failed : Read enable 2 is not high within 30 clock cycles");
  C7:assert property(read_enb0_low)
       $display("Assertion passed : Read enable 0 goes low after reading data");
     else 
       $display("Assertion failed : Read enable 0 not going low after reading data");
  C8:assert property(read_enb1_low)
      $display("Assertion passed : Read enable 1 goes low after reading data");
     else
      $display("Assertion failed : Read enable 1 not going low after reading data");
  C9:assert property(read_enb2_low)
      $display("Assertion passed : Read enable 2 goes low after reading data ");
     else
       $display("Assertion failed : Read enable 2 not going low after reading data");
 
  C10:cover property(stable_data);
  C11:cover property(busy_check);
  C12:cover property(valid_signal);
  C13:cover property(read_enable0);
  C14:cover property(read_enable1);
  C15:cover property(read_enable2);
  C16:cover property(read_enb0_low);
  C17:cover property(read_enb1_low);
  C18:cover property(read_enb2_low);*/
  
  
  
  
endmodule
