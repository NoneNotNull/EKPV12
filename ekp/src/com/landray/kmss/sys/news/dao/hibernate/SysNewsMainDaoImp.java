package com.landray.kmss.sys.news.dao.hibernate;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.hibernate.Query;

import com.landray.kmss.common.dao.BaseCreateInfoDaoImp;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.BaseTreeConstant;
import com.landray.kmss.sys.cache.KmssCache;
import com.landray.kmss.sys.news.dao.ISysNewsMainDao;
import com.landray.kmss.sys.news.model.SysNewsMain;
import com.landray.kmss.sys.news.service.spring.SysNewsMainPortlet;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 新闻主表单数据访问接口实现
 */
public class SysNewsMainDaoImp extends BaseCreateInfoDaoImp implements
		ISysNewsMainDao {
	public void updateTopAgent() throws Exception {
		String hql = "update SysNewsMain set fdTopTime=null, fdTopEndTime=null, fdIsTop=0 where fdTopEndTime<:now";
		Query query = getHibernateSession().createQuery(hql);
		query.setParameter("now", new Date());
		query.executeUpdate();
	}

	public List getNewsPath(String templateId) throws Exception {
		String hql = "select c.fdHierarchyId from SysCategoryMain c,SysNewsTemplate t where t.docCategory.fdId=c.fdId and t.fdId=:templateId";
		Query query = this.getHibernateSession().createQuery(hql).setParameter(
				"templateId", templateId);
		List list = query.list();
		String hierarchId = null;
		if (list.size() > 0)
			hierarchId = (String) list.get(0);
		if (StringUtil.isNotNull(hierarchId))
			hierarchId = hierarchId.substring(1, hierarchId.length() - 1);
		String ids[] = hierarchId.split("x");
		StringBuffer buffer = new StringBuffer();
		for (int i = 0; i < ids.length; i++) {
			buffer.append("'" + ids[i] + "'");
			if (i != ids.length - 1)
				buffer.append(",");
		}
		hql = "select fdId,fdName from SysCategoryMain where fdId in ("
				+ buffer.toString() + ") order by fdId";
		query = this.getHibernateSession().createQuery(hql);
		list = query.list();
		List returnList = new ArrayList();
		Object obj[];
		for (int j = 0; j < ids.length; j++) {
			for (int i = 0; i < list.size(); i++) {
				obj = (Object[]) list.get(i);
				if (ids[j].equals(obj[0].toString())) {
					returnList.add(obj[1]);
					break;
				}
			}
		}
		return returnList;
	}

	@Override
	public String add(IBaseModel modelObj) throws Exception {
		SysNewsMain sysNewsMain = (SysNewsMain) modelObj;
		String fdHierarchyId = sysNewsMain.getFdTemplate().getFdHierarchyId();
		super.add(modelObj);
		// 状态为发布后则清理缓存
		if (sysNewsMain.getDocStatus().charAt(0) >= '3') {
			clearCache(fdHierarchyId);
		}
		return modelObj.getFdId();
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		SysNewsMain sysNewsMain = (SysNewsMain) modelObj;
		String fdHierarchyId = sysNewsMain.getFdTemplate().getFdHierarchyId();
		String fdOldHierarchyId = sysNewsMain.getFdOldTemplate()
				.getFdHierarchyId();
		super.update(modelObj);
		// 发布后更改文档则清理缓存
		if (sysNewsMain.getDocStatus().charAt(0) >= '3') {
			clearCache(fdHierarchyId);
			if (!fdHierarchyId.equals(fdOldHierarchyId)) {
				clearCache(fdOldHierarchyId);
			}
		}
	}

	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		SysNewsMain sysNewsMain = (SysNewsMain) modelObj;
		String fdHierarchyId = sysNewsMain.getFdTemplate().getFdHierarchyId();
		super.delete(modelObj);
		clearCache(fdHierarchyId);
	}

	/**
	 * 清除相应类别缓存
	 * 
	 * @param fdTemplateId
	 */
	private void clearCache(String fdHierarchyId) {
		KmssCache cache = new KmssCache(SysNewsMainPortlet.class);
		List<String> keys;
		if (StringUtil.isNotNull(fdHierarchyId)) {
			keys = ArrayUtil.convertArrayToList(fdHierarchyId
					.split(BaseTreeConstant.HIERARCHY_ID_SPLIT));
		} else {
			keys = new ArrayList<String>();
		}
		keys.add("all");
		cache.remove(keys);
	}
}
