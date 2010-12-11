package org.reprap;

import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.HashMap;
import java.util.Properties;

public class Translation {

	private static Translation globalTranslation = null;

	private Properties currentTranslation = null;
	private Properties defaultTranslation = null;

	private String defaultLanguage = "en_GB";
	private String currentLanguage = null;
	
	private Translation(){		
		currentTranslation = new Properties();
		
		try {
			currentLanguage = Preferences.loadGlobalString("Language");
		} catch (IOException e){
			System.err.println("Translation class: Error loading the preferences file: "+e.getMessage());
			currentLanguage = defaultLanguage;
		}
		if (currentLanguage == null){
			currentLanguage = defaultLanguage;
		}
		//now we have found a language setting

		//first load the default language file
		defaultTranslation = loadTranslationFile(defaultLanguage);
		
		if (currentLanguage.equalsIgnoreCase(defaultLanguage)){
			currentTranslation = defaultTranslation;
		} else {
			currentTranslation = loadTranslationFile(currentLanguage);
		}
		
	}
	
	public static Translation getGlobalTranslation(){
		initIfNeeded(); 
		return globalTranslation;
	}
	
	synchronized private static void initIfNeeded() {
		if (globalTranslation == null)
			globalTranslation = new Translation();
	}
	
	private Properties loadTranslationFile(String languageCode){
		Properties p = new Properties();
		File f = new File("lib" + File.separatorChar + "translations" + File.separatorChar + languageCode + ".properties");
		try {

			p.load(f.toURL().openStream());
			
		} catch (IOException e){
			System.err.println("Translation class: Error loading the Translation file: "+f.getAbsolutePath());
		}
		return p;
	}
	
	public static String translate(String toBeTranslated){
		initIfNeeded();
		return globalTranslation.getTranslation(toBeTranslated);
	}
	
	private String getTranslation(String toBeTranslated){
		String translatedText = null;
		
		translatedText = currentTranslation.getProperty(toBeTranslated);
		
		// fall back to default language if translation is not found in current language
		if (translatedText == null){
			translatedText = defaultTranslation.getProperty(toBeTranslated);
			System.err.println("Translation class: missing translation: \"" + toBeTranslated + "\" in file: " + currentLanguage + ".properties");
			
			//return "(to be translated)" if there is no translation in either language
			if (translatedText == null){
				System.err.println("Translation class: no translation for \""+toBeTranslated+ "\" was found. Spelling?");
				translatedText = "(to be translated)";
			}
		}		
		
		return translatedText;
	}
	
//	public static void main(String[] args){
//
//		Translation t = Translation.getGlobalTranslation();
//		String s = t.getTranslation("MainWindowTitle");
//		
//		System.out.println(s);
//	}
	
}
