package com.landray.kmss.kms.knowledge.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.sys.doc.forms.SysDocBaseInfoForm;
import com.landray.kmss.sys.metadata.forms.ExtendDataFormInfo;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataForm;
import com.landray.kmss.sys.news.forms.SysNewsPublishMainForm;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishMainForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.organization.model.SysOrgPerson;

/**
 * 文档基本信息 Form
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeBaseDocForm extends SysDocBaseInfoForm implements
		IExtendDataForm, ISysNewsPublishMainForm {

	private static final long serialVersionUID = -321201069257463966L;

	private String fdDescription = null;

	public String getFdDescription() {
		return fdDescription;
	}

	public void setFdDescription(String fdDescription) {
		this.fdDescription = fdDescription;
	}

	private String outerAuthor;

	public String getOuterAuthor() {
		return outerAuthor;
	}

	public void setOuterAuthor(String outerAuthor) {
		this.outerAuthor = outerAuthor;
	}

	/**
	 * 推荐统计
	 */
	protected String docIntrCount = null;

	/**
	 * @return 推荐统计
	 */
	public String getDocIntrCount() {
		return docIntrCount;
	}

	/**
	 * @param docIntrCount
	 *            推荐统计
	 */
	public void setDocIntrCount(String docIntrCount) {
		this.docIntrCount = docIntrCount;
	}

	/**
	 * 点评统计
	 */
	protected String docEvalCount = null;

	/**
	 * @return 点评统计
	 */
	public String getDocEvalCount() {
		return docEvalCount;
	}

	/**
	 * @param docEvalCount
	 *            点评统计
	 */
	public void setDocEvalCount(String docEvalCount) {
		this.docEvalCount = docEvalCount;
	}

	/**
	 * 阅读统计
	 */
	protected String docReadCount = null;

	/**
	 * @return 阅读统计
	 */
	public String getDocReadCount() {
		return docReadCount;
	}

	/**
	 * @param docReadCount
	 *            阅读统计
	 */
	public void setDocReadCount(String docReadCount) {
		this.docReadCount = docReadCount;
	}
	
	//主文档id
	protected String  docOriginDocId=null;

	public String getDocOriginDocId() {
		return docOriginDocId;
	}

	public void setDocOriginDocId(String docOriginDocId) {
		this.docOriginDocId = docOriginDocId;
	}
	
	/**
	 * 是否最新版本
	 */
	protected String docIsNewVersion = null;

	/**
	 * @return 是否最新版本
	 */
	public String getDocIsNewVersion() {
		return docIsNewVersion;
	}

	/**
	 * @param docIsNewVersion
	 *            是否最新版本
	 */
	public void setDocIsNewVersion(String docIsNewVersion) {
		this.docIsNewVersion = docIsNewVersion;
	}

	/**
	 * 所属分类的ID
	 */
	protected String docCategoryId = null;

	/**
	 * @return 所属分类的ID
	 */
	public String getDocCategoryId() {
		return docCategoryId;
	}

	/**
	 * @param docCategoryId
	 *            所属分类的ID
	 */
	public void setDocCategoryId(String docCategoryId) {
		this.docCategoryId = docCategoryId;
	}

	/**
	 * 所属分类的名称
	 */
	protected String docCategoryName = null;

	/**
	 * @return 所属分类的名称
	 */
	public String getDocCategoryName() {
		return docCategoryName;
	}

	/**
	 * @param docCategoryName
	 *            所属分类的名称
	 */
	public void setDocCategoryName(String docCategoryName) {
		this.docCategoryName = docCategoryName;
	}

	protected String docSecondCategoriesIds = null;

	public String getDocSecondCategoriesIds() {
		return docSecondCategoriesIds;
	}

	public void setDocSecondCategoriesIds(String docSecondCategoriesIds) {
		this.docSecondCategoriesIds = docSecondCategoriesIds;
	}

	protected String docSecondCategoriesNames = null;

	public String getDocSecondCategoriesNames() {
		return docSecondCategoriesNames;
	}

	public void setDocSecondCategoriesNames(String docSecondCategoriesNames) {
		this.docSecondCategoriesNames = docSecondCategoriesNames;
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

	protected String docCreatorId = null;

	public String getDocCreatorId() {
		return docCreatorId;
	}

	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}

	private String docIsIndexTop = null;

	public String getDocIsIndexTop() {
		return docIsIndexTop;
	}

	public void setDocIsIndexTop(String docIsIndexTop) {
		this.docIsIndexTop = docIsIndexTop;
	}

	// 置顶时间
	protected String fdSetTopTime = null;

	public String getFdSetTopTime() {
		return fdSetTopTime;
	}

	public void setFdSetTopTime(String fdSetTopTime) {
		this.fdSetTopTime = fdSetTopTime;
	}

	// 置顶级别
	protected String fdSetTopLevel = null;

	public String getFdSetTopLevel() {
		return fdSetTopLevel;
	}

	public void setFdSetTopLevel(String fdSetTopLevel) {
		this.fdSetTopLevel = fdSetTopLevel;
	}

	// 置顶原因
	protected String fdSetTopReason = null;

	public String getFdSetTopReason() {
		return fdSetTopReason;
	}

	public void setFdSetTopReason(String fdSetTopReason) {
		this.fdSetTopReason = fdSetTopReason;
	}

	// 置顶类别集合
	protected java.lang.String fdTopCategoryId = null;

	public java.lang.String getFdTopCategoryId() {
		return fdTopCategoryId;
	}

	public void setFdTopCategoryId(java.lang.String fdTopCategoryId) {
		this.fdTopCategoryId = fdTopCategoryId;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {

		outerAuthor = null;
		fdDescription = null;
		docDeptId = null;
		docCreatorId = null;
		docAlterorId = null;
		docIntrCount = null;
		docEvalCount = null;
		docReadCount = null;
		docIsNewVersion = null;
		docCategoryId = null;
		docCategoryName = null;
		docSecondCategoriesIds = null;
		docSecondCategoriesNames = null;
		docIsIndexTop = null;
		extendDataFormInfo = new ExtendDataFormInfo();
		docIsIntroduced = null;
		docOriginDocId=null;
		super.reset(mapping, request);
	}

	@SuppressWarnings("unchecked")
	public Class getModelClass() {
		return KmsKnowledgeBaseDoc.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCreatorId", new FormConvertor_IDToModel(
					"docCreator", SysOrgPerson.class));
			toModelPropertyMap.put("docPostsIds",
					new FormConvertor_IDsToModelList("docPosts",
							SysOrgElement.class));
			toModelPropertyMap.put("authReaderIds",
					new FormConvertor_IDsToModelList("authReaders",
							SysOrgElement.class));
			toModelPropertyMap.put("authEditorIds",
					new FormConvertor_IDsToModelList("authEditors",
							SysOrgElement.class));
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
							KmsKnowledgeCategory.class));
			toModelPropertyMap.put("docSecondCategoriesIds",
					new FormConvertor_IDsToModelList("docSecondCategories",
							KmsKnowledgeCategory.class));
			toModelPropertyMap.put("docCategoryId",
					new FormConvertor_IDToModel("docCategory",
							KmsKnowledgeCategory.class));
		}
		return toModelPropertyMap;
	}

	private String idList;

	public String getIdList() {
		return idList;
	}

	public void setIdList(String idList) {
		this.idList = idList;
	}

	/*
	 * 扩展数据
	 */
	private ExtendDataFormInfo extendDataFormInfo = new ExtendDataFormInfo();

	public ExtendDataFormInfo getExtendDataFormInfo() {
		return extendDataFormInfo;
	}

	public void setExtendDataFormInfo(ExtendDataFormInfo extendDataFormInfo) {
		this.extendDataFormInfo = extendDataFormInfo;
	}

	private String extendDataXML;

	public String getExtendDataXML() {
		return extendDataXML;
	}

	public void setExtendDataXML(String extendDataXML) {
		this.extendDataXML = extendDataXML;
	}

	private String extendFilePath;

	public String getExtendFilePath() {
		return extendFilePath;
	}

	public void setExtendFilePath(String extendFilePath) {
		this.extendFilePath = extendFilePath;
	}
	
	public Boolean docIsIntroduced;

	public Boolean getDocIsIntroduced() {
		return docIsIntroduced;
	}

	public void setDocIsIntroduced(Boolean docIsIntroduced) {
		this.docIsIntroduced = docIsIntroduced;
	}
	// *********************发布机制(开始)***************************//
	SysNewsPublishMainForm SysNewsPublishMainForm = new SysNewsPublishMainForm();

	public SysNewsPublishMainForm getSysNewsPublishMainForm() {
		return SysNewsPublishMainForm;
	}

	// *********************发布机制(结束)***************************//
}
