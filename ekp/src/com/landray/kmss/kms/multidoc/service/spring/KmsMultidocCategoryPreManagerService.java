package com.landray.kmss.kms.multidoc.service.spring;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.sys.simplecategory.service.spring.SysSimpleCategoryPreviewManageServiceImp;

/**
 * 多维分类概览管理
 * 
 * @author Administrator
 * 
 */
public class KmsMultidocCategoryPreManagerService extends
		SysSimpleCategoryPreviewManageServiceImp {

	private final static String MULTIDOC_CATEGORY_URL_PART = "/kms/multidoc/?categoryId=";

	@Override
	protected String buildUrl(String templateId) {
		return MULTIDOC_CATEGORY_URL_PART.concat(templateId);
	}

	@Override
	protected String calculateDocAmount(
			SysSimpleCategoryAuthTmpModel templateModel, String authAreaId)
			throws Exception {
		String fdHierarchyId = templateModel.getFdHierarchyId();
		// SysAuthArea authArea = kmsMultidocTemplate.getAuthArea();
		HQLInfo hqlInfo = new HQLInfo();
		String tableName = "kmsMultidocKnowledge";
		StringBuffer whereBlock = new StringBuffer();
		whereBlock.append("((" + tableName + ".docIsNewVersion=1) and ");
		whereBlock.append(tableName + ".docStatus like '3%') and substring(");
		whereBlock.append(tableName + ".docCategory.fdHierarchyId,1,");
		whereBlock.append(fdHierarchyId.length() + ")='" + fdHierarchyId + "'");

		// String authAreaId = authArea != null ? authArea.getFdId() : null;
		hqlInfo.setWhereBlock(whereBlock.toString());
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
				SysAuthConstant.AuthCheck.SYS_NONE);
		Integer docAmount = mainService.findList(hqlInfo).size();
		return String.valueOf(docAmount);
	}

	public void ____previeQuartz() throws Exception {
		super.____previeQuartz(preService);
	}

}
