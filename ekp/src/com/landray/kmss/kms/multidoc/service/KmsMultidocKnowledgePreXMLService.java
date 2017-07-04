package com.landray.kmss.kms.multidoc.service;

import java.util.ArrayList;
import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 多维库列表页面右边最新知识~最热知识
 * 
 * @author
 * 
 */
public class KmsMultidocKnowledgePreXMLService implements IKmsDataBean {

	private IKmsMultidocKnowledgePreService kmsMultidocKnowledgePreService;

	public void setKmsMultidocKnowledgePreService(
			IKmsMultidocKnowledgePreService kmsMultidocKnowledgePreService) {
		this.kmsMultidocKnowledgePreService = kmsMultidocKnowledgePreService;
	}

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		String listType = requestInfo.getParameter("listType");
		JSONArray rtnList = new JSONArray();
		try {
			if (StringUtil.isNotNull(listType)) {
				List<KmsMultidocKnowledge> list = new ArrayList<KmsMultidocKnowledge>();
				if (listType.equals("hot"))
					list = kmsMultidocKnowledgePreService.getHotDoc();
				if (listType.equals("latest"))
					list = kmsMultidocKnowledgePreService.getLatestDoc();
				for (KmsMultidocKnowledge kml : list) {
					JSONObject json = new JSONObject();
					json.put("docSubject", StringUtil.XMLEscape(kml
							.getDocSubject()));
					json.put("docPublishTime", DateUtil.convertDateToString(kml
							.getDocPublishTime(), "yyyy-MM-dd"));
					json.put("fdId", kml.getFdId());
					json.put("docReadCount", kml.getDocReadCount());
					rtnList.add(json);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtnList;
	}
}
