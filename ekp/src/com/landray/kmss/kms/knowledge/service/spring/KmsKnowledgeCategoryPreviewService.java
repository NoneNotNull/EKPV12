package com.landray.kmss.kms.knowledge.service.spring;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategoryPreview;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.sys.simplecategory.dao.hibernate.ISysSimpleCategoryPreviewDao;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryPreviewModel;
import com.landray.kmss.sys.simplecategory.service.spring.SysSimpleCategoryPreviewServiceImp;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 分类概览service
 * 
 * @author 
 * 
 */
public class KmsKnowledgeCategoryPreviewService extends
		SysSimpleCategoryPreviewServiceImp {
	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;
	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}
	
	protected IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService = null;
	public IKmsKnowledgeBaseDocService getKmsMultidocKnowledgeService() {
		if (kmsKnowledgeBaseDocService == null) {
			kmsKnowledgeBaseDocService = (IKmsKnowledgeBaseDocService) SpringBeanUtil
					.getBean("kmsKnowledgeBaseDocService");
		}
		return kmsKnowledgeBaseDocService;
	}
	
	public void addCategoryPreviewBySomething(String previewContent,String categoryId,
					String authAreaId, String isEnableIsSolation) throws Exception {
		KmsKnowledgeCategoryPreview kmsKnowledgeCategoryPreview 
						        = new KmsKnowledgeCategoryPreview();
		kmsKnowledgeCategoryPreview.setFdId(IDGenerator.generateID());
		kmsKnowledgeCategoryPreview.setCreateDate(new Date());
		kmsKnowledgeCategoryPreview.setAuthAreaId(authAreaId);
		kmsKnowledgeCategoryPreview.setFdPreContent(previewContent);
		kmsKnowledgeCategoryPreview.setIsDataIsolation(isEnableIsSolation);
		if(StringUtil.isNull(categoryId)){
			kmsKnowledgeCategoryPreview.setFdCategoryId(null);
		}else{
			kmsKnowledgeCategoryPreview.setFdCategoryId(categoryId);
		}
		super.add(kmsKnowledgeCategoryPreview);
	}

	public SysSimpleCategoryPreviewModel getCategoryPreview(
			String authAreaId,String categoryId) throws Exception {
		return ((ISysSimpleCategoryPreviewDao) getBaseDao())
				.getCategoryPreview(authAreaId,categoryId);
	}
	
	/**
	 * 获取子级分类
	 * 
	 * @param categoryId
	 * @param authAreaId
	 * @return
	 * @throws Exception
	 */
	public List<SysSimpleCategoryAuthTmpModel> getCategoryList(String categoryId,
			String authAreaId) throws Exception {

		HQLInfo hqlInfo = new HQLInfo();
		String tableName = "kmsKnowledgeCategory";
		StringBuffer whereBlock = new StringBuffer();
		if (StringUtil.isNotNull(categoryId)) {
			whereBlock.append(tableName);
			whereBlock.append(".hbmParent.fdId = :categoryId");
			hqlInfo.setParameter("categoryId", categoryId);
		} else {
			whereBlock.append(tableName);
			whereBlock.append(".hbmParent.fdId is null");
		}
		//whereBlock.append(" and " + tableName
		//		+ ".fdTemplateType in('1','3')");
		hqlInfo.setWhereBlock(whereBlock.toString());
		hqlInfo.setOrderBy(tableName + ".fdOrder," + tableName + ".fdName,"
				+ tableName + ".fdId asc");

		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaIsolation,
				SysAuthConstant.AreaIsolation.BRANCH);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaSpecified,
				authAreaId);
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AuthCheck,
				SysAuthConstant.AuthCheck.SYS_NONE);
		List<SysSimpleCategoryAuthTmpModel> categoryList = this.kmsKnowledgeCategoryService
				.findList(hqlInfo);

		return categoryList;
	}
	
	/**
	 * 根据分类获取文档数量
	 */
	public Integer getDocAmount(SysSimpleCategoryAuthTmpModel sysSimpleCategoryAuthTmpModel,
			String authAreaId) throws Exception {
		
		String fdHierarchyId = sysSimpleCategoryAuthTmpModel.getFdHierarchyId();
		HQLInfo hqlInfo = new HQLInfo();
		String tableName = "kmsKnowledgeBaseDoc";
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
		Integer docAmount = getKmsMultidocKnowledgeService().findList(hqlInfo)
				.size();
		return docAmount;
	}

}
