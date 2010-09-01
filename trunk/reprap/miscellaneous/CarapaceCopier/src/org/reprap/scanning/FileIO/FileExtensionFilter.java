package org.reprap.scanning.FileIO;
// Copied from http://home.cogeco.ca/~ve3ll/jatutore.htm
// This should allow file filter by extension in file selection dialog boxes for JDK 1.5. This functionality is included in Java 6
import java.io.File; 
import javax.swing.filechooser.*;
public class FileExtensionFilter extends FileFilter
{
 String[] extensions; String description;
 public FileExtensionFilter(String ext)
   {this (new String[] {ext},null);}
 public FileExtensionFilter(String[] exts, String descr)
 {
   extensions = new String[exts.length];
   for (int i=exts.length-1;i>=0;i--)
       {extensions[i]=exts[i].toLowerCase();}
   description=(descr==null?exts[0]+" files":descr);
 }
 public boolean accept(File f)
 {
   if (f.isDirectory()) {return true;}
   String name = f.getName().toLowerCase();
   for (int i=extensions.length-1;i>=0;i--)
     {if (name.endsWith(extensions[i])) {return true;} }
   return false;
 }
 public String getDescription() {return description;}
}