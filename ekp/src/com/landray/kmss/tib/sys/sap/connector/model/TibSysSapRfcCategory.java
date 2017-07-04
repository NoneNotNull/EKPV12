package com.landray.kmss.tib.sys.sap.connector.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.constant.BaseTreeConstant;
import com.landray.kmss.sys.simplecategory.model.SysSimpleCategoryAuthTmpModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcCategoryForm;

/**
 * 配置/分类信息
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcCategory extends SysSimpleCategoryAuthTmpModel {

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
	 * @param fdName
	 *            名称
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
	 * 层级ID
	 */
	protected String fdHierarchyId = BaseTreeConstant.HIERARCHY_ID_SPLIT
			+ getFdId() + BaseTreeConstant.HIERARCHY_ID_SPLIT;

	/**
	 * @return 层级ID
	 */
	public String getFdHierarchyId() {
		return fdHierarchyId;
	}

	/**
	 * @param fdHierarchyId
	 *            层级ID
	 */
	public void setFdHierarchyId(String fdHierarchyId) {
		this.fdHierarchyId = fdHierarchyId;
	}

	public Class getFormClass() {
		return TibSysSapRfcCategoryForm.class;
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
