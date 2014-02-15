import 'binary.dart';

class Compiler
{
    String text;
    List lines;
    var clean_lines;
    var Errors;
    var binary_exe;
    var tags;
    var susccessful;
    int dir_data = -1;
    int dir_text = -1;

    var tipo_R = {
                  "add":"100000",
                  "addu":"100001",
                  "sub":"100010",
                  "subu":"100011",
                  "mult":"011000",
                  "multu":"011001",
                  "div":"011010",
                  "divu":"11011",
                  "mfhi":"010000",
                  "mflo":"010010",
                  "and":"100100",
                  "or":"100101",
                  "xor":"100110",
                  "nor":"100111",
                  "slt":"101010",
                  "sltu":"101011",
                  "sll":"000000",
                  "srl":"000010",
                  "sra":"000011",
                  "jr":"000100" 
    };
    var tipo_I = {
                  "addi":"001000",
                  "addiu":"001001",
                  "la":"", //Carga la direccion de memoria de una etiqueta
                  "lw":"100011",
                  "lh":"100101",
                  "lb":"",
                  "lbu":"",
                  "sw":"101011",//coincide con una de arriba
                  "sh":"",//almacena la primera parte de la palabra
                  "sb":"101000",
                  "lui":"001111",
                  "andi":"001100",
                  "ori":"001101",
                  "slti":"001010",
                  "beq":"000100",//4
                  "bne":"000101"
    };
    
    var tipo_J = {"j":"000010","jal":"000011"};

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
     
    
    Compiler(this.text)
    {
         lines = text.split('\n');
         Errors = new List<String>() ;
         binary_exe = new List<Binary>();
         tags = new Map();
         susccessful = true;
    }
    
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
    
    void delete_comentaries()
    {
         clean_lines = new List<String>();
         
         for(int i = 0; i < lines.length;i++)
         {
              lines[i] = lines[i].trim();
              
              if (lines[i].split('#')[0] != "")
              {
                   clean_lines.add(lines[i].split('#')[0]);
              } 
         }
    }
    
    void  split_data_and_text()
    {
         for(int i = 0; i < clean_lines.length;i++)
         {
              clean_lines[i] = clean_lines[i].toLowerCase();
              if(clean_lines[i].trim() == '.data')
              {
                   dir_data = i;
                   clean_lines.removeAt(i);
              }
              else if(clean_lines[i].trim() == '.text')
              {
                   dir_text = i;
                   clean_lines.removeAt(i);
              }
         }
         if (dir_text == -1)
         {
              Errors.add(".text not found");
              throw Errors;
         }
         if (dir_data > dir_text)
         {
              Errors.add(".data (" + dir_data.toString() + ")must be first to .text(" + dir_text.toString() + ")");
              throw Errors;
         }
         if(dir_data > 0  )
         {
              Errors.add(".data must be first of the document");
              throw Errors;
         }
    }
    
