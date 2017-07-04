package com.landray.kmss.tib.soap.sync.model;

import java.util.Date;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.tib.soap.sync.forms.TibSoapSyncTempFuncForm;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;

/**
 * 定时任务对应函数表
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public class TibSoapSyncTempFunc extends BaseModel implements InterceptFieldEnabled {

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
	 * XML数据
	 */
	protected String fdSoapXml;
	
	/**
	 * @return XML数据
	 */
	public String getFdSoapXml() {
		return (String) readLazyField("fdSoapXml", fdSoapXml);
	}
	
	/**
	 * @param fdSoapXml XML数据
	 */
	public void setFdSoapXml(String fdSoapXml) {
		this.fdSoapXml = (String) writeLazyField("fdSoapXml",
				this.fdSoapXml, fdSoapXml);
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
	 * 定时任务id
	 */
	protected TibSoapSyncJob fdQuartz;
	
	/**
	 * @return 定时任务id
	 */
	public TibSoapSyncJob getFdQuartz() {
		return fdQuartz;
	}
	
	/**
	 * @param fdQuartz 定时任务id
	 */
	public void setFdQuartz(TibSoapSyncJob fdQuartz) {
		this.fdQuartz = fdQuartz;
	}
	
	/**
	 * soap函数id
	 */
	protected TibSysSoapMain fdSoapMain;
	
	/**
	 * @return soap函数id
	 */
	public TibSysSoapMain getFdSoapMain() {
		return fdSoapMain;
	}
	
	/**
	 * @param fdSoapMain soap函数id
	 */
	public void setFdSoapMain(TibSysSoapMain fdSoapMain) {
		this.fdSoapMain = fdSoapMain;
	}
	
	// 数据源
	protected CompDbcp fdCompDbcp;
	
	public CompDbcp getFdCompDbcp() {
		return fdCompDbcp;
	}

	public void setFdCompDbcp(CompDbcp fdCompDbcp) {
		this.fdCompDbcp = fdCompDbcp;
	}
	
	// 同步表
	protected String fdSyncTableXpath;
	
	public String getFdSyncTableXpath() {
		return fdSyncTableXpath;
	}

	public void setFdSyncTableXpath(String fdSyncTableXpath) {
		this.fdSyncTableXpath = fdSyncTableXpath;
	}

	// 同步方式
	protected String fdSyncType;

	public String getFdSyncType() {
		return fdSyncType;
	}

	public void setFdSyncType(String fdSyncType) {
		this.fdSyncType = fdSyncType;
	}
	
	// 时间戳列
	protected String fdTimeColumn;

	public String getFdTimeColumn() {
		return fdTimeColumn;
	}

	public void setFdTimeColumn(String fdTimeColumn) {
		this.fdTimeColumn = fdTimeColumn;
	}
	
	// 删除条件
	protected String fdDelCondition;

	public String getFdDelCondition() {
		return fdDelCondition;
	}

	public void setFdDelCondition(String fdDelCondition) {
		this.fdDelCondition = fdDelCondition;
	}

	// 最后执行时间
	protected Date fdLastDate;

	public Date getFdLastDate() {
		return fdLastDate;
	}

	public void setFdLastDate(Date fdLastDate) {
		this.fdLastDate = fdLastDate;
	}

	public Class getFormClass() {
		return TibSoapSyncTempFuncForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdQuartz.fdId", "fdQuartzId");
			toFormPropertyMap.put("fdQuartz.fdId", "fdQuartzName");
			toFormPropertyMap.put("fdSoapMain.fdId", "fdSoapMainId");
			toFormPropertyMap.put("fdSoapMain.docSubject", "fdSoapMainName");
			toFormPropertyMap.put("fdCompDbcp.fdId", "fdCompDbcpId");
			toFormPropertyMap.put("fdCompDbcp.fdName", "fdCompDbcpName");
		}
		return toFormPropertyMap;
	}
}
