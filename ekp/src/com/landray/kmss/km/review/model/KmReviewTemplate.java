package com.landray.kmss.km.review.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.IBaseTemplateModel;
import com.landray.kmss.km.review.forms.KmReviewTemplateForm;
import com.landray.kmss.sys.agenda.interfaces.ISysAgendaCategoryModel;
import com.landray.kmss.sys.agenda.model.SysAgendaCategory;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.sys.notify.interfaces.SysNotifyRemindCategoryContextModel;
import com.landray.kmss.sys.number.interfaces.ISysNumberModel;
import com.landray.kmss.sys.number.model.SysNumberMainMapp;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.right.interfaces.ExtendAuthTmpModel;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateModel;
import com.landray.kmss.sys.xform.interfaces.ISysFormTemplateModel;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.DateUtil;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批流程模板
 */
public class KmReviewTemplate extends ExtendAuthTmpModel implements
		IBaseTemplateModel, IAttachment, ISysRelationMainModel,
		ISysWfTemplateModel, InterceptFieldEnabled, ISysFormTemplateModel
		// ,ISysNotifyRemindCategoryModel
		, ISysAgendaCategoryModel, ISysNumberModel {

	/*
	 * 模板名称
	 */
	protected java.lang.String fdName;

	/*
	 * 排序号
	 */
	protected java.lang.Long fdOrder;

	/*
	 * 编号前缀
	 */

	private java.lang.String fdNumberPrefix;
	/*
	 * 流程标签可见
	 */
	protected java.lang.Boolean fdLableVisiable;

	/*
	 * 允许修改反馈人
	 */
	protected java.lang.Boolean fdFeedbackModify;

	/*
	 * 内容
	 */
	protected java.lang.String docContent;

	/*
	 * 创建时间
	 */
	protected java.util.Date docCreateTime;

	/*
	 * 标题规则
	 */
	protected java.lang.String titleRegulation;
	protected java.lang.String titleRegulationName;


	/*
	 * 是否外部流程模板
	 */
	public Boolean fdIsExternal;
	/*
	 * 外部流程模板url
	 */
	public String fdExternalUrl;
	
	public Boolean getFdIsExternal() {
		return fdIsExternal;
	}

	public void setFdIsExternal(Boolean fdIsExternal) {
		this.fdIsExternal = fdIsExternal;
	}
	
	public String getFdExternalUrl() {
		return fdExternalUrl;
	}

	public void setFdExternalUrl(String fdExternalUrl) {
		this.fdExternalUrl = fdExternalUrl;
	}

	
	public java.lang.String getTitleRegulation() {
		return titleRegulation;
	}

	public void setTitleRegulation(java.lang.String titleRegulation) {
		this.titleRegulation = titleRegulation;
	}

	public java.lang.String getTitleRegulationName() {
		return titleRegulationName;
	}

	public void setTitleRegulationName(java.lang.String titleRegulationName) {
		this.titleRegulationName = titleRegulationName;
	}

	public KmReviewTemplate() {
		super();
	}

	/**
	 * @return 返回 模板名称
	 */
	public java.lang.String getFdName() {
		return fdName;
	}

	/**
	 * @param fdName
	 *            要设置的 模板名称
	 */
	public void setFdName(java.lang.String fdName) {
		this.fdName = fdName;
	}

	public java.lang.Boolean getFdLableVisiable() {
		return fdLableVisiable;
	}

	public void setFdLableVisiable(java.lang.Boolean fdLableVisiable) {
		this.fdLableVisiable = fdLableVisiable;
	}

	public java.lang.Boolean getFdFeedbackModify() {
		if (null == fdFeedbackModify) {
			fdFeedbackModify = new Boolean(false);
		}
		return fdFeedbackModify;
	}

	public void setFdFeedbackModify(java.lang.Boolean fdFeedbackModify) {
		this.fdFeedbackModify = fdFeedbackModify;
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
	 * @return 返回 创建时间
	 */
	public java.util.Date getDocCreateTime() {
		return docCreateTime;
	}

	/**
	 * @param docCreateTime
	 *            要设置的 创建时间
	 */
	public void setDocCreateTime(java.util.Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}

	/*
	 * 多对多关联 模板相关岗位
	 */
	protected List fdPosts = new ArrayList();

	/*
	 * 分类
	 */
	protected SysCategoryMain docCategory = null;

	/*
	 * 多对多关联 模板相关属性
	 */
	protected List docProperties = new ArrayList();

	/*
	 * 多对多关联 流程标签可阅读者
	 */
	protected List fdLabelReaders = new ArrayList();

	/*
	 * 多对多关联 反馈者
	 */
	protected List fdFeedback = new ArrayList();

	/*
	 * 多对多关联 审批流程模板关键字
	 */
	protected List docKeyword = new ArrayList();

	public Class getFormClass() {
		return KmReviewTemplateForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			// 类别
			toFormPropertyMap.put("docCategory.fdName", "fdCategoryName");
			toFormPropertyMap.put("docCategory.fdId", "fdCategoryId");
			// 相关岗位
			toFormPropertyMap.put("fdPosts",
					new ModelConvertor_ModelListToString(
							"fdPostIds:fdPostNames", "fdId:fdName"));
			// 相关属性
			toFormPropertyMap.put("docProperties",
					new ModelConvertor_ModelListToString(
							"docPropertyIds:docPropertyNames", "fdId:fdName"));
			// 流程标签可阅读者
			toFormPropertyMap.put("fdLabelReaders",
					new ModelConvertor_ModelListToString(
							"fdLabelReaderIds:fdLabelReaderNames",
							"fdId:fdName"));
			// 可反馈者
			toFormPropertyMap.put("fdFeedback",
					new ModelConvertor_ModelListToString(
							"fdFeedBackIds:fdFeedbackNames", "fdId:fdName"));
			// 关键字
			toFormPropertyMap.put("docKeyword",
					new ModelConvertor_ModelListToString(
							"fdKeywordIds:fdKeywordNames", "fdId:docKeyword"));
			// 模板创建者
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			// 创建时间
			toFormPropertyMap.put("docCreateTime", new ModelConvertor_Common(
					"docCreateTime").setDateTimeType(DateUtil.TYPE_DATETIME));

			// 模板修改者
			toFormPropertyMap.put("docAlteror.fdName", "docAlterorName");
			// 修改时间
			toFormPropertyMap.put("docAlterTime", new ModelConvertor_Common(
					"docAlterTime").setDateTimeType(DateUtil.TYPE_DATETIME));
		}
		return toFormPropertyMap;
	}

	public java.lang.Long getFdOrder() {
		return fdOrder;
	}

	public void setFdOrder(java.lang.Long fdOrder) {
		this.fdOrder = fdOrder;
	}

	/**
	 * 附件实现
	 */
	AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
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

	public List getFdLabelReaders() {
		return fdLabelReaders;
	}

	public void setFdLabelReaders(List fdLabelReaders) {
		this.fdLabelReaders = fdLabelReaders;
	}

	public List getFdPosts() {
		return fdPosts;
	}

	public void setFdPosts(List fdPosts) {
		this.fdPosts = fdPosts;
	}

	public SysCategoryMain getDocCategory() {
		return docCategory;
	}

	public void setDocCategory(SysCategoryMain docCategory) {
		this.docCategory = docCategory;
	}

	public java.lang.String getFdNumberPrefix() {
		return fdNumberPrefix;
	}

	public void setFdNumberPrefix(java.lang.String fdNumberPrefix) {
		this.fdNumberPrefix = fdNumberPrefix;
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

	public String getRelationSeparate() {
		return relationSeparate;
	}

	public void setRelationSeparate(String relationSeparate) {
		this.relationSeparate = relationSeparate;
	}

	/**
	 * 流程模板
	 */
	private List sysWfTemplateModels;

	public List getSysWfTemplateModels() {
		return sysWfTemplateModels;
	}

	public void setSysWfTemplateModels(List sysWfTemplateModels) {
		this.sysWfTemplateModels = sysWfTemplateModels;
	}

	/**
	 * 表单模板
	 */
	private List sysFormTemplateModels;

	public List getSysFormTemplateModels() {
		return sysFormTemplateModels;
	}

	public void setSysFormTemplateModels(List sysFormTemplateModels) {
		this.sysFormTemplateModels = sysFormTemplateModels;
	}

	// /*
	// * 文件地址
	// */
	// private String fdExtFilePath;
	//
	// public String getFdExtFilePath() {
	// return XFormUtil.getFileName(sysFormTemplateModels, "reviewMainDoc");
	// }
	//
	// public void setFdExtFilePath(String filePath) {
	// fdExtFilePath = filePath;
	// }

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

	private SysOrgPerson docAlteror;

	/**
	 * 修改者
	 * 
	 * @return docAlteror
	 */
	public SysOrgPerson getDocAlteror() {
		return docAlteror;
	}

	/**
	 * @param docAlteror
	 *            要设置的 docAlteror
	 */
	public void setDocAlteror(SysOrgPerson docAlteror) {
		this.docAlteror = docAlteror;
	}

	private Date docAlterTime;

	/**
	 * 修改时间
	 * 
	 * @return docAlterTime
	 */
	public Date getDocAlterTime() {
		return docAlterTime;
	}

	/**
	 * @param docAlterTime
	 *            要设置的 docAlterTime
	 */
	public void setDocAlterTime(Date docAlterTime) {
		this.docAlterTime = docAlterTime;
	}

	// ==============提醒机制(分类) 开始====================
	/**
	 * private SysNotifyRemindCategoryContextModel
	 * sysNotifyRemindCategoryContextModel = new
	 * SysNotifyRemindCategoryContextModel();
	 * 
	 * public SysNotifyRemindCategoryContextModel
	 * getSysNotifyRemindCategoryContextModel() { return
	 * sysNotifyRemindCategoryContextModel; }
	 * 
	 * public void setSysNotifyRemindCategoryContextModel(
	 * SysNotifyRemindCategoryContextModel sysNotifyRemindCategoryContextModel)
	 * { this.sysNotifyRemindCategoryContextModel =
	 * sysNotifyRemindCategoryContextModel; }
	 **/
	// ==============提醒机制(分类) 结束====================
	// ==============日程机制开始(分类) 开始=================
	private SysNotifyRemindCategoryContextModel sysNotifyRemindCategoryContextModel = new SysNotifyRemindCategoryContextModel();

	public SysNotifyRemindCategoryContextModel getSysNotifyRemindCategoryContextModel() {
		return sysNotifyRemindCategoryContextModel;
	}

	public void setSysNotifyRemindCategoryContextModel(
			SysNotifyRemindCategoryContextModel sysNotifyRemindCategoryContextModel) {
		this.sysNotifyRemindCategoryContextModel = sysNotifyRemindCategoryContextModel;
	}

	private SysAgendaCategory sysAgendaCategory = new SysAgendaCategory();

	public SysAgendaCategory getSysAgendaCategory() {
		return sysAgendaCategory;
	}

	public void setSysAgendaCategory(SysAgendaCategory sysAgendaCategory) {
		this.sysAgendaCategory = sysAgendaCategory;
	}

	// ==============日程机制结束(分类) 结束=================

	/**
	 * 日程机制从当前业务模块同步数据到时间管理模块同步时机
	 */
	private String syncDataToCalendarTime = "noSync";

	public String getSyncDataToCalendarTime() {
		return syncDataToCalendarTime;
	}

	public void setSyncDataToCalendarTime(String syncDataToCalendarTime) {
		this.syncDataToCalendarTime = syncDataToCalendarTime;
	}

	/**
	 * 编号机制
	 */
	private SysNumberMainMapp sysNumberMainMapp = new SysNumberMainMapp();

	public SysNumberMainMapp getSysNumberMainMappModel() {
		return sysNumberMainMapp;
	}

	public void setSysNumberMainMappModel(SysNumberMainMapp sysNumberMainMapp1) {
		this.sysNumberMainMapp = sysNumberMainMapp1;
	}

}
