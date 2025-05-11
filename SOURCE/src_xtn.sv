class src_xtn extends uvm_sequence_item;
  `uvm_object_utils(src_xtn)

   //source transaction signals
   rand bit [7:0]header;
   rand bit[7:0] payload[];
   bit [7:0]parity;
   bit pkt_valid;
   bit busy;
   bit error;

  //constraints
  constraint c1{header[1:0] !=2'b11;}
  constraint c2{header[7:2] !=0;}
  constraint c3{payload.size()==header[7:2];}

  //post_randomization for parity generation
  function void post_randomize();
  parity = parity^header;
  foreach(payload[i]) 
    parity=parity^payload[i];
     // parity=8'd25;
  endfunction 
 
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("Header",this.header,8,UVM_BIN);
    printer.print_field("Address",this.header[1:0],2,UVM_DEC);
    printer.print_field("Payload size",this.header[7:2],6,UVM_DEC);
    foreach(payload[i])
    begin
      printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
   end
   printer.print_field("parity",this.parity,8,UVM_DEC);
   printer.print_field("busy",this.busy,1,UVM_BIN);
   printer.print_field("error",this.error,1,UVM_BIN);
 endfunction
 
 function new(string name="src_xtn");
  super.new(name);
 endfunction 
endclass

