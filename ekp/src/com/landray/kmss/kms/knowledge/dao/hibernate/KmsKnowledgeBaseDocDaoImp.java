package com.landray.kmss.kms.knowledge.dao.hibernate;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.kms.knowledge.dao.IKmsKnowledgeBaseDocDao;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.service.spring.KmsKnowledgePortletService;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataDaoImp;

/**
 * 文档基本信息数据访问接口实现
 * 
 * @author 
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeBaseDocDaoImp  extends ExtendDataDaoImp implements IKmsKnowledgeBaseDocDao {

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		clearCache(modelObj);
		super.add(modelObj);
		return modelObj.getFdId();
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		clearCache(modelObj);
		super.update(modelObj);
	}

	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		clearCache(modelObj);
		super.delete(modelObj);
	}

	/**
	 * 清除相应类别缓存
	 * 
	 * @param modelObj
	 */
	private void clearCache(IBaseModel modelObj) {
		KmsKnowledgeBaseDoc knowledgeDoc = (KmsKnowledgeBaseDoc) modelObj;
		if(knowledgeDoc.getDocStatus().charAt(0) >= '3'){
			KmssCache cache = new KmssCache(KmsKnowledgePortletService.class);
			cache.remove(cache.getCacheKeys());
		}
	}
}
