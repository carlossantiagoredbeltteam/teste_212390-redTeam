// levenberg-marquardt in java downloaded from http://scribblethink.org/Computer/Javanumeric/index.html 17th December 2009
//
// To use this, implement the functions in the LMfunc interface.
//
// This library uses simple matrix routines from the JAMA java matrix package,
// which is in the public domain.  Reference:
//    http://math.nist.gov/javanumerics/jama/
// (JAMA has a matrix object class.  An earlier library JNL, which is no longer
// available, represented matrices as low-level arrays.  Several years 
// ago the performance of JNL matrix code was better than that of JAMA,
// though improvements in java compilers may have fixed this by now.)
//
// One further recommendation would be to use an inverse based
// on Choleski decomposition, which is easy to implement and
// suitable for the symmetric inverse required here.  There is a choleski
// routine at idiom.com/~zilla.
//
// If you make an improved version, please consider adding your
// name to it ("modified by ...") and send it back to me
// (and put it on the web).
//
// ----------------------------------------------------------------
// 
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library General Public
// License as published by the Free Software Foundation; either
// version 3 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Library General Public License for more details.
// 
// You should have received a copy of the GNU Library General Public
// License along with this library; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place - Suite 330,
// Boston, MA  02111-1307, USA.
//
// initial author contact info:  
// jplewis  www.idiom.com/~zilla  zilla # computer.org,   #=at
//
// Improvements by:
// dscherba  www.ncsa.uiuc.edu/~dscherba  
// Jonathan Jackson   j.jackson # ucl.ac.uk

// Modifications by Reece Arnott
// Modified 19th December 2009 to compare geometric distance of 2d points and to use generic gradient estimation method rather than a purpose built one for each error minimisation problem
// rather than square of distance between scalar numbers. The old lines of code are commented out but left in place 
// Modified 22nd December 2009 to also adjust parameters that are applied to the final y coordinates i.e.  Minimize E = sum {(f(y[k],b) - f(x[k],a)) / s[k]}^2
// Modified 24th January 2010 to have verbosity=0 gives some feedback and negative numbers gives no feedback 
// Modified 21st May 2010 to use pseudo-inverse of Hessian if Hessian is non-invertible/singular if requested not to throw a singular matrix exception using the boolean throwexceptionwhensingular passed in to the solve method
// Modified 25th May 2010 to update a JProgressBar 


package ZS.Solve;

// see comment above
import Jama.*;

import org.reprap.scanning.DataStructures.MatrixManipulations;
import org.reprap.scanning.Geometry.Point2d;

import javax.swing.JProgressBar;

/**
 * Levenberg-Marquardt, implemented from the general description
 * in Numerical Recipes (NR), then tweaked slightly to mostly
 * match the results of their code.
 * Use for nonlinear least squares assuming Gaussian errors.
 *
 * TODO this holds some parameters fixed by simply not updating them.
 * this may be ok if the number if fixed parameters is small,
 * but if the number of varying parameters is larger it would
 * be more efficient to make a smaller hessian involving only
 * the variables.
 *
 *TODO Currently using Point2d for y and gradient return.
 *This could be extended to generic nx1 vector rather easily and mxn Matrices without too much effort
 *
 * The NR code assumes a statistical context, e.g. returns
 * covariance of parameter errors; we do not do this.
 */
public final class LM
{

  /**
   * calculate the current sum-squared-error
   * (Chi-squared is the distribution of squared Gaussian errors,
   * thus the name)
   */
  //static double chiSquared(double[][] x, double[] a, double[] y, double[] s, 
  //		   LMfunc f)
  static double chiSquared(double[][] x, double[] a, Point2d[] y, double[] s, 
		   LMfunc f)
{
    int npts = y.length;
    double sum = 0.;
    for( int i = 0; i < npts; i++ ) {
    	Point2d error=f.adjust(y[i],a);
    	error.minus(f.val(x[i], a));
    	error.scale(1/s[i]);
    	sum=sum +error.lengthSquared();
    	//double d = y[i] - f.val(x[i], a);
    	//d = d / s[i];
    	//sum = sum + (d*d);
    	
    }

    return sum;
  } //chiSquared


