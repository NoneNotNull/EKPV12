package com.landray.kmss.sys.news.model;

import java.util.ArrayList;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.model.IAttachment;
import com.landray.kmss.sys.news.constant.SysNewsConstant;
import com.landray.kmss.sys.news.forms.SysNewsTemplateForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.sys.tag.interfaces.ISysTagTemplateModel;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateModel;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 新闻模板设置
 */
public class SysNewsTemplate extends SysSimpleCategoryAuthTmpModel implements
		ISysRelationMainModel, ISysWfTemplateModel, InterceptFieldEnabled,
		ISysTagTemplateModel, IAttachment {

	private static final long serialVersionUID = -7249989481941988497L;

	/*
	 * 新闻重要度
	 */
	protected java.lang.Long fdImportance;

	/*
	 * 文档内容
	 */
	protected java.lang.String docContent;

	/*
	 * 关键字
	 */
	protected List docKeyword = new ArrayList();

	private String fdStyle;

	public List getDocKeyword() {
		return docKeyword;
	}

	public void setDocKeyword(List docKeyword) {
		this.docKeyword = docKeyword;
	}
	
	public SysNewsTemplate() {
		super();
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

	public Class getFormClass() {
		return SysNewsTemplateForm.class;
	}

	private static ModelToFormPropertyMap modelToFormPropertyMap = null;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (modelToFormPropertyMap == null) {
			modelToFormPropertyMap = new ModelToFormPropertyMap();
			modelToFormPropertyMap.putAll(super.getToFormPropertyMap());

			// 关键字
			modelToFormPropertyMap
					.put("docKeyword", new ModelConvertor_ModelListToString(
							"docKeywordIds:docKeywordNames", "fdId:docKeyword"));
		}
		return modelToFormPropertyMap;
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

	// ********** 以下的代码为流程模板需要的代码，请直接拷贝 **********
	private List sysWfTemplateModels;

	public List getSysWfTemplateModels() {
		return sysWfTemplateModels;
	}

	public void setSysWfTemplateModels(List sysWfTemplateModels) {
		this.sysWfTemplateModels = sysWfTemplateModels;
	}

	// ********** 以上的代码为流程模板需要的代码，请直接拷贝 **********

	public String getFdStyle() {
		return fdStyle;
	}

	public void setFdStyle(String fdStyle) {
		this.fdStyle = fdStyle;
	}

	// ======标签机制开始 =========
	private List sysTagTemplates;

	public List getSysTagTemplates() {
		return sysTagTemplates;
	}

	public void setSysTagTemplates(List sysTagTemplates) {
		this.sysTagTemplates = sysTagTemplates;
	}

	// =======标签机制开始==========

	AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
	}

}
