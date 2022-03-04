print('Running Assembler:') 
filename = "Program3.txt"
read_file = open(filename, "r") 
#w_file is the file we are writing to
w_file = open("Machine3.txt", "w")

#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]  

#1. open the file
#2. for each line in the file,
#3.     split the string by white spaces
#4.      if the first string == SET then op3 = 0, else op3 = 1
#5.      
with open(filename, 'r') as f:
  for line in f:
    print(line)
    str_array = line.split()
    instruction = str_array[0]
    print(instruction)
    print(str_array)
    out1=""
    out2=""


    if instruction == "ld0":
      opcode = "0000"
    elif instruction == "mov":
      opcode = "0001"
    elif instruction == "lut":
      opcode = "0010"
    elif instruction == "ldr":
      opcode = "0011"
    elif instruction == "str":
      opcode = "0100"
    elif instruction == "add":
      opcode = "0101"
    elif instruction == "sub":
      opcode = "0110"
    elif instruction == "cmp":
      opcode = "0111"
    elif instruction == "and":
      opcode = "1000"
    elif instruction == "orr":
      opcode = "1001"
    elif instruction == "xor":
      opcode = "1010"
    elif instruction == "lsl":
      opcode = "1011"
    elif instruction == "rxr":
      opcode = "1100"
    elif instruction == "brn":
      opcode = "1101"
    elif instruction == "bge":
      opcode = "1110"
    elif instruction == "bne":
      opcode = "1111"

    # for instructions operationg on registers
    op1 = str_array[1]

    if ((instruction != "ld0") & (instruction != "brn") & (instruction != "bge") & (instruction != "bne")):
      if op1 == "r0":
        out1 = "000"
      elif op1 == "r1":
        out1 = "001"
      elif op1 == "r2":
        out1 = "010"
      elif op1 == "r3":
        out1 = "011"
      elif op1 == "r4":
        out1 = "100"
      elif op1 == "r5":
        out1 = "101"
      elif op1 == "r6":
        out1 = "110"
      elif op1 == "r7":
        out1 = "111"

      op2 = str_array[2]
      if op2 == "r0":
        out2 = "00"
      elif op2 == "r1":
        out2 = "01"
      elif op2 == "r2":
        out2 = "10"
      elif op2 == "r3":
        out2 = "11"
      output = opcode+out1+out2
    
    # instruction == ldo | brn | bge | bne
    # find immediate as binary value and concatnate with 0's to make it 5 bits
    else:
      out1 = bin(int(op1)).replace("0b","")
      length = len(str(out1))
      if length == 1:
        out1 = "0000"+out1
      elif length == 2:
        out1 = "000"+out1
      elif length == 3:
        out1 = "00"+out1
      elif length == 4:
        out1 = "0"+out1
      output = opcode+out1
  
    w_file.write(output + '\n' )
w_file.close()
