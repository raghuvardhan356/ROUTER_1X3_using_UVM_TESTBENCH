class dst_xtn extends uvm_sequence_item;
  `uvm_object_utils(dst_xtn)
   bit [7:0]header;
   bit [7:0]payload[];
   bit [7:0]parity;
  // bit read_enb;
   //bit valid_out;
   rand bit[5:0]delay;
   
  function void do_print(uvm_printer printer);
    super.do_print(printer);
    //printer.print_field("valid_out",this.valid_out,1,UVM_DEC);
   // printer.print_field("read_enb",this.read_enb,1,UVM_DEC);
    printer.print_field("Delay",this.delay,6,UVM_DEC);
    printer.print_field("Header",this.header,8,UVM_DEC);
    foreach(payload[i])
    begin
    printer.print_field($sformatf("Payload[%0d]",i),this.payload[i],8,UVM_DEC);
    end
    printer.print_field("Parity",this.parity,8,UVM_DEC);
  endfunction

  function new(string name="dst_xtn");
   super.new(name);
  endfunction
endclass
