package org.reprap.pcb;

//import Cords;

public class Coords {
	public double x,y;
	
	public Coords(double x, double y)
	{
		this.x = x;
		this.y = y;
	}
	
	
	public boolean equals(Coords b)
	{
		
		if(Double.compare(x, b.x) == 0 && Double.compare(y, b.y) == 0)
			return true;
		
		return false;
		
	}
	
	
	public void add(Coords b)
	{
		x += b.x;
		y += b.y;
	}
	
	public void sub(Coords b)
	{
		x -= b.x;
		y -= b.y;
	}
	
	public Coords mul(double f)
	{
		x = x*f;
		y = y*f;
		
		return this;
	}
	
	public double length()
	{
		return Math.sqrt(x*x + y*y);
	}
	
	public double distance(Coords ob)
	{
		Coords b = ob.clone();
		b.sub(this);
		
		return b.length();				
	}
	
	public Coords orthogonalNormal()
	{
		Coords b = clone();
		double l = length();
		double tmp;
		tmp = b.x/l;
		b.x = -b.y/l;
		b.y = tmp;
		return b;
	}
	
	public Coords clone()
	{
		return new Coords(x,y);
	}
}