  /**
   * Minimize E = sum {(y[k] - f(x[k],a)) / s[k]}^2
   * The individual errors are optionally scaled by s[k].
   * Note that LMfunc implements the value and gradient of f(x,a),
   * NOT the value and gradient of E with respect to a!
   * 
   * @param x array of domain points, each may be multidimensional
   * @param y corresponding array of values
   * @param a the parameters/state of the model
   * @param vary false to indicate the corresponding a[k] is to be held fixed
   * @param s2 sigma^2 for point i
   * @param lambda blend between steepest descent (lambda high) and
   *	jump to bottom of quadratic (lambda zero).
   * 	Start with 0.001.
   * @param termepsilon termination accuracy (0.01)
   * @param maxiter	stop and return after this many iterations if not done
   * @param verbose	set to negative (no prints), 0, 1, 2
   *
   * @return the new lambda for future iterations.
   *  Can use this and maxiter to interleave the LM descent with some other
   *  task, setting maxiter to something small.
   */
 // public static double solve(double[][] x, double[] a, double[] y, double[] s,
//		     boolean[] vary, LMfunc f,
//		     double lambda, double termepsilon, int maxiter,
//		     int verbose)
  public static double solve(double[][] x, double[] a, Point2d[] y, double[] s,
		     boolean[] vary, LMfunc f,
		     double lambda, double termepsilon, int maxiter,
		     int verbose, boolean throwexceptionwhensingular)
throws Exception
{
	  JProgressBar bar=new JProgressBar();
	  bar.setMinimum(0);
	  bar.setValue(0);
	  bar.setMaximum(maxiter);
	  return solve(x, a, y,s, vary,f,lambda,termepsilon,maxiter,verbose,throwexceptionwhensingular,bar);
	  }

