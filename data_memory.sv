
module data_memory (clk, read_en, write_en, data_addr, data_write, data_read);
  input clk;
  input read_en, write_en;
  input [0:ADDR_SIZE-1] data_addr;
  input [0:DATABUS_MSB] data_write;
  output [0:DATABUS_MSB] data_read;
  
  reg [0:DATABUS_MSB] data_mem [0:ADDR_NUM-1];
  
  
  initial begin
    integer i;
    for (i = 0; i < ADDR_NUM; i = i + 1) 
      data_mem[i] = {DATABUS_SIZE{1'b0}};
  end
  
  always @ (posedge clk) begin
      if (write_en)
        data_mem[data_addr] <= data_write;
  end
  
  assign data_read = (read_en) ? data_mem[data_addr] : {DATABUS_SIZE{1'b0}};
    
endmodule
  