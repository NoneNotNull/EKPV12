package com.landray.kmss.tib.common.mapping.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;

/**
 * 应用模块注册配置表 Form
 * 
 * @author
 * @version 1.0 2011-10-14
 */
@SuppressWarnings("serial")
public class TibCommonMappingModuleForm extends ExtendForm {

	/**
	 * 服务类型，1：代表支持SAP中间件，2代表支持WEB服务中间件
	 */
	protected String fdType = null;

	public String getFdType() {
		return fdType;
	}

	public void setFdType(String fdType) {
		this.fdType = fdType;
	}

	/**
	 * 服务器名称
	 */
	protected String fdServerName = null;

	/**
	 * @return 服务器名称
	 */
	public String getFdServerName() {
		return fdServerName;
	}

	/**
	 * @param fdServerName
	 *            服务器名称
	 */
	public void setFdServerName(String fdServerName) {
		this.fdServerName = fdServerName;
	}

	/**
	 * IP地址
	 */
	protected String fdServerIp = null;

	/**
	 * @return IP地址
	 */
	public String getFdServerIp() {
		return fdServerIp;
	}

	/**
	 * @param fdServerIp
	 *            IP地址
	 */
	public void setFdServerIp(String fdServerIp) {
		this.fdServerIp = fdServerIp;
	}

	/**
	 * 模块名称
	 */
	protected String fdModuleName = null;

	/**
	 * @return 模块名称
	 */
	public String getFdModuleName() {
		return fdModuleName;
	}

	/**
	 * @param fdModuleName
	 *            模块名称
	 */
	public void setFdModuleName(String fdModuleName) {
		this.fdModuleName = fdModuleName;
	}

	/**
	 * 模板modelName
	 */
	protected String fdTemplateName = null;

	/**
	 * @return 模板modelName
	 */
	public String getFdTemplateName() {
		return fdTemplateName;
	}

	/**
	 * @param fdModulePath
	 *            模板modelName
	 */
	public void setFdTemplateName(String fdTemplateName) {
		this.fdTemplateName = fdTemplateName;
	}

	/**
	 * 主文档modelName
	 */
	protected String fdMainModelName = null;

	public String getFdMainModelName() {
		return fdMainModelName;
	}

	public void setFdMainModelName(String fdMainModelName) {
		this.fdMainModelName = fdMainModelName;
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

	// 简单分类或者全局分类
	protected String fdCate = null;

	public String getFdCate() {
		return fdCate;
	}

	public void setFdCate(String fdCate) {
		this.fdCate = fdCate;
	}

	// 主文档的模板id字段名，一般为fdTemplate（model中属性）
	protected String fdModelTemFieldName = null;

	public String getFdModelTemFieldName() {
		return fdModelTemFieldName;
	}

	public void setFdModelTemFieldName(String fdModelTemFieldName) {
		this.fdModelTemFieldName = fdModelTemFieldName;
	}

	// 全局分类中主文档模板关联类别的字段名，一般为docCategory
	protected String fdTemCateFieldName = null;

	public String getFdTemCateFieldName() {
		return fdTemCateFieldName;
	}

	public void setFdTemCateFieldName(String fdTemCateFieldName) {
		this.fdTemCateFieldName = fdTemCateFieldName;
	}

	// 全局分类中主文档模板名称字段名，一般为fdName
	protected String fdTemNameFieldName = null;

	public String getFdTemNameFieldName() {
		return fdTemNameFieldName;
	}

	public void setFdTemNameFieldName(String fdTemNameFieldName) {
		this.fdTemNameFieldName = fdTemNameFieldName;
	}

	// 主文档的模板id字段名，一般为fdTemplateId（form中属性）
	protected String fdFormTemFieldName = null;

	public String getFdFormTemFieldName() {
		return fdFormTemFieldName;
	}

	public void setFdFormTemFieldName(String fdFormTemFieldName) {
		this.fdFormTemFieldName = fdFormTemFieldName;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdServerName = null;
		fdServerIp = null;
		fdModuleName = null;
		fdTemplateName = null;
		fdMainModelName = null;
		fdModelTemFieldName = null;
		fdTemCateFieldName = null;
		fdTemNameFieldName = null;
		fdFormTemFieldName = null;
		fdUse = "true";// 初始化为true
		fdCate = "1";// 初始化为0:简单分类
		super.reset(mapping, request);
	}

	@SuppressWarnings("unchecked")
	public Class getModelClass() {
		return TibCommonMappingModule.class;
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
