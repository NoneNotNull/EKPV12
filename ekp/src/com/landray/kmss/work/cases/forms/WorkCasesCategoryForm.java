package com.landray.kmss.work.cases.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.sys.lbpmservice.interfaces.ISysLbpmTemplateForm;
import com.landray.kmss.sys.lbpmservice.support.forms.LbpmTemplateForm;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.relation.forms.SysRelationMainForm;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainForm;
import com.landray.kmss.sys.simplecategory.forms.SysSimpleCategoryAuthTmpForm;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.work.cases.model.WorkCasesCategory;



/**
 * 分类信息 Form
 */
public class WorkCasesCategoryForm  extends SysSimpleCategoryAuthTmpForm  implements ISysLbpmTemplateForm,ISysRelationMainForm{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	/**
	 * 名称
	 */
	private String fdName;
	
	/**
	 * @return 名称
	 */
	public String getFdName() {
		return this.fdName;
	}
	
	/**
	 * @param fdName 名称
	 */
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	
	/**
	 * 排序号
	 */
	private String fdOrder;
	
	/**
	 * @return 排序号
	 */
	public String getFdOrder() {
		return this.fdOrder;
	}
	
	/**
	 * @param fdOrder 排序号
	 */
	public void setFdOrder(String fdOrder) {
		this.fdOrder = fdOrder;
	}
	
	/**
	 * 创建时间
	 */
	private String docCreateTime;
	
	/**
	 * @return 创建时间
	 */
	public String getDocCreateTime() {
		return this.docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 层级ID
	 */
//	private String fdHierarchyId;
//	
//	/**
//	 * @return 层级ID
//	 */
//	public String getFdHierarchyId() {
//		return this.fdHierarchyId;
//	}
//	
//	/**
//	 * @param fdHierarchyId 层级ID
//	 */
//	public void setFdHierarchyId(String fdHierarchyId) {
//		this.fdHierarchyId = fdHierarchyId;
//	}
	
	/**
	 * 创建者的ID
	 */
	private String docCreatorId;
	
	/**
	 * @return 创建者的ID
	 */
	public String getDocCreatorId() {
		return this.docCreatorId;
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
	private String docCreatorName;
	
	/**
	 * @return 创建者的名称
	 */
	public String getDocCreatorName() {
		return this.docCreatorName;
	}
	
	/**
	 * @param docCreatorName 创建者的名称
	 */
	public void setDocCreatorName(String docCreatorName) {
		this.docCreatorName = docCreatorName;
	}
	
	/**
	 * 上级分类的ID
	 */
	private String fdParentId;
	
	/**
	 * @return 上级分类的ID
	 */
	public String getFdParentId() {
		return this.fdParentId;
	}
	
	/**
	 * @param fdParentId 上级分类的ID
	 */
	public void setFdParentId(String fdParentId) {
		this.fdParentId = fdParentId;
	}
	
	/**
	 * 上级分类的名称
	 */
	private String fdParentName;
	
	/**
	 * @return 上级分类的名称
	 */
	public String getFdParentName() {
		return this.fdParentName;
	}
	
	/**
	 * @param fdParentName 上级分类的名称
	 */
	public void setFdParentName(String fdParentName) {
		this.fdParentName = fdParentName;
	}
	
	//机制开始 
	//机制结束

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdName = null;
		fdOrder = null;
		docCreateTime = null;
//		fdHierarchyId = null;
		docCreatorId = null;
		docCreatorName = null;
		fdParentId = null;
		fdParentName = null;
		sysWfTemplateForms.clear();
		super.reset(mapping, request);
	}

	public Class<WorkCasesCategory> getModelClass() {
		return WorkCasesCategory.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("docCreatorId",
					new FormConvertor_IDToModel("docCreator",
						SysOrgElement.class));
			toModelPropertyMap.put("fdParentId",
					new FormConvertor_IDToModel("fdParent",
						WorkCasesCategory.class));
		}
		return toModelPropertyMap;
	}
    
	
	private AutoHashMap sysWfTemplateForms = new AutoHashMap(
			LbpmTemplateForm.class);

	public AutoHashMap getSysWfTemplateForms() {
		return sysWfTemplateForms;
	}
	
	/**
	 * 关联机制
	 */
	private SysRelationMainForm sysRelationMainForm = new SysRelationMainForm();
	
	public SysRelationMainForm getSysRelationMainForm() {
		return sysRelationMainForm;
	}


}
