package com.landray.kmss.sys.news.model;

import com.landray.kmss.common.model.BaseCoreInnerModel;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.authorization.model.SysAuthArea;
import com.landray.kmss.sys.news.forms.SysNewsPublishCategoryForm;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超 发布机制类别
 */
public class SysNewsPublishCategory extends BaseCoreInnerModel implements ISysAuthAreaModel {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = -5373988302788427244L;
	/*
	 * 重要度设置
	 */
	protected java.lang.Long fdImportance;
	/*
	 * 新闻类别
	 */
	protected String fdCategoryId;
	protected String fdCategoryName;

	/*
	 * 审批通过是否自动发布
	 */
	protected Boolean fdIsAutoPublish;

	/*
	 * 需要经过新闻流程
	 */
	protected Boolean fdIsFlow;

	/*
	 * 是否允许修改新闻类别
	 */
	protected Boolean fdIsModifyCate;

	/*
	 * 是否允许修改重要度
	 */
	protected Boolean fdIsModifyImpor;

	public SysNewsPublishCategory() {
		super();
	}

	/**
	 * @return 返回 重要度设置
	 */

	/**
	 * @return 返回 审批通过是否自动发布
	 */
	public Boolean getFdIsAutoPublish() {
		return fdIsAutoPublish;
	}

	/**
	 * @param fdIsAutoPublish
	 *            要设置的 审批通过是否自动发布
	 */
	public void setFdIsAutoPublish(Boolean fdIsAutoPublish) {
		this.fdIsAutoPublish = fdIsAutoPublish;
	}

	/**
	 * @return 返回 需要经过新闻流程
	 */
	public Boolean getFdIsFlow() {
		return fdIsFlow;
	}

	/**
	 * @param fdIsFlow
	 *            要设置的 需要经过新闻流程
	 */
	public void setFdIsFlow(Boolean fdIsFlow) {
		this.fdIsFlow = fdIsFlow;
	}

	/**
	 * @return 返回 是否允许修改新闻类别
	 */
	public Boolean getFdIsModifyCate() {
		return fdIsModifyCate;
	}

	/**
	 * @param fdIsModifyTemp
	 *            要设置的 是否允许修改新闻类别
	 */
	public void setFdIsModifyCate(Boolean fdIsModifyCate) {
		this.fdIsModifyCate = fdIsModifyCate;
	}

	/**
	 * @return 返回 是否允许修改重要度
	 */
	public Boolean getFdIsModifyImpor() {
		return fdIsModifyImpor;
	}

	/**
	 * @param fdIsModifyImpor
	 *            要设置的 是否允许修改重要度
	 */
	public void setFdIsModifyImpor(Boolean fdIsModifyImpor) {
		this.fdIsModifyImpor = fdIsModifyImpor;
	}

	public Class getFormClass() {
		return SysNewsPublishCategoryForm.class;
	}

	/**
	 * @return 返回 新闻类别
	 */
	public String getFdCategoryId() {
		return fdCategoryId;
	}

	public void setFdCategoryId(String fdCategoryId) {
		this.fdCategoryId = fdCategoryId;
	}

	public String getFdCategoryName() {
		return fdCategoryName;
	}

	public void setFdCategoryName(String fdCategoryName) {
		this.fdCategoryName = fdCategoryName;
	}

	public java.lang.Long getFdImportance() {
		return fdImportance;
	}

	public void setFdImportance(java.lang.Long fdImportance) {
		this.fdImportance = fdImportance;
	}
	
	/*
	 * 所属场所
	 */
	protected SysAuthArea authArea;

	public SysAuthArea getAuthArea() {
		return authArea;
	}

	public void setAuthArea(SysAuthArea authArea) {
		this.authArea = authArea;
	}

}
