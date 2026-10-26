
module control (clk, reboot, regf_sel, regf_write_en, opcode, 
                state, datamem_read_en, datamem_write_en, alu_src);
  
  input clk, reboot;
  input [0:5] opcode;  
  output reg regf_sel;
  output reg regf_write_en; 
  output reg [0:2] state;
  output reg datamem_read_en;
  output reg datamem_write_en;
  output reg alu_src;
  reg [0:2] next_state;
  
  // assign next state
  always @ (posedge clk or posedge reboot) begin
    if (reboot)
      state <= STATE_REBOOT;
    else
      state <= next_state;
  end
  
  // state control
  always @ (*) begin
    next_state = state;
    case (state)
      STATE_REBOOT: next_state = STATE_FETCH;
      STATE_FETCH: next_state = STATE_EXECUTE;
      
      STATE_EXECUTE: begin
        if (opcode == LOAD || opcode == STORE)
          next_state = STATE_MEM;
        
        else if (opcode == BEQ)
          next_state = STATE_FETCH;
        else
          next_state = STATE_WB;
      end
      
      STATE_MEM: next_state = STATE_WB;
      STATE_WB: next_state = STATE_FETCH;      
      
      default:     next_state = STATE_FETCH;
              
    endcase
    
  end

  // control signals
  always @ (*) begin
    regf_write_en = 0;
    regf_sel = 0;
    datamem_read_en = 0;
    datamem_write_en = 0;
    alu_src = 0;
    
    if (state == STATE_EXECUTE) begin
      // alu mux sel for imm
      if (opcode == LOAD || opcode == STORE || opcode == ALU_ADDI)
        alu_src = 1;
    end
    
    else if (state == STATE_MEM) begin
      if (opcode == LOAD)
        datamem_read_en = 1;
      else if (opcode == STORE)
        datamem_write_en = 1;
    end
    
    else if (state == STATE_WB) begin
      if (opcode != STORE && opcode != BEQ && opcode != JUMP) begin
        regf_write_en = 1;
        regf_sel = (opcode != LOAD); // sel 0 if load
      end
    end
    
  end

endmodule