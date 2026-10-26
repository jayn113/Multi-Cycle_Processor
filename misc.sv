
module mux2x1_data (data_in1, data_in0, data_out, select);
  input [0:DATABUS_MSB] data_in1;
  input [0:DATABUS_MSB] data_in0;
  output reg [0:DATABUS_MSB] data_out;
  input select;
  
  always @ (*) begin
    if (select)
      data_out <= data_in1;
    else 
      data_out <= data_in0;
  end
  
endmodule