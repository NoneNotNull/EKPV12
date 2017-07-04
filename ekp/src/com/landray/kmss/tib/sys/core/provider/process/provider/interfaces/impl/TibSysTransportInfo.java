package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreInfo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCateVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysFuncVo;
import com.landray.kmss.util.StringUtil;

/**
 * 自定义提供者信息类
 * @author fat_tian
 *
 */
public class TibSysTransportInfo implements ITibSysCoreInfo {


	public List<TibSysCateVo> getCateInfo(String selectId, String pluginKey)
			throws Exception {
		List<TibSysCateVo> cateVo=new ArrayList<TibSysCateVo>();
		if (StringUtil.isNull(selectId)) {
			cateVo.add(new TibSysCateVo("transportId","自定义分类",pluginKey));
			Map<String, String> map = TibSysCoreProviderPlugins.getContainConfigByKey("customKey_");
			if (map != null && !map.isEmpty()) {
				cateVo.add(new TibSysCateVo(map.get("providerKey"), map.get("providerName"), map.get("providerKey")));
			}
		}
		return cateVo;
	}

	public List<TibSysFuncVo> getFuncDataList(String cateId, String pluginKey)
			throws Exception {
		List<TibSysFuncVo> funcList=new ArrayList<TibSysFuncVo>();
		if ("transportId".equals(cateId)) {
			funcList.add(new TibSysFuncVo("transportFuncId","自定义服务提供者函数", pluginKey));
		}
		return funcList;
	}

}
