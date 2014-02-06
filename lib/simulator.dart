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

