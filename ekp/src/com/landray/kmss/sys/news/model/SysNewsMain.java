package com.landray.kmss.sys.news.model;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.plugins.interfaces.IKmCkoModifyLogModel;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationModel;
import com.landray.kmss.sys.news.constant.SysNewsConstant;
import com.landray.kmss.sys.news.forms.SysNewsMainForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogAutoSaveModel;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.right.interfaces.ExtendAuthModel;
import com.landray.kmss.sys.tag.interfaces.ISysTagMainModel;
import com.landray.kmss.sys.tag.model.SysTagMain;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainModel;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessModel;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.DateUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 新闻主表单
 */
public class SysNewsMain extends ExtendAuthModel implements IAttachment,
		ISysRelationMainModel, ISysEvaluationModel, ISysReadLogAutoSaveModel,
		ISysWfMainModel, IKmCkoModifyLogModel, InterceptFieldEnabled,
		ISysTagMainModel {
	/*
	 * 主题
	 */
	protected java.lang.String docSubject;
	/*
	 * 新闻简要
	 */
	protected java.lang.String fdDescription;

	/*
	 * 新闻来源
	 */
	protected java.lang.String fdNewsSource;

	/*
	 * 修改时间
	 */
	protected java.util.Date docAlterTime;

	/*
	 * 发布时间
	 */
	protected java.util.Date docPublishTime;

	/*
	 * 文档内容
	 */
	protected java.lang.String docContent;

	/*
	 * 新闻重要度
	 */
	protected java.lang.Long fdImportance;

	/*
	 * 置顶有效期
	 */
	protected java.lang.Long fdTopDays;

	/*
	 * 标题图片
	 */
	protected java.lang.Long fdMainPicture;

	/*
	 * 内容简介
	 */
	protected java.lang.String fdSummary;

	/*
	 * 置顶时间
	 */
	protected java.util.Date fdTopTime;

	protected Boolean fdIsPicNews;

	/*
	 * 置顶失效时间
	 */
	protected java.util.Date fdTopEndTime;

	/*
	 * 是否链接新闻
	 */
	protected java.lang.Boolean fdIsLink;

	/*
	 * 域模型名称
	 */
	protected java.lang.String fdModelName;

	/*
	 * 域模型ID
	 */
	protected java.lang.String fdModelId;

	/*
	 * 域关键字
	 */
	protected java.lang.String fdKey;

	/*
	 * 新闻链接
	 */
	protected java.lang.String fdLinkUrl;

	protected Boolean fdIsTop;

	/*
	 * 滚动新闻标记
	 */
	protected java.lang.Boolean fdIsRolls;

	/*
	 * 修改者
	 */
	protected SysOrgElement fdModify = null;

	/*
	 * 作者
	 */
	protected SysOrgElement fdAuthor = null;

	/*
	 * 所属部门
	 */
	protected SysOrgElement fdDepartment = null;

	/*
	 * 新闻模板设置
	 */
	protected SysNewsTemplate fdTemplate = null;

	/*
	 * 文档关键字
	 */
	private List docKeyword = new ArrayList();

	/*
	 * 创建人IP
	 */
	protected String docCreatorClientIp = null;

	public String getDocCreatorClientIp() {
		return docCreatorClientIp;
	}

	public void setDocCreatorClientIp(String docCreatorClientIp) {
		this.docCreatorClientIp = docCreatorClientIp;
	}

	/*
	 * 文档内容的编辑方式
	 */
	protected String fdContentType;

	public String getFdContentType() {
		if (StringUtil.isNull(fdContentType)) {
			return SysNewsConstant.FDCONTENTTYPE_RTF;
		}
		return fdContentType;
	}

	public void setFdContentType(String fdContentType) {
		this.fdContentType = fdContentType;
	}

	/*
	 * 文档内容的HTML
	 */
	protected String fdHtmlContent;

	public String getFdHtmlContent() {
		return (String) readLazyField("fdHtmlContent", fdHtmlContent);
	}

	public void setFdHtmlContent(String fdHtmlContent) {
		this.fdHtmlContent = (String) writeLazyField("fdHtmlContent",
				this.fdHtmlContent, fdHtmlContent);
	}

	public SysNewsMain() {
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

	public java.lang.String getFdDescription() {
		return fdDescription;
	}

	public void setFdDescription(java.lang.String fdDescription) {
		this.fdDescription = fdDescription;
	}

	/**
	 * @return 返回 修改时间
	 */
	public java.util.Date getDocAlterTime() {
		return docAlterTime;
	}

	/**
	 * @param docAlterTime
	 *            要设置的 修改时间
	 */
	public void setDocAlterTime(java.util.Date docAlterTime) {
		this.docAlterTime = docAlterTime;
	}

	/**
	 * @return 返回 发布时间
	 */
	public java.util.Date getDocPublishTime() {
		return docPublishTime;
	}

	/**
	 * @param docPublishTime
	 *            要设置的 发布时间
	 */
	public void setDocPublishTime(java.util.Date docPublishTime) {
		this.docPublishTime = docPublishTime;
	}

	/**
	 * @return 返回 文档内容
	 */
	public java.lang.String getDocContent() {
		return (String) readLazyField("docContent", docContent);
	}

	/**
	 * @param docContent
	 *            要设置的 文档内容
	 */
	public void setDocContent(java.lang.String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * @return 返回 新闻重要度
	 */
	public java.lang.Long getFdImportance() {
		return fdImportance;
	}

	/**
	 * @param fdImportance
	 *            要设置的 新闻重要度
	 */
	public void setFdImportance(java.lang.Long fdImportance) {
		this.fdImportance = fdImportance;
	}

	/**
	 * @return 返回 置顶有效期
	 */
	public java.lang.Long getFdTopDays() {
		return fdTopDays;
	}

	/**
	 * @param fdTopDays
	 *            要设置的 置顶有效期
	 */
	public void setFdTopDays(java.lang.Long fdTopDays) {
		this.fdTopDays = fdTopDays;
	}

	/**
	 * @return 返回 标题图片
	 */
	public java.lang.Long getFdMainPicture() {
		return fdMainPicture;
	}

	/**
	 * @param fdMainPicture
	 *            要设置的 标题图片
	 */
	public void setFdMainPicture(java.lang.Long fdMainPicture) {
		this.fdMainPicture = fdMainPicture;
	}

	/**
	 * @return 返回 内容简介
	 */
	public java.lang.String getFdSummary() {
		return fdSummary;
	}

	/**
	 * @param fdSummary
	 *            要设置的 内容简介
	 */
	public void setFdSummary(java.lang.String fdSummary) {
		this.fdSummary = fdSummary;
	}

	/**
	 * @return 返回 置顶时间
	 */
	public java.util.Date getFdTopTime() {
		return fdTopTime;
	}

	/**
	 * @param fdTopTime
	 *            要设置的 置顶时间
	 */
	public void setFdTopTime(java.util.Date fdTopTime) {
		this.fdTopTime = fdTopTime;
	}

	/**
	 * @return 返回 是否链接新闻
	 */
	public java.lang.Boolean getFdIsLink() {
		return fdIsLink;
	}

	/**
	 * @param fdIsLink
	 *            要设置的 是否链接新闻
	 */
	public void setFdIsLink(java.lang.Boolean fdIsLink) {
		this.fdIsLink = fdIsLink;
	}

	/**
	 * @return 返回 域模型名称
	 */
	public java.lang.String getFdModelName() {
		return fdModelName;
	}

	/**
	 * @param fdModuleName
	 *            要设置的 域模型名称
	 */
	public void setFdModelName(java.lang.String fdModuleName) {
		this.fdModelName = fdModuleName;
	}

	/**
	 * @return 返回 域模型ID
	 */
	public java.lang.String getFdModelId() {
		return fdModelId;
	}

	/**
	 * @param fdModuleId
	 *            要设置的 域模型ID
	 */
	public void setFdModelId(java.lang.String fdModuleId) {
		this.fdModelId = fdModuleId;
	}

	/**
	 * @return 返回 域关键字
	 */
	public java.lang.String getFdKey() {
		return fdKey;
	}

	/**
	 * @param fdModuleKey
	 *            要设置的 域关键字
	 */
	public void setFdKey(java.lang.String fdModuleKey) {
		this.fdKey = fdModuleKey;
	}

	/**
	 * @return 返回 新闻链接
	 */
	public java.lang.String getFdLinkUrl() {
		return fdLinkUrl;
	}

	/**
	 * @param fdLinkUrl
	 *            要设置的 新闻链接
	 */
	public void setFdLinkUrl(java.lang.String fdLinkUrl) {
		this.fdLinkUrl = fdLinkUrl;
	}

	/**
	 * @return 返回 滚动新闻标记
	 */
	public java.lang.Boolean getFdIsRolls() {
		return fdIsRolls;
	}

	/**
	 * @param fdIsRolls
	 *            要设置的 滚动新闻标记
	 */
	public void setFdIsRolls(java.lang.Boolean fdIsRolls) {
		this.fdIsRolls = fdIsRolls;
	}

	public Class getFormClass() {
		return SysNewsMainForm.class;
	}

	public List getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(List docKeyword) {
		this.docKeyword = docKeyword;
	}

	public SysOrgElement getFdAuthor() {
		return fdAuthor;
	}

	public void setFdAuthor(SysOrgElement fdAuthor) {
		this.fdAuthor = fdAuthor;
	}

	public SysOrgElement getFdDepartment() {
		return fdDepartment;
	}

	public void setFdDepartment(SysOrgElement fdDepartment) {
		this.fdDepartment = fdDepartment;
	}

	public SysOrgElement getFdModify() {
		return fdModify;
	}

	public void setFdModify(SysOrgElement fdModify) {
		this.fdModify = fdModify;
	}

	private SysNewsTemplate fdOldTemplate = null;

	public SysNewsTemplate getFdOldTemplate() {
		return fdOldTemplate;
	}

	public SysNewsTemplate getFdTemplate() {
		return fdTemplate;
	}

	public void setFdTemplate(SysNewsTemplate fdTemplate) {
		this.fdTemplate = fdTemplate;
		if (fdOldTemplate == null) {
			this.fdOldTemplate = fdTemplate;
		}
	}

	private static ModelToFormPropertyMap modelToFormPropertyMap = null;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (modelToFormPropertyMap == null) {
			modelToFormPropertyMap = new ModelToFormPropertyMap();
			modelToFormPropertyMap.putAll(super.getToFormPropertyMap());
			// 创建者
			modelToFormPropertyMap.put("docCreator.fdId", "fdCreatorId");
			modelToFormPropertyMap.put("docCreator.fdName", "fdCreatorName");
			// 创建时间
			modelToFormPropertyMap.put("docCreateTime", new ModelConvertor_Common(
			"docCreateTime").setDateTimeType(DateUtil.TYPE_DATE));
			// 修改者
			modelToFormPropertyMap.put("fdModify.fdId", "fdModifyId");
			modelToFormPropertyMap.put("fdModify.fdName", "fdModifyName");
			// 作者
			modelToFormPropertyMap.put("fdAuthor.fdId", "fdAuthorId");
			modelToFormPropertyMap.put("fdAuthor.fdName", "fdAuthorName");
			// 所属部门
			modelToFormPropertyMap.put("fdDepartment.fdId", "fdDepartmentId");
			modelToFormPropertyMap.put("fdDepartment.fdName",
					"fdDepartmentName");
			// 新闻模板
			modelToFormPropertyMap.put("fdTemplate.fdId", "fdTemplateId");
			modelToFormPropertyMap.put("fdTemplate.fdName", "fdTemplateName");
			modelToFormPropertyMap.put("fdTemplate.fdStyle", "fdStyle");
			// 文档关键字
			modelToFormPropertyMap.put("docKeyword",
					new ModelConvertor_ModelListToString("docKeywordNames",
							"docKeyword"));

			// 由于界面没有datetime选择，只使用date
			modelToFormPropertyMap.put("docPublishTime",
					new ModelConvertor_Common("docPublishTime")
							.setDateTimeType(DateUtil.TYPE_DATE));
		}
		return modelToFormPropertyMap;
	}

	/**
	 * 附件实现
	 */
	AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
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

	/*
	 * 点评机制方法实现
	 */

	private String evaluationSeparate = null;

	public String getEvaluationSeparate() {
		return evaluationSeparate;
	}

	public void setEvaluationSeparate(String evaluationSeparate) {
		this.evaluationSeparate = evaluationSeparate;
	}

	public java.util.Date getFdTopEndTime() {
		return fdTopEndTime;
	}

	public void setFdTopEndTime(java.util.Date fdTopEndTime) {
		this.fdTopEndTime = fdTopEndTime;
	}

	public void recalculateFields() {
		super.recalculateFields();
		Date beginTime = getFdTopTime();
		if (beginTime == null) {
			setFdTopEndTime(null);
			setFdIsTop(new Boolean(false));
		} else {
			Calendar calendar = Calendar.getInstance();
			calendar.setTime(beginTime);
			int fdTopDays = this.getFdTopDays().intValue();
			calendar.add(Calendar.DAY_OF_MONTH, fdTopDays);
			setFdTopEndTime(calendar.getTime());
			setFdIsTop(new Boolean(true));
		}
		if (fdIsWriter && null != fdWriter) {
			fdAuthor = null;
		}
	}

	/*
	 * 文档阅读次数
	 */
	protected Long docReadCount = new Long(0);

	public Long getDocReadCount() {
		return docReadCount;
	}

	public void setDocReadCount(Long docReadCount) {
		this.docReadCount = docReadCount;
	}

	private String readLogSSeparate = null;

	/**
	 * 获取阅读分表字段
	 * 
	 * @return
	 */
	public String getReadLogSeparate() {
		return readLogSSeparate;
	}

	/**
	 * 设置阅读分表字段
	 */
	public void setReadLogSSeparate(String readLogSSeparate) {
		this.readLogSSeparate = readLogSSeparate;
	}

	// ********** 以下的代码为流程需要的代码，请直接拷贝 **********
	private SysWfBusinessModel sysWfBusinessModel = new SysWfBusinessModel();

	public SysWfBusinessModel getSysWfBusinessModel() {
		return sysWfBusinessModel;
	}

	// ********** 以上的代码为流程需要的代码，请直接拷贝 **********

	public Boolean getFdIsTop() {
		return fdIsTop;
	}

	public void setFdIsTop(Boolean fdIsTop) {
		this.fdIsTop = fdIsTop;
	}

	public Boolean getFdIsPicNews() {
		return fdIsPicNews;
	}

	public void setFdIsPicNews(Boolean fdIsPicNews) {
		this.fdIsPicNews = fdIsPicNews;
	}

	public java.lang.String getFdNewsSource() {
		return fdNewsSource;
	}

	public void setFdNewsSource(java.lang.String fdNewsSource) {
		this.fdNewsSource = fdNewsSource;
	}

	/*
	 * 作者，IT架构外人员，直接手工录入
	 */
	private String fdWriter;

	/**
	 * @return 作者，IT架构外人员，直接手工录入
	 */
	public String getFdWriter() {
		return fdWriter;
	}

	/**
	 * @param fdWriter
	 *            作者，IT架构外人员，直接手工录入
	 */
	public void setFdWriter(String fdWriter) {
		this.fdWriter = fdWriter;
	}

	private boolean fdIsWriter = false;

	public void setFdIsWriter(boolean fdIsWriter) {
		this.fdIsWriter = fdIsWriter;
	}

	/*
	 * 是否隐藏标题
	 */
	private Boolean fdIsHideSubject = Boolean.FALSE;

	public Boolean getFdIsHideSubject() {
		return fdIsHideSubject;
	}

	public void setFdIsHideSubject(Boolean fdIsHideSubject) {
		this.fdIsHideSubject = fdIsHideSubject;
	}

	// ===========标签机制开始=========
	private SysTagMain sysTagMain = null;

	public SysTagMain getSysTagMain() {

		return sysTagMain;
	}

	public void setSysTagMain(SysTagMain sysTagMain) {
		this.sysTagMain = sysTagMain;
	}
	// ==============标签机制结束========

}
