package com.landray.kmss.tib.common.mapping.forms;

import java.lang.reflect.InvocationTargetException;
import java.util.Collection;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingMain;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.util.AutoArrayList;
import com.landray.kmss.util.StringUtil;

/**
 * 模板/定时任务对应函数表 Form
 * 
 * @author
 * @version 1.0 2011-10-16
 */
@SuppressWarnings("serial")
public class TibCommonMappingFuncForm extends ExtendForm {
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
	 * 集成类型
	 */
	protected String fdIntegrationType = null;

	public String getFdIntegrationTypeShow() throws Exception {
		if (StringUtils.isEmpty(fdIntegrationType)) {
			return "";
		}

		Map<String, String> typemap = TibCommonMappingIntegrationPlugins
				.getRegisterdConfigs(fdTemplateId, fdIntegrationType);
		if (typemap == null || typemap.isEmpty()) {
			return "";
		}
		String displayName = typemap.get(TibCommonMappingIntegrationPlugins.displayName);
		return displayName;
	}

	public String getFdMapperJsp() {
		if (StringUtils.isEmpty(fdIntegrationType)) {
			return "";
		}

		Map<String, String> typemap = TibCommonMappingIntegrationPlugins
				.getConfigByType(fdIntegrationType);

		if (typemap == null || typemap.isEmpty()) {
			return "";
		}
		String fdMapperJsp = typemap.get(TibCommonMappingIntegrationPlugins.fdMapperJsp);
		return fdMapperJsp;
	}

