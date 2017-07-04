package com.landray.kmss.tib.common.log.forms;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.log.model.TibCommonLogMain;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.util.StringUtil;


/**
 * TIB_COMMON日志管理 Form
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogMainForm extends ExtendForm {

//	日志类型：webservice or sap 
	protected String fdLogType;
	
//	发起请求的客户机端host 永辉需求
	protected String fdTargetHost;
	
//	附加信息 用来扩展或者备注的
	protected String fdExtMsg; 
	
	/**
	 * 日志类型
	 */
	protected String fdType = null;
	
	/**
	 * @return 日志类型
	 */
	public String getFdType() {
		return fdType;
	}
	
	/**
	 * @param fdType 日志类型
	 */
	public void setFdType(String fdType) {
		this.fdType = fdType;
	}
	
//	展现
	public String getDisplayTypeName(){
		if(StringUtil.isNotNull(fdLogType)){
			Map<String, String>  mapInfo=TibCommonMappingIntegrationPlugins.getConfigByType(fdLogType);
			if(mapInfo!=null){
				return mapInfo.get(TibCommonMappingIntegrationPlugins.displayName);
			}
		}
		return "";
	}
	
	
	/**
	 * 相关URL
	 */
	protected String fdUrl = null;
	
	/**
	 * @return 相关URL
	 */
	public String getFdUrl() {
		return fdUrl;
	}
	
	/**
	 * @param fdUrl 相关URL
	 */
	public void setFdUrl(String fdUrl) {
		this.fdUrl = fdUrl;
	}
	
	/**
	 * 服务名称
	 */
	protected String fdPoolName = null;
	
	/**
	 * @return 服务名称
	 */
	public String getFdPoolName() {
		return fdPoolName;
	}
	
	/**
	 * @param fdPoolName 服务名称
	 */
	public void setFdPoolName(String fdPoolName) {
		this.fdPoolName = fdPoolName;
	}
	
	/**
	 * 开始时间
	 */
	protected String fdStartTime = null;
	
	/**
	 * @return 开始时间
	 */
	public String getFdStartTime() {
		return fdStartTime;
	}
	
	/**
	 * @param fdStartTime 开始时间
	 */
	public void setFdStartTime(String fdStartTime) {
		this.fdStartTime = fdStartTime;
	}
	
	/**
	 * 结束时间
	 */
	protected String fdEndTime = null;
	
	/**
	 * @return 结束时间
	 */
	public String getFdEndTime() {
		return fdEndTime;
	}
	
	/**
	 * @param fdEndTime 结束时间
	 */
	public void setFdEndTime(String fdEndTime) {
		this.fdEndTime = fdEndTime;
	}
	
	/**
	 * 传入参数
	 */
	protected String fdImportPar = null;
	
	/**
	 * @return 传入参数
	 */
	public String getFdImportPar() {
		return fdImportPar;
	}
	
	/**
	 * @param fdImportPar 传入参数
	 */
	public void setFdImportPar(String fdImportPar) {
		this.fdImportPar = fdImportPar;
	}
	
	/**
	 * 传出参数
	 */
	protected String fdExportPar = null;
	
	/**
	 * @return 传出参数
	 */
	public String getFdExportPar() {
		return fdExportPar;
	}
	
	/**
	 * @param fdExportPar 传出参数
	 */
	public void setFdExportPar(String fdExportPar) {
		this.fdExportPar = fdExportPar;
	}
	
	/**
	 * 日志信息
	 */
	protected String fdMessages = null;
	
	/**
	 * @return 日志信息
	 */
	public String getFdMessages() {
		return fdMessages;
	}
	
	/**
	 * @param fdMessages 日志信息
	 */
	public void setFdMessages(String fdMessages) {
		this.fdMessages = fdMessages;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdType = null;
		fdUrl = null;
		fdPoolName = null;
		fdStartTime = null;
		fdEndTime = null;
		fdImportPar = null;
		fdExportPar = null;
		fdMessages = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonLogMain.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
		}
		return toModelPropertyMap;
	}
	
	/**
	 * 是否异常
	 */
	protected String fdIsErr = null;
	
	/**
	 * @return 是否异常
	 */
	public String getFdIsErr() {
		return fdIsErr;
	}
	
	/**
	 * @param fdIsErr 是否异常
	 */
	public void setFdIsErr(String fdIsErr) {
		this.fdIsErr = fdIsErr;
	}
	
	/**
	 * 函数名称
	 */
	private String funcName;

	public String getFuncName() {
		return funcName;
	}

	public void setFuncName(String funcName) {
		this.funcName = funcName;
	}

	public String getFdLogType() {
		return fdLogType;
	}

	public void setFdLogType(String fdLogType) {
		this.fdLogType = fdLogType;
	}

	public String getFdTargetHost() {
		return fdTargetHost;
	}

	public void setFdTargetHost(String fdTargetHost) {
		this.fdTargetHost = fdTargetHost;
	}

	public String getFdExtMsg() {
		return fdExtMsg;
	}

	public void setFdExtMsg(String fdExtMsg) {
		this.fdExtMsg = fdExtMsg;
	}
	
	
}
