package com.landray.kmss.tib.jdbc.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseTreeModel;
import com.landray.kmss.tib.jdbc.forms.TibJdbcTaskCategoryForm;

/**
 * 任务分类
 * 
 * @author 
 * @version 1.0 2013-07-24
 */
public class TibJdbcTaskCategory extends BaseTreeModel {

	/**
	 * 名称
	 */
	protected String fdName;
	
	/**
	 * @return 名称
	 */
	public String getFdName() {
		return fdName;
	}
	
	/**
	 * @param fdName 名称
	 */
	public void setFdName(String fdName) {
		this.fdName = fdName;
	}
	
	/**
	 * 层级ID
	 *//*
	protected String fdHierarchyId;
	
	*//**
	 * @return 层级ID
	 *//*
	public String getFdHierarchyId() {
		return fdHierarchyId;
	}
	
	*//**
	 * @param fdHierarchyId 层级ID
	 *//*
	public void setFdHierarchyId(String fdHierarchyId) {
		this.fdHierarchyId = fdHierarchyId;
	}*/
	
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
	 * 上级分类
	 *//*
	protected TibJdbcTaskCategory fdParent;
	
	*//**
	 * @return 上级分类
	 *//*
	public TibJdbcTaskCategory getFdParent() {
		return fdParent;
	}
	
	*//**
	 * @param fdParent 上级分类
	 *//*
	public void setFdParent(TibJdbcTaskCategory fdParent) {
		this.fdParent = fdParent;
	}*/
	
	
	public Class getFormClass() {
		return TibJdbcTaskCategoryForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdParent.fdId", "fdParentId");
			toFormPropertyMap.put("fdParent.fdName", "fdParentName");
		}
		return toFormPropertyMap;
	}
}
