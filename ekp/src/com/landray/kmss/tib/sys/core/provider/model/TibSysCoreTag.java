package com.landray.kmss.tib.sys.core.provider.model;

import java.util.List;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreTagForm;

/**
 * 标签信息
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreTag extends BaseModel {

	/**
	 * 标签名称
	 */
	protected String fdTagName;
	
	/**
	 * @return 标签名称
	 */
	public String getFdTagName() {
		return fdTagName;
	}
	
	/**
	 * @param fdTagName 标签名称
	 */
	public void setFdTagName(String fdTagName) {
		this.fdTagName = fdTagName;
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
	
	protected List<TibSysCoreIface> tibSysCoreIfaces;
	
	public List<TibSysCoreIface> getTibSysCoreIfaces() {
		return tibSysCoreIfaces;
	}

	public void setTibSysCoreIfaces(List<TibSysCoreIface> tibSysCoreIfaces) {
		this.tibSysCoreIfaces = tibSysCoreIfaces;
	}

	public Class getFormClass() {
		return TibSysCoreTagForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
		}
		return toFormPropertyMap;
	}
}
