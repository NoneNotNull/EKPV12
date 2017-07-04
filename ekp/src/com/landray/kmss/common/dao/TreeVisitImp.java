package com.landray.kmss.common.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.ModelUtil;
import com.sunbor.web.tag.Page;

/**
 * 树访问接口的实现。<br>
 * 作用范围：Dao层代码，通过设置不同的参数配置满足业务需求的bean。
 * 
 * @author 叶中奇
 * @version 1.0 2006-6-16
 */
public class TreeVisitImp extends HibernateDaoSupport implements ITreeVisit,
		SysAuthConstant {
	private String findModel;

	private String findParent;

	private String findTable;

	private IHQLBuilder hqlBuilder = null;

	private String treeModel;

	private String treeParent;

	private String treeTable;

	public List findListByParent(String parentId, String whereBlock,
			String orderBy) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setOrderBy(orderBy);
		hqlInfo.setWhereBlock(whereBlock);
		return findListByParent(parentId, hqlInfo);
	}

	public List findListByParent(String parentId, HQLInfo hqlInfo)
			throws Exception {
		if (parentId != null)
			hqlInfo.setWhereBlock(getTreeWhereBlock(parentId, hqlInfo
					.getWhereBlock()));
		HQLWrapper hqlWrapper = hqlBuilder.buildQueryHQL(hqlInfo);
		Query query = this.getSession().createQuery(hqlWrapper.getHql());
		HQLUtil.setParameters(query, hqlWrapper.getParameterList());
		return query.list();
	}

	public Page findPageByParent(String parentId, String whereBlock,
			String orderBy, int pageno, int rowsize) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(whereBlock);
		hqlInfo.setOrderBy(orderBy);
		hqlInfo.setPageNo(pageno);
		hqlInfo.setRowSize(rowsize);
		return findPageByParent(parentId, hqlInfo);
	}

	public Page findPageByParent(String parentId, HQLInfo hqlInfo)
			throws Exception {
		if (parentId != null)
			hqlInfo.setWhereBlock(getTreeWhereBlock(parentId, hqlInfo
					.getWhereBlock()));
		return findPage(hqlInfo);
	}

	public List findValueByParent(String parentId, String selectBlock,
			String whereBlock, String orderBy) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock(selectBlock);
		hqlInfo.setOrderBy(orderBy);
		hqlInfo.setWhereBlock(whereBlock);
		return findValueByParent(parentId, hqlInfo);
	}

	public List findValueByParent(String parentId, HQLInfo hqlInfo)
			throws Exception {
		Session session = this.getSession();
		if (parentId != null)
			hqlInfo.setWhereBlock(getTreeWhereBlock(parentId, hqlInfo
					.getWhereBlock()));
		HQLWrapper hqlWrapper = hqlBuilder.buildQueryHQL(hqlInfo);
		Query query = session.createQuery(hqlWrapper.getHql());
		HQLUtil.setParameters(query, hqlWrapper.getParameterList());
		return query.list();
	}

	protected Page findPage(HQLInfo hqlInfo) throws Exception {
		Page page = null;
		Session session = this.getSession();
		String selectBlock = hqlInfo.getSelectBlock();
		String fromBlock = hqlInfo.getFromBlock();
		String orderBy = hqlInfo.getOrderBy();
		hqlInfo.setModelName(getFindModel());
		// if (hqlInfo.getAuthCheckType() == null)
		// hqlInfo.setAuthCheckType(AUTH_CHECK_READER);
		if (hqlInfo.getCheckParam(SysAuthConstant.CheckType.AllCheck) == null) {
			hqlInfo.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.DEFAULT);
		}

		hqlInfo.setSelectBlock("count(*)");
		hqlInfo.setFromBlock(null);
		hqlInfo.setOrderBy(null);
		hqlInfo.setIsAutoFetch(false);
		HQLWrapper hqlWrapper = hqlBuilder.buildQueryHQL(hqlInfo);
		Query query = session.createQuery(hqlWrapper.getHql());
		HQLUtil.setParameters(query, hqlWrapper.getParameterList());
		int total = ((Long) query.iterate().next()).intValue();
		if (total > 0) {
			hqlInfo.setSelectBlock(selectBlock);
			hqlInfo.setFromBlock(fromBlock);
			hqlInfo.setOrderBy(orderBy);
			hqlInfo.setIsAutoFetch(true);
			page = new Page();
			page.setRowsize(hqlInfo.getRowSize());
			page.setPageno(hqlInfo.getPageNo());
			page.setTotalrows(total);
			page.excecute();
			HQLWrapper hqlWrapper0 = hqlBuilder.buildQueryHQL(hqlInfo);
			Query q = session.createQuery(hqlWrapper0.getHql());
			HQLUtil.setParameters(q, hqlWrapper0.getParameterList());
			q.setFirstResult(page.getStart());
			q.setMaxResults(page.getRowsize());
			page.setList(q.list());
		}
		if (page == null) {
			page = Page.getEmptyPage();
		}
		return page;
	}

	private String getFindModel() {
		if (findModel == null)
			setFindParent(getTreeModel());
		return findModel;
	}

	protected String getFindParent() {
		if (findParent == null)
			setFindParent(getTreeParent());
		return findParent;
	}

	private String getFindTable() {
		if (findTable == null)
			findTable = ModelUtil.getModelTableName(getFindModel());
		return findTable;
	}

	private String getTreeModel() {
		return treeModel;
	}

	private String getTreeParent() {
		return treeParent;
	}

	private String getTreeTable() {
		if (treeTable == null)
			treeTable = ModelUtil.getModelTableName(getTreeModel());
		return treeTable;
	}

	private String getTreeWhereBlock(String parentID, String whereBlock) {
		HashMap parentMap = new HashMap();
		String hqlInfo = "select " + getTreeTable() + "." + getTreeParent()
				+ ".fdId, " + getTreeTable() + ".fdId";
		hqlInfo += " from " + getTreeModel() + " " + getTreeTable();
		Session session = this.getSession();
		List idList = session.createQuery(hqlInfo).list();
		for (int i = 0; i < idList.size(); i++) {
			Object[] idInfo = (Object[]) idList.get(i);
			parentMap.put(idInfo[1], idInfo[0]);
		}
		ArrayList usedID = new ArrayList();
		for (int i = 0; i < idList.size(); i++) {
			Object[] idInfo = (Object[]) idList.get(i);
			for (String curID = (String) idInfo[0]; curID != null; curID = (String) parentMap
					.get(curID)) {
				if (curID.equals(parentID)) {
					usedID.add(idInfo[1]);
					break;
				}
			}

		}
		usedID.add(parentID);
		return (whereBlock == null ? "" : whereBlock + " and ")
				+ HQLUtil.buildLogicIN(getFindTable() + "." + getFindParent()
						+ ".fdId", usedID);
	}

	/**
	 * XML配置参数：需要返回的域模型类类，默认取treeModel
	 * 
	 * @param findModel
	 */
	public void setFindModel(String findModel) {
		this.findModel = findModel;
	}

	/**
	 * XML配置参数：需要返回的域模型中对应树模型的属性名，默认取treeParent
	 * 
	 * @param findParent
	 */
	public void setFindParent(String findParent) {
		this.findParent = findParent;
	}

	/**
	 * XML配置参数：HQL拼装器
	 * 
	 * @param hqlBuilder
	 */
	public void setHqlBuilder(IHQLBuilder hqlBuilder) {
		this.hqlBuilder = hqlBuilder;
	}

	/**
	 * XML配置参数：树的域模型类名
	 * 
	 * @param treeModel
	 */
	public void setTreeModel(String treeModel) {
		this.treeModel = treeModel;
	}

	/**
	 * XML配置参数：树的域模型中父节点的属性名
	 * 
	 * @param treeParent
	 */
	public void setTreeParent(String treeParent) {
		this.treeParent = treeParent;
	}
}
