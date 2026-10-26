localparam ADD = 6'd0;
localparam SUB = 6'd1;
localparam SLL = 6'd2;
localparam SRL = 6'd3;
localparam TWO_CMPLMT = 6'd4;
localparam ONE_CMPLMT = 6'd5;
localparam LW = 6'd6;
localparam SW = 6'd7;
localparam BREQ = 6'd8;
localparam JMP = 6'd9;
localparam ADDI = 6'd10;

module tb();
  reg clk, reboot;
  wire [0:DATABUS_MSB] alu_out;
  wire C, N, Z, V;
  

  
  cpu dut (.clk(clk),
            .reboot(reboot),
            .alu_out(alu_out),
            .C(C),
            .N(N),
            .Z(Z),
            .V(V) );
  
  
  task write_instr(
    input int addr,
    input logic [5:0] opcode,
    input logic [1:0] rd,
    input logic [1:0] rs,
    input logic [1:0] rt,
    input logic [7:0] imm
  );
    
    begin
      dut.imem.instr_mem[addr] = {opcode, rd, rs, rt, imm};
    end
  endtask
  
  
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    
    clk = 0; 
    reboot = 1; 
    #1;
    

//     A = 0x10
//     B = 0x20
//     C = 0x30
//     (A) = 20
//     (B) = 22
//     (C) = (A + B)

    
    //			[addr]   [op]   [rd]  [rs]  [rt]  [imm]
    write_instr(20'h200, ADDI,	2'd1, 2'd0, 2'd0, 8'd20); // ADDI 	r1, 20
    write_instr(20'h201, SW,	2'd0, 2'd0, 2'd1, 8'h10); // STORE	r1, 0x10
    write_instr(20'h202, ADDI,	2'd2, 2'd0, 2'd0, 8'd22); // ADDI	r2, 22
    write_instr(20'h203, SW,	2'd0, 2'd0, 2'd2, 8'h20); // STORE	r2, 0x20
    write_instr(20'h204, ADD,	2'd3, 2'd1, 2'd2, 8'd00); // ADD 	r3, r1, r2
    write_instr(20'h205, SW,	2'd0, 2'd0, 2'd3, 8'h30); // STORE	r3, 0x30

    
    #20 reboot = 0; 

    #550; 
    $finish;
    
  end
  
  
  always #10 clk = ~clk;
  
endmodule