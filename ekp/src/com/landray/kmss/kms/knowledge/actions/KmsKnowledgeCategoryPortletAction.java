package com.landray.kmss.kms.knowledge.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryPortalAction;
import com.landray.kmss.util.StringUtil;

/**
 * 知识仓库门户分类导航
 * 
 * @author
 * 
 */
public class KmsKnowledgeCategoryPortletAction extends
		SysSimpleCategoryPortalAction {

	@Override
	public String getHref() {
		return "/kms/knowledge";
	}

	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmsKnowledgeCategoryService == null)
			kmsKnowledgeCategoryService = (IKmsKnowledgeCategoryService) getBean("kmsKnowledgeCategoryService");
		return kmsKnowledgeCategoryService;
	}

	@Override
	// 知识仓库分类隔离
	protected void buildValue(HttpServletRequest request, HQLInfo hqlInfo,
			String tableName) {
		String templateType = request.getParameter("templateType");

		if (StringUtil.isNull(templateType) || "___all".equals(templateType))
			return;
		KmsKnowledgeConstantUtil.buildHqlByTemplateType(templateType, hqlInfo,
				tableName);

	}
}