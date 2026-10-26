// Code your testbench here
// or browse Examples

module tb();
  reg clk, reboot;
  wire [0:35] alu_out;
  wire C, N, Z, V;
  

  
  cpu dut (.clk(clk),
            .reboot(reboot),
            .alu_out(alu_out),
            .C(C),
            .N(N),
            .Z(Z),
            .V(V) );

  
//     int sum = 0 ;
//     for( i = 0 ; i <= 10 ; i++ ){
//       sum += i ;
//     }

  
  initial begin
  	$dumpfile("dump.vcd"); $dumpvars;

  	clk = 0;
  	reboot = 1;
  	#1;
	
  	// constants
  	dut.dp.dmem.data_mem[8'h50] = 8'd1;     // 1
  	dut.dp.dmem.data_mem[8'h51] = 8'd11;    // loop limit
	    
	
  	//          [addr]   [op]  [rd]  [rs]  [rt]  [imm]
    write_instr(20'h200, ADDI, 2'd1, 2'd0, 2'd0, 8'd0);   // sum = 0 r1
    write_instr(20'h201, ADDI, 2'd2, 2'd0, 2'd0, 8'd0);   // i = 0   r2
	
  	// CHECK
  	write_instr(20'h202, LW,   2'd3, 2'd0, 2'd0, 8'h51);  // r3 = 11
    write_instr(20'h203, SUB,  2'd3, 2'd3, 2'd2, 8'd0);   // r3 = 11 - i
    write_instr(20'h204, BREQ, 2'd0, 2'd3, 2'd0, 8'h04);  // if = 0 go EXIT
	
  	// BODY
  	write_instr(20'h205, ADD,  2'd1, 2'd1, 2'd2, 8'd0);   // sum += i
  	write_instr(20'h206, LW,   2'd3, 2'd0, 2'd0, 8'h50);  // r3 = 1
  	write_instr(20'h207, ADD,  2'd2, 2'd2, 2'd3, 8'd0);   // i++
	
  	// unconditional branch to CHECK
    write_instr(20'h208, BREQ, 2'd0, 2'd0, 2'd0, 8'hF8);  // go back to 0x202
	
  	// EXIT
  	write_instr(20'h209, SW,   2'd0, 2'd0, 2'd1, 8'h40);  // store sum
	
  	#20 reboot = 0;
	
  	#2000;
  $finish;
end
  
  always #5 clk = ~clk;
  
endmodule