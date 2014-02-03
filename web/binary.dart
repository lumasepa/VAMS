/***
 * A library with data model to work with binary numbers
 */


import 'dart:math' as math;
import 'dart:core';


class Binary
{
	int value;
	int length;
	
	Binary (int sz)
	{
		if (sz <= 0)
		{
			throw new ExpectException("Length of the binary can't be less than 1");
		}
		this.length = sz;
	}
	
	Binary.fromint(int number,int sz)
	{
		if (sz <= 0)
		{
			throw new ExpectException("Length of the binary can't be less than 1");
		}
		this.length = sz;
		this.from_num(number);
	}
	  
	Binary from_num (int number)
	{
		if (number.bitLength > this.length)
		{
			throw new ExpectException("Number greater than " + this.length.toString() + " bits");
		}
		this.value = number;
		return this;  
	}
	  
	num to_num() => this.value;
	  
	Hex toHex()
	{
		Hex r;
		r.value = this.value;
		return r;
	}
	
	Binary fromHex(Hex x)
	{
		if (x.value.bitLength > this.length)
		{
			throw new ExpectException("Number greater than " + this.length.toString() + " bits");
		}
		this.value = x.value;
		return this;
	}
	
	String toString()
	{
		int p = value;
		String r = "";
		while(p > 0)
		{
			if(p % 2 == 1)
			{
				r = 1.toString() + r;
			}
			else
			{
				r = 0.toString() + r;
			}
			p = p ~/ 2;
		}
		return r;
	}

	String toStringfill()
	{
		int p = value;
		String r = "";
		while(p > 0)
		{
			if(p % 2 == 1)
			{
				r = 1.toString() + r;
			}
			else
			{
				r = 0.toString() + r;
			}
			p = p ~/ 2;
		}
		
		while(r.length < this.length)
		{
			r = 0.toString() + r;
		}
		
		return r;
	}
	
