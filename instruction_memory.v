
module instruction_memory (clk, pc, instruction);
  input clk;
  input [0:ADDR_SIZE-1] pc;
  output [0:INSTR_SIZE-1] instruction;
  
  reg [0:INSTR_SIZE-1] instr_mem [0:ADDR_NUM-1];
  
  initial begin
    integer i;
    for (i = 0; i < ADDR_NUM; i = i + 1) 
      instr_mem[i] = {INSTR_SIZE{1'b0}};
  end
  
  assign instruction = instr_mem[pc];
  
endmodule
  