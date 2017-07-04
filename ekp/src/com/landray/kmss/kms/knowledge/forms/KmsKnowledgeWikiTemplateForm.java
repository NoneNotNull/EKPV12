package com.landray.kmss.kms.knowledge.forms;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiTemplate;
import com.landray.kmss.sys.authorization.model.SysAuthArea;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.util.AutoArrayList;


/**
 * 模板表 Form
 * 
 * @author 
 * @version 1.0 2012-03-23
 */
public class KmsKnowledgeWikiTemplateForm extends ExtendForm {

	/**
	 * 模板名称
	 */
	protected String fdName = null;
	
	/**
	 * @return 模板名称
	 */
	public String getFdName() {
		return fdName;
	}
	
	/**
	 * @param fdName 模板名称
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
	 * 编辑规范
	 */
	protected String fdDescription = null;
	
	/**
	 * @return 编辑规范
	 */
	public String getFdDescription() {
		return fdDescription;
	}
	
	/**
	 * @param fdDescription 编辑规范
	 */
	public void setFdDescription(String fdDescription) {
		this.fdDescription = fdDescription;
	}
	
	/**
	 * 创建时间
	 */
	protected String docCreateTime = null;
	
	/**
	 * @return 创建时间
	 */
	public String getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 最后修改时间
	 */
	protected String docAlterTime = null;
	
	/**
	 * @return 最后修改时间
	 */
	public String getDocAlterTime() {
		return docAlterTime;
	}
	
	/**
	 * @param docAlterTime 最后修改时间
	 */
	public void setDocAlterTime(String docAlterTime) {
		this.docAlterTime = docAlterTime;
	}
	
	/**
	 * 创建者的ID
	 */
	protected String docCreatorId = null;
	
	/**
	 * @return 创建者的ID
	 */
	public String getDocCreatorId() {
		return docCreatorId;
	}
	
	/**
	 * @param docCreatorId 创建者的ID
	 */
	public void setDocCreatorId(String docCreatorId) {
		this.docCreatorId = docCreatorId;
	}
	
	/**
	 * 创建者的名称
	 */
	protected String docCreatorName = null;
	
	/**
	 * @return 创建者的名称
	 */
	public String getDocCreatorName() {
		return docCreatorName;
	}
	
	/**
	 * @param docCreatorName 创建者的名称
	 */
	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}
	
	/**
	 * 修改者的ID
	 */
	protected String docAlterorId = null;
	
	/**
	 * @return 修改者的ID
	 */
	public String getDocAlterorId() {
		return docAlterorId;
	}
	
	/**
	 * @param docAlterorId 修改者的ID
	 */
	public void setDocAlterorId(String docAlterorId) {
		this.docAlterorId = docAlterorId;
	}
	
	/**
	 * 修改者的名称
	 */
	protected String docAlterorName = null;
	
	/**
	 * @return 修改者的名称
	 */
	public String getDocAlterorName() {
		return docAlterorName;
	}
	
	/**
	 * @param docAlterorName 修改者的名称
	 */
	public void setDocAlterorName(String docAlterorName) {
		this.docAlterorName = docAlterorName;
	}
	// 所属场所ID
	protected String authAreaId = null;

	public String getAuthAreaId() {
		return authAreaId;
	}

	public void setAuthAreaId(String authAreaId) {
		this.authAreaId = authAreaId;
	}

	// 所属场所名称
	protected String authAreaName = null;

	public String getAuthAreaName() {
		return authAreaName;
	}

	public void setAuthAreaName(String authAreaName) {
		this.authAreaName = authAreaName;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdName = null;
		fdOrder = null;
		docContent = null;
		fdDescription = null;
		docCreateTime = null;
		docAlterTime = null;
		docCreatorId = null;
		docCreatorName = null;
		docAlterorId = null;
		docAlterorName = null;
		fdContentType = null;
		fdHtmlContent = null;
		authAreaId = null;
		authAreaName = null;
		fdCatelogList =  new AutoArrayList(KmsKnowledgeWikiCatalogForm.class);
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return KmsKnowledgeWikiTemplate.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCreatorId",
					new FormConvertor_IDToModel("docCreator",
						SysOrgElement.class));
			toModelPropertyMap.put("docAlterorId",
					new FormConvertor_IDToModel("docAlteror",
						SysOrgElement.class));
			toModelPropertyMap.put("fdCatelogList",new FormConvertor_FormListToModelList("fdCatelogList","fdTemplate"));
			toModelPropertyMap.put("authAreaId", new FormConvertor_IDToModel(
					"authArea", SysAuthArea.class));
		}
		return toModelPropertyMap;
	}
	
	/*
	 * 内容编辑类型
	 */
	private String fdContentType = null;

	/*
	 * word 转成的 HTML
	 */
	private String fdHtmlContent = null;

	/*
	 * 目录列表
	 * */
	private List<KmsKnowledgeWikiCatalogForm> fdCatelogList =  new AutoArrayList(KmsKnowledgeWikiCatalogForm.class);
	
	
	public String getFdContentType() {
		return fdContentType;
	}

	public void setFdContentType(String fdContentType) {
		this.fdContentType = fdContentType;
	}

	public String getFdHtmlContent() {
		return fdHtmlContent;
	}

	public void setFdHtmlContent(String fdHtmlContent) {
		this.fdHtmlContent = fdHtmlContent;
	}

	public List<KmsKnowledgeWikiCatalogForm> getFdCatelogList() {
		return fdCatelogList;
	}

	public void setFdCatelogList(List<KmsKnowledgeWikiCatalogForm> fdCatelogList) {
		this.fdCatelogList = fdCatelogList;
	}
}
