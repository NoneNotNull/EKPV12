package com.landray.kmss.kms.multidoc.dao.hibernate;

import org.hibernate.Query;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.kms.knowledge.dao.hibernate.KmsKnowledgeBaseDocDaoImp;
import com.landray.kmss.kms.multidoc.dao.IKmsMultidocKnowledgeDao;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.service.spring.KmsMultidocPortletService;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.util.HQLUtil;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档数据访问接口实现
 */
public class KmsMultidocKnowledgeDaoImp extends KmsKnowledgeBaseDocDaoImp implements
		IKmsMultidocKnowledgeDao {
	
	public int updateDocumentTemplate(String ids, String templateId)
			throws Exception {
		String hql = "update KmsMultidocKnowledge kmdoc set kmsMultidocTemplate.fdId='"
				+ templateId
				+ "' where kmdoc.fdId in("
				+ HQLUtil.replaceToSQLString(ids) + ")";
		Query query = getHibernateSession().createQuery(hql);
		return query.executeUpdate();
	}
	
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
		KmsMultidocKnowledge knowledgeDoc = (KmsMultidocKnowledge) modelObj;
		if(knowledgeDoc.getDocStatus().charAt(0) >= '3'){
			KmssCache cache = new KmssCache(KmsMultidocPortletService.class);
			cache.remove(cache.getCacheKeys());
		}
	}

	@Override
	public void updateDocdelete(IBaseModel modelObj) throws Exception {
		this.update(modelObj);
	}
}
