package com.landray.kmss.kms.multidoc.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormConvertor_NamesToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplateKeyword;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.attachment.model.SysAttMain;
import com.landray.kmss.sys.category.model.SysCategoryProperty;
import com.landray.kmss.sys.news.forms.SysNewsPublishCategoryForm;
import com.landray.kmss.sys.news.interfaces.ISysNewsPublishCategoryForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.property.interfaces.ISysPropertyTemplateForm;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.sys.relation.forms.SysRelationMainForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainForm;
import com.landray.kmss.sys.simplecategory.forms.SysSimpleCategoryAuthTmpForm;
import com.landray.kmss.sys.tag.forms.SysTagTemplateForm;
import com.landray.kmss.sys.tag.interfaces.ISysTagTemplateForm;
import com.landray.kmss.sys.workflow.base.forms.SysWfTemplateForm;
import com.landray.kmss.sys.workflow.interfaces.ISysWfTemplateForm;
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.AutoHashMap;

/**
 *  2007-Sep-18
 * 
 * @author 
 */
public class KmsMultidocTemplateForm extends SysSimpleCategoryAuthTmpForm
		implements ISysRelationMainForm, ISysWfTemplateForm, IAttachmentForm,
		ISysNewsPublishCategoryForm, ISysTagTemplateForm,
		ISysPropertyTemplateForm {

	private String fdNumberPrefix = null;

	public String getFdNumberPrefix() {
		return fdNumberPrefix;
	}

	public void setFdNumberPrefix(String fdNumberPrefix) {
		this.fdNumberPrefix = fdNumberPrefix;
	}

	private String docContent = null;

	public String getDocContent() {
		return docContent;
	}

	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}

	private String docExpire = null;

	public String getDocExpire() {
		return docExpire;
	}

	public void setDocExpire(String docExpire) {
		this.docExpire = docExpire;
	}
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

	private String docKeywordNames = null;

	public String getDocKeywordNames() {
		return docKeywordNames;
	}

	public void setDocKeywordNames(String docKeywordNames) {
		this.docKeywordNames = docKeywordNames;
	}

	public Class getModelClass() {
		return KmsMultidocTemplate.class;
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
		fdSysPropTemplateId = null;
		fdSysPropTemplateName = null;
		fdNumberPrefix = null;
		fdExternalId = null;
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
							"kmsMultidocTemplate", KmsMultidocTemplate.class,
							"docKeyword", KmsMultidocTemplateKeyword.class));
			toModelPropertyMap.put("fdParentId", new FormConvertor_IDToModel(
					"fdParent", KmsMultidocTemplate.class));
			toModelPropertyMap.put("fdSysPropTemplateId",
					new FormConvertor_IDToModel("sysPropertyTemplate",
							SysPropertyTemplate.class));
		}
		return toModelPropertyMap;
	}

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

	private AutoHashMap attachmentForms = new AutoHashMap(
			AttachmentDetailsForm.class);

	public AutoHashMap getAttachmentForms() {
		AttachmentDetailsForm form=(AttachmentDetailsForm)attachmentForms.get("rattachment") ;
		AutoArrayList list=(AutoArrayList)form.getAttachments();
		for(int i=0;i<list.size();i++){
			SysAttMain main=(SysAttMain)list.get(i);
			String id=main.getFdId(); 
			for(int j=i+1;j<list.size();j++){
				SysAttMain main2=(SysAttMain)list.get(j);
				if(id.equals(main2.getFdId()  )){
				    list.remove(j);
				    
				}
			}
			
		}
		 
		return attachmentForms;
	}

	public void setAttachmentForms(AutoHashMap autoHashMap) {
		this.attachmentForms = autoHashMap;
	}

	private AutoHashMap sysNewsPublishCategoryForms = new AutoHashMap(
			SysNewsPublishCategoryForm.class);

	public AutoHashMap getSysNewsPublishCategoryForms() {
		return sysNewsPublishCategoryForms;
	}

	private AutoHashMap sysTagTemplateForms = new AutoHashMap(
			SysTagTemplateForm.class);

	public void setSysTagTemplateForms(AutoHashMap sysTagTemplateForms) {
		this.sysTagTemplateForms = sysTagTemplateForms;
	}

	public AutoHashMap getSysTagTemplateForms() {
		return sysTagTemplateForms;
	}


	private String fdSysPropTemplateId = null;

	public String getFdSysPropTemplateId() {
		return fdSysPropTemplateId;
	}

	public void setFdSysPropTemplateId(String fdSysPropTemplateId) {
		this.fdSysPropTemplateId = fdSysPropTemplateId;
	}

	private String fdSysPropTemplateName = null;

	public String getFdSysPropTemplateName() {
		return fdSysPropTemplateName;
	}

	public void setFdSysPropTemplateName(String fdSysPropTemplateName) {
		this.fdSysPropTemplateName = fdSysPropTemplateName;
	}

	protected FormFile file = null;

	public FormFile getFile() {
		return file;
	}

	public void setFile(FormFile file) {
		this.file = file;
	}
	
	private String fdExternalId = null;

	public String getFdExternalId() {
		return fdExternalId;
	}

	public void setFdExternalId(String fdExternalId) {
		this.fdExternalId = fdExternalId;
	}
	

}
