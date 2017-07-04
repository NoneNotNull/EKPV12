package com.landray.kmss.tib.common.mapping.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingFuncExtForm;


/**
 * 模板扩展表
 * 
 * @author 
 * @version 1.0 2012-03-09
 */
public class TibCommonMappingFuncExt extends BaseModel {

	/**
	 * 异常类型，业务失败 or 普通异常 or 其他扩展
	 */
	protected String fdExceptionType;
	
	/**
	 * 是否忽略异常
	 */
	protected Boolean fdIsIgnore;
	
	/**
	 * @return 是否忽略异常
	 */
	public Boolean getFdIsIgnore() {
		return fdIsIgnore;
	}
	
	/**
	 * @param fdIsIgnore 是否忽略异常
	 */
	public void setFdIsIgnore(Boolean fdIsIgnore) {
		this.fdIsIgnore = fdIsIgnore;
	}
	
	/**
	 * 是否强制赋值
	 */
	protected Boolean fdIsAssign;
	
	/**
	 * @return 是否强制赋值
	 */
	public Boolean getFdIsAssign() {
		return fdIsAssign;
	}
	
	/**
	 * @param fdIsAssign 是否强制赋值
	 */
	public void setFdIsAssign(Boolean fdIsAssign) {
		this.fdIsAssign = fdIsAssign;
	}
	
	/**
	 * 赋值字段名
	 */
	protected String fdAssignField;
	
	/**
	 * @return 赋值字段名
	 */
	public String getFdAssignField() {
		return fdAssignField;
	}
	
	/**
	 * @param fdAssignField 赋值字段名
	 */
	public void setFdAssignField(String fdAssignField) {
		this.fdAssignField = fdAssignField;
	}
	
	/**
	 * 赋值字段id
	 */
	protected String fdAssignFieldid;
	
	/**
	 * @return 赋值字段id
	 */
	public String getFdAssignFieldid() {
		return fdAssignFieldid;
	}
	
	/**
	 * @param fdAssignFieldid 赋值字段id
	 */
	public void setFdAssignFieldid(String fdAssignFieldid) {
		this.fdAssignFieldid = fdAssignFieldid;
	}
	
	public  String fdAssignVal;
	
	public String getFdAssignVal() {
		return fdAssignVal;
	}

	public void setFdAssignVal(String fdAssignVal) {
		this.fdAssignVal = fdAssignVal;
	}

	/**
	 * 关联模板id
	 */
	protected TibCommonMappingFunc fdRef;
	
	/**
	 * @return 关联模板id
	 */
	public TibCommonMappingFunc getFdRef() {
		return fdRef;
	}
	/**
	 * @param fdRef 关联模板id
	 */
	public void setFdRef(TibCommonMappingFunc fdRef) {
		this.fdRef = fdRef;
	}
	
	public String getFdExceptionType() {
		return fdExceptionType;
	}

	public void setFdExceptionType(String fdExceptionType) {
		this.fdExceptionType = fdExceptionType;
	}

	public Class getFormClass() {
		return TibCommonMappingFuncExtForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdRef.fdId", "fdRefId");
//			toFormPropertyMap.put("fdRef.fdId", "fdRefName");
		}
		return toFormPropertyMap;
	}
}
