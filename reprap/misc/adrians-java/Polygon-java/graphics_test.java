class graphics_test
{
    public static void main(String[] args)
    {
	rr_2point p = new rr_2point(0, 0);
	rr_2point q = new rr_2point(0.9, 0.1);
	rr_2point r = new rr_2point(1, 0.85);
	rr_2point s = new rr_2point(0.05, 0.93);
	rr_2point pp = new rr_2point(0.35, 0.62);
	rr_2point qq = new rr_2point(0.45, 0.5);
	rr_2point rr = new rr_2point(0.55, 0.49);
	rr_2point ss = new rr_2point(0.4, 0.3);    
	rr_line x = new rr_line(new rr_2point(-1, -1), new rr_2point(1, 1));

	rr_polygon a = new rr_polygon();
	a.append(p, 1);
	a.append(q, 1);
	a.append(r, 1);
	a.append(s, 1);

	rr_p_list c = new rr_p_list();
	c.append(a);
	
	a = new rr_polygon();
	a.append(pp, 2);
	a.append(qq, 2);
	a.append(rr, 2);
	a.append(ss, 2);
	c.append(a);
    
	rr_p_list d = c.offset(-0.03);

	rr_polygon  e = d.hatch(x, 0.03, 3, 4);
	//d = d.offset(0.003);
	//e = e.join_up(d);
	//c.append(d); 
	c.append(e);
	
	new rr_graphics(c);
    }
}
