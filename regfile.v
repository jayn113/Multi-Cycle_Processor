
module regfile (read_addr1, read_addr2, write_addr,
                read_data1, read_data2, write_data,
                write_enable, clk);
  input clk;
  input [0:NUM_REGFILE_BITS - 1] read_addr1;
  input [0:NUM_REGFILE_BITS - 1] read_addr2;
  input [0:NUM_REGFILE_BITS - 1] write_addr;
  input [0:DATABUS_SIZE - 1] write_data;
  input write_enable;
  output [0:DATABUS_SIZE - 1] read_data1;
  output [0:DATABUS_SIZE - 1] read_data2;
  
  reg [0:DATABUS_SIZE - 1] reg_mem [0:NUM_REGISTERS - 1];
  
  initial begin
    integer i;
    for (i = 0; i < NUM_REGISTERS; i = i + 1)
      reg_mem[i] = {DATABUS_SIZE{1'b0}};
  end
  
  always @ (posedge clk) begin
    if (write_enable) 
      reg_mem[write_addr] <= write_data;
    
    // two valid ways to assign read_data
//     read_data1 <= reg_mem[read_addr1];
//     read_data2 <= reg_mem[read_addr2];
    
//     if (read_addr2 == 0)
//       read_data2 <= 0; // reg 0 always returns 0
//     else
//       read_data2 <= reg_mem[read_addr2];
    
  end
  // C conditional response, test ? true : false
  assign read_data1 = (read_addr1 == 0 ? 0 : reg_mem[read_addr1] );
  assign read_data2 = (read_addr2 == 0 ? 0 : reg_mem[read_addr2] );
  
endmodule