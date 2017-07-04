package com.landray.kmss.tib.common.mapping.model;

import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingMainForm;

/**
 * 主文档表
 * 
 * @author
 * @version 1.0 2011-10-16
 */
public class TibCommonMappingMain extends BaseModel {
	/**
	 * 流程模板id
	 */
	protected String fdTemplateId;

	/**
	 * @return 流程模板id
	 */
	public String getFdTemplateId() {
		return fdTemplateId;
	}

	/**
	 * @param fdTemplateId
	 *            流程模板id
	 */
	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}

	/**
	 * @param fdTemplateName
	 *            流程模板名称
	 */
	protected String fdTemplateName = null;

	public String getFdTemplateName() {
		return fdTemplateName;
	}

	public void setFdTemplateName(String fdTemplateName) {
		this.fdTemplateName = fdTemplateName;
	}

	/**
	 * @param fdMainModelName
	 *            文档主域模型modelName
	 */
	protected String fdMainModelName = null;

	public String getFdMainModelName() {
		return fdMainModelName;
	}

	public void setFdMainModelName(String fdMainModelName) {
		this.fdMainModelName = fdMainModelName;
	}

	/**
	 * 表单事件函数列表
	 */
	protected List<TibCommonMappingFunc> fdFormEventFunctionList;

	
	
	protected List<TibCommonMappingFunc> fdFormControlFunctionList;
	
	
	
	public List<TibCommonMappingFunc> getFdFormControlFunctionList() {
		return fdFormControlFunctionList;
	}

	public void setFdFormControlFunctionList(
			List<TibCommonMappingFunc> fdFormControlFunctionList) {
		this.fdFormControlFunctionList = fdFormControlFunctionList;
	}

	/**
	 * @return 表单事件函数列表
	 */
	public List<TibCommonMappingFunc> getFdFormEventFunctionList() {
		return fdFormEventFunctionList;
	}

	/**
	 * @param fdFunctionList
	 *            表单事件函数列表
	 */
	public void setFdFormEventFunctionList(
			List<TibCommonMappingFunc> fdFormEventFunctionList) {
		this.fdFormEventFunctionList = fdFormEventFunctionList;
	}

	/**
	 * 表单新建函数列表
	 */
	protected List<TibCommonMappingFunc> fdFormAddFunctionList;

	public List<TibCommonMappingFunc> getFdFormAddFunctionList() {
		return fdFormAddFunctionList;
	}

	public void setFdFormAddFunctionList(
			List<TibCommonMappingFunc> fdFormAddFunctionList) {
		this.fdFormAddFunctionList = fdFormAddFunctionList;
	}

	/**
	 * 表单删除函数列表
	 */
	protected List<TibCommonMappingFunc> fdFormDelFunctionList;

	public List<TibCommonMappingFunc> getFdFormDelFunctionList() {
		return fdFormDelFunctionList;
	}

	public void setFdFormDelFunctionList(
			List<TibCommonMappingFunc> fdFormDelFunctionList) {
		this.fdFormDelFunctionList = fdFormDelFunctionList;
	}

	/**
	 * 机器人函数列表
	 */
	protected List<TibCommonMappingFunc> fdRobotFunctionList;

	public List<TibCommonMappingFunc> getFdRobotFunctionList() {
		return fdRobotFunctionList;
	}

	public void setFdRobotFunctionList(List<TibCommonMappingFunc> fdRobotFunctionList) {
		this.fdRobotFunctionList = fdRobotFunctionList;
	}

	/**
	 * 表单保存函数列表
	 */
	protected List<TibCommonMappingFunc> fdFormSaveFunctionList;

	public List<TibCommonMappingFunc> getFdFormSaveFunctionList() {
		return fdFormSaveFunctionList;
	}

	public void setFdFormSaveFunctionList(
			List<TibCommonMappingFunc> fdFormSaveFunctionList) {
		this.fdFormSaveFunctionList = fdFormSaveFunctionList;
	}
	
	/**
	 * 流程驳回列表
	 */
	protected List<TibCommonMappingFunc> fdFlowRejectList;

	public List<TibCommonMappingFunc> getFdFlowRejectList() {
		return fdFlowRejectList;
	}

	public void setFdFlowRejectList(List<TibCommonMappingFunc> fdFlowRejectList) {
		this.fdFlowRejectList = fdFlowRejectList;
	}

	public Class getFormClass() {
		return TibCommonMappingMainForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdFormEventFunctionList",
					new ModelConvertor_ModelListToFormList(
							"fdFormEventFunctionListForms"));
			toFormPropertyMap.put("fdFormAddFunctionList",
					new ModelConvertor_ModelListToFormList(
							"fdFormAddFunctionListForms"));
			toFormPropertyMap.put("fdFormDelFunctionList",
					new ModelConvertor_ModelListToFormList(
							"fdFormDelFunctionListForms"));
			toFormPropertyMap.put("fdRobotFunctionList",
					new ModelConvertor_ModelListToFormList(
							"fdRobotFunctionListForms"));
			toFormPropertyMap.put("fdFormSaveFunctionList",
					new ModelConvertor_ModelListToFormList(
							"fdFormSaveFunctionListForms"));
			
			toFormPropertyMap.put("fdFormControlFunctionList",
					new ModelConvertor_ModelListToFormList(
							"fdFormControlFunctionListForms"));
			toFormPropertyMap.put("fdFlowRejectList",
					new ModelConvertor_ModelListToFormList(
					"fdFlowRejectListForms"));
			
		}
		return toFormPropertyMap;
	}
}
