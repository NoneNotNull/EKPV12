package com.landray.kmss.kms.knowledge.dao.hibernate;

import java.io.File;
import java.util.Date;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.framework.util.PluginConfigLocationsUtil;
import com.landray.kmss.kms.knowledge.dao.IKmsKnowledgeCategoryDao;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.spring.KmsKnowledgePortletService;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.sys.simplecategory.dao.hibernate.SysSimpleCategoryDaoImp;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.util.UserUtil;

/**
 * 知识分类数据访问接口实现
 * 
 * @author 
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeCategoryDaoImp extends SysSimpleCategoryDaoImp implements IKmsKnowledgeCategoryDao {
	
	public void update(IBaseModel modelObj) throws Exception {
		SysSimpleCategoryAuthTmpModel category = (SysSimpleCategoryAuthTmpModel) modelObj;
		category.setDocAlteror(UserUtil.getUser());
		category.setDocAlterTime(new Date());
		this.clearCache(modelObj);
		super.update(category) ;
	}
	
	private void clearCache(IBaseModel modelObj) {
		if(modelObj  instanceof KmsKnowledgeCategory) {
			KmssCache cache = new KmssCache(KmsKnowledgePortletService.class);
			cache.remove(cache.getCacheKeys());
			if( new File(PluginConfigLocationsUtil.getKmssConfigPath() + "/kms/wiki")
					.exists()) {
				try {
					KmssCache cacheWiki = new KmssCache(Class
							.forName("com.landray.kmss.kms.wiki.service.spring.KmsWikiPortletService"));
					cacheWiki.remove(cacheWiki.getCacheKeys());
				}catch (ClassNotFoundException e) {}		
			}
			if( new File(PluginConfigLocationsUtil.getKmssConfigPath() + "/kms/multidoc")
					.exists()) {
				try {
					KmssCache cacheMulti = new KmssCache(Class
							.forName("com.landray.kmss.kms.multidoc.service.spring.KmsMultidocPortletService"));
					cacheMulti.remove(cacheMulti.getCacheKeys());
				}catch (ClassNotFoundException e) {}
			}
		}
	}
}
