package com.landray.kmss.tib.common.mapping.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingMain;
import com.landray.kmss.util.AutoArrayList;

/**
 * 主文档表 Form
 * 
 * @author
 * @version 1.0 2011-10-16
 */
@SuppressWarnings("serial")
public class TibCommonMappingMainForm extends ExtendForm {
	/**
	 * 流程模板id
	 */
	protected String fdTemplateId = null;

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
	protected AutoArrayList fdFormEventFunctionListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	/**
	 * @return 表单事件函数列表
	 */
	public AutoArrayList getFdFormEventFunctionListForms() {
		return fdFormEventFunctionListForms;
	}

	/**
	 * @param fdFunctionListForms
	 *            表单事件函数列表
	 */
	public void setFdFormEventFunctionListForms(
			AutoArrayList fdFormEventFunctionListForms) {
		this.fdFormEventFunctionListForms = fdFormEventFunctionListForms;
	}

	/**
	 * 表单新建函数列表
	 */
	protected AutoArrayList fdFormAddFunctionListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	public AutoArrayList getFdFormAddFunctionListForms() {
		return fdFormAddFunctionListForms;
	}

	public void setFdFormAddFunctionListForms(
			AutoArrayList fdFormAddFunctionListForms) {
		this.fdFormAddFunctionListForms = fdFormAddFunctionListForms;
	}

	/**
	 * 表单删除函数列表
	 */
	protected AutoArrayList fdFormDelFunctionListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	public AutoArrayList getFdFormDelFunctionListForms() {
		return fdFormDelFunctionListForms;
	}

	public void setFdFormDelFunctionListForms(
			AutoArrayList fdFormDelFunctionListForms) {
		this.fdFormDelFunctionListForms = fdFormDelFunctionListForms;
	}

	/**
	 * 机器人函数列表
	 */
	protected AutoArrayList fdRobotFunctionListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	public AutoArrayList getFdRobotFunctionListForms() {
		return fdRobotFunctionListForms;
	}

	public void setFdRobotFunctionListForms(
			AutoArrayList fdRobotFunctionListForms) {
		this.fdRobotFunctionListForms = fdRobotFunctionListForms;
	}

	/**
	 * 表单保存函数列表
	 */
	protected AutoArrayList fdFormSaveFunctionListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	public AutoArrayList getFdFormSaveFunctionListForms() {
		return fdFormSaveFunctionListForms;
	}

	public void setFdFormSaveFunctionListForms(
			AutoArrayList fdFormSaveFunctionListForms) {
		this.fdFormSaveFunctionListForms = fdFormSaveFunctionListForms;
	}
	
	/**
	 * 表单控件列表
	 */
	protected AutoArrayList fdFormControlFunctionListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	public AutoArrayList getFdFormControlFunctionListForms() {
		return fdFormControlFunctionListForms;
	}

	public void setFdFormControlFunctionListForms(
			AutoArrayList fdFormControlFunctionListForms) {
		this.fdFormControlFunctionListForms = fdFormControlFunctionListForms;
	}
	
	/**
	 * 流程驳回列表
	 */
	protected AutoArrayList fdFlowRejectListForms = new AutoArrayList(
			TibCommonMappingFuncForm.class);

	public AutoArrayList getFdFlowRejectListForms() {
		return fdFlowRejectListForms;
	}

	public void setFdFlowRejectListForms(AutoArrayList fdFlowRejectListForms) {
		this.fdFlowRejectListForms = fdFlowRejectListForms;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdTemplateId = null;
		fdFormEventFunctionListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		fdFormAddFunctionListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		fdFormDelFunctionListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		fdRobotFunctionListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		fdFormControlFunctionListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		fdFormSaveFunctionListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		fdFlowRejectListForms = new AutoArrayList(TibCommonMappingFuncForm.class);
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonMappingMain.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdFormEventFunctionListForms",
					new FormConvertor_FormListToModelList(
							"fdFormEventFunctionList", "fdFormEventMain"));
			toModelPropertyMap.put("fdFormAddFunctionListForms",
					new FormConvertor_FormListToModelList(
							"fdFormAddFunctionList", "fdFormAddMain"));
			toModelPropertyMap.put("fdFormDelFunctionListForms",
					new FormConvertor_FormListToModelList(
							"fdFormDelFunctionList", "fdFormDelMain"));
			toModelPropertyMap.put("fdRobotFunctionListForms",
					new FormConvertor_FormListToModelList(
							"fdRobotFunctionList", "fdRobotMain"));
			toModelPropertyMap.put("fdFormSaveFunctionListForms",
					new FormConvertor_FormListToModelList(
							"fdFormSaveFunctionList", "fdFormSaveMain"));
			
			toModelPropertyMap.put("fdFormControlFunctionListForms",
					new FormConvertor_FormListToModelList(
							"fdFormControlFunctionList", "fdFormControlMain"));
			toModelPropertyMap.put("fdFlowRejectListForms",
					new FormConvertor_FormListToModelList(
							"fdFlowRejectList", "fdFlowRejectMain"));
			
			
		}
		return toModelPropertyMap;
	}
}