	/**
	 * @param fdTemplateId
	 *            流程模板id
	 */
	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}

	/**
	 * 触发类型
	 */
	protected String fdInvokeType = null;

	/**
	 * @return 触发类型
	 */
	public String getFdInvokeType() {
		return fdInvokeType;
	}

	/**
	 * @param fdInvokeType
	 *            触发类型
	 */
	public void setFdInvokeType(String fdInvokeType) {
		this.fdInvokeType = fdInvokeType;
	}

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
	 * 用途说明
	 */
	protected String fdFuncMark = null;

	/**
	 * @return 用途说明
	 */
	public String getFdFuncMark() {
		return fdFuncMark;
	}

	/**
	 * @param fdFuncMark
	 *            用途说明
	 */
	public void setFdFuncMark(String fdFuncMark) {
		this.fdFuncMark = fdFuncMark;
	}

	/**
	 * @param fdRfcParamXml
	 *            函数参数xml格式文件
	 */
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

	/**
	 * 表单事件jsp片段
	 */
	protected String fdJspSegmen = null;

	/**
	 * @return 表单事件jsp片段
	 */
	public String getFdJspSegmen() {
		return fdJspSegmen;
	}

	// 用于将一些特殊字符转化后在前端展示
	public String getFdJspSegmenView() {
		return TibSysCoreUtil.filter(fdJspSegmen);
	}

	/**
	 * @param fdJspSegmen
	 *            表单事件jsp片段
	 */
	public void setFdJspSegmen(String fdJspSegmen) {
		this.fdJspSegmen = fdJspSegmen;
	}
	
	/**
	 * 表单事件jsp片段实际值
	 */
	protected String fdJspSegmentActual;

	public String getFdJspSegmentActual() {
		return fdJspSegmentActual;
	}

	public void setFdJspSegmentActual(String fdJspSegmentActual) {
		this.fdJspSegmentActual = fdJspSegmentActual;
	}

	public String getFdIntegrationType() {
		return fdIntegrationType;
	}

	public void setFdIntegrationType(String fdIntegrationType) {
		this.fdIntegrationType = fdIntegrationType;
		// 当type设置以后需要再次确认fdSettingIdView;
		setFdSettingIdView(this.fdSettingIdView);
		setFdSettingNameView(this.fdSettingNameView);
	}

	/**
	 * 是否启用
	 */
	protected String fdUse = null;

	/**
	 * @return 是否启用
	 */
	public String getFdUse() {
		return fdUse;
	}

	/**
	 * @param fdUse
	 *            是否启用
	 */
	public void setFdUse(String fdUse) {
		this.fdUse = fdUse;
	}

	/*********************************************************************
	 * 综合外键测试
	 */

	private String fdRefId;
	private String fdRefName;

	public String getFdRefId() {
		return fdRefId;
	}

	public void setFdRefId(String fdRefId) {
		this.fdRefId = fdRefId;
	}

	public String getFdRefName() {
		return fdRefName;
	}

	public void setFdRefName(String fdRefName) {
		this.fdRefName = fdRefName;
	}

	/**
	 * 主文档id的ID
	 */
	protected String fdMainId = null;

	/**
	 * @return 主文档id的ID
	 */
	public String getFdMainId() {
		return fdMainId;
	}

	/**
	 * @param fdMainId
	 *            主文档id的ID
	 */
	public void setFdMainId(String fdMainId) {
		this.fdMainId = fdMainId;
	}

	/**
	 * 关联模板id的表单
	 */
	protected AutoArrayList fdExtendForms = new AutoArrayList(
			TibCommonMappingFuncExtForm.class);

	protected String fdExtendFormsView = null;

	public String getFdExtendFormsView() {
		JSONArray jsonArray = new JSONArray();
		for (int i = 0, len = fdExtendForms.size(); i < len; i++) {
			JSONObject json = new JSONObject();
			Object form = fdExtendForms.get(i);
			for (String field : TibCommonMappingFuncExtForm.converJsonField) {
				if (PropertyUtils.isReadable(form, field)) {
					try {
						json.element(field, PropertyUtils.getProperty(form,
								field));
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						// TODO 自动生成 catch 块
						e.printStackTrace();
					} catch (NoSuchMethodException e) {
						// TODO 自动生成 catch 块
						e.printStackTrace();
					}
				}
			}
			jsonArray.add(json);
		}
		return TibSysCoreUtil.filter(jsonArray.toString());
	}

	public void setFdExtendFormsView(String fdExtendFormsView) {
		if (StringUtil.isNull(fdExtendFormsView))
			return;
		this.fdExtendFormsView = fdExtendFormsView;
		JSONArray jsonArray = JSONArray.fromObject(fdExtendFormsView);

		// 清空没有用的数据以及更新数据
		Collection<TibCommonMappingFuncExtForm> list = jsonArray.toCollection(
				jsonArray, TibCommonMappingFuncExtForm.class);
		this.fdExtendForms.addAll(list);

	}

	/**
	 * @return 关联模板id的表单
	 */
	public AutoArrayList getFdExtendForms() {
		return fdExtendForms;
	}

	/**
	 * @param fdExtendForms
	 *            关联模板id的表单
	 */
	public void setFdExtendForms(AutoArrayList fdExtendForms) {
		this.fdExtendForms = fdExtendForms;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdInvokeType = null;
		fdOrder = null;
		fdFuncMark = null;
		fdRfcParamXml = null;
		fdJspSegmen = null;
		fdJspSegmentActual = null;
		fdUse = null;
		fdMainId = null;
		fdTemplateId = null;
		fdExtendForms = new AutoArrayList(TibCommonMappingFuncExtForm.class);
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonMappingFunc.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());

			toModelPropertyMap.put("fdMainId", new FormConvertor_IDToModel(
					"fdMain", TibCommonMappingMain.class));
			toModelPropertyMap.put("fdExtendForms",
					new FormConvertor_FormListToModelList("fdExtend", "fdRef"));
			// =====================

			toModelPropertyMap.put("fdMainId", new FormConvertor_IDToModel(
					"fdMain", TibCommonMappingMain.class));
			toModelPropertyMap.put("fdExtendForms",
					new FormConvertor_FormListToModelList("fdExtend", "fdRef"));
		}
		return toModelPropertyMap;
	}

	// protected String fdSettingIdView=null;

	// ====================================\

	/**
	 * 用来对外显示的id fdWsServiceMainId fdRfcSettingId 合并
	 */
	public String getFdSettingIdView() {
		// return fdSettingIdView;
		if (StringUtils.isEmpty(fdIntegrationType)) {
			return "";
		}
		// 如果检查到type 来显示值
		// if(fdIntegrationType.equals(Constant.FD_TYPE_SAP)){
		// return getFdRfcSettingId();
		// }
		// if(fdIntegrationType.equals(Constant.FD_TYPE_WEBSERVICE)){
		// return getFdWsServiceMainId();
		// }
		return "";
	}

	private String fdSettingIdView;

	public void setFdSettingIdView(String fdSettingIdView) {

		this.fdSettingIdView = fdSettingIdView;

		if (StringUtils.isEmpty(getFdIntegrationType())) {
			// return "";
			return;
		}
		// 如果检查到type 来显示值
		// if(Constant.FD_TYPE_SAP.equals(fdIntegrationType)){
		// //return getFdRfcSettingName();
		// // 如果关联去掉,Name 放空
		// setFdWsServiceMainId("");
		// setFdRfcSettingId(fdSettingIdView);
		// }
		// if(Constant.FD_TYPE_WEBSERVICE.equals(fdIntegrationType)){
		// //return getFdWsServiceMainName();
		// setFdRfcSettingId("");
		// setFdWsServiceMainId(fdSettingIdView);
		// }
		// 其他...扩展
	}

	/**
	 * 用来对外显示的Name FdRfcSettingName FdWsServiceMainName 合并
	 */
	public String getFdSettingNameView() {

		if (StringUtils.isEmpty(fdIntegrationType)) {
			return "";
		}
		// 如果检查到type 来显示值
		// if(fdIntegrationType.equals(Constant.FD_TYPE_SAP)){
		// return getFdRfcSettingName();
		// }
		// if(fdIntegrationType.equals(Constant.FD_TYPE_WEBSERVICE)){
		// return getFdWsServiceMainName();
		// }
		return "";
	}

	private String fdSettingNameView;

	public void setFdSettingNameView(String fdSettingNameView) {

		if (StringUtils.isEmpty(getFdIntegrationType())) {
			// return "";
		}
		// 如果检查到type 来显示值
		// if(Constant.FD_TYPE_SAP.equals(fdIntegrationType)){
		// //return getFdRfcSettingName();
		// // 如果关联去掉,Name 放空
		// setFdWsServiceMainName("");
		// setFdRfcSettingName(fdSettingNameView);
		// }
		// if(Constant.FD_TYPE_WEBSERVICE.equals(fdIntegrationType)){
		// //return getFdWsServiceMainName();
		// setFdRfcSettingName("");
		// setFdWsServiceMainName(fdSettingNameView);
		// }
		// 其他...扩展

	}

	// public String getFdSettingId() {
	// return fdSettingId;
	// }
	//
	// public void setFdSettingId(String fdSettingId) {
	// this.fdSettingId = fdSettingId;
	// }
	//
	// public String getDocSubject() {
	// return docSubject;
	// }
	//
	// public void setDocSubject(String docSubject) {
	// this.docSubject = docSubject;
	// }

}
