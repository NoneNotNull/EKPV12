package com.landray.kmss.kms.knowledge.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiCatalog;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiTemplate;
import com.landray.kmss.sys.organization.model.SysOrgElement;


/**
 * 模板目录树 Form
 * 
 * @author 
 * @version 1.0 2012-03-23
 */
public class KmsKnowledgeWikiCatalogForm extends ExtendForm {

	/**
	 * 目录名
	 */
	protected String fdName = null;
	
	/**
	 * @return 目录名
	 */
	public String getFdName() {
		return fdName;
	}
	
	/**
	 * @param fdName 目录名
	 */
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	
	/**
	 * 排序号
	 */
	protected String fdOrder = null;
	
	/**
	 * @return 排序号
	 */
	public String getFdOrder() {
		return fdOrder;
	}
	
	/**
	 * @param fdOrder 排序号
	 */
	public void setFdOrder(String fdOrder) {
		this.fdOrder = fdOrder;
	}
	
	/**
	 * 内容
	 */
	protected String docContent = null;
	
	/**
	 * @return 内容
	 */
	public String getDocContent() {
		return docContent;
	}
	
	/**
	 * @param docContent 内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = docContent;
	}
	
	/**
	 * key
	 */
	protected String fdKey = null;
	
	/**
	 * @return key
	 */
	public String getFdKey() {
		return fdKey;
	}
	
	/**
	 * @param fdKey key
	 */
	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}
	
	/**
	 * 模板ID的ID
	 */
	protected String fdTemplateId = null;
	
	/**
	 * @return 模板ID的ID
	 */
	public String getFdTemplateId() {
		return fdTemplateId;
	}
	
	/**
	 * @param fdTemplateId 模板ID的ID
	 */
	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}
	
	/**
	 * 模板ID的名称
	 */
	protected String fdTemplateName = null;
	
	/**
	 * @return 模板ID的名称
	 */
	public String getFdTemplateName() {
		return fdTemplateName;
	}
	
	/**
	 * @param fdTemplateName 模板ID的名称
	 */
	public void setFdTemplateName(String fdTemplateName) {
		this.fdTemplateName = fdTemplateName;
	}
	
	/**
	 * 默认可编辑者的ID列表
	 */
	protected String authTmpEditorIds = null;
	
	/**
	 * @return 默认可编辑者的ID列表
	 */
	public String getAuthTmpEditorIds() {
		return authTmpEditorIds;
	}
	
	/**
	 * @param authTmpEditorIds 默认可编辑者的ID列表
	 */
	public void setAuthTmpEditorIds(String authTmpEditorIds) {
		this.authTmpEditorIds = authTmpEditorIds;
	}
	
	/**
	 * 默认可编辑者的名称列表
	 */
	protected String authTmpEditorNames = null;
	
	/**
	 * @return 默认可编辑者的名称列表
	 */
	public String getAuthTmpEditorNames() {
		return authTmpEditorNames;
	}
	
	/**
	 * @param authTmpEditorNames 默认可编辑者的名称列表
	 */
	public void setAuthTmpEditorNames(String authTmpEditorNames) {
		this.authTmpEditorNames = authTmpEditorNames;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdName = null;
		fdOrder = null;
		docContent = null;
		fdKey = null;
		fdTemplateId = null;
		fdTemplateName = null;
		authTmpEditorIds = null;
		authTmpEditorNames = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmsKnowledgeWikiCatalog.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdTemplateId",
					new FormConvertor_IDToModel("fdTemplate",
							KmsKnowledgeWikiTemplate.class));
			toModelPropertyMap.put("authTmpEditorIds", new FormConvertor_IDsToModelList(
					"authTmpEditors", SysOrgElement.class));
		}
		return toModelPropertyMap;
	}
}
