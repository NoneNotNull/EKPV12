package com.landray.kmss.sys.news.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.forms.BaseCoreInnerForm;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.news.model.SysNewsPublishCategory;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超
 */
public class SysNewsPublishCategoryForm extends BaseCoreInnerForm implements ISysAuthAreaForm{

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 4961544142734000417L;
	/*
	 * 重要度设置
	 */
	private String fdImportance = null;
	/*
	 * 新闻类别Id
	 */
	private String fdCategoryId = null;
	/*
	 * 新闻类别名称
	 */
	private String fdCategoryName = null;
	/*
	 * 审批通过是否自动发布
	 */
	private String fdIsAutoPublish = null;
	/*
	 * 需要经过新闻流程
	 */
	private String fdIsFlow = null;
	/*
	 * 是否允许修改新闻类别
	 */
	private String fdIsModifyCate = null;
	/*
	 * 是否允许修改重要度
	 */
	private String fdIsModifyImpor = null;

	/**
	 * @return 返回 重要度设置
	 */
	public String getFdImportance() {
		return fdImportance;
	}

	/**
	 * @param fdImportance
	 *            要设置的 重要度设置
	 */
	public void setFdImportance(String fdImportance) {
		this.fdImportance = fdImportance;
	}

	/**
	 * @return 返回 审批通过是否自动发布
	 */
	public String getFdIsAutoPublish() {
		return fdIsAutoPublish;
	}

	/**
	 * @param fdIsAutoPublish
	 *            要设置的 审批通过是否自动发布
	 */
	public void setFdIsAutoPublish(String fdIsAutoPublish) {
		this.fdIsAutoPublish = fdIsAutoPublish;
	}

	/**
	 * @return 返回 需要经过新闻流程
	 */
	public String getFdIsFlow() {
		return fdIsFlow;
	}

	/**
	 * @param fdIsFlow
	 *            要设置的 需要经过新闻流程
	 */
	public void setFdIsFlow(String fdIsFlow) {
		this.fdIsFlow = fdIsFlow;
	}

	/**
	 * @return 返回 是否允许修改新闻类别
	 */

	/**
	 * @param fdIsModifyTemp
	 *            要设置的 是否允许修改新闻类别
	 */

	/**
	 * @return 返回 是否允许修改重要度
	 */
	public String getFdIsModifyImpor() {
		return fdIsModifyImpor;
	}

	/**
	 * @param fdIsModifyImpor
	 *            要设置的 是否允许修改重要度
	 */
	public void setFdIsModifyImpor(String fdIsModifyImpor) {
		this.fdIsModifyImpor = fdIsModifyImpor;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see org.apache.struts.action.ActionForm#reset(org.apache.struts.action.ActionMapping,
	 *      javax.servlet.http.HttpServletRequest)
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdImportance = null;
		fdCategoryId = null;
		fdCategoryName = null;
		fdIsAutoPublish = null;
		fdIsFlow = null;
		fdIsModifyCate = null;
		fdIsModifyImpor = null;
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return SysNewsPublishCategory.class;
	}

	/**
	 * @return 返回 新闻类别
	 */
	public String getFdCategoryId() {
		return fdCategoryId;
	}

	/**
	 * @param fdTemplateId
	 *            要设置的 新闻类别
	 */
	public void setFdCategoryId(String fdCategoryId) {
		this.fdCategoryId = fdCategoryId;
	}

	public String getFdCategoryName() {
		return fdCategoryName;
	}

	public void setFdCategoryName(String fdCategoryName) {
		this.fdCategoryName = fdCategoryName;
	}

	public String getFdIsModifyCate() {
		return fdIsModifyCate;
	}

	public void setFdIsModifyCate(String fdIsModifyCate) {
		this.fdIsModifyCate = fdIsModifyCate;
	}
	
	// 所属场所ID
	protected String authAreaId = null;

	public String getAuthAreaId() {
		return authAreaId;
	}

	public void setAuthAreaId(String authAreaId) {
		this.authAreaId = authAreaId;
	}

	// 所属场所名称
	protected String authAreaName = null;

	public String getAuthAreaName() {
		return authAreaName;
	}

	public void setAuthAreaName(String authAreaName) {
		this.authAreaName = authAreaName;
	}

}
