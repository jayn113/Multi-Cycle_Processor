// Project parameters

parameter DATABUS_SIZE = 36;
parameter DATABUS_MSB = DATABUS_SIZE - 1;
parameter ADDR_SIZE = 10;
parameter ADDR_NUM = 1 << ADDR_SIZE; // 1024
parameter PROG_LOAD_ADDR = 20'h200;
parameter INSTR_SIZE = 20;
parameter IMM_SIZE = 8;

// ALU opcodes
parameter ALU_ADD = 0;
parameter ALU_SUB = 1;
parameter ALU_SHIFT_LEFT = 2;
parameter ALU_SHIFT_RIGHT = 3;
parameter ALU_TWOS_COMPLEMENT = 4;
parameter ALU_ONES_COMPLEMENT = 5;
parameter LOAD = 6;
parameter STORE = 7;
parameter BEQ = 8;
parameter JUMP = 9;
parameter ALU_ADDI = 10;

// REG FILE
parameter NUM_REGFILE_BITS = 2;
parameter NUM_REGISTERS = (1 << NUM_REGFILE_BITS); // 4

// CONTROL
parameter STATE_REBOOT = 0;
parameter STATE_FETCH = 1;
parameter STATE_EXECUTE = 2;
parameter STATE_MEM = 3;
parameter STATE_WB = 4;
