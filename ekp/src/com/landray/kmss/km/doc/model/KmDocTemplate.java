package com.landray.kmss.km.doc.model;

import java.util.ArrayList;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.km.doc.forms.KmDocTemplateForm;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishCategoryModel;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.sys.tag.interfaces.ISysTagTemplateModel;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateModel;
import com.landray.kmss.util.AutoHashMap;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖 模板设置
 */
public class KmDocTemplate extends SysSimpleCategoryAuthTmpModel implements
		ISysRelationMainModel, ISysWfTemplateModel, IAttachment,
		InterceptFieldEnabled, ISysNewsPublishCategoryModel,
		ISysTagTemplateModel {

	public KmDocTemplate() {
		super();
	}

	/*
	 * 文档模板内容
	 */
	protected java.lang.String docContent;

	public java.lang.String getDocContent() {
		return (String) readLazyField("docContent", docContent);
	}

	public void setDocContent(java.lang.String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
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

	/*
	 * 多对多关联 辅类别
	 */
	protected List docProperties = new ArrayList();

	public List getDocProperties() {
		return docProperties;
	}

	public void setDocProperties(List fdProperties) {
		this.docProperties = fdProperties;
	}

	/*
	 * 关键字
	 */
	protected List docKeyword = new ArrayList();

	public List getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(List docKeyword) {
		this.docKeyword = docKeyword;
	}

	public Class getFormClass() {
		return KmDocTemplateForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());

			toFormPropertyMap.put("docPosts",
					new ModelConvertor_ModelListToString(
							"docPostsIds:docPostsNames", "fdId:fdName"));
			toFormPropertyMap.put("docProperties",
					new ModelConvertor_ModelListToString(
							"docPropertyIds:docPropertyNames", "fdId:fdName"));
			toFormPropertyMap.put("docKeyword",
					new ModelConvertor_ModelListToString("docKeywordNames",
							"docKeyword"));
		}
		return toFormPropertyMap;
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

	// =====附件机制(开始)=====
	protected AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return attachmentForms;
	}

	// =====附件机制(结束)=====

	// ======发布机制(开始)=====
	private List sysNewsPublishCategorys;

	public List getSysNewsPublishCategorys() {
		return sysNewsPublishCategorys;
	}

	public void setSysNewsPublishCategorys(List sysNewsPublishCategorys) {
		this.sysNewsPublishCategorys = sysNewsPublishCategorys;
	}

	// ======发布机制(结束)=====

	// ======标签机制开始 =========
	private List sysTagTemplates;

	public List getSysTagTemplates() {
		return sysTagTemplates;
	}

	public void setSysTagTemplates(List sysTagTemplates) {
		this.sysTagTemplates = sysTagTemplates;
	}
	// =======标签机制开始==========
}
