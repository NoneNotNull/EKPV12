package com.landray.kmss.tib.common.mapping.plugins.control.model;

import java.util.Date;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.mapping.plugins.control.forms.TibCommonMappControlFieldForm;

/**
 * 控件
 * 
 * @author 
 * @version 1.0 2014-08-25
 */
public class TibCommonMappControlField extends BaseModel {

	/**
	 * xpath唯一标识
	 */
	protected String uuId;
	
	/**
	 * @return xpath唯一标识
	 */
	public String getUuId() {
		return uuId;
	}
	
	/**
	 * @param uuId xpath唯一标识
	 */
	public void setUuId(String uuId) {
		this.uuId = uuId;
	}
	
	/**
	 * 传入参数唯一标识
	 */
	protected String conditionsUuid;
	
	public String getConditionsUuid() {
		return conditionsUuid;
	}

	public void setConditionsUuid(String conditionsUuid) {
		this.conditionsUuid = conditionsUuid;
	}

	/**
	 * 字段值
	 */
	protected String fieldValue;
	
	/**
	 * @return 字段值
	 */
	public String getFieldValue() {
		return fieldValue;
	}
	
	/**
	 * @param fieldValue 字段值
	 */
	public void setFieldValue(String fieldValue) {
		this.fieldValue = fieldValue;
	}
	
	/**
	 * 行号
	 */
	protected Integer rowIndex;
	
	public Integer getRowIndex() {
		return rowIndex;
	}

	public void setRowIndex(Integer rowIndex) {
		this.rowIndex = rowIndex;
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
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	public Class getFormClass() {
		return TibCommonMappControlFieldForm.class;
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
