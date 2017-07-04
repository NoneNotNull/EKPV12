package com.landray.kmss.km.doc.dao.hibernate;

import org.hibernate.Query;

import com.landray.kmss.km.doc.dao.IKmDocKnowledgeDao;
import com.landray.kmss.sys.doc.dao.hibernate.SysDocBaseInfoDaoImp;
import com.landray.kmss.util.HQLUtil;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档数据访问接口实现
 */
public class KmDocKnowledgeDaoImp extends SysDocBaseInfoDaoImp implements
		IKmDocKnowledgeDao {
	public int updateDocumentTemplate(String ids, String templateId)
			throws Exception {
		String hql = "update KmDocKnowledge kmdoc set kmDocTemplate.fdId='"
				+ templateId + "' where kmdoc.fdId in("
				+ HQLUtil.replaceToSQLString(ids) + ")";
		Query query = getHibernateSession().createQuery(hql);
		return query.executeUpdate();
	}
}
