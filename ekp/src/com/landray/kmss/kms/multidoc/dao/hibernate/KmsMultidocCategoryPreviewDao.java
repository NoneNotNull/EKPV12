package com.landray.kmss.kms.multidoc.dao.hibernate;

import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.kms.multidoc.model.KmsMultidocCategoryPreview;
import com.landray.kmss.sys.simplecategory.dao.hibernate.SysSimpleCategoryPreviewDaoImp;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryPreviewModel;
import com.landray.kmss.util.StringUtil;

/**
 * 多维分类概览dao
 * 
 * @author Administrator
 * 
 */
public class KmsMultidocCategoryPreviewDao extends
		SysSimpleCategoryPreviewDaoImp {

	public SysSimpleCategoryPreviewModel getCategoryPreview(
			String authAreaId,String categoryId) throws Exception {
		HQLInfo hql = new HQLInfo();
		if (StringUtil.isNotNull(authAreaId)){
			if(StringUtil.isNotNull(categoryId)){
				hql.setWhereBlock("kmsMultidocCategoryPreview.authAreaId=:authAreaId and kmsMultidocCategoryPreview.fdCategoryId=:fdCategoryId ");
				hql.setParameter("fdCategoryId", categoryId);
			}else{
				hql.setWhereBlock("kmsMultidocCategoryPreview.authAreaId=:authAreaId and kmsMultidocCategoryPreview.fdCategoryId is null ");
			}
			hql.setParameter("authAreaId", authAreaId);
		}else{
			if(StringUtil.isNotNull(categoryId)){
				hql.setWhereBlock("kmsMultidocCategoryPreview.authAreaId is null and kmsMultidocCategoryPreview.fdCategoryId=:fdCategoryId ");
				hql.setParameter("fdCategoryId", categoryId);
			}else{
				hql.setWhereBlock("kmsMultidocCategoryPreview.authAreaId is null and kmsMultidocCategoryPreview.fdCategoryId is null");
			}
		}
		
		List<KmsMultidocCategoryPreview> resutlList = findList(hql);
		KmsMultidocCategoryPreview kmsMultidocCategoryPreview = null;
		if (resutlList != null && !resutlList.isEmpty()) {
			kmsMultidocCategoryPreview = resutlList.get(0);
		}
		return kmsMultidocCategoryPreview;
	}

}
