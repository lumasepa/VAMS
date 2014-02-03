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
    var tipo_R = {"SLL":0x00,"SRL":0x02,"SRA":0x03, "SRLV":0x06, "SRAV":0x07,
                  "ADD":0x20, "SLLV":0x40,"ADDU":0x21, "SUB":0x22,"SUBU":0x23,
                  "AND":0x24,"OR":0x25, "XOR":0x26,"NOR":0x27, "SLT":0x2A,"SLTU":0x2B};
    
    var tipo_I = {"LB":0x20,"LH":0x21,"LW":0x23, "LWU":0x27, "LBU":0x24,
                  "LHU":0x25, "SB":0xA8,"SH":0x29, "SW":0x2B,"ADDI":0x08,
                  "ADDIU":0x09,"ANDI":0x0C, "ORI":0x0D,"XORI":0x0E,
                  "LUI":0x0F,"SLTI":0x0A,"SLTIU":0x0B, "BEQ":0x04,
                  "BNE":0x05,"J":0x02, "JAL":0x03};
    
    var tipo_J = {"JR":0x08, "JALR":0x09};
     
    
    Loader(this.text);
    
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
          tags[clean_lines[i].split(' ')[0]] = i;
          // delete tags form code
          clean_lines[i] = clean_lines[i].replaceAll(new RegExp(clean_lines[i].split(' ')[0]),'').trim();
        }
      }
      
      List bin_instructions = new List<Binary>();
      
      for(int i = 0; i < clean_lines.length;i++)
      {
        if (tipo_R[clean_lines[i].split(' ')[0]] != null)
        {
          print ("tipo R " + clean_lines[i].split(' ')[0]);
        }
        else if (tipo_I[clean_lines[i].split(' ')[0]] != null)
        {
          print ("tipo I " + clean_lines[i].split(' ')[0]);
        }
        else if (tipo_J[clean_lines[i].split(' ')[0]] != null)
        {
          print ("tipo J " + clean_lines[i].split(' ')[0]);
        }
        else
        {
          //throw new ExpectException("Error in Code line : " + i.toString() + " not a intruction " + clean_lines[i].split(' ')[0]);
          print ("Error in Code line : " + i.toString() + " not a intruction " + clean_lines[i].split(' ')[0]);
        }
          
      }
      
       
      
    }
}