    int parse_tags(int ini,int end,int dsp)
    { 
         int deleted_lines = 0;
         for(int i = ini; i < clean_lines.length;i++)
         {
              if(clean_lines[i].trim().startsWith(':'))
              {
                   if(tags[clean_lines[i].trim().split(' ')[0].replaceAll(new RegExp(":"),'')] != null)
                   {
                        susccessful = false;
                        Errors.add("Error in Code line : " + i.toString() + " Repeited tag in line " + tags[clean_lines[i].split(' ')[0].replaceAll(new RegExp(":"),'')].toString());
                   }
                   else
                   {
                        tags[clean_lines[i].split(' ')[0].replaceAll(new RegExp(":"),'')] = i + dsp;
                        // delete inicial tags form code
                        clean_lines[i] = clean_lines[i].replaceAll(new RegExp(clean_lines[i].split(' ')[0]),'').trim();
                        if(clean_lines[i] == "")
                        {
                             clean_lines.removeAt(i);
                             deleted_lines--;
                        }
                   }
              }
         }
         return deleted_lines;
    }
    int parse_data()
    {
         if(dir_data == -1)
         {
              return 0;
         }
         for(int i = dir_data; i < dir_text;i++)
         {
              if (clean_lines[i].trim().split(" ")[0].endsWith(':'))
              {
                   if(tags[clean_lines[i].trim().split(' ')[0].replaceAll(new RegExp(":"),'')] != null)
                   {
                        susccessful = false;
                        Errors.add("Error in Code line : " + i.toString() + " Repeited tag in line " + tags[clean_lines[i].split(' ')[0].replaceAll(new RegExp(":"),'')].toString());
                   }
                   else
                   {
                        tags[clean_lines[i].trim().split(" ")[0].replaceAll(new RegExp(":"),'')] = binary_exe.length;
                        switch(clean_lines[i].split(" ")[1])
                        {
                             case ".utf16":
                                  var bin;
                                  for (int j = 0; j < clean_lines[i].split(" ")[2].length;j + 2)
                                  {
                                       if(j + 1 < clean_lines[i].split(" ")[2].length)
                                       {
                                            int halfword1 = clean_lines[i].split(" ")[2].codeUnitAt(j);
                                            int halfword2 = clean_lines[i].split(" ")[2].codeUnitAt(j+1) * 2^16;
                                            bin = new Binary(32);
                                            bin.from_num(halfword1+halfword2);
                                            binary_exe.add(bin);
                                       }
                                       else
                                       {
                                            int halfword1 = clean_lines[i].split(" ")[1].codeUnitAt(j);
                                            bin = new Binary(32);
                                            bin.from_num(halfword1);
                                            binary_exe.add(bin);
                                       }
                                       
                                  }
                                  break;
                             case ".utf16z":
                                  var bin;
                                  bool end_zero = false;
                                  for (int j = 0; j < clean_lines[i].split(" ")[2].length;j + 2)
                                  {
                                       if(j + 1 < clean_lines[i].split(" ")[2].length)
                                       {
                                            int halfword1 = clean_lines[i].split(" ")[2].codeUnitAt(j);
                                            int halfword2 = clean_lines[i].split(" ")[2].codeUnitAt(j+1) * 2^16;
                                            bin = new Binary(32);
                                            bin.from_num(halfword1+halfword2);
                                            binary_exe.add(bin);
                                       }
                                       else
                                       {
                                            int halfword1 = clean_lines[i].split(" ")[1].codeUnitAt(j);
                                            bin = new Binary(32);
                                            bin.from_num(halfword1);
                                            binary_exe.add(bin);
                                            end_zero = true;
                                       }   
                                  }
                                  if(!end_zero)
                                  {
                                       bin = new Binary(32);
                                       bin.from_num(0);
                                       binary_exe.add(bin);
                                  }
                                  break;
                             case ".byte":
                                  var bin;
                                  var byte = new List<Binary>();
                                  for (int j = 2; j < clean_lines[i].split(" ").length; j = j + 4)
                                  {
                                       for(int k = 0; k < 4; k++)
                                       {
                                            if(j + k < clean_lines[i].split(" ").length)
                                            {
                                                  byte.add(new Binary(32).from_num(int.parse(clean_lines[i].split(" ")[j+k])));
                                            }
                                            else
                                            {
                                                 byte.add(new Binary(32).from_num(0));
                                            }
                                       }
                                            
                                            bin = (byte[0] << 24) | (byte[1] << 16) | (byte[2] << 8) | byte[3];
                                            binary_exe.add(bin);
                                            byte.clear();
                                  }
                                  
                                  break;
                             case ".halfword":
                                  var bin;
                                  for (int j = 2; j < clean_lines[i].split(" ").length; j = j + 2)
                                  {
                                       if(j + 1 < clean_lines[i].split(" ").length)
                                       {
                                            var halfword1 = new Binary(32).from_num(int.parse(clean_lines[i].split(" ")[j]));
                                            var halfword2 = new Binary(32).from_num(int.parse(clean_lines[i].split(" ")[j+1]));
                                            
                                            bin = (halfword1 << 16) | halfword2;
                                            binary_exe.add(bin);
                                       }
                                       else
                                       {
                                            bin = new Binary(32).from_num(int.parse(clean_lines[i].split(" ")[j]));
                                            binary_exe.add(bin);
                                       }   
                                  }
                                  break;
                             case ".word":
                                  var bin;
                                  for (int j = 2; j < clean_lines[i].split(" ").length;j ++)
                                  {
                                            int word = int.parse(clean_lines[i].split(" ")[j]);
                                            bin = new Binary(32);
                                            bin.from_num(word);
                                            binary_exe.add(bin);
                                  }
                                  break;
                             case ".space":
                                  var bin;
                                  for (int j = 1; j < int.parse(clean_lines[i].split(" ")[2])/4;j ++)
                                  {
                                            bin = new Binary(32);
                                            bin.from_num(0);
                                            binary_exe.add(bin);
                                  }
                                  if(int.parse(clean_lines[i].split(" ")[2]) % 4 != 0)
                                  {
                                       bin = new Binary(32);
                                       bin.from_num(0);
                                       binary_exe.add(bin);
                                  }
                                  
                                  break;
                             default:
                                  susccessful = false;
                                  Errors.add("Error in Code line : " + i.toString() + "not a data type" + clean_lines[i].split(" ")[1]);
                                  break;
                        }
                   }
              }
              else
              {
                   susccessful = false;
                   Errors.add("Error in Code line : " + i.toString() + "not a valid label" + clean_lines[i].trim().split(" ")[1]);
              }
         }
         return binary_exe.length;
    }
    void parse_text()
    {
         for(int i = dir_text; i < clean_lines.length;i++)
         {
              var line = clean_lines[i].split(' ');
              if (tipo_R[line[0]] != null)
              {
                   var params = line[1].split(",");
                   if(params.length != 3)
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " Invalid number of registers " + clean_lines[i]);
                   }
                   else if(regs[params[2].trim()] == null ||
                             regs[params[1].trim()] == null ||
                             regs[params[0].trim()] == null)
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " Register not valid " + clean_lines[i]);
                   }
                   else
                   {          
                        var instruction = new Binary(32);
                        
                        instruction.fromString("000000" + regs[params[2].trim()] + 
                                  regs[params[1].trim()] + 
                                  regs[params[0].trim()] + 
                                  tipo_R[line[0]]);
                        binary_exe.add(instruction);
                   }
              }
              else if (tipo_I[line[0]] != null)
              {
                   var params = line[1].split(",");
                   if(params.length != 3)
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " Invalid number of parameters " + clean_lines[i]);
                   } 
                   else if(regs[params[0].trim()] == null ||
                             regs[params[1].trim()] == null )
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " Register not valid " + clean_lines[i]);
                   }
                   else if(!isInt(params[2].trim()) && tags[params[2].trim()] == null)
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " Tag not valid " + clean_lines[i]);
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
                        binary_exe.add(instruction);
                   }
              }
              else if (tipo_J[line[0]] != null)
              {
                   if(line.length != 2)
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " Invalid number of parameters " + clean_lines[i]);
                   } 
                   else if(!isInt(line[1]) && tags[line[1].trim()] == null)
                   {
                        susccessful = false;
                        Errors.add ("Error in Code line : " + i.toString() + " inmediate not valid " + clean_lines[i]);
                   }
                   else
                   { 
                        if(isInt(line[1].trim()))
                        {
                             var instruction = new Binary(32);
                             var inm = new Binary(26);
                             inm.from_num(int.parse(line[1]));
                             instruction.fromString(tipo_J[line[0]] + inm.toStringfill());
                             binary_exe.add(instruction);
                        }
                        else
                        {
                             var instruction = new Binary(32);
                             var inm = new Binary(26);
                             inm.from_num(tags[line[1]]);
                             instruction.fromString(tipo_J[line[0]] + inm.toStringfill());
                             binary_exe.add(instruction);
                        }
                   }
              }
              else
              {
                   susccessful = false;
                   Errors.add ("Error in Code line : " + i.toString() + " not a instruction " + clean_lines[i]);
              }
         }
    }
    List compile()
    {
      delete_comentaries();
      
      split_data_and_text();
      
      parse_data();
      
      int dir_text_bin = binary_exe.length;
      
      int desplazamiento_tag = binary_exe.length - dir_text;
      
      parse_tags(dir_text, clean_lines.length,desplazamiento_tag);
      
      parse_text();
      
      binary_exe.add(new Binary(32).from_num(dir_text_bin));

      if(susccessful)
      {
           return binary_exe;
      }
      else
      {
           throw Errors;
      }
    }
}