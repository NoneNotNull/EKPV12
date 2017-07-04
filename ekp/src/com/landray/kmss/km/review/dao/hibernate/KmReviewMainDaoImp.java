package com.landray.kmss.km.review.dao.hibernate;

import java.util.List;

import org.hibernate.Query;

import com.landray.kmss.km.review.dao.IKmReviewMainDao;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataDaoImp;
import com.landray.kmss.util.HQLUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批文档基本信息数据访问接口实现
 */
public class KmReviewMainDaoImp extends ExtendDataDaoImp implements
		IKmReviewMainDao {

	public Object[] getCurrentFlowNumber(String templateId,
			String fdNumberPattern) throws Exception {
		String hql = "SELECT m.fdId,m.fdCurrentNumber,m.fdNumber  FROM KmReviewMain AS m WHERE "
				+ "m.fdNumber=(select max(t.fdNumber) from KmReviewMain AS t where t.fdTemplate.fdId='"
				+ templateId
				+ "' AND t.fdNumber like '"
				+ fdNumberPattern
				+ "%')";
		Query query = getHibernateSession().createQuery(hql);
		List list = query.list();
		if (list != null && list.size() > 0) {
			return (Object[]) list.get(0);
		} else {
			return new Object[3];
		}
	}

	public int updateDocumentTemplate(String ids, String templateId)
			throws Exception {
		String hql = "update KmReviewMain set fdTemplate.fdId='" + templateId
				+ "' where fdId in(" + HQLUtil.replaceToSQLString(ids) + ")";
		Query query = getHibernateSession().createQuery(hql);
		return query.executeUpdate();
	}

}
