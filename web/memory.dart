/*
 * Class of memory of the machine regs and main memory 
 * Autor : Sergio Medina Toledo
 * Email : lumasepa@gmail.com
 * License : GNU GPLv2 https://www.gnu.org/licenses/old-licenses/gpl-2.0.html
 */

/**
 * A representation of the register bank of the machine
 */
class RegBank
{
  List register;
  int sz;
  
  /** Contructor that Set the register bank size static
   *  sz_reg : number of registers
   */
  RegBank(num sz_reg)
  {
    this.sz = sz_reg;
    this.register = new List(this.sz);
  }
  
  /** Method to get a word from the register bank
   *  reg : register id
   */
  num getreg(int reg) => register[reg];
  
  /** Method to save a word in the register bank
   *  reg : register id
   *  value : word to save
   */ 
  num setreg(int reg, num value) => register[reg] = value;
  
}
/**
 * A representation of the memory of the machine
 */
class Memory
{
  List memory;
  int sz;
  
  /** Contructor that Set the memory size static
   *  sz_mem : size of the memory
   */
  Memory(int sz_mem)
  {
    this.sz = sz_mem;
    this.memory = new List(this.sz);
  }
  /** Method to get a word from the memory
   *  dir : memory direction
   */
  num getmem(int dir) => memory[dir];
  
  /** Method to save a word in the memory
   *  dir : memory direction
   *  value : word to save
   */ 
  num setmem(int dir, num value) => memory[dir] = value;
  
}
