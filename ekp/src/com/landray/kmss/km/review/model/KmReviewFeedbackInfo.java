package com.landray.kmss.km.review.model;

import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.km.review.forms.KmReviewFeedbackInfoForm;
import com.landray.kmss.sys.notify.interfaces.ISysNotifyModel;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.right.interfaces.BaseAuthModel;
import com.landray.kmss.util.DateUtil;

/**
 * 创建日期 2007-Sep-03
 * 
 * @author 舒斌 反馈信息
 */
public class KmReviewFeedbackInfo extends BaseAuthModel implements
		ISysNotifyModel {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1866597153938233597L;

	/*
	 * 提要
	 */
	protected java.lang.String fdSummary;

	/*
	 * 反馈时间
	 */
	protected java.util.Date docCreateTime;

	/*
	 * 反馈内容
	 */
	protected java.lang.String docContent;

	/*
	 * 通知人员
	 */
	protected java.lang.String fdNotifyPeople;

	/*
	 * 通知方式
	 */
	protected java.lang.String fdNotifyType;

	/*
	 * 审批文档基本信息
	 */
	protected KmReviewMain kmReviewMain = null;

	/*
	 * 创建人
	 */
	protected SysOrgElement fdCreator = null;

	public KmReviewFeedbackInfo() {
		super();
	}

	/**
	 * @return 返回 提要
	 */
	public java.lang.String getFdSummary() {
		return fdSummary;
	}

	/**
	 * @param fdSummary
	 *            要设置的 提要
	 */
	public void setFdSummary(java.lang.String fdSummary) {
		this.fdSummary = fdSummary;
	}

	public java.util.Date getDocCreateTime() {
		return docCreateTime;
	}

	public void setDocCreateTime(java.util.Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}

	/**
	 * @return 返回 反馈内容
	 */
	public java.lang.String getDocContent() {
		return docContent;
	}

	/**
	 * @param docContent
	 *            要设置的 反馈内容
	 */
	public void setDocContent(java.lang.String docContent) {
		this.docContent = docContent;
	}

	/**
	 * @return 返回 通知人员
	 */
	public java.lang.String getFdNotifyPeople() {
		return fdNotifyPeople;
	}

	/**
	 * @param fdNotifyPeople
	 *            要设置的 通知人员
	 */
	public void setFdNotifyPeople(java.lang.String fdNotifyPeople) {
		this.fdNotifyPeople = fdNotifyPeople;
	}

	/**
	 * @return 返回 通知方式
	 */
	public java.lang.String getFdNotifyType() {
		return fdNotifyType;
	}

	/**
	 * @param fdNotifyType
	 *            要设置的 通知方式
	 */
	public void setFdNotifyType(java.lang.String fdNotifyType) {
		this.fdNotifyType = fdNotifyType;
	}

	/**
	 * @return 返回 审批文档基本信息
	 */
	public KmReviewMain getKmReviewMain() {
		return kmReviewMain;
	}

	/**
	 * @param kmReviewMain
	 *            要设置的 审批文档基本信息
	 */
	public void setKmReviewMain(KmReviewMain kmReviewMain) {
		this.kmReviewMain = kmReviewMain;
	}

	public SysOrgElement getFdCreator() {
		return fdCreator;
	}

	public void setFdCreator(SysOrgElement fdCreator) {
		this.fdCreator = fdCreator;
	}

	public Class getFormClass() {
		return KmReviewFeedbackInfoForm.class;
	}

	private static ModelToFormPropertyMap modelToFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (modelToFormPropertyMap == null)
			modelToFormPropertyMap = new ModelToFormPropertyMap();
		modelToFormPropertyMap.putAll(super.getToFormPropertyMap());
		// 创建者
		modelToFormPropertyMap.put("fdCreator.fdName", "docCreatorName");
		// 创建时间
		modelToFormPropertyMap.put("docCreateTime", new ModelConvertor_Common(
				"docCreatorTime").setDateTimeType(DateUtil.TYPE_DATETIME));
		return modelToFormPropertyMap;
	}

	public String getDocSubject() {
		// TODO 自动生成的方法存根
		return null;
	}

}
