package com.landray.kmss.tib.common.mapping.plugins.control.forms;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionMapping;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.util.AutoArrayList;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;

import com.landray.kmss.tib.common.mapping.plugins.control.model.TibCommonMappControlField;


/**
 * 控件 Form
 * 
 * @author 
 * @version 1.0 2014-08-25
 */
public class TibCommonMappControlFieldForm extends ExtendForm {

	/**
	 * xpath唯一标识
	 */
	protected String uuId = null;
	
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
	protected String conditionsuuid = null;
	
	/**
	 * @return 传入参数唯一标识
	 */
	public String getConditionsuuid() {
		return conditionsuuid;
	}
	
	/**
	 * @param conditionsuuid 传入参数唯一标识
	 */
	public void setConditionsuuid(String conditionsuuid) {
		this.conditionsuuid = conditionsuuid;
	}
	
	/**
	 * 字段值
	 */
	protected String fieldValue = null;
	
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
	protected String rowIndex = null;
	
	/**
	 * @return 行号
	 */
	public String getRowIndex() {
		return rowIndex;
	}
	
	/**
	 * @param rowIndex 行号
	 */
	public void setRowIndex(String rowIndex) {
		this.rowIndex = rowIndex;
	}
	
	/**
	 * 创建时间
	 */
	protected String docCreateTime = null;
	
	/**
	 * @return 创建时间
	 */
	public String getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		uuId = null;
		conditionsuuid = null;
		fieldValue = null;
		rowIndex = null;
		docCreateTime = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonMappControlField.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
		}
		return toModelPropertyMap;
	}
}
