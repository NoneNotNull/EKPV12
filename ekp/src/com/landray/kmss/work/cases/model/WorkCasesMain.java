package com.landray.kmss.work.cases.model;

import java.util.Date;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkModel;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationCountModel;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationModel;
import com.landray.kmss.sys.lbpmservice.interfaces.ISysLbpmMainModel;
import com.landray.kmss.sys.lbpmservice.interfaces.LbpmProcessForm;
import com.landray.kmss.sys.notify.interfaces.ISysNotifyModel;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogAutoSaveModel;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.right.interfaces.ExtendAuthModel;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.work.cases.forms.WorkCasesMainForm;

/**
 * 文档类
 */
public class WorkCasesMain  extends ExtendAuthModel  implements InterceptFieldEnabled,IAttachment,ISysLbpmMainModel,ISysNotifyModel,ISysReadLogAutoSaveModel,ISysEvaluationModel,ISysEvaluationCountModel,ISysBookmarkModel,ISysRelationMainModel{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 文档标题
	 */
	private String docSubject;
	
	/**
	 * @return 文档标题
	 */
	public String getDocSubject() {
		return this.docSubject;
	}
	
	/**
	 * @param docSubject 文档标题
	 */
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}
	
	/**
	 * 内容
	 */
	private String docContent;
	
	/**
	 * @return 内容
	 */
	public String getDocContent() {
		return (String) readLazyField("docContent", this.docContent);
	}
	
	/**
	 * @param docContent 内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * 创建时间
	 */
	private Date docCreateTime;
	
	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return this.docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 发布时间
	 */
	private Date docPublishTime;
	
	/**
	 * @return 发布时间
	 */
	public Date getDocPublishTime() {
		return this.docPublishTime;
	}
	
	/**
	 * @param docPublishTime 发布时间
	 */
	public void setDocPublishTime(Date docPublishTime) {
		this.docPublishTime = docPublishTime;
	}
	
	/**
	 * 案例类型
	 */
	private String fdWorkType;
	
	/**
	 * @return 案例类型
	 */
	public String getFdWorkType() {
		return this.fdWorkType;
	}
	
	/**
	 * @param fdWorkType 案例类型
	 */
	public void setFdWorkType(String fdWorkType) {
		this.fdWorkType = fdWorkType;
	}
	
	/**
	 * 创建者
	 */
	private SysOrgPerson docCreator;
	
	/**
	 * @return 创建者
	 */
	public SysOrgPerson getDocCreator() {
		return this.docCreator;
	}
	
	/**
	 * @param docCreator 创建者
	 */
	public void setDocCreator(SysOrgPerson docCreator) {
		this.docCreator = docCreator;
	}
	
	/**
	 * 所属分类
	 */
	private WorkCasesCategory docCategory;
	
	/**
	 * @return 所属分类
	 */
	public WorkCasesCategory getDocCategory() {
		return this.docCategory;
	}
	
	/**
	 * @param docCategory 所属分类
	 */
	public void setDocCategory(WorkCasesCategory docCategory) {
		this.docCategory = docCategory;
	}
	
	/**
	 * 可阅读者
	 */
//	private List<SysOrgElement> authReaders;
//	
//	/**
//	 * @return 可阅读者
//	 */
//	public List<SysOrgElement> getAuthReaders() {
//		return this.authReaders;
//	}
	
	/**
	 * @param authReaders 可阅读者
	 */
//	public void setAuthReaders(List<SysOrgElement> authReaders) {
//		this.authReaders = authReaders;
//	}
	
	/**
	 * 其它可阅读者
	 */
//	private List<SysOrgElement> authOtherReaders;
//	
//	/**
//	 * @return 其它可阅读者
//	 */
//	public List<SysOrgElement> getAuthOtherReaders() {
//		return this.authOtherReaders;
//	}
	
	/**
	 * @param authOtherReaders 其它可阅读者
	 */
//	public void setAuthOtherReaders(List<SysOrgElement> authOtherReaders) {
//		this.authOtherReaders = authOtherReaders;
//	}
	
	/**
	 * 所有可阅读者
	 */
//	private List<SysOrgElement> authAllReaders;
//	
//	/**
//	 * @return 所有可阅读者
//	 */
//	public List<SysOrgElement> getAuthAllReaders() {
//		return this.authAllReaders;
//	}
//	
	/**
	 * @param authAllReaders 所有可阅读者
	 */
//	public void setAuthAllReaders(List<SysOrgElement> authAllReaders) {
//		this.authAllReaders = authAllReaders;
//	}
	
	/**
	 * 可编辑者
	 */
//	private List<SysOrgElement> authEditors;
//	
//	/**
//	 * @return 可编辑者
//	 */
//	public List<SysOrgElement> getAuthEditors() {
//		return this.authEditors;
//	}
//	
	/**
	 * @param authEditors 可编辑者
	 */
//	public void setAuthEditors(List<SysOrgElement> authEditors) {
//		this.authEditors = authEditors;
//	}
//	
//	/**
//	 * 其它可编辑者
//	 */
//	private List<SysOrgElement> authOtherEditors;
//	
//	/**
//	 * @return 其它可编辑者
//	 */
//	public List<SysOrgElement> getAuthOtherEditors() {
//		return this.authOtherEditors;
//	}
	
	/**
	 * @param authOtherEditors 其它可编辑者
	 */
