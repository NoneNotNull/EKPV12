package com.landray.kmss.kms.knowledge.dao.hibernate;

import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategoryPreview;
import com.landray.kmss.sys.simplecategory.dao.hibernate.SysSimpleCategoryPreviewDaoImp;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryPreviewModel;
import com.landray.kmss.util.StringUtil;

/**
 * 分类概览dao
 * @author 
 *
 */
public class KmsKnowledgeCategoryPreviewDao extends
			SysSimpleCategoryPreviewDaoImp {

	public SysSimpleCategoryPreviewModel getCategoryPreview(
			String authAreaId,String categoryId) throws Exception {
		HQLInfo hql = new HQLInfo();
		if (StringUtil.isNotNull(authAreaId)){
			if(StringUtil.isNotNull(categoryId)){
				hql.setWhereBlock("kmsKnowledgeCategoryPreview.authAreaId=:authAreaId and kmsKnowledgeCategoryPreview.fdCategoryId=:fdCategoryId ");
				hql.setParameter("fdCategoryId", categoryId);
			}else{
				hql.setWhereBlock("kmsKnowledgeCategoryPreview.authAreaId=:authAreaId and kmsKnowledgeCategoryPreview.fdCategoryId is null ");
			}
			hql.setParameter("authAreaId", authAreaId);
		}else{
			if(StringUtil.isNotNull(categoryId)){
				hql.setWhereBlock("kmsKnowledgeCategoryPreview.authAreaId is null and kmsKnowledgeCategoryPreview.fdCategoryId=:fdCategoryId ");
				hql.setParameter("fdCategoryId", categoryId);
			}else{
				hql.setWhereBlock("kmsKnowledgeCategoryPreview.authAreaId is null and kmsKnowledgeCategoryPreview.fdCategoryId is null");
			}
		}
		
		List<KmsKnowledgeCategoryPreview> resutlList = findList(hql);
		KmsKnowledgeCategoryPreview kmsKnowledgeCategoryPreview = null;
		if (resutlList != null && !resutlList.isEmpty()) {
			kmsKnowledgeCategoryPreview = resutlList.get(0);
		}
		return kmsKnowledgeCategoryPreview;
	}
	
}