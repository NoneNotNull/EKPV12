package com.landray.kmss.kms.knowledge.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeWikiTemplateForm;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaModel;
import com.landray.kmss.sys.authorization.model.SysAuthArea;
import com.landray.kmss.sys.organization.model.SysOrgElement;

/**
 * 模板表
 * 
 * @author
 * @version 1.0 2012-03-23
 */
public class KmsKnowledgeWikiTemplate extends BaseModel implements
		InterceptFieldEnabled,ISysAuthAreaModel  {

	private static final long serialVersionUID = -7766176341361541013L;

	/**
	 * 模板名称
	 */
	protected String fdName;

	/**
	 * @return 模板名称
	 */
	public String getFdName() {
		return fdName;
	}

	/**
	 * @param fdName
	 *            模板名称
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
	 * @param fdOrder
	 *            排序号
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
	 * @param docContent
	 *            内容
	 */
	public void setDocContent(String docContent) {
		this.docContent = (String) writeLazyField("docContent",
				this.docContent, docContent);
	}

	/**
	 * 编辑规范
	 */
	protected String fdDescription;

	/**
	 * @return 编辑规范
	 */
	public String getFdDescription() {
		return fdDescription;
	}

	/**
	 * @param fdDescription
	 *            编辑规范
	 */
	public void setFdDescription(String fdDescription) {
		this.fdDescription = fdDescription;
	}

	/**
	 * 创建时间
	 */
	protected Date docCreateTime;

	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return docCreateTime;
	}

	/**
	 * @param docCreateTime
	 *            创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}

	/**
	 * 最后修改时间
	 */
	protected Date docAlterTime;

	/**
	 * @return 最后修改时间
	 */
	public Date getDocAlterTime() {
		return docAlterTime;
	}

	/**
	 * @param docAlterTime
	 *            最后修改时间
	 */
	public void setDocAlterTime(Date docAlterTime) {
		this.docAlterTime = docAlterTime;
	}

	/**
	 * 创建者
	 */
	protected SysOrgElement docCreator;

	/**
	 * @return 创建者
	 */
	public SysOrgElement getDocCreator() {
		return docCreator;
	}

	/**
	 * @param docCreator
	 *            创建者
	 */
	public void setDocCreator(SysOrgElement docCreator) {
		this.docCreator = docCreator;
	}

	/**
	 * 修改者
	 */
	protected SysOrgElement docAlteror;

	/**
	 * @return 修改者
	 */
	public SysOrgElement getDocAlteror() {
		return docAlteror;
	}

	/**
	 * @param docAlteror
	 *            修改者
	 */
	public void setDocAlteror(SysOrgElement docAlteror) {
		this.docAlteror = docAlteror;
	}

	public Class getFormClass() {
		return KmsKnowledgeWikiTemplateForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			toFormPropertyMap.put("docAlteror.fdId", "docAlterorId");
			toFormPropertyMap.put("docAlteror.fdName", "docAlterorName");
			toFormPropertyMap.put("fdCatelogList",
					new ModelConvertor_ModelListToFormList("fdCatelogList"));
		}
		return toFormPropertyMap;
	}

	/*
	 * 内容编辑类型
	 */
	protected String fdContentType;

	/*
	 * word 转成的 HTML
	 */
	protected String fdHtmlContent;

	/*
	 * 目录列表
	 */
	protected List<KmsKnowledgeWikiCatalog> fdCatelogList = new ArrayList<KmsKnowledgeWikiCatalog>();

	public String getFdContentType() {
		return fdContentType;
	}

	public void setFdContentType(String fdContentType) {
		this.fdContentType = fdContentType;
	}

	public String getFdHtmlContent() {
		return (String) readLazyField("fdHtmlContent", fdHtmlContent);
	}

	public void setFdHtmlContent(String fdHtmlContent) {
		this.fdHtmlContent = (String) writeLazyField("fdHtmlContent",
				this.fdHtmlContent, fdHtmlContent);
	}

	public List<KmsKnowledgeWikiCatalog> getFdCatelogList() {
		return fdCatelogList;
	}

	public void setFdCatelogList(List<KmsKnowledgeWikiCatalog> fdCatelogList) {
		this.fdCatelogList = fdCatelogList;
	}

	// 导入目录使用~
	private String fdCatalogStr;

	public String getFdCatalogStr() {
		return fdCatalogStr;
	}

	public void setFdCatalogStr(String fdCatalogStr) {
		this.fdCatalogStr = fdCatalogStr;
	}


	/*
	 * 所属场所
	 */
	protected SysAuthArea authArea;

	public SysAuthArea getAuthArea() {
		return authArea;
	}

	public void setAuthArea(SysAuthArea authArea) {
		this.authArea = authArea;
	}


}
