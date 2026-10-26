`include "parameters.sv"
`include "instruction_memory.sv"
`include "data_processing.sv"
`include "control.sv"

module cpu (clk, reboot, alu_out, C, N, Z, V);
  
  input clk, reboot;
  output [0:DATABUS_MSB] alu_out;
  output C, N, Z, V;
  
  reg [0:ADDR_SIZE-1] pc;
  wire [0:INSTR_SIZE-1] instruction;  

   
  // instruction decode
  wire [0:5] opcode = 		instruction[0:5];
  wire [0:1] rd = 			instruction[6:7];
  wire [0:1] rs = 			instruction[8:9];
  wire [0:1] rt = 			instruction[10:11];
  wire [0:IMM_SIZE-1] imm = instruction[12:INSTR_SIZE-1];
  
  // inter-module wires
  wire regf_sel;
  wire regf_write_en;
  wire [0:DATABUS_MSB] regfA;
  wire [0:DATABUS_MSB] regfB;

  wire [0:2] state;
  wire datamem_read_en;
  wire datamem_write_en;
  wire alu_src;
    
  
  always @ (posedge clk) begin
    if (reboot)
      pc <= PROG_LOAD_ADDR;
    
    else if (state == STATE_EXECUTE && opcode == BEQ) begin
      if (Z)
        pc <= pc + 1 + {{(ADDR_SIZE - IMM_SIZE){imm[0]}}, imm};
      else
        pc <= pc + 1;
    end
    else if (state == STATE_WB)
      pc <= pc + 1;
  end
  
  
  data_processing dp (.clk(clk),
                      .opcode(opcode),
                      .write_addr(rd),
                      .regf_sel(regf_sel),
                      .regf_write_en(regf_write_en),
                      .read_addr1(rs),
                      .read_addr2(rt),
                      .regfA_reg(regfA),
                      .regfB_reg(regfB),
                      .imm(imm),
                      .datamem_read_en(datamem_read_en),
                      .datamem_write_en(datamem_write_en),
                      .alu_src(alu_src),
                      .alu_out(alu_out),
                      .state(state),
                      .C(C), .V(V), .N(N), .Z(Z) );

  
  control ctrl (.clk(clk),
                .reboot(reboot),
                .regf_sel(regf_sel),
                .regf_write_en(regf_write_en),
                .opcode(opcode),
                .state(state),
                .datamem_read_en(datamem_read_en),
                .datamem_write_en(datamem_write_en),
                .alu_src(alu_src) );
      
  
      instruction_memory imem (.clk(clk),
                           .pc(pc),
                           .instruction(instruction) );


endmodule