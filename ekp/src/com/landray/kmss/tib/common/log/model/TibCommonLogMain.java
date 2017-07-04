package com.landray.kmss.tib.common.log.model;

import java.util.Date;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelConvertor_Common;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.log.forms.TibCommonLogMainForm;

/**
 * TIB_COMMON日志管理
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogMain extends BaseModel implements InterceptFieldEnabled {

	public TibCommonLogMain(){
		
	}
	
	public TibCommonLogMain(String fdLogType, /*String fdTargetHost,*//* String fdExtMsg,*/
			Integer fdType, String fdUrl, String fdPoolName, Date fdStartTime,
			Date fdEndTime, String fdImportPar, String fdExportPar,
			String fdMessages, String fdIsErr/*, String funcName*/) {
		this.fdLogType = fdLogType;
		this.fdType = fdType;
		this.fdUrl = fdUrl;
		this.fdPoolName = fdPoolName;
		if(fdStartTime==null){
			fdStartTime=new Date();
		}
		this.fdStartTime = fdStartTime;
		if(fdEndTime==null){
			fdEndTime=new Date();
		}
		this.fdEndTime = fdEndTime;
		this.fdImportPar = fdImportPar;
		this.fdExportPar = fdExportPar;
		this.fdMessages = fdMessages;
		this.fdIsErr = fdIsErr;
	}
	
	public TibCommonLogMain(String fdLogType, Integer fdType,
			String fdPoolName, Date fdStartTime, String fdImportPar,
			String fdExportPar, String fdMessages, String fdIsErr) {
		this.fdLogType = fdLogType;
		this.fdType = fdType;
		this.fdPoolName = fdPoolName;
		if (fdEndTime == null) {
			fdEndTime = new Date();
		}
		if (fdStartTime == null) {
			fdStartTime = new Date();
		}
		this.fdStartTime = fdStartTime;
		this.fdImportPar = fdImportPar;
		this.fdExportPar = fdExportPar;
		this.fdMessages = fdMessages;
		this.fdIsErr = fdIsErr;
	}
	
	
	
	// 日志类型：webservice or sap 
	protected String fdLogType;
	
	// 发起请求的客户机端host 永辉需求
	protected String fdTargetHost;
	
	// 附加信息 用来扩展或者备注的
	protected String fdExtMsg; 
	
	/**
	 * 日志类型
	 */
	protected Integer fdType;
	
	/**
	 * @return 日志类型
	 */
	public Integer getFdType() {
		return fdType;
	}
	
	/**
	 * @param fdType 日志类型
	 */
	public void setFdType(Integer fdType) {
		this.fdType = fdType;
	}
	
	
	public String getFdExtMsg() {
		return fdExtMsg;
	}

	public void setFdExtMsg(String fdExtMsg) {
		this.fdExtMsg = fdExtMsg;
	}



	/**
	 * 相关URL
	 */
	protected String fdUrl;
	
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
	protected String fdPoolName;
	
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
	protected Date fdStartTime;
	
	/**
	 * @return 开始时间
	 */
	public Date getFdStartTime() {
		return fdStartTime;
	}
	
	/**
	 * @param fdStartTime 开始时间
	 */
	public void setFdStartTime(Date fdStartTime) {
		this.fdStartTime = fdStartTime;
	}
	
	/**
	 * 结束时间
	 */
	protected Date fdEndTime;
	
	/**
	 * @return 结束时间
	 */
	public Date getFdEndTime() {
		return fdEndTime;
	}
	
	/**
	 * @param fdEndTime 结束时间
	 */
	public void setFdEndTime(Date fdEndTime) {
		this.fdEndTime = fdEndTime;
	}
	
	/**
	 * 传入参数
	 */
	protected String fdImportPar;
	
	/**
	 * @return 传入参数
	 */
	public String getFdImportPar() {
		return (String) readLazyField("fdImportPar", fdImportPar);
	}
	
	/**
	 * @param fdImportPar 传入参数
	 */
	public void setFdImportPar(String fdImportPar) {
		this.fdImportPar = (String) writeLazyField("fdImportPar",
				this.fdImportPar, fdImportPar);
	}

	/**
	 * 传出参数
	 */
	protected String fdExportPar;
	
	/**
	 * @return 传出参数
	 */
	public String getFdExportPar() {
		return (String) readLazyField("fdExportPar", fdExportPar);
	}
	
	/**
	 * @param fdExportPar 传出参数
	 */
	public void setFdExportPar(String fdExportPar) {
		this.fdExportPar = (String) writeLazyField("fdExportPar",
				this.fdExportPar, fdExportPar);
	}

	/**
	 * 日志信息
	 */
	protected String fdMessages;
	
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
	
	public Class getFormClass() {
		return TibCommonLogMainForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdStartTime", new ModelConvertor_Common(
				"fdStartTime").setDateTimeType("time.sec"));
			toFormPropertyMap.put("fdEndTime", new ModelConvertor_Common(
				"fdEndTime").setDateTimeType("time.sec"));
		}
		return toFormPropertyMap;
	}
	
	/**
	 * 是否异常
	 */
	protected String fdIsErr;

	/**
	 * @return 是否异常
	 */
	public String getFdIsErr() {
		return fdIsErr;
	}

	/**
	 * @param fdIsErr
	 *            是否异常
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
	
	
	
}
