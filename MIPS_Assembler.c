#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Instruction format definitions
#define R_TYPE 0
#define I_TYPE 1
#define J_TYPE 2

// Function to remove leading/trailing whitespace
char* trim(char* str) {
    while(isspace((unsigned char)*str)) str++;
    if(*str == 0) return str;
    char* end = str + strlen(str) - 1;
    while(end > str && isspace((unsigned char)*end)) end--;
    end[1] = '\0';
    return str;
}

// Function to extract register number from string (e.g., "$1" -> 1)
int get_register(char* reg) {
    if (reg[0] != '$') return -1;
    return atoi(reg + 1);
}

// Function to get instruction type and opcode
int get_instruction_info(char* instr, int* type, int* opcode) {
    // R-type instructions (opcode = 0)
    if (strcmp(instr, "add") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x20; }
    if (strcmp(instr, "sub") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x22; }
    if (strcmp(instr, "xor") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x26; }
    if (strcmp(instr, "and") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x24; }
    if (strcmp(instr, "or") == 0)  { *type = R_TYPE; *opcode = 0x00; return 0x25; }
    if (strcmp(instr, "slt") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x2A; }
    if (strcmp(instr, "srl") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x02; }
    if (strcmp(instr, "sll") == 0) { *type = R_TYPE; *opcode = 0x00; return 0x00; }
    if (strcmp(instr, "jr") == 0)  { *type = R_TYPE; *opcode = 0x00; return 0x08; }
    
    // I-type instructions
    if (strcmp(instr, "addi") == 0) { *type = I_TYPE; *opcode = 0x08; return 0; }
    if (strcmp(instr, "andi") == 0) { *type = I_TYPE; *opcode = 0x0C; return 0; }
    if (strcmp(instr, "ori") == 0)  { *type = I_TYPE; *opcode = 0x0D; return 0; }
    if (strcmp(instr, "lw") == 0)   { *type = I_TYPE; *opcode = 0x23; return 0; }
    if (strcmp(instr, "sw") == 0)   { *type = I_TYPE; *opcode = 0x2B; return 0; }
    if (strcmp(instr, "beq") == 0)  { *type = I_TYPE; *opcode = 0x04; return 0; }
    if (strcmp(instr, "bne") == 0)  { *type = I_TYPE; *opcode = 0x05; return 0; }
    
    // J-type instruction
    if (strcmp(instr, "j") == 0)    { *type = J_TYPE; *opcode = 0x02; return 0; }
    
    return -1; // Invalid instruction
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Usage: %s <input_file> <output_file>\n", argv[0]);
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    FILE* output = fopen(argv[2], "w");
    
    if (!input || !output) {
        printf("Error opening files\n");
        return 1;
    }

    char line[256];
    int line_number = 0;
    
    while (fgets(line, sizeof(line), input)) {
        line_number++;
        char* token;
        unsigned int machine_code = 0;
        
        // Remove comments (everything after #)
        char* comment = strchr(line, '#');
        if (comment) *comment = '\0';
        
        // Skip empty lines
        if (strlen(trim(line)) == 0) continue;
        
        // Get instruction
        token = strtok(line, " ,\t\n()");
        if (!token) continue;
        
        int type, opcode, funct;
        funct = get_instruction_info(token, &type, &opcode);
        if (funct == -1) {
            printf("Error: Invalid instruction on line %d\n", line_number);
            continue;
        }
        
        machine_code = opcode << 26; // Set opcode
        
        if (type == R_TYPE) {
            if (strcmp(token, "jr") == 0) {
                // jr $rs
                token = strtok(NULL, " ,\t\n()");
                int rs = get_register(token);
                machine_code |= (rs << 21);
            } else if (strcmp(token, "srl") == 0 || strcmp(token, "sll") == 0) {
                // srl/sll $rd, $rt, shamt
                token = strtok(NULL, " ,\t\n()");
                int rd = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int rt = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int shamt = atoi(token);
                
                machine_code |= (rt << 16) | (rd << 11) | (shamt << 6) | funct;
            } else {
                // Regular R-type: op $rd, $rs, $rt
                token = strtok(NULL, " ,\t\n()");
                int rd = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int rs = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int rt = get_register(token);
                
                machine_code |= (rs << 21) | (rt << 16) | (rd << 11) | funct;
            }
        }
        else if (type == I_TYPE) {
            if (strcmp(token, "lw") == 0 || strcmp(token, "sw") == 0) {
                // lw/sw $rt, imm($rs)
                token = strtok(NULL, " ,\t\n()");
                int rt = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int imm = atoi(token);
                token = strtok(NULL, " ,\t\n()");
                int rs = get_register(token);
                
                machine_code |= (rs << 21) | (rt << 16) | (imm & 0xFFFF);
            } else {
                // Regular I-type: op $rt, $rs, imm
                token = strtok(NULL, " ,\t\n()");
                int rt = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int rs = get_register(token);
                token = strtok(NULL, " ,\t\n()");
                int imm = atoi(token);
                
                machine_code |= (rs << 21) | (rt << 16) | (imm & 0xFFFF);
            }
        }
        else if (type == J_TYPE) {
            // j target
            token = strtok(NULL, " ,\t\n()");
            int target = atoi(token);
            machine_code |= (target & 0x3FFFFFF);
        }
        
        fprintf(output, "%08X\n", machine_code);
    }
    
    fclose(input);
    fclose(output);
    return 0;
}