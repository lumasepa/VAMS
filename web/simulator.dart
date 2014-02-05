import 'dart:core';
import 'binary.dart';
import 'memory.dart';

class ALU
{
  bool flag = true;
  bool overflow = false;
  
  void operate(var sr1, var sr2, var dst, var op)
  {
    switch(op)
    {
      case 'XOR':
        dst = sr1 ^ sr2;
      break;
      /* .
       * .
       * .
       * .
       */
    }
  }
}


class UC
{
     Binary exec(Binary instruction)
     {
     
     }
}

class Machine
{
     Binary PC;
     UC uc;
     ALU alu;
     RegBank regbank;
     Memory memory;
     Machine(){}
     void init(){}
     void start(){}
}

class Loader
{
    String text;
    var tipo_R = {"SLL":"00000000","SRL":"00000010","SRA":"00000011", "SRLV":"00000110", "SRAV":"00000111",
                  "ADD":"00100000", "SLLV":"01000000","ADDU":"00100001", "SUB":"00100001","SUBU":"00100011",
                  "AND":"00100100","OR":"00100101", "XOR":"00100110","NOR":"00100111", "SLT":"00101010",
                  "SLTU":"00101011","JR":"00001000"};
    
    var tipo_I = {"LB":"100000","LH":"100001","LW":"100011", "LWU":"100111", "LBU":"100100",
                  "LHU":"100101", "SB":"101000","SH":"101001", "SW":"101011","ADDI":"001000",
                  "ADDIU":"001001","ANDI":"001100", "ORI":"001101","XORI":"001110",
                  "LUI":"001111","SLTI":"001010","SLTIU":"001011", "BEQ":"000100",
                  "BNE":"000101"};
    
    var tipo_J = {"J":"000010","JAL":"000011"};

    var regs = {"\$zero":"00000","\$at":"00001","\$v0":"00010","\$v1":"00011",
                "\$a0":"00100","\$a1":"00101","\$a2":"00110","\$a3":"00111",
                "\$t0":"01000","\$t1":"01001","\$t2":"01010","\$t3":"01011","\$t4":"01100","\$t5":"01101","\$t6":"01110","\$t7":"01111",
                "\$s0":"10000","\$s1":"10001","\$s2":"10010","\$s3":"10011","\$s4":"10100","\$s5":"10101","\$s6":"10110","\$s7":"10111",
                "\$t8":"11000","\$t9":"11001",
                "\$k0":"11010","\$k1":"11011",
                "\$gp":"11100",
                "\$sp":"11101",
                "\$fp":"11110",
                "\$ra":"11111"};
     
    
    Loader(this.text);
    
    bool isInt(String number)
    {
         for(int i = number.length -1; i >= 0; i--)
         {
              switch(number[i])
              {
                   case '0':
                   case '1':
                   case '2':
                   case '3':
                   case '4':
                   case '5':
                   case '6':
                   case '7':
                   case '8':
                   case '9':
                   break;
                   default :
                        return false;
                   break;
              }
         }
         return true;
    }
    
    List parse()
    {
      
      List<Binary> intructions;
      List lines = text.split('\n');
      var clean_lines = new List<String>();

      for(int i = 0; i < lines.length;i++)
      {
        lines[i] = lines[i].trim();
        
        // Delete commentaries 
        if (lines[i].split('#')[0] != "")
        {
          clean_lines.add(lines[i].split('#')[0]);
        }
      }
      // Chech for tag
      var tags = new Map();
      
      for(int i = 0; i < clean_lines.length;i++)
      {
        if(clean_lines[i].startsWith(':'))
        {
             if(tags[clean_lines[i].split(' ')[0].replaceAll(new RegExp(":"),'')] != null)
             {
                  print("Error in Code line : " + i.toString() + " Repeited tag in line " + tags[clean_lines[i].split(' ')[0].replaceAll(new RegExp(":"),'')].toString());
             }
             else
             {
                    tags[clean_lines[i].split(' ')[0].replaceAll(new RegExp(":"),'')] = i;
                    // delete inicial tags form code
                    clean_lines[i] = clean_lines[i].replaceAll(new RegExp(clean_lines[i].split(' ')[0]),'').trim();
             }
        }
      }
      
      List bin_instructions = new List<Binary>();
      
      for(int i = 0; i < clean_lines.length;i++)
      {
        var line = clean_lines[i].split(' ');
        if (tipo_R[line[0]] != null)
        {
          var params = line[1].split(",");
          if(params.length != 3)
          {
            print ("Error in Code line : " + i.toString() + " Invalid number of registers " + clean_lines[i]);
          }
          else if(regs[params[2].trim()] == null ||
             regs[params[1].trim()] == null ||
             regs[params[0].trim()] == null)
          {
            print ("Error in Code line : " + i.toString() + " Register not valid " + clean_lines[i]);
          }
          else
          {          
               var instruction = new Binary(32);
               
               instruction.fromString("000000" + regs[params[2].trim()] + 
                                                 regs[params[1].trim()] + 
                                                 regs[params[0].trim()] + 
                                                 tipo_R[line[0]]);
               print(instruction.toStringfill());
          }
        }
        else if (tipo_I[line[0]] != null)
        {
          var params = line[1].split(",");
          if(params.length != 3)
          {
            print ("Error in Code line : " + i.toString() + " Invalid number of parameters " + clean_lines[i]);
          } 
          else if(regs[params[0].trim()] == null ||
             regs[params[1].trim()] == null )
          {
            print ("Error in Code line : " + i.toString() + " Register not valid " + clean_lines[i]);
          }
          else if(!isInt(params[2].trim()) && tags[params[2].trim()] == null)
          {
               print ("Error in Code line : " + i.toString() + " Tag not valid " + clean_lines[i]);
          }
          else
          {
               var instruction = new Binary(32);
               if(!isInt(params[2].trim()))
               {
                    var tag = new Binary(16);
                    tag.from_num(tags[params[2].trim()]);
                    instruction.fromString(tipo_I[line[0]] +
                              regs[params[1].trim()] +
                              regs[params[0].trim()] +
                              tag.toStringfill());
               }
               else
               {
                    var inm = new Binary(16);
                    inm.from_num(int.parse(params[2].trim()));
                              instruction.fromString(tipo_I[line[0]] +
                              regs[params[1].trim()] +
                              regs[params[0].trim()] +
                              inm.toStringfill());
               }
               print(instruction.toStringfill());
          }
        }
        else if (tipo_J[line[0]] != null)
        {
             if(line.length != 2)
             {
                  print ("Error in Code line : " + i.toString() + " Invalid number of parameters " + clean_lines[i]);
             } 
             else if(!isInt(line[1]))
             {
                  print ("Error in Code line : " + i.toString() + " inmediate not valid " + clean_lines[i]);
             }
             else
             { 
                  var instruction = new Binary(32);
                  var inm = new Binary(26);
                  inm.from_num(int.parse(line[1]));
                  instruction.fromString(tipo_J[line[0]] + inm.toStringfill());
                  print(instruction.toStringfill());
             }
        }
        else
        {
          print ("Error in Code line : " + i.toString() + " not a intruction " + clean_lines[i]);
        }
        
          
      }
      
    }
}