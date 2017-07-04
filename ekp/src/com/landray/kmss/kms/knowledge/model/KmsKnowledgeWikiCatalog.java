package com.landray.kmss.kms.knowledge.model;

import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToString;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeWikiCatalogForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
 
/**
 * 模板目录树
 * 
 * @author 
 * @version 1.0 2012-03-23
 */
public class KmsKnowledgeWikiCatalog extends BaseModel {

	/**
	 * 目录名
	 */
	protected String fdName;
	
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
	protected Integer fdOrder;
	
	/**
	 * @return 排序号
	 */
	public Integer getFdOrder() {
		return fdOrder;
	}
	
	/**
	 * @param fdOrder 排序号
	 */
	public void setFdOrder(Integer fdOrder) {
		this.fdOrder = fdOrder;
	}
	
	/**
	 * 内容
	 */
	protected String docContent;
	
	/**
	 * @return 内容
	 */
	public String getDocContent() {
		return (String) readLazyField("docContent", docContent);
	}
	
	/**
	 * @param docContent 内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * key
	 */
	protected String fdKey;
	
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
	 * 模板ID
	 */
	protected KmsKnowledgeWikiTemplate fdTemplate;
	
	/**
	 * @return 模板ID
	 */
	public KmsKnowledgeWikiTemplate getFdTemplate() {
		return fdTemplate;
	}
	
	/**
	 * @param fdTemplate 模板ID
	 */
	public void setFdTemplate(KmsKnowledgeWikiTemplate fdTemplate) {
		this.fdTemplate = fdTemplate;
	}
	
	/**
	 * 默认可编辑者
	 */
	protected List<SysOrgElement> authTmpEditors;
	
	/**
	 * @return 默认可编辑者
	 */
	public List<SysOrgElement> getAuthTmpEditors() {
		return authTmpEditors;
	}
	
	/**
	 * @param authTmpEditors 默认可编辑者
	 */
	public void setAuthTmpEditors(List<SysOrgElement> authTmpEditors) {
		this.authTmpEditors = authTmpEditors;
	}
	
	public Class getFormClass() {
		return KmsKnowledgeWikiCatalogForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdTemplate.fdId", "fdTemplateId");
			toFormPropertyMap.put("fdTemplate.fdId", "fdTemplateName");
			toFormPropertyMap.put("authTmpEditors",
					new ModelConvertor_ModelListToString(
							"authTmpEditorIds:authTmpEditorNames", "fdId:fdName"));
		}
		return toFormPropertyMap;
	}
}
