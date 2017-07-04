package com.landray.kmss.tib.common.mapping.plugins.taglib;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.web.taglib.xform.ICustomizeDataSource;

public class TibCommonPluginsDataSource implements ICustomizeDataSource  {

	public String getDefaultValue() {
		return null;
	}

	public Map<String, String> getOptions() {
		// TODO 自动生成的方法存根
		List<Map<String, String>> pluginsList= TibCommonMappingIntegrationPlugins.getConfigs();
		Map<String,String> optMap=new HashMap<String, String>();
		for(Map<String, String> pluginsMap : pluginsList){
			String key=pluginsMap.get(TibCommonMappingIntegrationPlugins.fdIntegrationType);
			String display=pluginsMap.get(TibCommonMappingIntegrationPlugins.displayName);
			optMap.put(key, display);
		}
		return optMap;
	}

}
