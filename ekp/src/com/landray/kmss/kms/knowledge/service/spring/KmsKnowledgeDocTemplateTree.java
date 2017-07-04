package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeDocTemplateService;
import com.landray.kmss.util.StringUtil;

/**
 * 模板选择树
 * 
 * */
public class KmsKnowledgeDocTemplateTree implements IXMLDataBean {

	private IKmsKnowledgeDocTemplateService kmsKnowledgeDocTemplateService;

	
	public void setKmsKnowledgeDocTemplateService(
			IKmsKnowledgeDocTemplateService kmsKnowledgeDocTemplateService) {
		this.kmsKnowledgeDocTemplateService = kmsKnowledgeDocTemplateService;
	}

	public List<?> getDataList(RequestContext requestInfo) throws Exception {
		String type = requestInfo.getParameter("type");
		if ("root".equals(type)) {
			return getRoot(requestInfo);
		} else if ("child".equals(type)) {
			return getChild(requestInfo);
		} else if("search".equals(type)){
			return getSearchResult(requestInfo);
		}
		return null;
	}

	private List<?> getRoot(RequestContext requestInfo) throws Exception {
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		//String selectId = requestInfo.getRequest().getParameter("selectId");
		List<?> list = kmsKnowledgeDocTemplateService.findValue(
				"kmsKnowledgeDocTemplate.fdName,kmsKnowledgeDocTemplate.fdId", null,
				"kmsKnowledgeDocTemplate.fdOrder");
		for (int i = 0; i < list.size(); i++) {
			Object[] info = (Object[]) list.get(i);
			Map<String, Object> node = new HashMap<String, Object>();
			node.put("text", info[0].toString());
			node.put("value", info[1]);
			rtnList.add(node);
		}
		return rtnList;
	}

	private List<?> getChild(RequestContext requestInfo) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setDistinctType(HQLInfo.DISTINCT_YES);
		hqlInfo.setSelectBlock("kmsKnowledgeDocTemplate.fdId,kmsKnowledgeDocTemplate.fdName");
		hqlInfo.setOrderBy("kmsKnowledgeDocTemplate.fdOrder");
		return kmsKnowledgeDocTemplateService.findValue(hqlInfo);
	}
	
	private List<?> getSearchResult(RequestContext requestInfo) throws Exception {
		String key = requestInfo.getRequest().getParameter("key");
		String whereBlock = "";
		HQLInfo hqlInfo = new HQLInfo();
		if (StringUtil.isNotNull(key)) {
			whereBlock = "kmsKnowledgeDocTemplate.fdName like :key or kmsKnowledgeDocTemplate.docContent like :key";
			hqlInfo.setParameter("key", "%"+key+"%");
		}
		hqlInfo.setDistinctType(HQLInfo.DISTINCT_YES);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setSelectBlock("kmsKnowledgeDocTemplate.fdId,kmsKnowledgeDocTemplate.fdName");
		return kmsKnowledgeDocTemplateService.findValue(hqlInfo);
	}
}