  public static double solve(double[][] x, double[] a, Point2d[] y, double[] s,
		     boolean[] vary, LMfunc f,
		     double lambda, double termepsilon, int maxiter,
		     int verbose, boolean throwexceptionwhensingular, JProgressBar bar)
throws Exception
{
int npts = y.length;
int nparm = a.length;
assert s.length == npts;
assert x.length == npts;
if (verbose > 0) {
System.out.print("solve x["+x.length+"]["+x[0].length+"]" );
System.out.print(" a["+a.length+"]");
System.out.println(" y["+y.length+"]");
}

double e0 = chiSquared(x, a, y, s, f);
//double lambda = 0.001;
boolean done = false;

// g = gradient, H = hessian, d = step to minimum
// H d = -g, solve for d
double[][] H = new double[nparm][nparm];
double[] g = new double[nparm];
//double[] d = new double[nparm];

double[] oos2 = new double[s.length];
for( int i = 0; i < npts; i++ )  oos2[i] = 1./(s[i]*s[i]);

int iter = 0;
int term = 0;	// termination count test

do{ 
	if (verbose>=0) System.out.print(".");
++iter;
bar.setValue(bar.getValue()+1);
// hessian approximation
for( int r = 0; r < nparm; r++ ) {
for( int c = 0; c < nparm; c++ ) {
for( int i = 0; i < npts; i++ ) {
 if (i == 0) H[r][c] = 0.;
 double[] xi = x[i];
 //H[r][c] += (oos2[i] * f.grad(xi, a, r) * f.grad(xi, a, c));
	 H[r][c] += (oos2[i] * grad(f,xi, a, r,y[i]).x * grad(f,xi, a, r,y[i]).x);
	 H[r][c] += (oos2[i] * grad(f,xi, a, r,y[i]).y * grad(f,xi, a, r,y[i]).y);
}  //npts
} //c
} //r
// boost diagonal towards gradient descent
for( int r = 0; r < nparm; r++ )
H[r][r] *= (1. + lambda);

// gradient
for( int r = 0; r < nparm; r++ ) {
	for( int i = 0; i < npts; i++ ) {
		if (i == 0) g[r] = 0.;
		double[] xi = x[i];
	 	 Point2d error=f.adjust(y[i],a);
		 error.minus(f.val(xi,a));
 	 	 //g[r] += (oos2[i] * (y[i]-f.val(xi,a)) * f.grad(xi, a, r));
		 g[r] += (oos2[i] * (Math.sqrt(error.lengthSquared())) * grad(f,xi, a, r,y[i]).x);
		 g[r] += (oos2[i] * (Math.sqrt(error.lengthSquared())) * grad(f,xi, a, r,y[i]).y);
	}
} //npts
// scale (for consistency with NR, not necessary)
if (false) {
for( int r = 0; r < nparm; r++ ) {
g[r] = -0.5 * g[r];
for( int c = 0; c < nparm; c++ ) {
 H[r][c] *= 0.5;
}
}
}
// solve H d = -g, evaluate error at new location
//double[] d = DoubleMatrix.solve(H, g);
//double[] d=new Matrix(H).lu().solve(new Matrix(g, nparm)).getRowPackedCopy();

// Note that the solve method will throw an exception if the Hessian is singular which means we are at an insolvable point
// so if throwexceptionwhensingular is true the calling code needs to trap this exception
// One way around this is to approximate the inverse with the pseudo-inverse. This will allow the algorithm to keep going 
// and potentially add a couple of decimal places of precision but we are rather stuck. 
// The Hessian is a grouping of partial second derivatives so it will normally be singular when we are very close to a minimum but it could also be that
// there are simply too many free parameters and the function is insolvable. 
double[] d;
if ((throwexceptionwhensingular) || (new Matrix(H).lu().isNonsingular())) d=new Matrix(H).lu().solve(new Matrix(g, nparm)).getRowPackedCopy();
else // find d as H+-g where H+ is the pseudoinverse of H
	d=(new MatrixManipulations().PseudoInverse(new Matrix (H))).times(new Matrix(g, nparm)).getRowPackedCopy();
//double[] na = DoubleVector.add(a, d);
double[] na = (new Matrix(a, nparm)).plus(new Matrix(d, nparm)).getRowPackedCopy();
double e1 = chiSquared(x, na, y, s, f);

if (verbose > 0) {
System.out.println("\n\niteration "+iter+" lambda = "+lambda);
System.out.print("a = ");
 (new Matrix(a, nparm)).print(10, 20);
if (verbose > 1) {
   System.out.print("H = "); 
   (new Matrix(H)).print(10, 20);
   System.out.print("g = "); 
   (new Matrix(g, nparm)).print(10, 20);
   System.out.print("d = "); 
   (new Matrix(d, nparm)).print(10, 20);
}

System.out.print("e0 = " + e0 + ": ");
System.out.print("moved from ");
(new Matrix(a, nparm)).print(10, 20);
System.out.println("e1 = " + e1 + ": ");
if (e1 < e0) {
System.out.print("to ");
(new Matrix(na, nparm)).print(10, 20);
}
else {
System.out.println("move rejected");
}
}

// termination test (slightly different than NR)
if (Math.abs(e1-e0) > termepsilon) {
term = 0;
}
else {
term++;
if (term == 4) {
if (verbose>=0) System.out.println("terminating after " + iter + " iterations");
done = true;
}
}
if (iter >= maxiter) done = true;

// in the C++ version, found that changing this to e1 >= e0
// was not a good idea.  See comment there.
//
if (e1 > e0 || Double.isNaN(e1)) { // new location worse than before
lambda *= 10.;
}
else {		// new location better, accept new parameters
lambda *= 0.1;
e0 = e1;
// simply assigning a = na will not get results copied back to caller
for( int i = 0; i < nparm; i++ ) {
if (vary[i]) a[i] = na[i];
}
}

} while(!done);
return lambda;

} //solve
    /**
	    * return the kth component of the gradient df(x,a)/da_k
	    * 
	    * Note that the Point2d returned is not a point or vector in the normal sense of (x,y)
	    * but is instead a couplet of the partial derivative of x in terms of a[k] and the partial derivative of y in terms of a[k]  
	    * 
	    * TODO change these to be generic matrices rather than just Point2d?
	    * 
	    */
	  
