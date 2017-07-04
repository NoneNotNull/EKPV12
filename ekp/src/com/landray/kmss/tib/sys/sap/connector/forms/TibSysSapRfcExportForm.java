package com.landray.kmss.tib.sys.sap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcExport;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;

/**
 * 传出参数配置 Form
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcExportForm extends ExtendForm {

	/**
	 * 排序号
	 */
	protected String fdOrder = null;

	/**
	 * @return 排序号
	 */
	public String getFdOrder() {
		return fdOrder;
	}

	/**
	 * @param fdOrder
	 *            排序号
	 */
	public void setFdOrder(String fdOrder) {
		this.fdOrder = fdOrder;
	}

	/**
	 * 启用
	 */
	protected String fdParameterUse = null;

	/**
	 * @return 启用
	 */
	public String getFdParameterUse() {
		return fdParameterUse;
	}

	/**
	 * @param fdParameterUse
	 *            启用
	 */
	public void setFdParameterUse(String fdParameterUse) {
		this.fdParameterUse = fdParameterUse;
	}

	/**
	 * 参数名称
	 */
	protected String fdParameterName = null;

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
	protected String fdParameterType = null;

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
	 * 数据类型
	 */
	protected String fdParameterTypeName = null;

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
	 * 说明
	 */
	protected String fdParameterMark = null;

	/**
	 * @return 说明
	 */
	public String getFdParameterMark() {
		return fdParameterMark;
	}

	/**
	 * @param fdParameterMark
	 *            说明
	 */
	public void setFdParameterMark(String fdParameterMark) {
		this.fdParameterMark = fdParameterMark;
	}

	/**
	 * 层级ID
	 */
	protected String fdHierarchyId = null;

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

	/**
	 * 所属函数的ID
	 */
	protected String fdFunctionId = null;

	/**
	 * @return 所属函数的ID
	 */
	public String getFdFunctionId() {
		return fdFunctionId;
	}

	/**
	 * @param fdFunctionId
	 *            所属函数的ID
	 */
	public void setFdFunctionId(String fdFunctionId) {
		this.fdFunctionId = fdFunctionId;
	}

	/**
	 * 所属函数的名称
	 */
	protected String fdFunctionName = null;

	/**
	 * @return 所属函数的名称
	 */
	public String getFdFunctionName() {
		return fdFunctionName;
	}

	/**
	 * @param fdFunctionName
	 *            所属函数的名称
	 */
	public void setFdFunctionName(String fdFunctionName) {
		this.fdFunctionName = fdFunctionName;
	}

	/**
	 * 父ID的ID
	 */
	protected String fdParentId = null;

	/**
	 * @return 父ID的ID
	 */
	public String getFdParentId() {
		return fdParentId;
	}

	/**
	 * @param fdParentId
	 *            父ID的ID
	 */
	public void setFdParentId(String fdParentId) {
		this.fdParentId = fdParentId;
	}

	/**
	 * 父ID的名称
	 */
	protected String fdParentName = null;

	/**
	 * @return 父ID的名称
	 */
	public String getFdParentName() {
		return fdParentName;
	}

	/**
	 * @param fdParentName
	 *            父ID的名称
	 */
	public void setFdParentName(String fdParentName) {
		this.fdParentName = fdParentName;
	}

	protected String fdRfcParamXml = null;

	public String getFdRfcParamXml() {
		return fdRfcParamXml;
	}

	// 用于将一些特殊字符转化后在前端展示
	public String getFdRfcParamXmlView() {
		return TibSysCoreUtil.filter(fdRfcParamXml);
	}

	public void setFdRfcParamXml(String fdRfcParamXml) {
		this.fdRfcParamXml = fdRfcParamXml;
	}

	protected String fdReturnFlag = "0";
	/**
	 * 返回成功标记
	 */
	protected String fdSuccess = null;

	/**
	 * 返回失败标记
	 */
	protected String fdFail = null;

	public String getFdSuccess() {
		return fdSuccess;
	}

	public void setFdSuccess(String fdSuccess) {
		this.fdSuccess = fdSuccess;
	}

	public String getFdFail() {
		return fdFail;
	}

	public void setFdFail(String fdFail) {
		this.fdFail = fdFail;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdOrder = null;
		fdParameterUse = null;
		fdParameterName = null;
		fdParameterType = null;
		fdParameterTypeName = null;
		fdParameterMark = null;
		fdHierarchyId = null;
		fdFunctionId = null;
		fdFunctionName = null;
		fdParentId = null;
		fdParentName = null;
		fdRfcParamXml = null;
		fdSuccess = null;
		fdFail = null;
		fdReturnFlag = null;
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSapRfcExport.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdFunctionId", new FormConvertor_IDToModel(
					"fdFunction", TibSysSapRfcSetting.class));
			toModelPropertyMap.put("fdParentId", new FormConvertor_IDToModel(
					"fdParent", TibSysSapRfcExport.class));
		}
		return toModelPropertyMap;
	}

	public String getFdReturnFlag() {
		return fdReturnFlag;
	}

	public void setFdReturnFlag(String fdReturnFlag) {
		this.fdReturnFlag = fdReturnFlag;
	}
}
