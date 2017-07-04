package com.landray.kmss.tib.sys.soap.connector.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseTreeModel;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapSettCategoryForm;

/**
 * 分类信息
 * 
 * @author kezm
 * @version 1.0 2013-06-16
 */
public class TibSysSoapSettCategory extends BaseTreeModel {

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
	
//	/**
//	 * 层级ID
//	 */
//	protected String fdHierarchyId;
//	
//	/**
//	 * @return 层级ID
//	 */
//	public String getFdHierarchyId() {
//		return fdHierarchyId;
//	}
//	
//	/**
//	 * @param fdHierarchyId 层级ID
//	 */
//	public void setFdHierarchyId(String fdHierarchyId) {
//		this.fdHierarchyId = fdHierarchyId;
//	}
//	
//	/**
//	 * 上级分类
//	 */
//	protected TibSysSoapSettCategory fdParent;
//	
//	/**
//	 * @return 上级分类
//	 */
//	public TibSysSoapSettCategory getFdParent() {
//		return fdParent;
//	}
//	
//	/**
//	 * @param fdParent 上级分类
//	 */
//	public void setFdParent(TibSysSoapSettCategory fdParent) {
//		this.fdParent = fdParent;
//	}
	protected String fdOrder;
	
	public String getFdOrder() {
		return fdOrder;
	}

	public void setFdOrder(String fdOrder) {
		this.fdOrder = fdOrder;
	}

	public Class getFormClass() {
		return TibSysSoapSettCategoryForm.class;
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
