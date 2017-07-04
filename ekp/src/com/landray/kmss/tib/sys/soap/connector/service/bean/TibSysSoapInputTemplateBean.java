/**
 * 
 */
package com.landray.kmss.tib.sys.soap.connector.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.header.HeaderOperation;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.SpringBeanUtil;

/**
 * 通过modelName获取xml模版
 * @author 邱建华
 * @version 1.0 2012-12-25
 */
public class TibSysSoapInputTemplateBean implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		String mainName = requestInfo.getParameter("mainName");
		ITibSysSoapMainService TibSysSoapMainService = (ITibSysSoapMainService) SpringBeanUtil
				.getBean("tibSysSoapMainService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibSysSoapMain.docSubject=:docSubject");
		hqlInfo.setParameter("docSubject", mainName);
		TibSysSoapMain main = (TibSysSoapMain) TibSysSoapMainService
				.findList(hqlInfo).get(0);
		String templateXml = main.getWsMapperTemplate();
		templateXml = HeaderOperation.allToPartXmlByPath(templateXml, "/web/Input");
		// 移除禁用的节点
		templateXml = ParseSoapXmlUtil.disableFilter(templateXml);
		map.put("templateXml", templateXml);
		rtnList.add(map);
		return rtnList;
	}
	
}
