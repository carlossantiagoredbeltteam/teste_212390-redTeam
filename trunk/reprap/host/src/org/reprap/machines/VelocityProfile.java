package org.reprap.machines;

/**
 * Small class to compute the optimum velocity profile given a starting and an ending 
 * velocity, a maximum velocity that cannot be exceeded, and an acceleration.
 * 
 * The result is either a single maximum velocity, v, inbetween the ends (in which case flat will be false), or
 * an acceleration to maxSpeed at s1 from the start, movement at that velocity to s2, then deceleration to the end.
 * @author Adrian
 *
 */

public class VelocityProfile 
{
	private double v, s1, s2;
	private int flat;
	
	public VelocityProfile(double s, double vStart, double maxSpeed, double vEnd, double acceleration)
	{
		if(maxSpeed <= vStart && maxSpeed <= vEnd)
		{
			flat = 0;
			return;
		}
		
		s1 = (2*acceleration*s - vStart*vStart + vEnd*vEnd)/(4*acceleration);
		v = Math.sqrt(2*acceleration*s1 + vStart*vStart);
		double f = s1/s;
		if(f < 0 || f > 1)
		{
			System.err.println("VelocityProfile - sm/s: " + f);
		} 
		if(v <= maxSpeed)
			flat = 1;
		else
		{
			//s2 = s1 + 0.5*(v*v - vEnd*vEnd)/acceleration;
			s2 = s - 0.5*(maxSpeed*maxSpeed - vEnd*vEnd)/acceleration;
			f = s2/s;
			if(f < 0 || f > 1)
			{
				System.err.println("VelocityProfile - s2/s: " + f);
			}
			s1 = 0.5*(maxSpeed*maxSpeed - vStart*vStart)/acceleration;
			f = s1/s;
			if(f < 0 || f > 1)
			{
				System.err.println("VelocityProfile - s1/s: " + f);
			}
			flat = 2;
		}
	}

	public double v() { return v; }
	public double s1() { return s1; }
	public double s2() { return s2; }
	public int flat() { return flat; }
}
