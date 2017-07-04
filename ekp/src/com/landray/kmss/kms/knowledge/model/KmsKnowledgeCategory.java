package com.landray.kmss.kms.knowledge.model;

import java.util.ArrayList;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeCategoryForm;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishCategoryModel;
import com.landray.kmss.sys.property.interfaces.ISysPropertyTemplate;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.sys.tag.interfaces.ISysTagTemplateModel;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateModel;
import com.landray.kmss.util.AutoHashMap;

/**
 * 知识分类
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeCategory extends SysSimpleCategoryAuthTmpModel
		implements ISysRelationMainModel, ISysWfTemplateModel, IAttachment,
		InterceptFieldEnabled, ISysNewsPublishCategoryModel,
		ISysTagTemplateModel, ISysPropertyTemplate {

	private static final long serialVersionUID = 1518660237591156422L;
	/**
	 * 知识模版类型
	 */
	protected String fdTemplateType;
	

	public String getFdTemplateType() {
		return fdTemplateType;
	}

	public void setFdTemplateType(String fdTemplateType) {
		this.fdTemplateType = fdTemplateType;
	}

	/**
	 * 描述
	 */
	protected String fdDescription;

	/**
	 * @return 描述
	 */
	public String getFdDescription() {
		return fdDescription;
	}

	/**
	 * @param fdDescription
	 *            描述
	 */
	public void setFdDescription(String fdDescription) {
		this.fdDescription = fdDescription;
	}


	/*
	 * 文档存放期限
	 */
	protected java.lang.Long docExpire;

	public java.lang.Long getDocExpire() {
		return docExpire;
	}

	public void setDocExpire(java.lang.Long docExpire) {
		this.docExpire = docExpire;
	}

	/**
	 * 知识编号前缀
	 */
	protected String fdNumberPrefix;

	/**
	 * @return 知识编号前缀
	 */
	public String getFdNumberPrefix() {
		return fdNumberPrefix;
	}

	/**
	 * @param fdNumberPrefix
	 *            知识编号前缀
	 */
	public void setFdNumberPrefix(String fdNumberPrefix) {
		this.fdNumberPrefix = fdNumberPrefix;
	}
	

	/*
	 * 多对多关联 相关岗位
	 */
	protected List docPosts = new ArrayList();

	public List getDocPosts() {
		return docPosts;
	}

	public void setDocPosts(List fdPosts) {
		this.docPosts = fdPosts;
	}

	public Class getFormClass() {
		return KmsKnowledgeCategoryForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("sysPropertyTemplate.fdId",
					"fdSysPropTemplateId");
			toFormPropertyMap.put("sysPropertyTemplate.fdName",
					"fdSysPropTemplateName");
			toFormPropertyMap.put("wikiTemplate.fdId", "wikiTemplateId");
			toFormPropertyMap.put("wikiTemplate.fdName", "wikiTemplateName");
			toFormPropertyMap.put("docTemplate.fdId", "docTemplateId");
			toFormPropertyMap.put("docTemplate.fdName", "docTemplateName");
			toFormPropertyMap.put("docPosts",
					new ModelConvertor_ModelListToString(
							"docPostsIds:docPostsNames", "fdId:fdName"));
		}
		return toFormPropertyMap;
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
	 * 关联域模型信息
	 */
	private SysRelationMain sysRelationMain = null;

	public SysRelationMain getSysRelationMain() {
		return sysRelationMain;
	}

	public void setSysRelationMain(SysRelationMain sysRelationMain) {
		this.sysRelationMain = sysRelationMain;
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

	// ======发布机制(开始)=====
	private List sysNewsPublishCategorys;

	public List getSysNewsPublishCategorys() {
		return sysNewsPublishCategorys;
	}

	public void setSysNewsPublishCategorys(List sysNewsPublishCategorys) {
		this.sysNewsPublishCategorys = sysNewsPublishCategorys;
	}

	// ======标签机制开始 =========
	private List sysTagTemplates;

	public List getSysTagTemplates() {
		return sysTagTemplates;
	}

	public void setSysTagTemplates(List sysTagTemplates) {
		this.sysTagTemplates = sysTagTemplates;
	}

	// =====附件机制(开始)=====
	protected AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return attachmentForms;
	}

	// ======对应的属性模板=====
	private SysPropertyTemplate sysPropertyTemplate = null;

	public SysPropertyTemplate getSysPropertyTemplate() {
		return sysPropertyTemplate;
	}

	public void setSysPropertyTemplate(SysPropertyTemplate sysPropertyTemplate) {
		this.sysPropertyTemplate = sysPropertyTemplate;
	}
	
	/**
	 * 模板ID
	 */
	protected KmsKnowledgeWikiTemplate wikiTemplate;

	public KmsKnowledgeWikiTemplate getWikiTemplate() {
		return wikiTemplate;
	}

	public void setWikiTemplate(KmsKnowledgeWikiTemplate wikiTemplate) {
		this.wikiTemplate = wikiTemplate;
	}
	
	protected KmsKnowledgeDocTemplate docTemplate;

	public KmsKnowledgeDocTemplate getDocTemplate() {
		return docTemplate;
	}

	public void setDocTemplate(KmsKnowledgeDocTemplate docTemplate) {
		this.docTemplate = docTemplate;
	}

	private List<KmsKnowledgeBaseDoc> knowledges;

	public List<KmsKnowledgeBaseDoc> getKnowledges() {
		return knowledges;
	}

	public void setKnowledges(List<KmsKnowledgeBaseDoc> knowledges) {
		this.knowledges = knowledges;
	}
}
