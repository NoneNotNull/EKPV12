package com.landray.kmss.tib.sys.core.provider.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreInfo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCateVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysFuncVo;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSysCoreIfaceRefBean implements IXMLDataBean {
	private Log logger = LogFactory.getLog(this.getClass());

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		String type = requestInfo.getParameter("type");

		if ("cate".equals(type)) {
			rtnList = executeCate(requestInfo);
		} else if ("func".equals(type)) {
			rtnList = executeFunc(requestInfo);
		} else if ("search".equals(type)) {
			rtnList = executeSearch(requestInfo);
		}
		return rtnList;
	}

	public List<Map<String, String>> executeCate(RequestContext requestInfo)
			throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(
				1);
		// j_value 包裹所有数据 {curId：fdIfaceRef： key: }
		String j_value = requestInfo.getParameter("selectId");
		if (StringUtil.isNull(j_value)) {
			List<Map<String, String>> providers = TibSysCoreProviderPlugins
					.getConfigs();
			for (Map<String, String> providerMap : providers) {
				Map<String, String> rtnMap = new HashMap<String, String>();

				String key = providerMap.get("providerKey");
				// 排除自定义服务提供者下的扩展
				if (key.contains("customKey_")) {
					continue;
				}
				String name = providerMap.get("providerName");
				JSONObject json = new JSONObject();
				json.accumulate("key", key);
				json.accumulate("fdIfaceRef", key);
				rtnMap.put("value", json.toString());
				rtnMap.put("text", name);
				rtnList.add(rtnMap);
			}
		} else {
			JSONObject jsonValue = JSONObject.fromObject(j_value);
			String refKey = null;
			String refId = null;
			if(jsonValue.containsKey("fdIfaceRef")){
				refKey = (String) jsonValue.get("fdIfaceRef");
				refId = (String) jsonValue.get("curId");
			}
			if (!StringUtil.isNull(refKey)) {
				Map<String, String> pluginMap = TibSysCoreProviderPlugins
						.getConfigByKey(refKey);
				String beanName = pluginMap.get("infoClass");
				if (StringUtil.isNotNull(beanName)) {
					ITibSysCoreInfo tibSysCoreInfo = (ITibSysCoreInfo) SpringBeanUtil
							.getBean(beanName);
					if (tibSysCoreInfo != null) {
						List<TibSysCateVo> cateVos = tibSysCoreInfo
								.getCateInfo(refId, refKey);
						if (cateVos != null) {
							for (TibSysCateVo cate : cateVos) {
								Map<String, String> rtnMap = new HashMap<String, String>();
								JSONObject json = new JSONObject();
								json.accumulate("curId", cate.getCateId());
								json.accumulate("fdIfaceRef", cate.getContainKey());
								rtnMap.put("value", json.toString());
								rtnMap.put("text", cate.getDisplayName());
								rtnList.add(rtnMap);
							}
						}
					}
				}
			}
		}
		return rtnList;
	}

	public List<Map<String, String>> executeFunc(RequestContext requestInfo)
			throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(
				1);
		// {"curId":"13c6b99317e1528e26a854d4471be9ab","fdIfaceRef":"sap"}
		String j_value = requestInfo.getParameter("selectId");
		if (StringUtil.isNotNull(j_value)) {
			JSONObject json = JSONObject.fromObject(j_value);
			String refKey = (String) json.get("fdIfaceRef");
			String curId = "";
			if (json.containsKey("curId")) {
				curId = json.getString("curId");
			}
			if (!StringUtil.isNull(refKey)) {
				Map<String, String> pluginMap = TibSysCoreProviderPlugins
						.getConfigByKey(refKey);
				String beanName = pluginMap.get("infoClass");
				if (StringUtil.isNotNull(beanName)) {
					ITibSysCoreInfo tibSysCoreInfo = (ITibSysCoreInfo) SpringBeanUtil
							.getBean(beanName);
					// 获取函数信息
					List<TibSysFuncVo> funcVos = tibSysCoreInfo
							.getFuncDataList(curId, refKey);
					if (funcVos != null) {
						for (TibSysFuncVo funcVo : funcVos) {
							String funcId = funcVo.getFuncId();
							String providerKey = funcVo.getContainKey();
							Map<String, String> rtnMap = new HashMap<String, String>();
							JSONObject jso = new JSONObject();
							jso.accumulate("curId", funcVo.getFuncId());
							jso.accumulate("fdIfaceRef", funcVo.getContainKey());
							rtnMap.put("id", funcId);
							rtnMap.put("name", funcVo.getDisplayName());
							rtnMap.put("providerKey", providerKey);
							Map<String, String> pluginInfo = TibSysCoreProviderPlugins
									.getConfigByKey(providerKey);
							if (pluginInfo != null && !pluginInfo.isEmpty()) {
								String providerName = pluginInfo.get("providerName");
								rtnMap.put("providerName", providerName);
							}
							rtnList.add(rtnMap);
						}
					}

				}
			}
		} 
		return rtnList;
	}
	
	public List<Map<String, String>> executeSearch(RequestContext requestInfo)
			throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>(1);
		return rtnList;
	}

}
