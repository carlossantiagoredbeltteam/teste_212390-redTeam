// LMfunc.java
// Modified by Reece Arnott 22nd December 2009 to take out grad method which is now included as a private method in the LM class.
// Also val now returns an x,y point rather than a single number


package ZS.Solve;

import org.reprap.scanning.Geometry.Point2d;

/**
 * Caller implement this interface to specify the
 * function to be minimized and its gradient.
 * 
 * Optionally return an initial guess and some test data,
 * though the LM.java only uses this in its optional main() test program.
 * Return null if these are not needed.
 */
public interface LMfunc
{

  /**
   * x is a single point, but domain may be mulidimensional
   */
  //double val(double[] x, double[] a);
  Point2d val(double[] x, double[] a);

  
  /***
   * Adjust does any post adjustments to the y point using the parameters 
   * For example polynomial radial distortion estimation is based on the distance between y and the image centre and is not easily expressible in terms of x (real world point to be transformed to image coordinates)
   * So to compare apples to apples you use the adjust method to undo the radial distortion of an image and use the ordinary solve to transform a world point to an undistorted image point.
   * 
   * Note that this does not apply when talking about an invertible distortion matrix as it can be inverted and applied to the x vector
   * 
   * If there are no adjustments to do just return y
   */
  Point2d adjust(Point2d y, double[] a);
  
  
  /**
   * return the kth component of the gradient df(x,a)/da_k
   *
   * This has been taken out and replaced with a private method within LM take gives a generic partial derivative 
   */
  //double grad(double[] x, double[] a, int ak);
  /**
   * return initial guess at a[]
   */
  double[] initial();

  /**
   * return an array[4] of x,a,y,s for a test case;
   * a is the desired final answer.
   */
  Object[] testdata();

} //LMfunc

