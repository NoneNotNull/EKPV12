package com.landray.kmss.kms.knowledge.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeDocTemplate;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiTemplate;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.attachment.forms.IAttachmentForm;
import com.landray.kmss.sys.attachment.model.SysAttMain;
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
 * 知识分类 Form
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeCategoryForm extends SysSimpleCategoryAuthTmpForm
		implements ISysRelationMainForm, ISysWfTemplateForm, IAttachmentForm,
		ISysNewsPublishCategoryForm, ISysTagTemplateForm,
		ISysPropertyTemplateForm {

	/**
	 * 描述
	 */
	protected String fdDescription = null;

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

	private String docExpire = null;

	public String getDocExpire() {
		return docExpire;
	}

	public void setDocExpire(String docExpire) {
		this.docExpire = docExpire;
	}

	/**
	 * 知识编号前缀
	 */
	protected String fdNumberPrefix = null;

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

	/**
	 * 知识模版类型
	 */
	protected String fdTemplateType = null;

	public String getFdTemplateType() {
		return fdTemplateType;
	}

	public void setFdTemplateType(String fdTemplateType) {
		String value = null;
		if(fdTemplateType!=null && fdTemplateType.length()>1){
			value = String.valueOf(KmsKnowledgeConstantUtil.getTemplateTypeValue(fdTemplateType));
		}else{
			value = KmsKnowledgeConstantUtil.getTemplateType(fdTemplateType);
		}
		this.fdTemplateType = value;
	}
	

	private String wikiTemplateId = null;

	public String getWikiTemplateId() {
		return wikiTemplateId;
	}

	public void setWikiTemplateId(String wikiTemplateId) {
		this.wikiTemplateId = wikiTemplateId;
	}

	private String wikiTemplateName = null;

	public String getWikiTemplateName() {
		return wikiTemplateName;
	}

	public void setWikiTemplateName(String wikiTemplateName) {
		this.wikiTemplateName = wikiTemplateName;
	}

	private String docTemplateId = null;

	private String docTemplateName = null;

	public String getDocTemplateId() {
		return docTemplateId;
	}

	public void setDocTemplateId(String docTemplateId) {
		this.docTemplateId = docTemplateId;
	}

	public String getDocTemplateName() {
		return docTemplateName;
	}

	public void setDocTemplateName(String docTemplateName) {
		this.docTemplateName = docTemplateName;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docExpire = null;
		docPostsIds = null;
		docPostsNames = null;
		sysRelationMainForm = new SysRelationMainForm();
		sysWfTemplateForms.clear();
		fdSysPropTemplateId = null;
		fdSysPropTemplateName = null;
		fdNumberPrefix = null;
		fdTemplateType = null;
		wikiTemplateId = null;
		wikiTemplateName = null;
		docTemplateId = null;
		docTemplateName = null;
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmsKnowledgeCategory.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdSysPropTemplateId",
					new FormConvertor_IDToModel("sysPropertyTemplate",
							SysPropertyTemplate.class));
			toModelPropertyMap.put("fdParentId", new FormConvertor_IDToModel(
					"fdParent", KmsKnowledgeCategory.class));
			toModelPropertyMap.put("docPostsIds",
					new FormConvertor_IDsToModelList("docPosts",
							SysOrgElement.class));
			toModelPropertyMap.put("wikiTemplateId",
					new FormConvertor_IDToModel("wikiTemplate",
							KmsKnowledgeWikiTemplate.class));
			toModelPropertyMap.put("docTemplateId",
					new FormConvertor_IDToModel("docTemplate",
							KmsKnowledgeDocTemplate.class));

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
		AttachmentDetailsForm form = (AttachmentDetailsForm) attachmentForms
				.get("rattachment");
		AutoArrayList list = (AutoArrayList) form.getAttachments();
		for (int i = 0; i < list.size(); i++) {
			SysAttMain main = (SysAttMain) list.get(i);
			String id = main.getFdId();
			for (int j = i + 1; j < list.size(); j++) {
				SysAttMain main2 = (SysAttMain) list.get(j);
				if (id.equals(main2.getFdId())) {
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
}
