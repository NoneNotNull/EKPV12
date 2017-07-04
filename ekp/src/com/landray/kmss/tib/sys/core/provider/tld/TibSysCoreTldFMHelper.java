package com.landray.kmss.tib.sys.core.provider.tld;

import java.util.Locale;

import freemarker.cache.ClassTemplateLoader;
import freemarker.cache.TemplateLoader;
import freemarker.template.Configuration;

public class TibSysCoreTldFMHelper {

	private static Configuration defaultConfiguration=null;
	
	public static Configuration instanceDefaultCfg(){
		if(defaultConfiguration==null){
			Configuration def=new Configuration();
			TemplateLoader loader = new ClassTemplateLoader(
					TibSysCoreTldFMHelper.class,
					"/com/landray/kmss/tib/sys/core/provider/tld");
			def.setTemplateLoader(loader);
			def.setNumberFormat("0.#");
			def.setLocale(Locale.CHINA);
			def.setDefaultEncoding("UTF-8");
			defaultConfiguration=def;
		}
		return defaultConfiguration;
		
	}
	
	
}
