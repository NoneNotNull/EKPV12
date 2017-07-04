package com.landray.kmss.tib.sys.sap.connector.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcTableForm;

/**
 * 表参数配置
 * 
 * @author
 * @version 1.0 2011-10-25
 */
public class TibSysSapRfcTable extends BaseModel {

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
	 * 启用
	 */
	protected Boolean fdUse;

	/**
	 * @return 启用
	 */
	public Boolean getFdUse() {
		return fdUse;
	}

	/**
	 * @param fdUse
	 *            启用
	 */
	public void setFdUse(Boolean fdUse) {
		this.fdUse = fdUse;
	}

	/**
	 * 参数名称
	 */
	protected String fdParameterName;

	/**
	 * @return 参数名称
	 */
	public String getFdParameterName() {
		return fdParameterName;
	}

	/**
	 * @param fdParameterName
	 *            参数名称
	 */
	public void setFdParameterName(String fdParameterName) {
		this.fdParameterName = fdParameterName;
	}

	/**
	 * 对象类型
	 */
	protected String fdParameterType;

	/**
	 * @return 对象类型
	 */
	public String getFdParameterType() {
		return fdParameterType;
	}

	/**
	 * @param fdParameterType
	 *            对象类型
	 */
	public void setFdParameterType(String fdParameterType) {
		this.fdParameterType = fdParameterType;
	}

	/**
	 * 最大长度
	 */
	protected Integer fdParameterLength;

	/**
	 * @return 最大长度
	 */
	public Integer getFdParameterLength() {
		return fdParameterLength;
	}

	/**
	 * @param fdParameterLength
	 *            最大长度
	 */
	public void setFdParameterLength(Integer fdParameterLength) {
		this.fdParameterLength = fdParameterLength;
	}

	/**
	 * 数据类型
	 */
	protected String fdParameterTypeName;

	/**
	 * @return 数据类型
	 */
	public String getFdParameterTypeName() {
		return fdParameterTypeName;
	}

	/**
	 * @param fdParameterTypeName
	 *            数据类型
	 */
	public void setFdParameterTypeName(String fdParameterTypeName) {
		this.fdParameterTypeName = fdParameterTypeName;
	}

	/**
	 * 必填
	 */
	protected String fdParameterRequired;

	/**
	 * @return 必填
	 */
	public String getFdParameterRequired() {
		return fdParameterRequired;
	}

	/**
	 * @param fdParameterRequired
	 *            必填
	 */
	public void setFdParameterRequired(String fdParameterRequired) {
		this.fdParameterRequired = fdParameterRequired;
	}

	/**
	 * 说明
	 */
	protected String fdMark;

	/**
	 * @return 说明
	 */
	public String getFdMark() {
		return fdMark;
	}

	/**
	 * @param fdMark
	 *            说明
	 */
	public void setFdMark(String fdMark) {
		this.fdMark = fdMark;
	}

	/**
	 * 所属函数
	 */
	protected TibSysSapRfcSetting fdFunction;

	/**
	 * @return 所属函数
	 */
	public TibSysSapRfcSetting getFdFunction() {
		return fdFunction;
	}

	/**
	 * @param fdFunction
	 *            所属函数
	 */
	public void setFdFunction(TibSysSapRfcSetting fdFunction) {
		this.fdFunction = fdFunction;
	}

	/**
	 * 父ID
	 */
	protected TibSysSapRfcTable fdParent;

	/**
	 * @return 父ID
	 */
	public TibSysSapRfcTable getFdParent() {
		return fdParent;
	}

	/**
	 * @param fdParentId
	 *            父ID
	 */
	public void setFdParent(TibSysSapRfcTable fdParent) {
		this.fdParent = fdParent;
	}

	/**
	 * @param fdRfcParamXml
	 *            函数参数xml格式文件
	 */
	protected String fdRfcParamXml = null;

	public String getFdRfcParamXml() {
		return (String) readLazyField("fdRfcParamXml", fdRfcParamXml);
	}

	public void setFdRfcParamXml(String fdRfcParamXml) {
		this.fdRfcParamXml = (String) writeLazyField("fdRfcParamXml",
				this.fdRfcParamXml, fdRfcParamXml);
	}

	/**
	 * 层级ID
	 */
	protected String fdHierarchyId;

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

	protected String fdisin;

	public Class getFormClass() {
		return TibSysSapRfcTableForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdFunction.fdId", "fdFunctionId");
			toFormPropertyMap.put("fdFunction.fdId", "fdFunctionName");
			toFormPropertyMap.put("fdParent.fdId", "fdParentId");
			toFormPropertyMap.put("fdParent.fdId", "fdParentName");

		}
		return toFormPropertyMap;
	}

	public String getFdisin() {
		return fdisin;
	}

	public void setFdisin(String fdisin) {
		this.fdisin = fdisin;
	}
}
