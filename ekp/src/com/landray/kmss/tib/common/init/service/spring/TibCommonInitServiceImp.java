package com.landray.kmss.tib.common.init.service.spring;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.common.init.plugins.TibCommonInitPlugin;
import com.landray.kmss.tib.common.init.service.ITibCommonInitService;
import com.landray.kmss.util.StringUtil;

/**
 * 主文档业务接口实现
 * 
 * @author 
 * @version 1.0 2013-06-17
 */
public class TibCommonInitServiceImp extends BaseServiceImp implements ITibCommonInitService {

	public List<String> getJspPathList() throws Exception {
		List<Map<String, String>> pluginList = TibCommonInitPlugin.getConfigs();
		List<String> jspList = new ArrayList<String>();
		for(Map<String, String> map : pluginList) {
			String jspPath = map.get("jspPath");
			if (StringUtil.isNotNull(jspPath)) {
				jspList.add(jspPath);
			}
		}
		return jspList;
	}

}
