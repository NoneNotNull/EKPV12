package com.landray.kmss.tib.common.mapping.model;

import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingFuncForm;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;


/**
 * 模板/定时任务对应函数表
 * 
 * @author
 * @version 1.0 2011-10-16
 */
public class TibCommonMappingFunc extends BaseModel {
	

	//	集成类型
	protected String fdIntegrationType;
	
	public String getFdIntegrationTypeShow(){
		if(StringUtils.isEmpty(fdIntegrationType)){
			return "";
		}
		Map<String, String>  typemap=TibCommonMappingIntegrationPlugins.getConfigByType(fdIntegrationType);
		if(typemap==null||typemap.isEmpty()){
			return "";
		}
		String displayName=typemap.get(TibCommonMappingIntegrationPlugins.displayName);
		return displayName;
	}
	
	
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
	 * 触发类型
	 */
	protected Integer fdInvokeType;

	/**
	 * @return 触发类型
	 */
	public Integer getFdInvokeType() {
		return fdInvokeType;
	}

	/**
	 * @param fdInvokeType
	 *            触发类型
	 */
	public void setFdInvokeType(Integer fdInvokeType) {
		this.fdInvokeType = fdInvokeType;
	}

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
	 * 用途说明
	 */
	protected String fdFuncMark;

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
		return (String) readLazyField("fdRfcParamXml", fdRfcParamXml);
	}

	public void setFdRfcParamXml(String fdRfcParamXml) {
		this.fdRfcParamXml = (String) writeLazyField("fdRfcParamXml",
				this.fdRfcParamXml, fdRfcParamXml);
	}

	/**
	 * 表单事件jsp片段
	 */
	protected String fdJspSegmen;

	/**
	 * @return 表单事件jsp片段
	 */
	public String getFdJspSegmen() {
		return (String) readLazyField("fdJspSegmen", fdJspSegmen);
	}

	/**
	 * @param fdJspSegmen
	 *            表单事件jsp片段
	 */
	public void setFdJspSegmen(String fdJspSegmen) {
		this.fdJspSegmen = (String) writeLazyField("fdJspSegmen",
				this.fdJspSegmen, fdJspSegmen);
	}
	
	/**
	 * 表单事件jsp片段实际值
	 */
	protected String fdJspSegmentActual;

	public String getFdJspSegmentActual() {
		return fdJspSegmentActual;
	}

	public void setFdJspSegmentActual(String fdJspSegmentActual) {
		this.fdJspSegmentActual = (String) writeLazyField("fdJspSegmentActual",
				this.fdJspSegmentActual, fdJspSegmentActual);
	}


	/**
	 * 是否启用
	 */
	protected Boolean fdUse;

	/**
	 * @return 是否启用
	 */
	public Boolean getFdUse() {
		return fdUse;
	}

	/**
	 * @param fdUse
	 *            是否启用
	 */
	public void setFdUse(Boolean fdUse) {
		this.fdUse = fdUse;
	}

	/**
	 * 主文档id
	 */
	protected TibCommonMappingMain fdMain;

	/**
	 * @return 主文档id
	 */
	public TibCommonMappingMain getFdMain() {
		return fdMain;
	}

	/**
	 * @param fdMain
	 *            主文档id
	 */
	public void setFdMain(TibCommonMappingMain fdMain) {
		this.fdMain = fdMain;
	}

	/**
	 * 模板扩展表
	 */
	protected List<TibCommonMappingFuncExt> fdExtend;

	/**
	 * @return 模板扩展表
	 */
	public List<TibCommonMappingFuncExt> getFdExtend() {
		return fdExtend;
	}

	/**
	 * @param fdExtend
	 *            模板扩展表
	 */
	public void setFdExtend(List<TibCommonMappingFuncExt> fdExtend) {
		this.fdExtend = fdExtend;
	}

	public Class getFormClass() {
		return TibCommonMappingFuncForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	/**************************************************
       综合外键 关联的文档模板id
	 */
	private String  fdRefId ;
	private String  fdRefName ;
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
	
	//=================================================

	public String getFdIntegrationType() {
		return fdIntegrationType;
	}

	public void setFdIntegrationType(String fdIntegrationType) {
		this.fdIntegrationType = fdIntegrationType;
	}

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdExtend",
					new ModelConvertor_ModelListToFormList("fdExtendForms"));
			
			toFormPropertyMap.put("fdMain.fdId", "fdMainId");
			toFormPropertyMap.put("fdExtend",
					new ModelConvertor_ModelListToFormList("fdExtendForms"));
			
		}
		return toFormPropertyMap;
	}
	

}
