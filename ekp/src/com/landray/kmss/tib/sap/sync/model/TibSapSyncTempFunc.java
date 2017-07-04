package com.landray.kmss.tib.sap.sync.model;

import java.util.Date;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sap.sync.forms.TibSapSyncTempFuncForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;

/**
 * 定时任务对应函数表
 * 
 * @author 
 * @version 1.0 2011-10-20
 */
public class TibSapSyncTempFunc extends BaseModel {

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
	 * @param fdInvokeType 触发类型
	 */
	public void setFdInvokeType(Integer fdInvokeType) {
		this.fdInvokeType = fdInvokeType;
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
	 * @param fdFuncMark 用途说明
	 */
	public void setFdFuncMark(String fdFuncMark) {
		this.fdFuncMark = fdFuncMark;
	}
	
	/**
	 * rfcXml数据
	 */
	protected String fdRfcXml;

	/**
	 * @return rfcXml数据
	 */
	public String getFdRfcXml() {
		return (String) readLazyField("fdRfcXml", fdRfcXml);
	}

	/**
	 * @param fdRfcImport
	 *            rfcXml数据
	 */
	public void setFdRfcXml(String fdRfcImport) {
		this.fdRfcXml = (String) writeLazyField("fdRfcXml",
				this.fdRfcXml, fdRfcImport);
	}
	/**
	 * 最后修改时间
	 */
	protected Date fdEditorTime;
	
	
//
//	/**
//	 * 传出参数对应字段json
//	 */
//	protected String fdRfcExport;
//
//	/**
//	 * @return 传出参数对应字段json
//	 */
//	public String getFdRfcExport() {
//		return (String) readLazyField("fdRfcExport", fdRfcExport);
//	}
//
//	/**
//	 * @param fdRfcExport
//	 *            传出参数对应字段json
//	 */
//	public void setFdRfcExport(String fdRfcExport) {
//		this.fdRfcExport = (String) writeLazyField("fdRfcExport",
//				this.fdRfcExport, fdRfcExport);
//	}
	
	public Date getFdEditorTime() {
		return fdEditorTime;
	}

	public void setFdEditorTime(Date fdEditorTime) {
		this.fdEditorTime = fdEditorTime;
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
	 * @param fdUse 是否启用
	 */
	public void setFdUse(Boolean fdUse) {
		this.fdUse = fdUse;
	}
	
	/**
	 * 是否启用文件传输
	 */
	protected String fdSendType;
	
	
	
	public String getFdSendType() {
		return fdSendType;
	}

	public void setFdSendType(String fdSendType) {
		this.fdSendType = fdSendType;
	}

	/**
	 * 定时任务时间戳
	 */
	protected Date fdQuartzTime;
	
	/**
	 * @return 定时任务时间戳
	 */
	public Date getFdQuartzTime() {
		return fdQuartzTime;
	}
	
	/**
	 * @param fdQuartzTime 定时任务时间戳
	 */
	public void setFdQuartzTime(Date fdQuartzTime) {
		this.fdQuartzTime = fdQuartzTime;
	}
	
	/**
	 * rfc函数id
	 */
	protected TibSysSapRfcSetting fdRfcSetting;
	
	/**
	 * @return rfc函数id
	 */
	public TibSysSapRfcSetting getFdRfcSetting() {
		return fdRfcSetting;
	}
	
	/**
	 * @param fdRfcSetting rfc函数id
	 */
	public void setFdRfcSetting(TibSysSapRfcSetting fdRfcSetting) {
		this.fdRfcSetting = fdRfcSetting;
	}
	
	/**
	 * 定时任务id
	 */
	protected TibSapSyncJob fdQuartz;
	
	/**
	 * @return 定时任务id
	 */
	public TibSapSyncJob getFdQuartz() {
		return fdQuartz;
	}
	
	/**
	 * @param fdQuartz 定时任务id
	 */
	public void setFdQuartz(TibSapSyncJob fdQuartz) {
		this.fdQuartz = fdQuartz;
	}
	
	public Class getFormClass() {
		return TibSapSyncTempFuncForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdRfcSetting.fdId", "fdRfcSettingId");
			toFormPropertyMap.put("fdRfcSetting.fdFunctionName", "fdRfcSettingName");
			toFormPropertyMap.put("fdQuartz.fdId", "fdQuartzId");
			toFormPropertyMap.put("fdQuartz.fdId", "fdQuartzName");
		}
		return toFormPropertyMap;
	}
}