	    private static Point2d grad(LMfunc f, double[] x, double[] a, int k, Point2d y)
	    {
		  /* Outline of steps
		   * 
		   * 1. Set the amount to change the parameter by: currently (as I can't think of a better way) they all change to be 100.0001% and 99.9999% of the current value (except when they are currently 0 in which case they are set + and - 0.0001)
		   * 
		   * 2. use val/adjust to find the error vector in each of these two cases and find the difference between them 
		   * 
		   * 3. divide each of the differences by the difference in the parameter changed and return 
		   * 
		   */  	
	    	
	    	// Step 1
	    	double delta=0.0001;
	    	double negativeak,positiveak;
	    	double originalak=a[k];
	    	if (a[k]==0) {
	    		negativeak=0-delta;
	    		positiveak=delta;
	    	}
	    	else{
	    		negativeak=a[k]*(1+delta);
	    		positiveak=a[k]*(1-delta);
	    	}
	    	// Step 2
	    	a[k]=positiveak;
	    	Point2d errorpos=f.adjust(y,a);
	    	errorpos.minus(f.val(x, a));
	    	a[k]=negativeak;
	    	Point2d errorneg=f.adjust(y,a);
	    	errorneg.minus(f.val(x, a));
	    	Point2d answer=errorpos.minusEquals(errorneg);
	    	a[k]=originalak;
	    	//Step 3
	    	answer.scale(1/(positiveak-negativeak));
	    	return answer;
	    } //grad
    
  //----------------------------------------------------------------

  /**
   * solve for phase, amplitude and frequency of a sinusoid
   */
 /*
    static class LMSineTest implements LMfunc
  {
    static final int	PHASE = 0;
    static final int	AMP = 1;
    static final int	FREQ = 2;

    public double[] initial()
    {
      double[] a = new double[3];
      a[PHASE] = 0.;
      a[AMP] = 1.;
      a[FREQ] = 1.;
      return a;
    } //initial

    //public double val(double[] x, double[] a)
    public Point2d val(double[] x, double[] a)
    {
      return new Point2d(a[AMP] * Math.sin(a[FREQ]*x[0] + a[PHASE]),0);
    } //val

    //public double grad(double[] x, double[] a, int a_k)
    public Point2d grad(double[] x, double[] a, int a_k)
    {
      if (a_k == AMP)
	//return Math.sin(a[FREQ]*x[0] + a[PHASE]);
    	 return new Point2d(Math.sin(a[FREQ]*x[0] + a[PHASE]),0);
      else if (a_k == FREQ)
	//return a[AMP] * Math.cos(a[FREQ]*x[0] + a[PHASE]) * x[0];
    	  return new Point2d(a[AMP] * Math.cos(a[FREQ]*x[0] + a[PHASE]) * x[0],0);
      else if (a_k == PHASE)
	//return a[AMP] * Math.cos(a[FREQ]*x[0] + a[PHASE]);
    	  return new Point2d(a[AMP] * Math.cos(a[FREQ]*x[0] + a[PHASE]),0);
      else {
	assert false;
	//return 0.;
	return new Point2d(0,0);
      }
    } //grad


    public Object[] testdata() {
      double[] a = new double[3];
      a[PHASE] = 0.111;
      a[AMP] = 1.222;
      a[FREQ] = 1.333;

      int npts = 10;
      double[][] x = new double[npts][1];
     // double[] y = new double[npts];
      Point2d[] y = new Point2d[npts];
      double[] s = new double[npts];
      for( int i = 0; i < npts; i++ ) {
	x[i][0] = (double)i / npts;
	y[i] = val(x[i], a);
	s[i] = 1.;
      }

      Object[] o = new Object[4];
      o[0] = x;
      o[1] = a;
      o[2] = y;
      o[3] = s;

      return o;
    } //test

  } //SineTest
*/
  //----------------------------------------------------------------

