package com.landray.kmss.common.dao;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.orm.hibernate3.HibernateObjectRetrievalFailureException;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * 实现了常用的CRUD以及查询等方法，建议大部分的Dao继承。<br>
 * 注意：要继承该类，必须<br>
 * <li>对应的model继承类{@link com.landray.kmss.common.model.IBaseModel BaseModel}；</li>
 * 使用范围：Dao层代码，作为基类调用。
 * 
 * @see IHQLInfo
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class BaseDaoImp extends HibernateDaoSupport implements IBaseDao,
		ApplicationContextAware, SysAuthConstant {
	protected ApplicationContext applicationContext;

	protected IHQLBuilder hqlBuilder = null;

	private String modelName;

	public String add(IBaseModel modelObj) throws Exception {
		TimeCounter.logCurrentTime("Dao-add", true, getClass());
		modelObj.recalculateFields();
		getHibernateTemplate().save(modelObj);
		TimeCounter.logCurrentTime("Dao-add", false, getClass());
		return modelObj.getFdId();
	}

	public void delete(IBaseModel modelObj) throws Exception {
		TimeCounter.logCurrentTime("Dao-delete", true, getClass());
		getHibernateTemplate().delete(modelObj);
		TimeCounter.logCurrentTime("Dao-delete", false, getClass());
	}

	public void flushHibernateSession() {
		getSession().flush();
	}

	public IBaseModel findByPrimaryKey(String id) throws Exception {
		return findByPrimaryKey(id, null, false);
	}

	public IBaseModel findByPrimaryKey(String id, Object modelInfo,
			boolean noLazy) throws Exception {
		TimeCounter.logCurrentTime("Dao-findByPrimaryKey", true, getClass());
		Object rtnVal = null;
		if (id != null) {
			try {
				if (modelInfo == null)
					modelInfo = getModelName();
				if (modelInfo instanceof Class) {
					if (noLazy)
						rtnVal = getHibernateTemplate().get((Class) modelInfo,
								id);
					else
						rtnVal = getHibernateTemplate().load((Class) modelInfo,
								id);
				} else {
					if (noLazy)
						rtnVal = getHibernateTemplate().get((String) modelInfo,
								id);
					else
						rtnVal = getHibernateTemplate().load(
								(String) modelInfo, id);
				}
			} catch (HibernateObjectRetrievalFailureException e) {
			}
		}
		TimeCounter.logCurrentTime("Dao-findByPrimaryKey", false, getClass());
		return (IBaseModel) rtnVal;
	}

	public final List findByPrimaryKeys(String[] ids) throws Exception {
		ArrayList modelList = new ArrayList();
		IBaseModel model;
		for (int i = 0; i < ids.length; i++) {
			model = findByPrimaryKey(ids[i]);
			if (model != null)
				modelList.add(model);
		}
		return modelList;
	}

	public List findList(HQLInfo hqlInfo) throws Exception {
		TimeCounter.logCurrentTime("Dao-findList", true, getClass());
		hqlInfo.setFromBlock(null);
		List rtnList = createHbmQuery(hqlInfo).list();
		TimeCounter.logCurrentTime("Dao-findList", false, getClass());
		return rtnList;
	}

	public List findList(String whereBlock, String orderBy) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderBy);
		return findList(hqlInfo);
	}

	public Page findPage(HQLInfo hqlInfo) throws Exception {
		Page page = null;

		if (hqlInfo.getCheckParam(SysAuthConstant.CheckType.AllCheck) == null) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.DEFAULT);
		}

		int total = hqlInfo.getRowSize();
		if (hqlInfo.isGetCount()) {
			TimeCounter.logCurrentTime("Dao-findPage-count", true, getClass());
			hqlInfo.setGettingCount(true);
			total = ((Long) createHbmQuery(hqlInfo).iterate().next())
					.intValue();
			TimeCounter.logCurrentTime("Dao-findPage-count", false, getClass());
		}
		TimeCounter.logCurrentTime("Dao-findPage-list", true, getClass());
		if (total > 0) {
			hqlInfo.setGettingCount(false);
			// Oracle的排序列若出现重复值，那排序的结果可能不准确，为了避免该现象，若出现了排序列，则强制在最后加上按fdId排序
			String order = hqlInfo.getOrderBy();
			if (StringUtil.isNotNull(order)) {
				String tableName = ModelUtil.getModelTableName(StringUtil
						.isNotNull(hqlInfo.getModelName()) ? hqlInfo
						.getModelName() : getModelName());
				Pattern p = Pattern.compile(",\\s*" + tableName
						+ "\\.fdId\\s*|,\\s*fdId\\s*");
				if (!p.matcher("," + order).find()) {
					hqlInfo.setOrderBy(order + "," + tableName + ".fdId desc");
				}
			}
			page = new Page();
			page.setRowsize(hqlInfo.getRowSize());
			page.setPageno(hqlInfo.getPageNo());
			page.setTotalrows(total);
			page.excecute();
			Query q = createHbmQuery(hqlInfo);
			q.setFirstResult(page.getStart());
			q.setMaxResults(page.getRowsize());
			page.setList(q.list());
		}
		if (page == null) {
			page = Page.getEmptyPage();
		}
		TimeCounter.logCurrentTime("Dao-findPage-list", false, getClass());
		return page;
	}

	public Page findPage(String whereBlock, String orderBy, int pageno,
			int rowsize) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderBy);
		hqlInfo.setPageNo(pageno);
		hqlInfo.setRowSize(rowsize);
		return findPage(hqlInfo);
	}

	public List findValue(HQLInfo hqlInfo) throws Exception {
		TimeCounter.logCurrentTime("Dao-findValue", true, getClass());
		List rtnList = createHbmQuery(hqlInfo).list();
		TimeCounter.logCurrentTime("Dao-findValue", false, getClass());
		return rtnList;
	}

	public Iterator findValueIterator(HQLInfo hqlInfo) throws Exception {
		TimeCounter.logCurrentTime("Dao-findValue", true, getClass());
		Iterator rtnList = createHbmQuery(hqlInfo).iterate();
		TimeCounter.logCurrentTime("Dao-findValue", false, getClass());
		return rtnList;
	}

	public void findValueIterator(HQLInfo hqlInfo, boolean isClear,
			IteratorCallBack callBack) throws Exception {
		TimeCounter.logCurrentTime("Dao-findValueIterator", true, getClass());
		Iterator iterate = findValueIterator(hqlInfo);
		while (iterate.hasNext()) {
			Object obj = iterate.next();
			callBack.exec(obj);
			if (isClear) {
				getSession().flush();
				getSession().clear();
			} else {
				getSession().evict(obj);
			}
		}
		TimeCounter.logCurrentTime("Dao-findValueIterator", false, getClass());
	}

	public List findValue(String selectBlock, String whereBlock, String orderBy)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock(selectBlock);
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderBy);
		return findValue(hqlInfo);
	}

	public Session getHibernateSession() {
		return getSession();
	}

	public String getModelName() {
		return modelName;
	}

	/**
	 * 设置spring提供的applicationContext（spring自动调用）。
	 * 
	 * @see org.springframework.context.ApplicationContextAware#setApplicationContext(org.springframework.context.ApplicationContext)
	 */
	public void setApplicationContext(ApplicationContext applicationContext) {
		this.applicationContext = applicationContext;
	}

	/**
	 * 设置HQL拼装器
	 * 
	 * @param hqlBuilder
	 */
	public void setHqlBuilder(IHQLBuilder hqlBuilder) {
		this.hqlBuilder = hqlBuilder;
	}

	/**
	 * 设置Dao对应的域模型
	 * 
	 * @param modelName
	 */
	public void setModelName(String modelName) {
		this.modelName = modelName;
	}

	public void update(IBaseModel modelObj) throws Exception {
		modelObj.recalculateFields();
		getHibernateTemplate().saveOrUpdate(modelObj);
	}

	protected Query createHbmQuery(HQLInfo hqlInfo) throws Exception {
		if (StringUtil.isNull(hqlInfo.getModelName()))
			hqlInfo.setModelName(getModelName());
		HQLWrapper hqlWrapper = hqlBuilder.buildQueryHQL(hqlInfo);
		String hql = hqlWrapper.getHql();
		Query query = getSession().createQuery(hql);
		if (StringUtil.isNotNull(hqlInfo.getPartition())) {
			query.setComment(hql +" $partition$(" + hqlInfo.getModelName() + "," + hqlInfo.getPartition() + ") ");
		}
		HQLUtil.setParameters(query, hqlWrapper.getParameterList());
		return query;
	}

	public void clearHibernateSession() {
		getSession().clear();
	}

	public boolean isExist(String modelName, String fdId) throws Exception {
		return getSession().createQuery(
				"select fdId from " + modelName + " where fdId=:fdId")
				.setParameter("fdId", fdId).list().size() > 0;
	}

}
