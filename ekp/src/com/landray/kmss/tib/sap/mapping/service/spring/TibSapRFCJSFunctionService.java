package com.landray.kmss.tib.sap.mapping.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * @author zhangwt 公式执行RFC函数接口
 * 
 */
public class TibSapRFCJSFunctionService implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		String BAPI_NAME = requestInfo.getParameter("BAPI_NAME");
		String BAPI_CONTENT = requestInfo.getParameter("BAPI_CONTENT");
		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
		JSONObject json = (JSONObject) tibSysSapJcoFunctionUtil.getJsonToJson(
				BAPI_NAME, BAPI_CONTENT).getResult();
		String result = json.toString();// result的具体结构在项目文件中有定义
		List rtnList = new ArrayList();
		Map map = new HashMap();
		map.put("result", result);
		rtnList.add(map);
		return rtnList;
	}

}
