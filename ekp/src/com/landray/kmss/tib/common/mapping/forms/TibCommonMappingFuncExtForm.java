package com.landray.kmss.tib.common.mapping.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFuncExt;




/**
 * 模板扩展表 Form
 * 
 * @author 
 * @version 1.0 2012-03-09
 */
@SuppressWarnings("serial")
public class TibCommonMappingFuncExtForm extends ExtendForm {

	
	protected static String[] converJsonField={"fdId","fdExceptionType","fdIsIgnore","fdIsAssign","fdAssignField","fdAssignFieldid","fdRefId","fdAssignVal"};
	
	protected String fdExceptionType = null;
	
	/**
	 * 是否忽略异常
	 */
	protected String fdIsIgnore = null;
	
	/**
	 * @return 是否忽略异常
	 */
	public String getFdIsIgnore() {
		return fdIsIgnore;
	}
	
	/**
	 * @param fdIsIgnore 是否忽略异常
	 */
	public void setFdIsIgnore(String fdIsIgnore) {
		this.fdIsIgnore = fdIsIgnore;
	}
	
	/**
	 * 是否强制赋值
	 */
	protected String fdIsAssign = null;
	
	/**
	 * @return 是否强制赋值
	 */
	public String getFdIsAssign() {
		return fdIsAssign;
	}
	
	/**
	 * @param fdIsAssign 是否强制赋值
	 */
	public void setFdIsAssign(String fdIsAssign) {
		this.fdIsAssign = fdIsAssign;
	}
	
	/**
	 * 赋值字段名
	 */
	protected String fdAssignField = null;
	
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
	protected String fdAssignFieldid = null;
	
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
	
	protected String fdAssignVal = null;
	
	public String getFdAssignVal() {
		return fdAssignVal;
	}

	public void setFdAssignVal(String fdAssignVal) {
		this.fdAssignVal = fdAssignVal;
	}

	/**
	 * 关联模板id的ID
	 */
	protected String fdRefId = null;
	
	/**
	 * @return 关联模板id的ID
	 */
	public String getFdRefId() {
		return fdRefId;
	}
	
	/**
	 * @param fdRefId 关联模板id的ID
	 */
	public void setFdRefId(String fdRefId) {
		this.fdRefId = fdRefId;
	}
	
	/**
	 * 关联模板id的名称
	 */
	protected String fdRefName = null;
	
	/**
	 * @return 关联模板id的名称
	 */
	public String getFdRefName() {
		return fdRefName;
	}
	
	/**
	 * @param fdRefName 关联模板id的名称
	 */
	public void setFdRefName(String fdRefName) {
		this.fdRefName = fdRefName;
	}
	
	public String getFdExceptionType() {
		return fdExceptionType;
	}

	public void setFdExceptionType(String fdExceptionType) {
		this.fdExceptionType = fdExceptionType;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdIsIgnore = null;
		fdIsAssign = null;
		fdAssignField = null;
		fdAssignFieldid = null;
		fdRefId = null;
		fdRefName = null;
		fdExceptionType=null;
		super.reset(mapping, request);
	}

	@SuppressWarnings("unchecked")
	public Class getModelClass() {
		return TibCommonMappingFuncExt.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdRefId",
					new FormConvertor_IDToModel("fdRef",
						TibCommonMappingFunc.class));
		}
		return toModelPropertyMap;
	}
}
