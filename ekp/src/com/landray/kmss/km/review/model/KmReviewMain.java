package com.landray.kmss.km.review.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.IDocSubjectModel;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.review.forms.KmReviewMainForm;
import com.landray.kmss.sys.agenda.interfaces.ISysAgendaMainModel;
import com.landray.kmss.sys.agenda.model.SysAgendaMain;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkModel;
import com.landray.kmss.sys.circulation.interfaces.ISysCirculationModel;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataModel;
import com.landray.kmss.sys.metadata.model.ExtendDataModelInfo;
import com.landray.kmss.sys.notify.interfaces.SysNotifyRemindMainContextModel;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogAutoSaveModel;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.right.interfaces.ExtendAuthModel;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainModel;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessModel;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批文档基本信息
 */
public class KmReviewMain extends ExtendAuthModel implements IAttachment,
		ISysRelationMainModel, ISysReadLogAutoSaveModel, ISysWfMainModel,
		InterceptFieldEnabled, ISysBookmarkModel, ISysCirculationModel,
		IExtendDataModel, IDocSubjectModel
		// ,ISysNotifyRemindMainModel
		, ISysAgendaMainModel {

	protected String fdWorkId = null;
	protected String fdPhaseId = null;

	public String getFdPhaseId() {
		return fdPhaseId;
	}

	public void setFdPhaseId(String fdPhaseId) {
		this.fdPhaseId = fdPhaseId;
	}

	public String getFdModelId() {
		return fdModelId;
	}

	public void setFdModelId(String fdModelId) {
		this.fdModelId = fdModelId;
	}

	public String getFdModelName() {
		return fdModelName;
	}

	public void setFdModelName(String fdModelName) {
		this.fdModelName = fdModelName;
	}

	/*
	 * 主表ID
	 */
	protected String fdModelId = null;
	/*
	 * 主表域模型
	 */
	protected String fdModelName = null;

	public String getFdWorkId() {
		return fdWorkId;
	}

	public void setFdWorkId(String fdWorkId) {
		this.fdWorkId = fdWorkId;
	}

	/*
	 * 主题
	 */
	protected java.lang.String docSubject;

	/*
	 * 当前流水号
	 */
	protected java.lang.Long fdCurrentNumber;

	/*
	 * 申请单编号
	 */
	protected java.lang.String fdNumber;

	/*
	 * 发布时间
	 */
	protected Date docPublishTime;

	/*
	 * 内容
	 */
	protected java.lang.String docContent;

	/*
	 * 文档状态
	 */
	protected java.lang.String docStatus = "10";

	/*
	 * 所有人可阅读标记
	 */
	protected java.lang.Boolean authReaderFlag;

	/*
	 * 模板
	 */
	protected KmReviewTemplate fdTemplate = null;

	/*
	 * 允许修改实施反馈人标志
	 */
	protected String fdFeedbackModify;

	/*
	 * 在发布状态下已经指定过实施反馈人
	 */
	protected java.lang.Long fdFeedbackExecuted;

	public KmReviewMain() {
		super();
	}

	/**
	 * @return 返回 主题
	 */
	public java.lang.String getDocSubject() {
		return docSubject;
	}

	/**
	 * @param docSubject
	 *            要设置的 主题
	 */
	public void setDocSubject(java.lang.String docSubject) {
		this.docSubject = docSubject;
	}

	/**
	 * @return 返回 申请单编号
	 */
	public java.lang.String getFdNumber() {
		return fdNumber;
	}

	/**
	 * @param fdNumber
	 *            要设置的 申请单编号
	 */
	public void setFdNumber(java.lang.String fdNumber) {
		this.fdNumber = fdNumber;
	}

	/**
	 * @return 返回 内容
	 */
	public java.lang.String getDocContent() {
		return (String) readLazyField("docContent", docContent);
	}

	/**
	 * @param docContent
	 *            要设置的 内容
	 */
	public void setDocContent(java.lang.String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * @return 返回 文档状态
	 */
	public java.lang.String getDocStatus() {
		return docStatus;
	}

	/**
	 * @param docStatus
	 *            要设置的 文档状态
	 */
	public void setDocStatus(java.lang.String docStatus) {
		this.docStatus = docStatus;
	}

	/**
	 * @return 返回 所有人可阅读标记
	 */
	public java.lang.Boolean getAuthReaderFlag() {
		if (authReaderFlag == null) {
			return new Boolean(false);
		}
		return authReaderFlag;
	}

	/**
	 * @param authReaderFlag
	 *            要设置的 所有人可阅读标记
	 */
	public void setAuthReaderFlag(java.lang.Boolean authReaderFlag) {
		this.authReaderFlag = authReaderFlag;
	}

	/*
	 * 多对多关联 反馈信息
	 */
	protected List fdFeedbackInfo = new ArrayList();

	/*
	 * 多对多关联 文档相关岗位
	 */
	protected List fdPosts = new ArrayList();

	/*
	 * 多对多关联 流程标签可阅读者
	 */
	protected List fdLableReaders = new ArrayList();

	/*
	 * 多对多关联 文档可反馈者
	 */
	protected List fdFeedback = new ArrayList();

	/*
	 * 多对多关联 其他属性
	 */
	protected List docProperties = new ArrayList();

	/*
	 * 多对多关联 文档关键字
	 */
	protected List docKeyword = new ArrayList();

	public Class getFormClass() {
		return KmReviewMainForm.class;
	}

	public List getDocProperties() {
		return docProperties;
	}

	public void setDocProperties(List docProperties) {
		this.docProperties = docProperties;
	}

	public List getFdFeedback() {
		return fdFeedback;
	}

	public void setFdFeedback(List fdFeedback) {
		this.fdFeedback = fdFeedback;
	}

	public List getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(List docKeyword) {
		this.docKeyword = docKeyword;
	}

	public List getFdLableReaders() {
		return fdLableReaders;
	}

	public void setFdLableReaders(List fdLableReaders) {
		this.fdLableReaders = fdLableReaders;
	}

	public List getFdFeedbackInfo() {
		return fdFeedbackInfo;
	}

	public void setFdFeedbackInfo(List fdFeedbackInfo) {
		this.fdFeedbackInfo = fdFeedbackInfo;
	}

	public List getFdPosts() {
		return fdPosts;
	}

	public void setFdPosts(List fdPosts) {
		this.fdPosts = fdPosts;
	}

	public java.lang.Long getFdCurrentNumber() {
		return fdCurrentNumber;
	}

	public void setFdCurrentNumber(java.lang.Long fdCurrentNumber) {
		this.fdCurrentNumber = fdCurrentNumber;
	}

	private SysOrgElement fdDepartment;

	/**
	 * 部门
	 * 
	 * @return
	 */
	public SysOrgElement getFdDepartment() {
		return fdDepartment;
	}

	/**
	 * 部门
	 * 
	 * @param fdDepartment
	 */
	public void setFdDepartment(SysOrgElement fdDepartment) {
		this.fdDepartment = fdDepartment;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			// 模板
			toFormPropertyMap.put("fdTemplate.fdName",
					new ModelConvertor_Common("fdTemplateName"));
			toFormPropertyMap.put("fdTemplate.fdId", "fdTemplateId");
			toFormPropertyMap.put("fdTemplate.titleRegulation",
					"titleRegulation");
			toFormPropertyMap.put("fdTemplate.titleRegulationName",
					"titleRegulationName");

			toFormPropertyMap.put("fdTemplate.docCategory.fdId",
					"fdDocCategoryId");

			// 相关岗位
			toFormPropertyMap.put("fdPosts",
					new ModelConvertor_ModelListToString(
							"fdPostIds:fdPostNames", "fdId:fdName"));
			// 流程标签可阅读者
			toFormPropertyMap.put("fdLableReaders",
					new ModelConvertor_ModelListToString(
							"fdLableReaderIds:fdLableReaderNames",
							"fdId:fdName"));
			// 反馈人
			toFormPropertyMap.put("fdFeedback",
					new ModelConvertor_ModelListToString(
							"fdFeedbackIds:fdFeedbackNames", "fdId:fdName"));
			// 相关属性
			toFormPropertyMap.put("docProperties",
					new ModelConvertor_ModelListToString(
							"docPropertyIds:docPropertyNames", "fdId:fdName"));
			// 关键字
			toFormPropertyMap.put("docKeyword",
					new ModelConvertor_ModelListToString(
							"fdKeywordIds:fdKeywordNames", "fdId:docKeyword"));
			// 创建人
			toFormPropertyMap.put("docCreator.fdId", new ModelConvertor_Common(
					"docCreatorId"));
			toFormPropertyMap.put("docCreator.fdName",
					new ModelConvertor_Common("docCreatorName"));
			// 创建人部门
			toFormPropertyMap.put("fdDepartment.fdName",
					new ModelConvertor_Common("fdDepartmentName"));
			// 创建时间
			toFormPropertyMap.put("docCreateTime", new ModelConvertor_Common(
					"docCreateTime").setDateTimeType(DateUtil.TYPE_DATETIME));
			// 发布时间
			toFormPropertyMap.put("docPublishTime", new ModelConvertor_Common(
					"docPublishTime").setDateTimeType(DateUtil.TYPE_DATETIME));
		}
		return toFormPropertyMap;
	}

	/**
	 * 附件实现
	 */
	AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
	}

	public KmReviewTemplate getFdTemplate() {
		return fdTemplate;
	}

	public void setFdTemplate(KmReviewTemplate fdTemplate) {
		this.fdTemplate = fdTemplate;
	}

	/*
	 * 关联域模型信息
	 */
	private SysRelationMain sysRelationMain = null;

	public SysRelationMain getSysRelationMain() {
		return sysRelationMain;
	}

	public void setSysRelationMain(SysRelationMain sysRelationMain) {
		this.sysRelationMain = sysRelationMain;
	}

	String relationSeparate = null;

	/**
	 * 获取关联分表字段
	 * 
	 * @return
	 */
	public String getRelationSeparate() {
		return relationSeparate;
	}

	/**
	 * 设置关联分表字段
	 */
	public void setRelationSeparate(String relationSeparate) {
		this.relationSeparate = relationSeparate;
	}

	protected Long docReadCount = new Long(0);

	/*
	 * 设定阅读次数
	 */
	public void setDocReadCount(Long docReadCount) {
		this.docReadCount = docReadCount;
	}

	/*
	 * 获得阅读次数
	 */
	public Long getDocReadCount() {
		return this.docReadCount;
	}

	private String readLogSSeparate = null;

	public String getReadLogSeparate() {
		return readLogSSeparate;
	}

	public void setReadLogSSeparate(String readLogSSeparate) {
		this.readLogSSeparate = readLogSSeparate;

	}

	public String getFdFeedbackModify() {
		return fdFeedbackModify;
	}

	public void setFdFeedbackModify(String fdFeedbackModify) {
		this.fdFeedbackModify = fdFeedbackModify;
	}

	public java.lang.Long getFdFeedbackExecuted() {
		return fdFeedbackExecuted;
	}

	public void setFdFeedbackExecuted(java.lang.Long fdFeedbackExecuted) {
		this.fdFeedbackExecuted = fdFeedbackExecuted;
	}

	public void recalculateFields() {
		super.recalculateFields();
		if (getFdDepartment() == null && getDocCreator() != null) {
			setFdDepartment(getDocCreator().getFdParent());
		}
	}

	protected void recalculateReaderField() {
		super.recalculateReaderField();
		String tmpStatus = getDocStatus();
		if (StringUtil.isNotNull(tmpStatus) && tmpStatus.charAt(0) >= '3') {
			List tempList = this.getFdFeedback();
			if (tempList != null)
				ArrayUtil.concatTwoList(tempList, authAllReaders);
			tempList = this.getFdLableReaders();
			if (tempList != null)
				ArrayUtil.concatTwoList(tempList, authAllReaders);
		}
	}

	/*
	 * 流程机制
	 */
	private SysWfBusinessModel sysWfBusinessModel = new SysWfBusinessModel();

	public SysWfBusinessModel getSysWfBusinessModel() {
		return sysWfBusinessModel;
	}

	/*
	 * 通知机制方法实现
	 */
	private java.lang.String fdNotifyType;

	public java.lang.String getFdNotifyType() {
		return fdNotifyType;
	}

	public void setFdNotifyType(java.lang.String fdNotifyType) {
		this.fdNotifyType = fdNotifyType;
	}

	public Date getDocPublishTime() {
		return docPublishTime;
	}

	public void setDocPublishTime(Date docPublishTime) {
		this.docPublishTime = docPublishTime;
	}

	// *********************收藏机制(开始)***********************//

	private Integer docMarkCount = Integer.valueOf(0);

	public Integer getDocMarkCount() {
		return docMarkCount;
	}

	public void setDocMarkCount(Integer count) {
		this.docMarkCount = count;
	}

	// *********************收藏机制(结束)***********************//

	// 将原有传阅改为传阅机制 modify by yirf
	// ===============传阅机制开始===============
	public String getCirculationSeparate() {
		return null;
	}

	public void setCirculationSeparate(String circulationSeparate) {
	}

	// ===============传阅机制结束===============

	// ============== 表单扩展数据 开始 ==========================
	/*
	 * 表单扩展数据
	 */
	private ExtendDataModelInfo extendDataModelInfo = new ExtendDataModelInfo(
			this);

	public ExtendDataModelInfo getExtendDataModelInfo() {
		return extendDataModelInfo;
	}

	private String extendDataXML;

	public String getExtendDataXML() {
		return (String) readLazyField("extendDataXML", extendDataXML);
	}

	public void setExtendDataXML(String extendDataXML) {
		this.extendDataXML = (String) writeLazyField("extendDataXML",
				this.extendDataXML, extendDataXML);
	}

	private String extendFilePath;

	public String getExtendFilePath() {
		return extendFilePath;
	}

	public void setExtendFilePath(String extendFilePath) {
		this.extendFilePath = extendFilePath;
	}

	// ============== 表单扩展数据 结束 =========================

	/**
	 * 是否使用表单
	 */
	private Boolean fdUseForm = Boolean.FALSE;

	/**
	 * 是否使用表单
	 * 
	 * @return fdUseForm
	 */
	public Boolean getFdUseForm() {
		return fdUseForm;
	}

	/**
	 * 是否使用表单
	 * 
	 * @param fdUseForm
	 *            要设置的 fdUseForm
	 */
	public void setFdUseForm(Boolean fdUseForm) {
		this.fdUseForm = fdUseForm;
	}

	// **********流程管理是否处理完成 开始* **********

	// 1:结束 0：未结束
	private String fdWorkStatus = "0";

	public String getFdWorkStatus() {
		// 若是流程管理 则一旦发布，可将工作项设置为完成状态
		if (SysDocConstant.DOC_STATUS_PUBLISH.equals(docStatus)) {
			fdWorkStatus = "1";
		}
		return fdWorkStatus;
	}

	public void setFdWorkStatus(String fdWorkStatus) {
		this.fdWorkStatus = fdWorkStatus;
	}

	// **********流程管理是否处理完成 结束* **********

	// ==============提醒机制(主文档) 开始====================
	/**
	 * private SysNotifyRemindMainContextModel sysNotifyRemindMainContextModel =
	 * new SysNotifyRemindMainContextModel();
	 * 
	 * public SysNotifyRemindMainContextModel
	 * getSysNotifyRemindMainContextModel() { return
	 * sysNotifyRemindMainContextModel; }
	 * 
	 * public void
	 * setSysNotifyRemindMainContextModel(SysNotifyRemindMainContextModel
	 * sysNotifyRemindMainContextModel) { this.sysNotifyRemindMainContextModel =
	 * sysNotifyRemindMainContextModel; }
	 **/
	// ==============提醒机制(主文档) 结束====================
	// ==============日程机制开始(主文档) 开始=================
	private SysNotifyRemindMainContextModel sysNotifyRemindMainContextModel = null;

	public SysNotifyRemindMainContextModel getSysNotifyRemindMainContextModel() {
		return sysNotifyRemindMainContextModel;
	}

	public void setSysNotifyRemindMainContextModel(
			SysNotifyRemindMainContextModel sysNotifyRemindMainContextModel) {
		this.sysNotifyRemindMainContextModel = sysNotifyRemindMainContextModel;
	}

	private SysAgendaMain sysAgendaMain = null;

	public SysAgendaMain getSysAgendaMain() {
		return sysAgendaMain;
	}

	public void setSysAgendaMain(SysAgendaMain sysAgendaMain) {
		this.sysAgendaMain = sysAgendaMain;
	}

	// ==============日程机制结束(主文档) 结束=================

	/**
	 * 日程机制从当前业务模块同步数据到时间管理模块同步时机
	 */
	private String syncDataToCalendarTime;

	public String getSyncDataToCalendarTime() {
		return syncDataToCalendarTime;
	}

	public void setSyncDataToCalendarTime(String syncDataToCalendarTime) {
		this.syncDataToCalendarTime = syncDataToCalendarTime;
	}

}
