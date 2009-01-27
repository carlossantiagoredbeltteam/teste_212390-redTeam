package org.reprap.artofillusion;

import java.io.InputStream;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;

import artofillusion.ArtOfIllusion;
import artofillusion.Plugin;
import artofillusion.PluginRegistry;

public class CSGEvaluatorPlugin implements Plugin
{
    protected static String versionstr = "0.0";

    public void processMessage(int message, Object args[]) {
	if (message == Plugin.APPLICATION_STARTING) {
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder;
	    try {
		builder = factory.newDocumentBuilder();
		Document doc = builder.parse(getClass().getClassLoader().getResourceAsStream("extensions.xml"));
		Element extensions = doc.getDocumentElement();
		versionstr = extensions.getAttribute("version");
	    } catch (Exception e) {
		System.out.println("Failed to read version for CSGEvaluator");
		e.printStackTrace();
	    }
	}
	else if (message == Plugin.SCENE_WINDOW_CREATED) {
	}
    }
    
    public static String getVersion()
    { return versionstr; }
}
