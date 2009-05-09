package org.reprap.artofillusion.language;

import java.util.List;

import org.reprap.artofillusion.parser.MetaCADParser;
import org.reprap.artofillusion.parser.ParseException;

public class Tester {

  /**
   * @param args
   */
  public static void main(String[] args) {
    // TODO Auto-generated method stub
    MetaCADParser parser = MetaCADParser.getSingleton(
           "mymacro() {sphere(x,x,x)}"
           );                                           
                                                      
                                                      /*
                                                      "x=234   " +
    		"y=(x/32)*sin(x)  " +
    		"macro mymacro() { sphere(x,x,x) }" +
    		"sklj=kjsdhf " +
    		"macro mymacro2() { sphere(x,x,x) }" +
    		"macro my2ndmacro(x,y) { cs(x,y,0) {\n"+
                  "  sphere(x,y,x);\n" +
                  "  union() {" +
                   "     cube(x,y,x);"+
                   "     cylinder(x,2*y,2*x)"+
                   " }" +
               " } }\n" +
               "hello=hello*2");*/
    
    try {
      MacroPrototype p = parser.MacroPrototype();
      parser = MetaCADParser.getSingleton(                                    "x=234   " +
             "y=(x/32)*sin(x, \"hello world\")  //a comment \n" +
             "mymacro() { sphere(x,x,x, \"this is a compl.icated \\n\\\"string,,,\",23) }" +
             "sklj=kjsdhf " +
             "mymacro2() { sphere(x,x,x) }" +
             "my2ndmacro(x,y) { cs(x,y,0) {\n"+
               "  sphere(x,y,x);\n" +
               "  union() {" +
                "     cube(x,y,x);"+
                "     cylinder(x,2*y,2*x)"+
                " }" +
            " }}\n" +
            "hello=hello*2  /* multi\n line comment */ hello8=234 # dash style comment \n" +
            "hello=edfg");
      List<ParsedStatement> m= parser.ParsedStatementList();
      System.out.println(m.size());
      
    } catch (ParseException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
    }

  }

}
