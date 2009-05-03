package org.reprap.artofillusion;

public class ObjFactory {
	public static ParsedTree create(String name) throws Exception
	{
		name = name.toLowerCase();
		
                if (name.startsWith("sphere"))
                {
                        return new SphereObj();
                }
                if (name.startsWith("cube"))
                {
                        return new CubeObj();
                }
                if (name.startsWith("cylinder"))
                {
                        return new CylinderObj();
                }
		else if (name.startsWith("cs"))
		{
			return new CSObj();
		}
		
		throw new Exception("unknown Object type: " + name);
	}	
}
