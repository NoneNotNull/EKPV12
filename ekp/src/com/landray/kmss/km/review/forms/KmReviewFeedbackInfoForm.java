package com.landray.kmss.km.review.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_Common;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.km.review.model.KmReviewFeedbackInfo;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.right.interfaces.BaseAuthForm;
import com.landray.kmss.util.DateUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌
 */
public class KmReviewFeedbackInfoForm extends BaseAuthForm

{
	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = -781110232694790189L;

	/*
	 * 主文档ID
	 */
	private String fdMainId = null;

	/*
	 * 创建人
	 */
	private String docCreatorName = null;

	private String docCreatorId = null;

	/*
	 * 通知人
	 */
	private String fdNotifyId = null;
	private String fdNotifyPeople = null;

	/*
	 * 通知类型
	 */
	private String fdNotifyType = null;

	/*
	 * 提要
	 */
	private String fdSummary = null;

	/*
	 * 反馈时间
	 */
	private String docCreatorTime = null;

	/*
	 * 反馈内容
	 */
	private String docContent = null;
	
	private String fdReaderNames = null;

	/**
	 * @return 返回 提要
	 */
	public String getFdSummary() {
		return fdSummary;
	}

	/**
	 * @param fdSummary
	 *            要设置的 提要
	 */
	public void setFdSummary(String fdSummary) {
		this.fdSummary = fdSummary;
	}

	/**
	 * @return 返回 反馈时间
	 */
	public String getDocCreatorTime() {
		return docCreatorTime;
	}

	/**
	 * @param docCreatorTime
	 *            要设置的 反馈时间
	 */
	public void setDocCreatorTime(String docCreatorTime) {
		this.docCreatorTime = docCreatorTime;
	}

	/**
	 * @return 返回 反馈内容
	 */
	public String getDocContent() {
		return docContent;
	}

	/**
	 * @param docContent
	 *            要设置的 反馈内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}

	public String getDocCreatorName() {
		return docCreatorName;
	}

	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @see org.apache.struts.action.ActionForm#reset(org.apache.struts.action.ActionMapping,
	 *      javax.servlet.http.HttpServletRequest)
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdMainId = null;
		fdNotifyId = null;
		docCreatorId = null;
		docCreatorName = null;
		fdSummary = null;
		docCreatorTime = null;
		docContent = null;
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmReviewFeedbackInfo.class;
	}

	public String getDocCreatorId() {
		return docCreatorId;
	}

	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}



	public String getFdMainId() {
		return fdMainId;
	}

	public void setFdMainId(String fdMainId) {
		this.fdMainId = fdMainId;
	}

	public String getFdNotifyPeople() {
		return fdNotifyPeople;
	}

	public void setFdNotifyPeople(String fdNotifyPeople) {
		this.fdNotifyPeople = fdNotifyPeople;
	}

	public String getFdNotifyType() {
		return fdNotifyType;
	}

	public void setFdNotifyType(String fdNotifyType) {
		this.fdNotifyType = fdNotifyType;
	}

	private static FormToModelPropertyMap formToModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (formToModelPropertyMap == null) {
			formToModelPropertyMap = new FormToModelPropertyMap();
			formToModelPropertyMap.putAll(super.getToModelPropertyMap());
			// 时间
			formToModelPropertyMap.put("docCreatorTime",
					new FormConvertor_Common("docCreateTime")
							.setDateTimeType(DateUtil.TYPE_DATETIME));
			// 创建人
			formToModelPropertyMap.put("docCreatorId",
					new FormConvertor_IDToModel("fdCreator",
							SysOrgElement.class));
			//文档
			formToModelPropertyMap.put("fdMainId",
					new FormConvertor_IDToModel("kmReviewMain",
							KmReviewMain.class));

		}
		return formToModelPropertyMap;
	}

	public String getFdNotifyId() {
		return fdNotifyId;
	}

	public void setFdNotifyId(String fdNotifyId) {
		this.fdNotifyId = fdNotifyId;
	}

	public String getFdReaderNames() {
		return fdReaderNames;
	}

	public void setFdReaderNames(String fdReaderNames) {
		this.fdReaderNames = fdReaderNames;
	}

}