	Binary fromString(String s)
	{
		if (s.length > this.length)
		{
			throw new ExpectException("Number greater than " + this.length.toString() + " bits");
		}
		
		int p = 0;
		for(int i = 0; i < s.length; i++)
		{
			if(s[i] == '1')
			{
				p = p + math.pow(2, s.length-i-1);
			}
			else if(s[i] != '0')
			{
				throw new ExpectException("String not a binary chain");
			}
		}
		value = p;
		return this;
	}
	Binary operator+ (Binary x)
	{
		Binary r = new Binary.fromint(this.value + x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator- (Binary x)
	{
		Binary r = new Binary.fromint(this.value + x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator* (Binary x)
	{
		Binary r = new Binary.fromint(this.value * x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator~/ (Binary x)
	{
		Binary r = new Binary.fromint(this.value ~/ x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator% (Binary x)
	{
		Binary r = new Binary.fromint(this.value % x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator& (Binary x)
	{
		Binary r = new Binary.fromint(this.value & x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator^ (Binary x)
	{
		Binary r = new Binary.fromint(this.value ^ x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator| (Binary x)
	{
		Binary r = new Binary.fromint(this.value | x.value,  x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Binary operator<< (num x)
	{
		Binary r = new Binary.fromint(this.value << x,this.length);
		return r;
	}
	
	Binary operator>> (num x)
	{
		Binary r = new Binary.fromint(this.value >> x,this.length);
		return r;
	}
	
	bool operator== (Binary x) => this.value == x.value;
	
	bool operator<= (Binary x) => this.value <= x.value;
	
	bool operator>= (Binary x) => this.value >= x.value;
	
	bool operator< (Binary x) => this.value < x.value;

	bool operator> (Binary x) => this.value > x.value;

	Binary operator~ ()
	{
		Binary r = new Binary.fromint(~this.value,this.length);
		return r;
	}
}

class Hex
{
	int value;
	int length;
	
	Hex (int sz)
	{
		if (sz <= 0)
		{
			throw new ExpectException("Length of the Hex can't be less than 1");
		}
		this.length = sz;
	}
	
	Hex.fromint(int number,int sz)
	{
		if (sz <= 0)
		{
			throw new ExpectException("Length of the Hex can't be less than 1");
		}
		this.length = sz;
		this.from_num(number);
	}
	  
	Hex from_num (int number)
	{
		if (number.bitLength > this.length)
		{
			throw new ExpectException("Number greater than " + this.length.toString() + " bits");
		}
		this.value = number;
		return this;  
	}
	  
	num to_num() => this.value;
	  
	Binary toBinary()
	{
		Binary r;
		r.value = this.value;
		return r;
	}
	
	Hex fromBinary(Binary x)
	{
		if (x.value.bitLength > this.length)
		{
			throw new ExpectException("Number greater than " + this.length.toString() + " bits");
		}
		this.value = x.value;
		return this;
	}
	
	String toString()
	{
		int p = value;
		String r = "";
		while(p > 0)
		{
			int resto = p % 16;
			if(resto < 10)
			{
				r = resto.toString() + r;
			}
			else
			{
				switch(resto)
				{
					case 10:
						r = 'A' + r;
					break;
					case 11:
						r = 'B' + r;
					break;
					case 12:
						r = 'C' + r;
					break;
					case 13:
						r = 'D' + r;
					break;
					case 14:
						r = 'E' + r;
					break;
					case 15:
						r = 'F' + r;
					break;
				}
			}
			p = p ~/ 16;
		}
		return r;
	}

	String toStringfill()
	{
		
		String r = this.toString();
		
		while(r.length < this.length~/4)
		{
			r = 0.toString() + r;
		}
		return r;
	}
	
	Hex fromString(String s)
	{
		if(s.length * 4 > this.length)
		{
			throw new ExpectException("Number greater than " + this.length.toString() + " bits");
		}
		String S_bin = "";
		for(int i = s.length -1; i >= 0; i--)
		{
			switch(s[i])
			{
				case '0':
					S_bin = "0000" + S_bin;
				break;
				case '1':
					S_bin = "0001" + S_bin;
				break;
				case '2':
					S_bin = "0010" + S_bin;
				break;
				case '3':
					S_bin = "0011" + S_bin;
				break;
				case '4':
					S_bin = "0100" + S_bin;
				break;
				case '5':
					S_bin = "0101" + S_bin;
				break;
				case '6':
					S_bin = "0110" + S_bin;
				break;
				case '7':
					S_bin = "0111" + S_bin;
				break;
				case '8':
					S_bin = "1000" + S_bin;
				break;
				case '9':
					S_bin = "1001" + S_bin;
				break;
				case 'A':
				case 'a':
					S_bin = "1010" + S_bin;
				break;
				case 'B':
				case 'b':
					S_bin = "1011" + S_bin;
				break;
				case 'C':
				case 'c':
					S_bin = "1100" + S_bin;
				break;
				case 'D':
				case 'd':
					S_bin = "1101" + S_bin;
				break;
				case 'E':
				case 'e':
					S_bin = "1110" + S_bin;
				break;
				case 'F':
				case 'f':
					S_bin = "1111" + S_bin;
				break;
			}
		}
		Binary b = new Binary(this.length);
		b.fromString(S_bin);
		this.value = b.value;
		return this;
	}
	Hex operator+ (Hex x)
	{
		Hex r = new Hex.fromint(this.value + x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator- (Hex x)
	{
		Hex r = new Hex.fromint(this.value + x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator* (Hex x)
	{
		Hex r = new Hex.fromint(this.value * x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator~/ (Hex x)
	{
		Hex r = new Hex.fromint(this.value ~/ x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator% (Hex x)
	{
		Hex r = new Hex.fromint(this.value % x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator& (Hex x)
	{
		Hex r = new Hex.fromint(this.value & x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator^ (Hex x)
	{
		Hex r = new Hex.fromint(this.value ^ x.value, x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator| (Hex x)
	{
		Hex r = new Hex.fromint(this.value | x.value,  x.length < this.length ? this.length : x.length);
		return r;
	}
	
	Hex operator<< (num x)
	{
		Hex r = new Hex.fromint(this.value << x,this.length);
		return r;
	}
	
	Hex operator>> (num x)
	{
		Hex r = new Hex.fromint(this.value >> x,this.length);
		return r;
	}
	
	bool operator== (Hex x) => this.value == x.value;
	
	bool operator<= (Hex x) => this.value <= x.value;
	
	bool operator>= (Hex x) => this.value >= x.value;
	
	bool operator< (Hex x) => this.value < x.value;

	bool operator> (Hex x) => this.value > x.value;

	Hex operator~ ()
	{
		Hex r = new Hex.fromint(~this.value,this.length);
		return r;
	}
}