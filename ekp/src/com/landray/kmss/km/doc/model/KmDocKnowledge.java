package com.landray.kmss.km.doc.model;

import java.util.ArrayList;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.km.doc.forms.KmDocKnowledgeForm;
import com.landray.kmss.plugins.interfaces.IKmCkoModifyLogModel;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkModel;
import com.landray.kmss.sys.doc.model.SysDocBaseInfo;
import com.landray.kmss.sys.edition.interfaces.ISysEditionAutoDeleteModel;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationModel;
import com.landray.kmss.sys.introduce.interfaces.ISysIntroduceModel;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishMainModel;
import com.landray.kmss.sys.news.model.SysNewsPublishMain;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogAutoSaveModel;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.tag.interfaces.ISysTagMainModel;
import com.landray.kmss.sys.tag.model.SysTagMain;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainModel;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessModel;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档
 */
public class KmDocKnowledge extends SysDocBaseInfo implements
		ISysEvaluationModel, ISysIntroduceModel, ISysReadLogAutoSaveModel,
		ISysWfMainModel, ISysRelationMainModel, ISysEditionAutoDeleteModel,
		IAttachment, IKmCkoModifyLogModel, ISysBookmarkModel,
		ISysNewsPublishMainModel, ISysTagMainModel,InterceptFieldEnabled //大字段加入延时加载实现接口
		{
	/*
	 * 主表ID
	 */
	protected String fdModelId = null;
	/*
	 * 主表域模型
	 */
	protected String fdModelName = null;
	protected String fdWorkId = null;
	protected String fdPhaseId = null;
	
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

	public String getFdWorkId() {
		return fdWorkId;
	}

	public void setFdWorkId(String fdWorkId) {
		this.fdWorkId = fdWorkId;
	}

	public String getFdPhaseId() {
		return fdPhaseId;
	}

	public void setFdPhaseId(String fdPhaseId) {
		this.fdPhaseId = fdPhaseId;
	}

	/*
	 * 重写SysDocBaseInfo中的docContent字段 在该字段中添加延时加载的方法readLazyField和writeLazyField
	 * 文档内容
	 * by weiby
	 */
	protected String docContent;

	public String getDocContent() {
		return (String) readLazyField("docContent", docContent);
	}

	public void setDocContent(String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/*
	 * 资料说明
	 */
	protected java.lang.String fdDescription;

	public KmDocKnowledge() {
		super();
		setDocType("com.landray.kmss.km.doc.model.KmDocKnowledge");
	}

	/**
	 * @return 返回 资料说明
	 */
	public java.lang.String getFdDescription() {
		return fdDescription;
	}

	/**
	 * @param fdDescription
	 *            要设置的 资料说明
	 */
	public void setFdDescription(java.lang.String fdDescription) {
		this.fdDescription = fdDescription;
	}

	/*
	 * 模板设置
	 */
	protected KmDocTemplate kmDocTemplate = null;

	/**
	 * @return 返回 模板设置
	 */
	public KmDocTemplate getKmDocTemplate() {
		return kmDocTemplate;
	}

	/**
	 * @param kmDocTemplate
	 *            要设置的 模板设置
	 */
	public void setKmDocTemplate(KmDocTemplate kmDocTemplate) {
		this.kmDocTemplate = kmDocTemplate;
	}

	/*
	 * 多对多关联 辅类别
	 */
	protected List docProperties = new ArrayList();

	/**
	 * @return 返回多对多关联 辅类别
	 */
	public List getDocProperties() {
		return docProperties;
	}

	/**
	 * @param docProperties
	 *            要设置的 多对多关联辅类别
	 */
	public void setDocProperties(List docProperties) {
		this.docProperties = docProperties;
	}

	/*
	 * 多对多关联 相关岗位
	 */
	protected List docPosts = new ArrayList();

	/**
	 * @return 返回多对多关联 相关岗位
	 */
	public List getDocPosts() {
		return docPosts;
	}

	/**
	 * @param toKhrusers
	 *            要设置的 相关岗位
	 */
	public void setDocPosts(List docPosts) {
		this.docPosts = docPosts;
	}

	/*
	 * 一对多 关键字
	 */
	protected List docKeyword = new ArrayList();

	public List getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(List docKeyword) {
		this.docKeyword = docKeyword;
	}

	private String fdImportInfo;

	public String getFdImportInfo() {
		return fdImportInfo;
	}

	public void setFdImportInfo(String fdImportInfo) {
		this.fdImportInfo = fdImportInfo;
	}

	public Class getFormClass() {
		return KmDocKnowledgeForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("kmDocTemplate.fdId", "fdDocTemplateId");
			toFormPropertyMap.put("kmDocTemplate.fdName", "fdDocTemplateName");
			toFormPropertyMap.put("docOriginDoc.fdId", "docOriginDocId");
			toFormPropertyMap.put("docPosts",
					new ModelConvertor_ModelListToString(
							"docPostsIds:docPostsNames", "fdId:fdName"));
			toFormPropertyMap.put("docProperties",
					new ModelConvertor_ModelListToString(
							"docPropertiesIds:docPropertiesNames",
							"fdId:fdName"));
			toFormPropertyMap.put("docKeyword",
					new ModelConvertor_ModelListToString("docKeywordNames",
							"docKeyword"));
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			toFormPropertyMap.put("docAuthor.fdId", "docAuthorId");
			toFormPropertyMap.put("docAuthor.fdName", "docAuthorName");
		}
		return toFormPropertyMap;
	}

	/*
	 * 流程机制
	 */
	private SysWfBusinessModel sysWfBusinessModel = new SysWfBusinessModel();

	public SysWfBusinessModel getSysWfBusinessModel() {
		return sysWfBusinessModel;
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
	// *********************发布机制(开始)***********************//
	private SysNewsPublishMain sysNewsPublishMain = null;

	public SysNewsPublishMain getSysNewsPublishMain() {
		return sysNewsPublishMain;
	}

	public void setSysNewsPublishMain(SysNewsPublishMain sysNewsPublishMain) {
		this.sysNewsPublishMain = sysNewsPublishMain;
	}

	// *********************发布机制(结束)***********************//
	// ===========标签机制开始=========
	private SysTagMain sysTagMain = null;

	public SysTagMain getSysTagMain() {

		return sysTagMain;
	}

	public void setSysTagMain(SysTagMain sysTagMain) {
		this.sysTagMain = sysTagMain;
	}

	// ==============标签机制结束========

	/*
	 * 版本号
	 */

	protected String fdCurrentVersion = null;

	public String getFdCurrentVersion() {
		return this.docMainVersion + "." + this.docAuxiVersion;
	}

	public void setFdCurrentVersion(String fdCurrentVersion) {
		this.fdCurrentVersion = fdCurrentVersion;
	}
	
    // **********知识文档是否处理完成 开始* **********
	
    // 1:结束 0：未结束
	private String fdWorkStatus="0" ;

	public String getFdWorkStatus() {
		//若是知识文档 则一旦发布，可将工作项设置为完成状态
		if (SysDocConstant.DOC_STATUS_PUBLISH.equals(docStatus)) {
			fdWorkStatus = "1";
		}
		return fdWorkStatus;
	}

	public void setFdWorkStatus(String fdWorkStatus) {
		this.fdWorkStatus = fdWorkStatus;
	}

	// **********知识文档是否处理完成 结束* **********

}
