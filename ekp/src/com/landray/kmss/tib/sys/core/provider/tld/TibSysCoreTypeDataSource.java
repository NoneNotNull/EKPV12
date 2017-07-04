package com.landray.kmss.tib.sys.core.provider.tld;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.web.taglib.xform.ICustomizeDataSource;

public class TibSysCoreTypeDataSource implements ICustomizeDataSource{

	public String getDefaultValue() {
		// TODO 自动生成的方法存根
		return null;
	}

	public Map<String, String> getOptions() {
		// TODO 自动生成的方法存根
		Map<String,String> rtnMap= new HashMap<String, String>(1);
		List<Map<String, String>>  providers=TibSysCoreProviderPlugins.getConfigs();
		for(Map<String,String> provider:providers){
			String key =provider.get("providerKey");
			String value =provider.get("providerName");
			rtnMap.put(key, value);
		}
		
		return rtnMap;
	}

}
