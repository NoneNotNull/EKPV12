package com.landray.kmss.tib.sap.mapping.service.spring;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * @author zhangwt js执行RFC函数接口
 */
public class TibSapRFCFunctions {

	/*********************************************
	 * BAPI_CONTENT采用的json数据结构在项目文件中有定义
	 **********************************************/
	private static final Log log = LogFactory.getLog(TibSapRFCFunctions.class);

	public static String invokeRFC(String BAPI_NAME, String BAPI_CONTENT)
			throws Exception {
		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
				.getBean("tibSysSapJcoFunctionUtil");
		JSONObject json = (JSONObject) tibSysSapJcoFunctionUtil.getJsonToJson(
				BAPI_NAME, BAPI_CONTENT).getResult();
		String result = json.toString();
		return result;// result的具体结构在项目文件中有定义
	}
}