  /**
   * quadratic (p-o)'S'S(p-o)
   * solve for o, S
   * S is a single scale factor
   */
 /*
    static class LMQuadTest implements LMfunc
  {

    public double val(double[] x, double[] a)
    {
      assert a.length == 3;
      assert x.length == 2;

      double ox = a[0];
      double oy = a[1];
      double s  = a[2];

      double sdx = s*(x[0] - ox);
      double sdy = s*(x[1] - oy);

      return sdx*sdx + sdy*sdy;
    } //val

*/
    /**
     * z = (p-o)'S'S(p-o)
     * dz/dp = 2S'S(p-o)
     *
     * z = (s*(px-ox))^2 + (s*(py-oy))^2
     * dz/dox = -2(s*(px-ox))*s
     * dz/ds = 2*s*[(px-ox)^2 + (py-oy)^2]

     * z = (s*dx)^2 + (s*dy)^2
     * dz/ds = 2(s*dx)*dx + 2(s*dy)*dy
     */
  /*
    public double grad(double[] x, double[] a, int a_k)
    {
      assert a.length == 3;
      assert x.length == 2;
      assert a_k < 3: "a_k="+a_k;

      double ox = a[0];
      double oy = a[1];
      double s  = a[2];

      double dx = (x[0] - ox);
      double dy = (x[1] - oy);

      if (a_k == 0)	
	return -2.*s*s*dx;

      else if (a_k == 1)
	return -2.*s*s*dy;

      else
	return 2.*s*(dx*dx + dy*dy);
    } //grad


    public double[] initial()
    {
      double[] a = new double[3];
      a[0] = 0.05;
      a[1] = 0.1;
      a[2] = 1.0;
      return a;
    } //initial


    public Object[] testdata()
    {
      Object[] o = new Object[4];
      int npts = 25;
      double[][] x = new double[npts][2];
      double[] y = new double[npts];
      double[] s = new double[npts];
      double[] a = new double[3];

      a[0] = 0.;
      a[1] = 0.;
      a[2] = 0.9;

      int i = 0;
      for( int r = -2; r <= 2; r++ ) {
	for( int c = -2; c <= 2; c++ ) {
	  x[i][0] = c;
	  x[i][1] = r;
	  y[i] = val(x[i], a);
	  System.out.println("Quad "+c+","+r+" -> "+y[i]);
	  s[i] = 1.;
	  i++;
	}
      }
      System.out.print("quad x= "); 
      (new Matrix(x)).print(10, 2);

      System.out.print("quad y= "); 
      (new Matrix(y,npts)).print(10, 2);


      o[0] = x;
      o[1] = a;
      o[2] = y;
      o[3] = s;
      return o;
    } //testdata

  } //LMQuadTest
*/
  //----------------------------------------------------------------

