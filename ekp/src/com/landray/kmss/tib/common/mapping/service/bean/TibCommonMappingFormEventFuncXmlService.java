package com.landray.kmss.tib.common.mapping.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;

public class TibCommonMappingFormEventFuncXmlService implements IXMLDataBean {
	
	private Log logger = LogFactory.getLog(this.getClass());
	
	private ITibCommonMappingFuncService tibCommonMappingFuncService;

	public void setTibCommonMappingFuncService(
			ITibCommonMappingFuncService tibCommonMappingFuncService) {
		this.tibCommonMappingFuncService = tibCommonMappingFuncService;
	}

	// 用于得到表单事件的函数xml信息
	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		
		// TODO 自动生成的方法存根
		String funcId = requestInfo.getParameter("funcId");
		List<Map<String, String>> rtnList = new ArrayList<Map<String,String>>(1);
//		防止sql注入
		HQLInfo hqlInfo=new HQLInfo();
		hqlInfo.setSelectBlock("tibCommonMappingFunc.fdRfcParamXml");
		hqlInfo.setWhereBlock("tibCommonMappingFunc.fdId=:fdId");
		hqlInfo.setParameter("fdId", funcId);
		List<String> xmlList =tibCommonMappingFuncService.findValue(hqlInfo);
		if(xmlList==null||xmlList.isEmpty()){
			return rtnList;
		}
		String funcXml = xmlList.get(0);
		Map<String, String> map = new HashMap<String, String>(1);
		map.put("funcXml", funcXml);
		rtnList.add(map);
		return rtnList;
	}

}
