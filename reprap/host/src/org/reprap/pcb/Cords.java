package org.reprap.pcb;

//import Cords;

public class Cords {
	public float x,y;
	boolean inInch=false;
	
	public Cords(float x, float y, boolean inch)
	{
		this.x = x;
		this.y = y;
		
		if(inch)
		{
			this.inInch = true;
			inchToMM();
		}
	}
	
	private void inchToMM()
	{
		if(inInch)
		{

			x = x*25.4f;
			y = y*25.4f;
			
			inInch=false;
		}
			//System.out.println(num+" INCH in MM "+mm);
	}
	
	public boolean equals(Cords b)
	{
		
		if(Float.compare(x, b.x) == 0 && Float.compare(y, b.y) == 0)
			return true;
		
		return false;
		
	}
	
	
	public void add(Cords b)
	{
		x += b.x;
		y += b.y;
	}
	
	public void sub(Cords b)
	{
		x -= b.x;
		y -= b.y;
	}
	
	public Cords mul(float f)
	{
		x = x*f;
		y = y*f;
		
		return this;
	}
	
	public float length()
	{
		return (float) Math.sqrt(Math.pow(x, 2)+Math.pow(y, 2));
	}
	
	public float distance(Cords ob)
	{
		Cords b = ob.clone();
		b.sub(this);
		
		return b.length();				
	}
	
	public Cords clone()
	{
		return new Cords(x,y, false);
	}
}