  /**
   * Replicate the example in NR, fit a sum of Gaussians to data.
   * y(x) = \sum B_k exp(-((x - E_k) / G_k)^2)
   * minimize chisq = \sum { y[j] - \sum B_k exp(-((x_j - E_k) / G_k)^2) }^2
   *
   * B_k, E_k, G_k are stored in that order
   *
   * Works, results are close to those from the NR example code.
   */
  /*
   static class LMGaussTest implements LMfunc
  {
    static double SPREAD = 0.001; 	// noise variance

    public double val(double[] x, double[] a)
    {
      assert x.length == 1;
      assert (a.length%3) == 0;

      int K = a.length / 3;
      int i = 0;

      double y = 0.;
      for( int j = 0; j < K; j++ ) {
	double arg = (x[0] - a[i+1]) / a[i+2];
	double ex = Math.exp(- arg*arg);
	y += (a[i] * ex);
	i += 3;
      }

      return y;
    } //val

*/
    /**
     * <pre>
     * y(x) = \sum B_k exp(-((x - E_k) / G_k)^2)
     * arg  =  (x-E_k)/G_k
     * ex   =  exp(-arg*arg)
     * fac =   B_k * ex * 2 * arg
     * 
     * d/dB_k = exp(-((x - E_k) / G_k)^2)
     *
     * d/dE_k = B_k exp(-((x - E_k) / G_k)^2) . -2((x - E_k) / G_k) . -1/G_k
     *        = 2 * B_k * ex * arg / G_k
     *   d/E_k[-((x - E_k) / G_k)^2] = -2((x - E_k) / G_k) d/dE_k[(x-E_k)/G_k]
     *   d/dE_k[(x-E_k)/G_k] = -1/G_k
     *
     * d/G_k = B_k exp(-((x - E_k) / G_k)^2) . -2((x - E_k) / G_k) . -(x-E_k)/G_k^2
     *       = B_k ex -2 arg -arg / G_k
     *       = fac arg / G_k
     *   d/dx[1/x] = d/dx[x^-1] = -x[x^-2]
     */
  /*
    public double grad(double[] x, double[] a, int a_k)
    {
      assert x.length == 1;

      // i - index one of the K Gaussians
      int i = 3*(a_k / 3);

      double arg = (x[0] - a[i+1]) / a[i+2];
      double ex = Math.exp(- arg*arg);
      double fac = a[i] * ex * 2. * arg;

      if (a_k == i)
	return ex;

      else if (a_k == (i+1)) {
	return fac / a[i+2];
      }

      else if (a_k == (i+2)) {
	return fac * arg / a[i+2];
      }

      else {
	System.err.println("bad a_k");
	return 1.;
      }

    } //grad


    public double[] initial()
    {
      double[] a = new double[6];
      a[0] = 4.5;
      a[1] = 2.2;
      a[2] = 2.8;

      a[3] = 2.5;
      a[4] = 4.9;
      a[5] = 2.8;
      return a;
    } //initial


    public Object[] testdata()
    {
      Object[] o = new Object[4];
      int npts = 100;
      double[][] x = new double[npts][1];
      double[] y = new double[npts];
      double[] s = new double[npts];
      double[] a = new double[6];

      a[0] = 5.0;	// values returned by initial
      a[1] = 2.0;	// should be fairly close to these
      a[2] = 3.0;
      a[3] = 2.0;
      a[4] = 5.0;
      a[5] = 3.0;

      for( int i = 0; i < npts; i++ ) {
	x[i][0] = 0.1*(i+1);	// NR always counts from 1
	y[i] = val(x[i], a);
	s[i] = SPREAD * y[i];
	System.out.println(i+": x,y= "+x[i][0]+", "+y[i]);
      }

      o[0] = x;
      o[1] = a;
      o[2] = y;
      o[3] = s;

      return o;
    } //testdata

  } //LMGaussTest
*/
  //----------------------------------------------------------------
/*
  // test program
  public static void main(String[] cmdline)
  {

    //LMfunc f = new LMQuadTest();
    LMfunc f = new LMSineTest();	// works
    //LMfunc f = new LMGaussTest();	// works

    double[] aguess = f.initial();
    Object[] test = f.testdata();
    double[][] x = (double[][])test[0];
    double[] areal = (double[])test[1];
   // double[] y = (double[])test[2];
    Point2d[] y = (Point2d[])test[2];
    double[] s = (double[])test[3];
    boolean[] vary = new boolean[aguess.length];
    for( int i = 0; i < aguess.length; i++ ) vary[i] = true;
    assert aguess.length == areal.length;

    try {
      LM test2=new LM();
    	test2.solve( x, aguess, y, s, vary, f, 0.001, 0.01, 100, 2);
    }
    catch(Exception ex) {
      System.err.println("Exception caught: " + ex.getMessage());
      System.exit(1); 
    }

    System.out.print("desired solution "); 
    (new Matrix(areal, areal.length)).print(10, 2);

    System.exit(0);
  } //main
*/
} //LM

