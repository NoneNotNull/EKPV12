package com.landray.kmss.km.doc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormConvertor_NamesToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.km.doc.model.KmDocTemplateKeyword;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.category.model.SysCategoryProperty;
import com.landray.kmss.sys.news.forms.SysNewsPublishCategoryForm;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishCategoryForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.relation.forms.SysRelationMainForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainForm;
import com.landray.kmss.sys.simplecategory.forms.SysSimpleCategoryAuthTmpForm;
import com.landray.kmss.sys.tag.forms.SysTagTemplateForm;
import com.landray.kmss.sys.tag.interfaces.ISysTagTemplateForm;
import com.landray.kmss.sys.workflow.base.forms.SysWfTemplateForm;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateForm;
import com.landray.kmss.util.AutoHashMap;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖
 */
public class KmDocTemplateForm extends SysSimpleCategoryAuthTmpForm implements
		ISysRelationMainForm, ISysWfTemplateForm, IAttachmentForm,
		ISysNewsPublishCategoryForm, ISysTagTemplateForm {
	/*
	 * 文档模板内容
	 */
	private String docContent = null;

	public String getDocContent() {
		return docContent;
	}

	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}

	/*
	 * 文档存放期限
	 */
	private String docExpire = null;

	public String getDocExpire() {
		return docExpire;
	}

	public void setDocExpire(String docExpire) {
		this.docExpire = docExpire;
	}

	/*
	 * 辅类别
	 */
	private String docPropertyNames = null;

	private String docPropertyIds = null;

	public String getDocPropertyIds() {
		return docPropertyIds;
	}

	public void setDocPropertyIds(String docPropertyIds) {
		this.docPropertyIds = docPropertyIds;
	}

	public String getDocPropertyNames() {
		return docPropertyNames;
	}

	public void setDocPropertyNames(String docPropertyNames) {
		this.docPropertyNames = docPropertyNames;
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

	public Class getModelClass() {
		return KmDocTemplate.class;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docContent = null;
		docExpire = null;
		docPropertyIds = null;
		docPropertyNames = null;
		docPostsIds = null;
		docPostsNames = null;
		sysRelationMainForm = new SysRelationMainForm();

		sysWfTemplateForms.clear();
		super.reset(mapping, request);
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());

			toModelPropertyMap.put("docPostsIds",
					new FormConvertor_IDsToModelList("docPosts",
							SysOrgElement.class));
			toModelPropertyMap.put("docPropertyIds",
					new FormConvertor_IDsToModelList("docProperties",
							SysCategoryProperty.class));
			toModelPropertyMap.put("docKeywordNames",
					new FormConvertor_NamesToModelList("docKeyword",
							"kmDocTemplate", KmDocTemplate.class, "docKeyword",
							KmDocTemplateKeyword.class));
			toModelPropertyMap.put("fdParentId", new FormConvertor_IDToModel(
					"fdParent", KmDocTemplate.class));
		}
		return toModelPropertyMap;
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

	private AutoHashMap sysWfTemplateForms = new AutoHashMap(
			SysWfTemplateForm.class);

	public AutoHashMap getSysWfTemplateForms() {
		return sysWfTemplateForms;
	}

	/*
	 * 附件机制
	 */
	private AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		return attachmentForms;
	}

	public void setAttachmentForms(AutoHashMap autoHashMap) {
		this.attachmentForms = autoHashMap;
	}

	// =================发布机制开始===============
	private AutoHashMap sysNewsPublishCategoryForms = new AutoHashMap(
			SysNewsPublishCategoryForm.class);

	public AutoHashMap getSysNewsPublishCategoryForms() {
		return sysNewsPublishCategoryForms;
	}

	// =================发布机制结束===============
	// =============标签机制开始===================
	private AutoHashMap sysTagTemplateForms = new AutoHashMap(
			SysTagTemplateForm.class);

	public AutoHashMap getSysTagTemplateForms() {
		return sysTagTemplateForms;
	}
	// =============标签机制结束===================
}
