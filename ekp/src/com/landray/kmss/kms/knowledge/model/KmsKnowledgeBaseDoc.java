package com.landray.kmss.kms.knowledge.model;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.kms.common.model.IKmsCommonErrorCorrectionModel;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeBaseDocForm;
import com.landray.kmss.sys.doc.model.SysDocBaseInfo;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataModel;
import com.landray.kmss.sys.metadata.model.ExtendDataModelInfo;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishMainModel;
import com.landray.kmss.sys.news.model.SysNewsPublishMain;

/**
 * 文档基本信息
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeBaseDoc extends SysDocBaseInfo implements
		IExtendDataModel,ISysNewsPublishMainModel,IKmsCommonErrorCorrectionModel {

	private static final long serialVersionUID = -5558630369932250766L;
	/*
	 * 类型
	 */
	private Integer fdKnowledgeType;

	public Integer getFdKnowledgeType() {
		return fdKnowledgeType;
	}

	public void setFdKnowledgeType(Integer fdKnowledgeType) {
		this.fdKnowledgeType = fdKnowledgeType;
	}

	private String outerAuthor;

	public String getOuterAuthor() {
		return outerAuthor;
	}

	public void setOuterAuthor(String outerAuthor) {
		this.outerAuthor = outerAuthor;
	}

	// 摘要
	protected java.lang.String fdDescription;

	public java.lang.String getFdDescription() {
		return fdDescription;
	}

	public void setFdDescription(java.lang.String fdDescription) {
		this.fdDescription = fdDescription;
	}

	/**
	 * 岗位
	 */
	protected List<?> docPosts;

	/**
	 * @return 岗位
	 */
	public List<?> getDocPosts() {
		return docPosts;
	}

	/**
	 * @param docPosts
	 *            岗位
	 */
	public void setDocPosts(List<?> docPosts) {
		this.docPosts = docPosts;
	}

	/**
	 * 推荐统计
	 */
	protected Integer docIntrCount = Integer.valueOf(0);

	/**
	 * @return 推荐统计
	 */
	public Integer getDocIntrCount() {
		return docIntrCount;
	}

	/**
	 * @param docIntrCount
	 *            推荐统计
	 */
	public void setDocIntrCount(Integer docIntrCount) {
		this.docIntrCount = docIntrCount;
	}

	/**
	 * 点评统计
	 */
	protected Integer docEvalCount = Integer.valueOf(0);

	/**
	 * @return 点评统计
	 */
	public Integer getDocEvalCount() {
		return docEvalCount;
	}

	/**
	 * @param docEvalCount
	 *            点评统计
	 */
	public void setDocEvalCount(Integer docEvalCount) {
		this.docEvalCount = docEvalCount;
	}

	/**
	 * 所属分类
	 */
	protected KmsKnowledgeCategory docCategory;

	/**
	 * @return 所属分类
	 */
	public KmsKnowledgeCategory getDocCategory() {
		return docCategory;
	}

	/**
	 * @param docCategory
	 *            所属分类
	 */
	public void setDocCategory(KmsKnowledgeCategory docCategory) {
		this.docCategory = docCategory;
	}

	/**
	 * 辅分类
	 */
	List<KmsKnowledgeCategory> docSecondCategories;

	public List<KmsKnowledgeCategory> getDocSecondCategories() {
		return docSecondCategories;
	}

	public void setDocSecondCategories(
			List<KmsKnowledgeCategory> docSecondCategories) {
		this.docSecondCategories = docSecondCategories;
	}

	// 增加置顶
	protected Boolean docIsIndexTop;

	public Boolean getDocIsIndexTop() {
		return docIsIndexTop;
	}

	public void setDocIsIndexTop(Boolean docIsIndexTop) {
		this.docIsIndexTop = docIsIndexTop;
	}

	// 置顶时间
	protected Date fdSetTopTime;

	public Date getFdSetTopTime() {
		return fdSetTopTime;
	}

	public void setFdSetTopTime(Date fdSetTopTime) {
		this.fdSetTopTime = fdSetTopTime;
	}

	// 置顶级别
	protected String fdSetTopLevel;

	public String getFdSetTopLevel() {
		return fdSetTopLevel;
	}

	public void setFdSetTopLevel(String fdSetTopLevel) {
		this.fdSetTopLevel = fdSetTopLevel;
	}

	// 置顶原因
	protected String fdSetTopReason;

	public String getFdSetTopReason() {
		return fdSetTopReason;
	}

	public void setFdSetTopReason(String fdSetTopReason) {
		this.fdSetTopReason = fdSetTopReason;
	}

	// 置顶类别集合
	protected java.lang.String fdTopCategoryId;

	public java.lang.String getFdTopCategoryId() {
		return fdTopCategoryId;
	}

	public void setFdTopCategoryId(java.lang.String fdTopCategoryId) {
		this.fdTopCategoryId = fdTopCategoryId;
	}

	// ============== 扩展数据 开始 ==========================
	private ExtendDataModelInfo extendDataModelInfo = new ExtendDataModelInfo(
			this);

	public ExtendDataModelInfo getExtendDataModelInfo() {
		return extendDataModelInfo;
	}

	public void setExtendDataModelInfo(ExtendDataModelInfo extendDataModelInfo) {
		this.extendDataModelInfo = extendDataModelInfo;
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
	// *********************发布机制(开始)***********************//
	private SysNewsPublishMain sysNewsPublishMain = null;

	public SysNewsPublishMain getSysNewsPublishMain() {
		return sysNewsPublishMain;
	}

	public void setSysNewsPublishMain(SysNewsPublishMain sysNewsPublishMain) {
		this.sysNewsPublishMain = sysNewsPublishMain;
	}

	// *********************发布机制(结束)***********************//
	// ============== 扩展数据 结束 =========================

	public Class getFormClass() {
		return KmsKnowledgeBaseDocForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docAlteror.fdId", "docAlterorId");
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docOriginDoc.fdId", "docOriginDocId");
			toFormPropertyMap.put("docCategory.fdId", "docCategoryId");
			toFormPropertyMap.put("docCategory.fdName", "docCategoryName");
			toFormPropertyMap.put("docPosts",
					new ModelConvertor_ModelListToString(
							"docPostsIds:docPostsNames", "fdId:fdName"));
			toFormPropertyMap.put("docSecondCategories",
					new ModelConvertor_ModelListToString(
							"docSecondCategoriesIds:docSecondCategoriesNames",
							"fdId:fdName"));
		}
		return toFormPropertyMap;
	}

	public IBaseModel getCategory() {
		return docCategory;
	}

	public String getFdFirstId() {
		return null;
	}
}
