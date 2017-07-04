package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;

/**
 * 校验模板名字不重复
 */
public class KmsKnowledgeCategoryNameCheckService implements IXMLDataBean {

	private IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}

	@SuppressWarnings("unchecked")
	public List getDataList(RequestContext requestInfo) throws Exception {
		// 校验项目名称唯一性
		String fdName = requestInfo.getRequest().getParameter("fdName");
		String fdId = requestInfo.getRequest().getParameter("fdId");
		String parentId = requestInfo.getRequest().getParameter("parentId");
		List rtnList = new ArrayList();
		boolean isExist = kmsKnowledgeCategoryService.checkCategoryNameExist(fdId, fdName,
				parentId);
		rtnList.add(isExist);
		return rtnList;
	}

}
