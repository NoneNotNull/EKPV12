package com.landray.kmss.km.doc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormConvertor_NamesToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.km.doc.model.KmDocKnowledge;
import com.landray.kmss.km.doc.model.KmDocKnowledgeKeyword;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.plugins.interfaces.IKmCkoModifyLogForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.bookmark.interfaces.ISysBookmarkForm;
import com.landray.kmss.sys.category.model.SysCategoryProperty;
import com.landray.kmss.sys.doc.forms.SysDocBaseInfoForm;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainForm;
import com.landray.kmss.sys.evaluation.interfaces.ISysEvaluationForm;
import com.landray.kmss.sys.introduce.interfaces.ISysIntroduceForm;
import com.landray.kmss.sys.news.forms.SysNewsPublishMainForm;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishMainForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.readlog.interfaces.ISysReadLogForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainForm;
import com.landray.kmss.sys.tag.forms.SysTagMainForm;
import com.landray.kmss.sys.tag.interfaces.ISysTagMainForm;
import com.landray.kmss.sys.workflow.interfaces.ISysWfMainForm;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessForm;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖
 */
public class KmDocKnowledgeForm extends SysDocBaseInfoForm implements
		ISysEvaluationForm, ISysIntroduceForm, ISysReadLogForm, ISysWfMainForm,
		ISysEditionMainForm, ISysRelationMainForm, IAttachmentForm,
		IKmCkoModifyLogForm, ISysBookmarkForm, ISysNewsPublishMainForm,
		ISysTagMainForm {	
	/*
	 * 域模型ID
	 */
	private String fdModelId = null;
	/*
	 * 域模型类名
	 */
	private String fdModelName = null;
	private String fdWorkId = null;
	private String fdPhaseId = null;
		
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
	
	/**
	 * 文件作者的ID
	 */
	protected String docCreatorId = null;

	/**
	 * @return 文件作者的ID
	 */
	public String getDocCreatorId() {
		return docCreatorId;
	}

	/**
	 * @param docCreatorId
	 *            文件作者的ID
	 */
	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}

	/**
	 * 文件作者的名称
	 */
	protected String docCreatorName = null;

	/**
	 * @return 文件作者的名称
	 */
	public String getDocCreatorName() {
		return docCreatorName;
	}

	/**
	 * @param docCreatorName
	 *            文件作者的名称
	 */
	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}
	
	/**
	 * 录入人的ID
	 */
	protected String docAuthorId = null;

	/**
	 * @return 录入人的ID
	 */
	public String getDocAuthorId() {
		return docAuthorId;
	}

	/**
	 * @param docAuthorId
	 *            录入人的ID
	 */
	public void setDocAuthorId(String docAuthorId) {
		this.docAuthorId = docAuthorId;
	}

	/**
	 * 录入人的名称
	 */
	protected String docAuthorName = null;

	/**
	 * @return 录入人的名称
	 */
	public String getDocAuthorName() {
		return docAuthorName;
	}

	/**
	 * @param docAuthorName
	 *            录入人的名称
	 */
	public void setDocAuthorName(String docAuthorName) {
		this.docAuthorName = docAuthorName;
	}

	/*
	 * 是否精华
	 */
	protected Boolean docIsIntroduced;

	public Boolean getDocIsIntroduced() {
		return docIsIntroduced;
	}

	public void setDocIsIntroduced(Boolean docIsIntroduced) {
		this.docIsIntroduced = docIsIntroduced;
	}
	
	/*
	 * 资料说明
	 */
	private String fdDescription = null;

	private String fdImportInfo = null;

	private String docCreatorDeptId = null;

	public String getFdImportInfo() {
		return fdImportInfo;
	}

	public void setFdImportInfo(String fdImportInfo) {
		this.fdImportInfo = fdImportInfo;
	}

	/*
	 * 所属模板
	 */
	private String fdDocTemplateId = null;

	private String fdDocTemplateName = null;

	public String getFdDocTemplateId() {
		return fdDocTemplateId;
	}

	public void setFdDocTemplateId(String kmDocTemplateId) {
		this.fdDocTemplateId = kmDocTemplateId;
	}

	public String getFdDocTemplateName() {
		return fdDocTemplateName;
	}

	public void setFdDocTemplateName(String kmDocTemplateName) {
		this.fdDocTemplateName = kmDocTemplateName;
	}

	/*
	 * 辅助类别IDs
	 */
	private String docPropertiesIds = null;

	/*
	 * 辅助类别名称
	 */
	private String docPropertiesNames = null;

	public String getDocPropertiesIds() {
		return docPropertiesIds;
	}

	public void setDocPropertiesIds(String fdCategoryAuxiliryIds) {
		this.docPropertiesIds = fdCategoryAuxiliryIds;
	}

	public String getDocPropertiesNames() {
		return docPropertiesNames;
	}

	public void setDocPropertiesNames(String fdCategoryAuxiliryNames) {
		this.docPropertiesNames = fdCategoryAuxiliryNames;
	}

	/**
	 * @return 返回 资料说明
	 */
	public String getFdDescription() {
		return fdDescription;
	}

	/**
	 * @param fdDescription
	 *            要设置的 资料说明
	 */
	public void setFdDescription(String fdDescription) {
		this.fdDescription = fdDescription;
	}

	/*
	 * 相关岗位
	 */
	private String docPostsIds = null;

	private String docPostsNames = null;

	public String getDocPostsIds() {
		return docPostsIds;
	}

	public void setDocPostsIds(String docPostsIds) {
		this.docPostsIds = docPostsIds;
	}

	public String getDocPostsNames() {
		return docPostsNames;
	}

	public void setDocPostsNames(String docPostsNames) {
		this.docPostsNames = docPostsNames;
	}

	/*
	 * 关键字
	 */
	private String docKeywordNames = null;

	public String getDocKeywordNames() {
		return docKeywordNames;
	}

	public void setDocKeywordNames(String docKeywordNames) {
		this.docKeywordNames = docKeywordNames;
	}

	/*
	 * （非 Javadoc）
	 * 
	 * @seeorg.apache.struts.action.ActionForm#reset(org.apache.struts.action.
	 * ActionMapping, javax.servlet.http.HttpServletRequest)
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		super.reset(mapping, request);
		docPropertiesIds = null;
		fdDescription = null;
		docPropertiesNames = null;
		fdImportInfo = null;
		docPostsIds = null;
		docPostsNames = null;
		fdDocTemplateName = null;
		fdDocTemplateId = null;
		docCreatorId = null;
		docCreatorName = null;
		docAuthorId = null;
		docAuthorName = null;
		sysWfBusinessForm = new SysWfBusinessForm();
		fdStyle = null;
		docReadCount = null;
		docOriginDocId=null;
		docIsIntroduced=null;
	}

	public Class getModelClass() {
		return KmDocKnowledge.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCreatorId", new FormConvertor_IDToModel(
					"docCreator", SysOrgElement.class));
			toModelPropertyMap.put("docAuthorId", new FormConvertor_IDToModel(
					"docAuthor", SysOrgElement.class));
			toModelPropertyMap.put("fdDocTemplateId",
					new FormConvertor_IDToModel("kmDocTemplate",
							KmDocTemplate.class));
			toModelPropertyMap.put("docPostsIds",
					new FormConvertor_IDsToModelList("docPosts",
							SysOrgElement.class));
			toModelPropertyMap.put("docPropertiesIds",
					new FormConvertor_IDsToModelList("docProperties",
							SysCategoryProperty.class));
			toModelPropertyMap.put("docKeywordNames",
					new FormConvertor_NamesToModelList("docKeyword",
							"kmDocKnowledge", KmDocKnowledge.class,
							"docKeyword", KmDocKnowledgeKeyword.class).setSplitStr(" "));
		}
		return toModelPropertyMap;
	}

	/*
	 * 流程机制
	 */
	private SysWfBusinessForm sysWfBusinessForm = new SysWfBusinessForm();

	public SysWfBusinessForm getSysWfBusinessForm() {
		return sysWfBusinessForm;
	}

	/*
	 * 样式
	 */
	private String fdStyle = null;

	public String getFdStyle() {
		if (fdStyle == null) {
			return "default";
		}
		return fdStyle;
	}

	public void setFdStyle(String fdStyle) {
		this.fdStyle = fdStyle;
	}

	/*
	 * 阅读次数
	 */
	private String docReadCount = null;

	public String getDocReadCount() {
		return docReadCount;
	}

	public void setDocReadCount(String docReadCount) {
		this.docReadCount = docReadCount;
	}

	// *********************收藏机制(开始)*********************************//
	private String docMarkCount;

	public String getDocMarkCount() {
		return docMarkCount;
	}

	public void setDocMarkCount(String count) {
		this.docMarkCount = count;
	}

	// *********************收藏机制(结束)***************************//
	// *********************发布机制(开始)***************************//
	SysNewsPublishMainForm SysNewsPublishMainForm = new SysNewsPublishMainForm();

	public SysNewsPublishMainForm getSysNewsPublishMainForm() {
		return SysNewsPublishMainForm;
	}

	// *********************发布机制(结束)***************************//
	// ==============标签机制 开始==================
	SysTagMainForm SysTagMainForm = new SysTagMainForm();

	public SysTagMainForm getSysTagMainForm() {

		return SysTagMainForm;
	}

	// ==============标签机制 结束====================

	public String getDocCreatorDeptId() {
		return docCreatorDeptId;
	}

	public void setDocCreatorDeptId(String docCreatorDeptId) {
		this.docCreatorDeptId = docCreatorDeptId;
	}

	/*
	 * 版本号
	 */

	protected String fdCurrentVersion = null;

	public String getFdCurrentVersion() {
		return fdCurrentVersion;
	}

	public void setFdCurrentVersion(String fdCurrentVersion) {
		this.fdCurrentVersion = fdCurrentVersion;
	}
	
	//主文档id
	protected String  docOriginDocId=null;

	public String getDocOriginDocId() {
		return docOriginDocId;
	}

	public void setDocOriginDocId(String docOriginDocId) {
		this.docOriginDocId = docOriginDocId;
	}
	
	
}
