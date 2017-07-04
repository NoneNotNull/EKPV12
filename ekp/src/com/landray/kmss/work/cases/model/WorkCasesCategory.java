package com.landray.kmss.work.cases.model;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.lbpmservice.interfaces.ISysLbpmTemplateModel;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.sys.relation.interfaces.ISysRelationMainModel;
import com.landray.kmss.sys.relation.model.SysRelationMain;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.work.cases.forms.WorkCasesCategoryForm;



/**
 * 分类信息
 * 
 */
public class WorkCasesCategory  extends SysSimpleCategoryAuthTmpModel implements ISysLbpmTemplateModel,ISysRelationMainModel{

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
	private Integer fdOrder;
	
	/**
	 * @return 排序号
	 */
	public Integer getFdOrder() {
		return this.fdOrder;
	}
	
	/**
	 * @param fdOrder 排序号
	 */
	public void setFdOrder(Integer fdOrder) {
		this.fdOrder = fdOrder;
	}
	
	/**
	 * 创建时间
	 */
	private Date docCreateTime;
	
	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return this.docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 层级ID
	 */
//	private String fdHierarchyId;
	
	/**
	 * @return 层级ID
	 */
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
	 * 创建者
	 */
	private SysOrgPerson docCreator;
	
	/**
	 * @return 创建者
	 */
	public SysOrgPerson getDocCreator() {
		return this.docCreator;
	}
	
	/**
	 * @param docCreator 创建者
	 */
	public void setDocCreator(SysOrgPerson docCreator) {
		this.docCreator = docCreator;
	}
	
	/**
	 * 上级分类
	 */
//	private WorkCasesCategory fdParent;
//	
//	/**
//	 * @return 上级分类
//	 */
//	public WorkCasesCategory getFdParent() {
//		return this.fdParent;
//	}
//	
//	/**
//	 * @param fdParent 上级分类
//	 */
//	public void setFdParent(WorkCasesCategory fdParent) {
//		this.fdParent = fdParent;
//	}
	

	//机制开始
	//机制结束

	public Class<WorkCasesCategoryForm> getFormClass() {
		return WorkCasesCategoryForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("docCreator.fdId", "docCreatorId");
			toFormPropertyMap.put("docCreator.fdName", "docCreatorName");
			toFormPropertyMap.put("fdParent.fdId", "fdParentId");
			toFormPropertyMap.put("fdParent.fdName", "fdParentName");
		}
		return toFormPropertyMap;
	}
    
	private List sysWfTemplateModels;
	
	@Override
	public List getSysWfTemplateModels() {
		return sysWfTemplateModels;
	}

	@Override
	public void setSysWfTemplateModels(List sysWfTemplateModels) {
		this.sysWfTemplateModels = sysWfTemplateModels;
		
	}
	
	/**
	 * 关联域模型信息
	 */
	private SysRelationMain sysRelationMain = null;
	public SysRelationMain getSysRelationMain() {
		return  sysRelationMain;
	}
	public void setSysRelationMain(SysRelationMain sysRelationMain) {
		this.sysRelationMain = sysRelationMain;
	}


     protected String relationSeparate = null;

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

}
