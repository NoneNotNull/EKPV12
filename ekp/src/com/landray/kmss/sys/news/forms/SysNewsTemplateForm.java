package com.landray.kmss.sys.news.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_NamesToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.news.constant.SysNewsConstant;
import com.landray.kmss.sys.news.model.SysNewsTemplate;
import com.landray.kmss.sys.news.model.SysNewsTemplateKeyword;
import com.landray.kmss.sys.relation.forms.SysRelationMainForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainForm;
import com.landray.kmss.sys.simplecategory.forms.SysSimpleCategoryAuthTmpForm;
import com.landray.kmss.sys.tag.forms.SysTagTemplateForm;
import com.landray.kmss.sys.tag.interfaces.ISysTagTemplateForm;
import com.landray.kmss.sys.workflow.base.forms.SysWfTemplateForm;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateForm;
import com.landray.kmss.util.AutoHashMap;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌
 */
public class SysNewsTemplateForm extends SysSimpleCategoryAuthTmpForm implements
		ISysRelationMainForm, ISysWfTemplateForm, ISysTagTemplateForm,
		IAttachmentForm {

	private static final long serialVersionUID = 2139915214951884077L;

	/*
	 * 新闻重要度
	 */
	private String fdImportance = null;

	/*
	 * 文档内容
	 */
	private String docContent = null;

	/*
	 * 关键字
	 */
	private String docKeywordIds = null;

	private String docKeywordNames = null;

	private String fdStyle;

	/**
	 * @return 返回 新闻重要度
	 */
	public String getFdImportance() {
		return fdImportance;
	}

	/**
	 * @param fdImportance
	 *            要设置的 新闻重要度
	 */
	public void setFdImportance(String fdImportance) {
		this.fdImportance = fdImportance;
	}

	/**
	 * @return 返回 文档内容
	 */
	public String getDocContent() {
		return docContent;
	}

	/**
	 * @param docContent
	 *            要设置的 文档内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}

	public String getDocKeywordIds() {
		return docKeywordIds;
	}

	public void setDocKeywordIds(String docKeywordIds) {
		this.docKeywordIds = docKeywordIds;
	}

	public String getDocKeywordNames() {
		return docKeywordNames;
	}

	public void setDocKeywordNames(String docKeywordNames) {
		this.docKeywordNames = docKeywordNames;
	}

	/*
	 * 文档内容的编辑方式
	 */
	private String fdContentType;

	public String getFdContentType() {
		return fdContentType;
	}

	public void setFdContentType(String fdContentType) {
		this.fdContentType = fdContentType;
	}
	
	/*
	 * （非 Javadoc）
	 * 
	 * @seeorg.apache.struts.action.ActionForm#reset(org.apache.struts.action.
	 * ActionMapping, javax.servlet.http.HttpServletRequest)
	 */
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdImportance = null;
		docContent = null;
		fdStyle = null;
		docKeywordIds = null;
		docKeywordNames = null;
		fdContentType = SysNewsConstant.FDCONTENTTYPE_RTF;
		sysWfTemplateForms.clear();
		sysRelationMainForm = new SysRelationMainForm();
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return SysNewsTemplate.class;
	}

	private static FormToModelPropertyMap formToModelPropertyMap = null;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (formToModelPropertyMap == null) {
			formToModelPropertyMap = new FormToModelPropertyMap();
			formToModelPropertyMap.putAll(super.getToModelPropertyMap());
			// 关键字
			formToModelPropertyMap.put("docKeywordNames",
					new FormConvertor_NamesToModelList("docKeyword",
							"sysNewsTemplate", SysNewsTemplate.class,
							"docKeyword", SysNewsTemplateKeyword.class));
			formToModelPropertyMap.put("fdParentId",
					new FormConvertor_IDToModel("fdParent",
							SysNewsTemplate.class));
		}
		return formToModelPropertyMap;
	}

	/*
	 * 关联机制
	 */
	private SysRelationMainForm sysRelationMainForm = new SysRelationMainForm();

	public SysRelationMainForm getSysRelationMainForm() {
		return sysRelationMainForm;
	}

	public void setSysRelationMainForm(SysRelationMainForm sysRelationMainForm) {
		this.sysRelationMainForm = sysRelationMainForm;
	}

	// ********** 以下的代码为流程模板需要的代码，请直接拷贝 **********
	private AutoHashMap sysWfTemplateForms = new AutoHashMap(
			SysWfTemplateForm.class);

	public AutoHashMap getSysWfTemplateForms() {
		return sysWfTemplateForms;
	}

	// ********** 以上的代码为流程模板需要的代码，请直接拷贝 **********

	public String getFdStyle() {
		if (fdStyle == null) {
			return "default";
		}
		return fdStyle;
	}

	public void setFdStyle(String fdStyle) {
		this.fdStyle = fdStyle;
	}

	// =============标签机制开始===================
	private AutoHashMap sysTagTemplateForms = new AutoHashMap(
			SysTagTemplateForm.class);

	public AutoHashMap getSysTagTemplateForms() {
		return sysTagTemplateForms;
	}

	// =============标签机制结束===================

	AutoHashMap autoHashMap = new AutoHashMap(AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return autoHashMap;
	}

}
