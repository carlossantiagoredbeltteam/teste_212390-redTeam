/*
 *  New RepRap Extruder Head - Test program
 *
 *  Adrian Bowyer
 *  14 October 2005
 *
 */

class rr_layer
{
    static final int extrude_off = -1;
    private cartesian c;
    private rr_3point home;
    double addon;
    rr_2point offset;
    int start_delay;
    double stop_distance;

    public rr_layer(double an, rr_2point ot, int sy, double se)
    {
	addon = an;
	offset = new rr_2point(ot);
	start_delay = sy;
	stop_distance = se;
	c = new cartesian(false);
	c.user_port((byte)4);
	home = new rr_3point(c.pos());
    }

    public void offset_fudge(int layer)
    {
	if(layer%2 != 0)
	    offset.x = offset.x - 1.5;
	else
	    offset.x = offset.x + 1.5;

	offset.y = offset.y + 0.5;
    }

    public void wrap_up()
    {
	go_home();
	c.save();
    }

    private void go(rr_3point p)
    {
	if(!c.go(p))
	    {
		System.out.println("Illegal position: (" + p.toString() + ")");
		rr_3point r = new rr_3point(c.envelope());
		System.out.println("Robot's envelope is: (" + r.toString() + ")");
	    }
    }

    public void extrude(boolean on)
    {
	if(on)
	    {
		c.user_port((byte)0);

		try  // Wait...
		    {
			Thread.sleep(start_delay);
		    }
		catch (InterruptedException e)
		    {

		    }
	    }

	else
	    c.user_port((byte)4);
    }

    public void vertical(double height)
    {
	rr_3point here = new rr_3point(c.pos());
	here.z = height;
	go(here);
    }

    public void go_home()
    {
	vertical(home.z);
	go(home);
    }

    public rr_polygon add_stop_point(rr_polygon pg)
    {
	rr_polygon result = new rr_polygon(pg);
	int leng = result.points.size();
	double sum = 0;
	double d;
	rr_line ln;
	rr_2point p, q;

	if(((Integer)(result.flags.get(0))).intValue() != 0)
	    {
		p = (rr_2point)result.points.get(0);
		leng = leng - 1;
	    } else
	    {
		p = (rr_2point)result.points.get(leng - 1);
		leng = leng - 2;
	    }

	for(int i = leng; i >= 0; i--)
	    {
		q = (rr_2point)result.points.get(i);
		d = (p.sub(q)).mod();
		sum = sum + d;
		if (sum > stop_distance)
		    {
			d = sum - stop_distance;
			ln = new rr_line(q, p);
			ln.norm();
			p = ln.point(d);
			result.points.add(i+1, p);
			result.flags.add(i+1, new Integer(extrude_off));
			return result;
		    }
		p = q;
	    }
	return result;
    }

    public void make_polygons(rr_p_list pl, double height)
    {
	int leng_l = pl.polygons.size();
	for(int i = 0; i < leng_l; i++)
	    {
		rr_polygon pg = add_stop_point((rr_polygon)pl.polygons.get(i));
		int leng_p = pg.points.size();
		if(leng_p > 0)
		    {
			rr_2point p = new rr_2point((rr_2point)pg.points.get(0));
			p = p.add(offset);

			rr_3point start_high = new rr_3point(p.x, p.y, height + addon);
			go(start_high);
			rr_3point start = new rr_3point(p.x, p.y, height);
			go(start);

			extrude(true);
			for(int j = 1; j < leng_p; j++)
			    {
				p = new rr_2point((rr_2point)pg.points.get(j));
				p = p.add(offset);
				rr_3point r = new rr_3point(p.x, p.y, height);
				go(r);
				if(((Integer)(pg.flags.get(j))).intValue() == extrude_off)
				    extrude(false);
			    }

		        if(((Integer)(pg.flags.get(0))).intValue() != 0)
			    go(start);

			extrude(false);
			vertical(height + addon);
		    }
	    }
    }

    public rr_p_list prepare(rr_polygon pg, rr_line hatch_line, double width)
    {
	rr_polygon off = pg.offset(-width*0.52);
	rr_polygon hatch_off = pg.offset(-width*1.5);
	rr_p_list h = new rr_p_list();
	h.append(hatch_off);
	rr_polygon hatch = h.hatch(hatch_line, width, 3, 4);
	rr_p_list result = new rr_p_list();
	result.append(off);
	result.append(hatch);
	return result;
    }

    public static void main(String[] args)
    {
	TextReader in = new TextReader(System.in);

	System.out.print("Height clearance (mm): ");
	double an = in.getDouble();

	System.out.print("Extrude start delay (ms): ");
	int sy = in.getInt();

	System.out.print("Extrude stop distance (mm): ");
	double se= in.getDouble();

	System.out.print("Polygon file: ");
	String f_name = in.getWord();
	rr_polygon pg = new rr_polygon(f_name);

	System.out.println("Polygon's limits are: " + pg.box.toString());
	System.out.print("X and Y offset (mm): ");
	rr_2point ot = new rr_2point();
	ot.x = in.getDouble();
	ot.y = in.getDouble();

	System.out.print("Polymorph track width: ");
	double width = in.getDouble();

	System.out.print("Start height (mm): ");
	double height = in.getDouble();

	System.out.print("Height increment (mm): ");
	double h_inc = in.getDouble();

	System.out.print("Number of layers: ");
	int layers = in.getInt();

	double ang;
	String response;

	rr_layer rr = new rr_layer(an, ot, sy, se);

	rr.extrude(true);
	rr.extrude(false);

	for(int i = 0; i < layers; i++)
	    {
		rr.offset_fudge(i);

		if(i%2 == 0)
		    ang = Math.PI*0.25;
		else
		    ang = -Math.PI*0.25;

		rr_2point p = new rr_2point(Math.cos(ang), Math.sin(ang));
		rr_line hatch_line = new rr_line(new rr_2point(0, 0), p);
		rr_p_list rpl = rr.prepare(pg, hatch_line, width);

		//new rr_graphics(rpl);

		rr.make_polygons(rpl, height);
	 
		height = height + h_inc;
		System.out.print("Continue? ");
		response = in.getWord().toLowerCase();
		if(response.equals("n") || response.equals("no")) break;
	    }
	rr.wrap_up();
    }
}

