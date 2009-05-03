package org.reprap.artofillusion;

public class ObjFactory {
	public static ParsedTree create(String name) throws Exception
	{
		name = name.toLowerCase();
		
                if (name.startsWith("sphere"))
                {
                        return new SphereObj();
                }
                else if (name.startsWith("cube"))
                {
                        return new CubeObj();
                }
                else if (name.startsWith("cylinder"))
                {
                        return new CylinderObj();
                }
		else if (name.startsWith("cs"))
		{
			return new CSObj();
		}
                else if (name.startsWith("union"))
                {
                        return new UnionObj();
                }
                else if (name.startsWith("difference"))
                {
                        return new DifferenceObj();
                }
                else if (name.startsWith("intersection"))
                {
                        return new IntersectionObj();
                }
		
		throw new Exception("unknown Object type: " + name);
	}	
}
