`include "alu.sv"
`include "regfile.sv"
`include "misc.sv"
`include "data_memory.sv"

module data_processing (clk, opcode, read_addr1, read_addr2, write_addr,
                        regf_sel, regf_write_en, imm, alu_src, alu_out,
                        datamem_write_en, datamem_read_en, C, N, Z, V,
                        state, regfA_reg, regfB_reg);
  
  input clk;
  input [0:5] opcode;
  input [0:NUM_REGFILE_BITS - 1] read_addr1;
  input [0:NUM_REGFILE_BITS - 1] read_addr2;
  input [0:NUM_REGFILE_BITS - 1] write_addr;
  input regf_sel;
  input regf_write_en;
  input [0:IMM_SIZE-1] imm;
  input alu_src;
  input datamem_write_en;
  input datamem_read_en;
  input [0:2] state;
  
  output [0:DATABUS_MSB] alu_out;
  output reg C; 
  output reg N;
  output reg Z;
  output reg V;
  wire [0:DATABUS_MSB] regfA;
  wire [0:DATABUS_MSB] regfB;
  
  wire [0:DATABUS_MSB] regf_datamem_load;
  wire [0:DATABUS_MSB] alu_muxB;
  wire [0:DATABUS_MSB] imm_extend = { {(DATABUS_SIZE - IMM_SIZE){1'b0}}, imm};
  wire [0:DATABUS_MSB] regf_write;
  wire [0:ADDR_SIZE-1] dmem_addr = alu_out_reg[DATABUS_SIZE-INSTR_SIZE:DATABUS_MSB];
  wire Cw, Nw, Zw, Vw;
  
  output reg [0:DATABUS_MSB] regfA_reg;
  output reg [0:DATABUS_MSB] regfB_reg;
  reg [0:DATABUS_MSB] alu_out_reg;
  reg [0:DATABUS_MSB] regf_datamem_load_reg;
  
  
  always @ (posedge clk) begin
    if (state == STATE_FETCH) begin
      regfA_reg <= regfA;
      regfB_reg <= regfB;
    end
    else if (state == STATE_EXECUTE) begin
      alu_out_reg <= alu_out;
      C <= Cw;
      N <= Nw;
      Z <= Zw;
      V <= Vw;
    end
    else if (state == STATE_MEM) begin
      regf_datamem_load_reg <= regf_datamem_load;
    end
  end

  
  
  ALU alu (.bus1(regfA_reg),
           .bus2(alu_muxB),
           .ALUout(alu_out),
           .opcode(opcode),
           .C(Cw),
           .N(Nw),
           .Z(Zw),
           .V(Vw) );
  
  mux2x1_data mux_alu (.data_in0(regfB_reg),
                       .data_in1(imm_extend),
                       .data_out(alu_muxB),
                       .select(alu_src) );
  
  regfile regf (.clk(clk),
                .read_addr1(read_addr1), 
                .read_addr2(read_addr2), 
                .write_addr(write_addr),
                .read_data1(regfA), 
                .read_data2(regfB), 
                .write_data(regf_write),
                .write_enable(regf_write_en) );
    
  // select data to write into regf
  mux2x1_data m1 (.data_in0(regf_datamem_load_reg), // from data_mem
                  .data_in1(alu_out_reg),   // from R-type
          		  .data_out(regf_write), 
				  .select(regf_sel) );
  
  data_memory dmem (.clk(clk),
                    .read_en(datamem_read_en),
                    .write_en(datamem_write_en),
                    .data_addr(alu_out_reg),
                    .data_write(regfB_reg), // store at data read in regf rt
                    .data_read(regf_datamem_load) ); // write mem data to reg thru mux
    
  
 endmodule