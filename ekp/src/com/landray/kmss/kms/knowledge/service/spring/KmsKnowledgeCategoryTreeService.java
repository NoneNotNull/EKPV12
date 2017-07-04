package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.util.StringUtil;

public class KmsKnowledgeCategoryTreeService implements IXMLDataBean{
	private IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}
	
	public List getDataList(RequestContext xmlContext) throws Exception {
		List rtnList = new ArrayList();
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setOrderBy("kmsKnowledgeCategory.fdOrder");
		String whereBlock = null;
		String selectdId = xmlContext.getRequest().getParameter("docCateId");
		
		if (!StringUtil.isNull(selectdId)) {
			whereBlock = "kmsKnowledgeCategory.hbmParent.fdId = :selectdId";
			hqlInfo.setParameter("selectdId", selectdId);
		} else {
			whereBlock = " kmsKnowledgeCategory.hbmParent is null ";
		}
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setSelectBlock("kmsKnowledgeCategory.fdName,kmsKnowledgeCategory.fdId");
		List kmsKnowledgeCategoryList = kmsKnowledgeCategoryService.findList(hqlInfo);
		
		for (int i = 0; i < kmsKnowledgeCategoryList.size(); i++) {
			Object[] info = (Object[]) kmsKnowledgeCategoryList.get(i);
			HashMap node = new HashMap();
			node.put("text", info[0]);
			node.put("value", info[1]);
			node.put("isAutoFetch", "true");
			rtnList.add(node);
		}
		return rtnList;
	}
}
