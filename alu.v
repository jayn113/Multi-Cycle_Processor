
module ALU (bus1, bus2, ALUout, opcode, C, N, Z, V);
  								// carryOut, -ve, zero, overflow
  input [0:DATABUS_MSB] bus1;
  input [0:DATABUS_MSB] bus2;
  output reg [0:DATABUS_MSB] ALUout;
  input [0:5] opcode;
  output C;
  output N;
  output Z;
  output V;
  
  reg [0:DATABUS_MSB] temp;
  reg carry; // unsigned op overflow
  reg [0:DATABUS_SIZE] carryWidth; // unsigned to pad only 0s
  
  always @ (*) begin
    ALUout = 0;
	carry  = 0;
    if (opcode == ALU_ADD || opcode == ALU_ADDI) begin
      carryWidth = bus1 + bus2;
      ALUout = carryWidth[1:DATABUS_SIZE];
      carry = carryWidth[0];
    end
    
    else if (opcode == ALU_SUB) begin
      carryWidth = {1'b0, bus1} - {1'b0, bus2};
      ALUout = carryWidth[1:DATABUS_SIZE];
      carry = carryWidth[0];
    end
    
    else if (opcode == ALU_SHIFT_LEFT) begin
      // bus1 = arg to shift
      // bus2 = shift count
      if (bus2 < 0)
        temp = 0;
      else
        temp = bus2;
      ALUout = (bus1 << temp);
      
      // calculate carry
      if (temp == 0)
        carry = 0;
      else if (temp <= DATABUS_SIZE)
        carry = bus1[temp - 1];
      else // (temp > DATABUS_SIZE)
        carry = bus1[DATABUS_MSB];
    end
    
    else if (opcode == ALU_SHIFT_RIGHT) begin
      if (bus2 < 0)
        temp = 0;
      else
        temp = bus2;
      ALUout = (bus1 >> temp);
      
      // calculate carryout
      if (temp == 0)
        carry = 0;
      else if (temp <= DATABUS_SIZE)
        carry = bus1[DATABUS_SIZE - temp];
      else // (temp > DATABUS_SIZE)
        carry = bus1[0];
    end
    
    else if (opcode == ALU_TWOS_COMPLEMENT) begin
      ALUout = ~(bus1) + 1;
    end
    
    else if (opcode == ALU_ONES_COMPLEMENT) begin
      ALUout = ~(bus1);
    end
    
    else if (opcode == LOAD || opcode == STORE) begin
      // bus1 holds base mem addr, bus2 holds imm
      ALUout = bus1 + bus2;
      // for LOAD, ALUout gives dmem offset addr to be stored at rd
      // fore STORE, ALUout gives dmem offset addr to store data in rd
    end
        
    // TODO: Branch, jump?
	      
  end
  
  assign C = carry;
  assign N =  ALUout[0];
  assign Z = (ALUout == 0);
  
endmodule