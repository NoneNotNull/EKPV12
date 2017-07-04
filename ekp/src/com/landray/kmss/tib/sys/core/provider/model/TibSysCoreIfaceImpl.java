package com.landray.kmss.tib.sys.core.provider.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceImplForm;

/**
 * 接口实现
 * 
 * @author 
 * @version 1.0 2013-08-08
 */
public class TibSysCoreIfaceImpl extends BaseModel {

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
	 * 关联实现函数
	 */
	protected String fdImplRef;
	
	/**
	 * @return 关联实现函数
	 */
	public String getFdImplRef() {
		return fdImplRef;
	}
	
	/**
	 * @param fdImplRef 关联实现函数
	 */
	public void setFdImplRef(String fdImplRef) {
		this.fdImplRef = fdImplRef;
	}
	
	/**
	 * 关联实现函数名称
	 */
	protected String fdImplRefName;
	
	/**
	 * @return 关联实现函数名称
	 */
	public String getFdImplRefName() {
		return fdImplRefName;
	}
	
	/**
	 * @param fdImplRefName 关联实现函数名称
	 */
	public void setFdImplRefName(String fdImplRefName) {
		this.fdImplRefName = fdImplRefName;
	}
	
	/**
	 * 函数类型(扩展点providerKey)
	 */
	protected String fdFuncType;
	
	/**
	 * @return 函数类型
	 */
	public String getFdFuncType() {
		return fdFuncType;
	}
	
	/**
	 * @param fdFuncType 函数类型
	 */
	public void setFdFuncType(String fdFuncType) {
		this.fdFuncType = fdFuncType;
	}
	
	/**
	 * 映射数据
	 */
	protected String fdImplRefData;
	
	/**
	 * @return 映射数据
	 */
	public String getFdImplRefData() {
		return fdImplRefData;
	}
	
	/**
	 * @param fdImplRefData 映射数据
	 */
	public void setFdImplRefData(String fdImplRefData) {
		this.fdImplRefData = fdImplRefData;
	}
	
	/**
	 * 所属接口
	 */
	protected TibSysCoreIface tibSysCoreIface;
	
	/**
	 * @return 所属接口
	 */
	public TibSysCoreIface getTibSysCoreIface() {
		return tibSysCoreIface;
	}
	
	/**
	 * @param tibSysCoreIface 所属接口
	 */
	public void setTibSysCoreIface(TibSysCoreIface tibSysCoreIface) {
		this.tibSysCoreIface = tibSysCoreIface;
	}
	
	/**
	 * 所属接口Xml目前状态。0：未改变，1：已变动
	 */
	protected String fdIfaceXmlStatus;

	public String getFdIfaceXmlStatus() {
		return fdIfaceXmlStatus;
	}

	public void setFdIfaceXmlStatus(String fdIfaceXmlStatus) {
		this.fdIfaceXmlStatus = fdIfaceXmlStatus;
	}
	
	/**
	 * 实现执行的顺序
	 */
	protected String fdOrderBy;

	public String getFdOrderBy() {
		return fdOrderBy;
	}

	public void setFdOrderBy(String fdOrderBy) {
		this.fdOrderBy = fdOrderBy;
	}

	public Class getFormClass() {
		return TibSysCoreIfaceImplForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("tibSysCoreIface.fdId", "tibSysCoreIfaceId");
			toFormPropertyMap.put("tibSysCoreIface.fdIfaceName", "tibSysCoreIfaceName");
		}
		return toFormPropertyMap;
	}
}
