package com.landray.kmss.tib.sap.mapping.plugins.controls.list;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.constant.Constant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncXmlOperateService;

/**
 * 获取配置的数据源
 * 
 * @author qiujh 2013-03-12
 * 
 */			 
public class TibSapMappingListBean 
		implements IXMLDataBean {

	private ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService;
	
	public void setTibCommonMappingFuncXmlOperateService(
			ITibCommonMappingFuncXmlOperateService tibCommonMappingFuncXmlOperateService) {
		this.tibCommonMappingFuncXmlOperateService = tibCommonMappingFuncXmlOperateService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> result = new ArrayList<Map<String, String>>();
		String fdTemplateId = requestInfo.getParameter("fdTemplateId");
		List<TibCommonMappingFunc> funcList = tibCommonMappingFuncXmlOperateService.getFuncList(fdTemplateId, Integer.valueOf(Constant.INVOKE_TYPE_FORMCONTROL),Constant.FD_TYPE_SAP);
		for (TibCommonMappingFunc func : funcList) {
			Map<String, String> map = new HashMap<String, String>();
			String fdId = func.getFdId();
			String fdName = func.getFdRefName();
			map.put("fdId", fdId);
			map.put("fdName", fdName);
			result.add(map);
		}
		return result;
	}

}
