package com.landray.kmss.tib.common.init.plugins.taglib;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.landray.kmss.tib.common.init.plugins.TibCommonInitPlugin;
import com.landray.kmss.web.taglib.xform.ICustomizeDataSource;

public class TibCommonInitBean implements ICustomizeDataSource {

	public String getDefaultValue() {
		return null;
	}

	public Map<String, String> getOptions() {
		List<Map<String, String>> pluginList = TibCommonInitPlugin.getConfigs();
		Map<String, String> returnMap = new TreeMap<String, String>();
		for(Map<String, String> map : pluginList) {
			String key = map.get("moduleKey");
			String value = map.get("initTitle");
			returnMap.put(key, value);
		}
		return returnMap;
	}
	
}
