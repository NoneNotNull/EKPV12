package com.landray.kmss.tib.sap.sync.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncJob;
import com.landray.kmss.tib.sap.sync.model.TibSapSyncTempFunc;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;


/**
 * 定时任务对应函数表 Form
 * 
 * @author 
 * @version 1.0 2011-10-20
 */
public class TibSapSyncTempFuncForm extends ExtendForm {

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
	 * @param fdInvokeType 触发类型
	 */
	public void setFdInvokeType(String fdInvokeType) {
		this.fdInvokeType = fdInvokeType;
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
	 * @param fdFuncMark 用途说明
	 */
	public void setFdFuncMark(String fdFuncMark) {
		this.fdFuncMark = fdFuncMark;
	}
	
	/**
	 * rfcXml数据
	 */
	protected String fdRfcXml = null;
	
	/**
	 * @return rfcXml数据
	 */
	public String getFdRfcXml() {
		return fdRfcXml;
//		return TibSapMappingUtil.filter(fdRfcXml);
	}
	
	/**
	 * @param fdRfcImport rfcXml数据
	 */
	public void setFdRfcXml(String fdRfcXml) {
		this.fdRfcXml = fdRfcXml;
	}
	
	// 用于将一些特殊字符转化后在前端展示
	public String getFdRfcXmlView() {
		return TibSysCoreUtil.filter(fdRfcXml);
	}
	
//	
//	/**
//	 * 传出参数对应字段json
//	 */
//	protected String fdRfcExport = null;
//	
//	/**
//	 * @return 传出参数对应字段json
//	 */
//	public String getFdRfcExport() {
//		return fdRfcExport;
//	}
//	
//	/**
//	 * @param fdRfcExport 传出参数对应字段json
//	 */
//	public void setFdRfcExport(String fdRfcExport) {
//		this.fdRfcExport = fdRfcExport;
//	}
//	
//	// 用于将一些特殊字符转化后在前端展示
//	public String getFdRfcImportView() {
//		return TibSapMappingUtil.filter(fdRfcImport);
//	}
//	
//	// 用于将一些特殊字符转化后在前端展示
//	public String getFdRfcExportView() {
//		return TibSapMappingUtil.filter(fdRfcExport);
//	}
	
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
	 * @param fdUse 是否启用
	 */
	public void setFdUse(String fdUse) {
		this.fdUse = fdUse;
	}
	
	
	/**
	 * 是否启用文件传输
	 */
	protected String fdSendType;
	
	/**
	 * @return 是否启用文件传输
	 */
	public String getFdSendType() {
		return fdSendType;
	}
	
	/**
	 * @param fdUse 是否启用文件传输
	 */
	public void setFdSendType(String fdSendType) {
		this.fdSendType= fdSendType;
	}
	
	/**
	 * 最后修改时间
	 */
	protected String fdEditorTime = null;
	
	public String getFdEditorTime() {
		return fdEditorTime;
	}

	public void setFdEditorTime(String fdEditorTime) {
		this.fdEditorTime = fdEditorTime;
	}

	/**
	 * 定时任务时间戳
	 */
	protected String fdQuartzTime = null;
	
	/**
	 * @return 定时任务时间戳
	 */
	public String getFdQuartzTime() {
		return fdQuartzTime;
	}
	
	/**
	 * @param fdQuartzTime 定时任务时间戳
	 */
	public void setFdQuartzTime(String fdQuartzTime) {
		this.fdQuartzTime = fdQuartzTime;
	}
	
	/**
	 * rfc函数id的ID
	 */
	protected String fdRfcSettingId = null;
	
	/**
	 * @return rfc函数id的ID
	 */
	public String getFdRfcSettingId() {
		return fdRfcSettingId;
	}
	
	/**
	 * @param fdRfcSettingId rfc函数id的ID
	 */
	public void setFdRfcSettingId(String fdRfcSettingId) {
		this.fdRfcSettingId = fdRfcSettingId;
	}
	
	/**
	 * rfc函数id的名称
	 */
	protected String fdRfcSettingName = null;
	
	/**
	 * @return rfc函数id的名称
	 */
	public String getFdRfcSettingName() {
		return fdRfcSettingName;
	}
	
	/**
	 * @param fdRfcSettingName rfc函数id的名称
	 */
	public void setFdRfcSettingName(String fdRfcSettingName) {
		this.fdRfcSettingName = fdRfcSettingName;
	}
	
	/**
	 * 定时任务id的ID
	 */
	protected String fdQuartzId = null;
	
	/**
	 * @return 定时任务id的ID
	 */
	public String getFdQuartzId() {
		return fdQuartzId;
	}
	
	/**
	 * @param fdQuartzId 定时任务id的ID
	 */
	public void setFdQuartzId(String fdQuartzId) {
		this.fdQuartzId = fdQuartzId;
	}
	
	/**
	 * 定时任务id的名称
	 */
	protected String fdQuartzName = null;
	
	/**
	 * @return 定时任务id的名称
	 */
	public String getFdQuartzName() {
		return fdQuartzName;
	}
	
	/**
	 * @param fdQuartzName 定时任务id的名称
	 */
	public void setFdQuartzName(String fdQuartzName) {
		this.fdQuartzName = fdQuartzName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdInvokeType = null;
		fdFuncMark = null;
		fdRfcXml = null;
//		fdRfcExport = null;
		fdUse = null;
		fdSendType=null;
		fdQuartzTime = null;
		fdRfcSettingId = null;
		fdRfcSettingName = null;
		fdQuartzId = null;
		fdQuartzName = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSapSyncTempFunc.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdRfcSettingId",
					new FormConvertor_IDToModel("fdRfcSetting",
						TibSysSapRfcSetting.class));
			toModelPropertyMap.put("fdQuartzId",
					new FormConvertor_IDToModel("fdQuartz",
						TibSapSyncJob.class));
		}
		return toModelPropertyMap;
	}
}