//	public void setAuthOtherEditors(List<SysOrgElement> authOtherEditors) {
//		this.authOtherEditors = authOtherEditors;
//	}
//	
//	/**
//	 * 所有可编辑者
//	 */
//	private List<SysOrgElement> authAllEditors;
//	
//	/**
//	 * @return 所有可编辑者
//	 */
//	public List<SysOrgElement> getAuthAllEditors() {
//		return this.authAllEditors;
//	}
	
	/**
	 * @param authAllEditors 所有可编辑者
	 */
//	public void setAuthAllEditors(List<SysOrgElement> authAllEditors) {
//		this.authAllEditors = authAllEditors;
//	}
//	
//	/**
//	 * 通知人
//	 */
	private List<SysOrgElement> fdNotifiers;
	
	/**
	 * @return 通知人
	 */
	public List<SysOrgElement> getFdNotifiers() {
		return this.fdNotifiers;
	}
	
	/**
	 * @param fdNotifiers 通知人	 
	 */
	public void setFdNotifiers(List<SysOrgElement> fdNotifiers) {
		this.fdNotifiers = fdNotifiers;
	}
	

	//机制开始
	//机制结束

	public Class<WorkCasesMainForm> getFormClass() {
		return WorkCasesMainForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
			toFormPropertyMap.put("authReaders",
					new ModelConvertor_ModelListToString(
							"authReaderIds:authReaderNames", "fdId:fdName"));
			toFormPropertyMap.put("authOtherReaders",
					new ModelConvertor_ModelListToString(
							"authOtherReaderIds:authOtherReaderNames", "fdId:fdName"));
			toFormPropertyMap.put("authAllReaders",
					new ModelConvertor_ModelListToString(
							"authAllReaderIds:authAllReaderNames", "fdId:fdName"));
			toFormPropertyMap.put("authEditors",
					new ModelConvertor_ModelListToString(
							"authEditorIds:authEditorNames", "fdId:fdName"));
			toFormPropertyMap.put("authOtherEditors",
					new ModelConvertor_ModelListToString(
							"authOtherEditorIds:authOtherEditorNames", "fdId:fdName"));
			toFormPropertyMap.put("authAllEditors",
					new ModelConvertor_ModelListToString(
							"authAllEditorIds:authAllEditorNames", "fdId:fdName"));
			toFormPropertyMap.put("fdNotifiers",
					new ModelConvertor_ModelListToString(
							"fdNotifierIds:fdNotifierNames", "fdId:fdName"));
		}
		return toFormPropertyMap;
	}
    
	//文档状态
	private String docStatus;
	@Override
	public String getDocStatus() {
		return docStatus;
	}

	@Override
	public void setDocStatus(String docStatus) {
		this.docStatus = docStatus;
		
	}
	/**
	 * 附件上传
	 */
	AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);
	@Override
	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
	}
	
	/**
	 * 流程模板
	 */
	private LbpmProcessForm sysWfBusinessModel = new LbpmProcessForm ();
	@Override
	public LbpmProcessForm getSysWfBusinessModel() {
		return sysWfBusinessModel;
	}
	
	/**
	 * 通知类型
	 */
	private java.lang.String fdNotifyType;

	public java.lang.String getFdNotifyType() {
	return fdNotifyType;
	}

	public void setFdNotifyType(java.lang.String fdNotifyType) {
	this.fdNotifyType = fdNotifyType;
	}
	
	/**
	 * 文档阅读次数
	 */
	private Long docReadCount;

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
	 * @return readLogSSeparate
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
	
	/**
	 * 点评机制方法实现
	 */
	protected String evaluationSeparate;
	public String getEvaluationSeparate() {

		return evaluationSeparate;
	}

	public void setEvaluationSeparate(String evaluationSeparate) {
		this.evaluationSeparate = evaluationSeparate;

	}
	
	/**
	 * 点评，点评数
	 */
	private Integer docEvalCount = Integer.valueOf(0);

	public Integer getDocEvalCount () {
		return docEvalCount;
	}

	public void setDocEvalCount(Integer count) {
		this. docEvalCount = count;
	}

	/**
	 * 被收藏次数
	 */
	private Integer docMarkCount;

	public Integer getDocMarkCount() {
		return docMarkCount;
	}

	public void setDocMarkCount(Integer count) {
		this.docMarkCount = count;
	}

	/**
	 * 关联域模型信息
	 */
	private SysRelationMain sysRelationMain = null;
	public SysRelationMain getSysRelationMain() {
		return  sysRelationMain;
	}
	public void setSysRelationMain(SysRelationMain sysRelationMain) {
		this.sysRelationMain = sysRelationMain;
	}


     protected String relationSeparate = null;

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

	@Override
	protected void recalculateReaderField() {
		super.recalculateReaderField();
		List notifies =  getFdNotifiers();
		String docStatus = getDocStatus();
		if(notifies != null && StringUtil.isNotNull(docStatus) && docStatus.charAt(0) >= '3'){
			if (!getAuthReaderFlag()){
				ArrayUtil.concatTwoList(notifies, this.authAllReaders);
			}
			
		}
		
	}


}
