package com.landray.kmss.tib.soap.sync.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncJob;
import com.landray.kmss.tib.soap.sync.model.TibSoapSyncTempFunc;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;


/**
 * 定时任务对应函数表 Form
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public class TibSoapSyncTempFuncForm extends ExtendForm {

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
	 * XML数据
	 */
	protected String fdSoapXml = null;
	
	/**
	 * @return XML数据
	 */
	public String getFdSoapXml() {
		return fdSoapXml;
	}
	
	/**
	 * @param fdSoapXml XML数据
	 */
	public void setFdSoapXml(String fdSoapXml) {
		this.fdSoapXml = fdSoapXml;
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
	 * @param fdUse 是否启用
	 */
	public void setFdUse(String fdUse) {
		this.fdUse = fdUse;
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
	
	/**
	 * soap函数id的ID
	 */
	protected String fdSoapMainId = null;
	
	/**
	 * @return soap函数id的ID
	 */
	public String getFdSoapMainId() {
		return fdSoapMainId;
	}
	
	/**
	 * @param fdSoapMainId soap函数id的ID
	 */
	public void setFdSoapMainId(String fdSoapMainId) {
		this.fdSoapMainId = fdSoapMainId;
	}
	
	/**
	 * soap函数id的名称
	 */
	protected String fdSoapMainName = null;
	
	/**
	 * @return soap函数id的名称
	 */
	public String getFdSoapMainName() {
		return fdSoapMainName;
	}
	
	/**
	 * @param fdSoapMainName soap函数id的名称
	 */
	public void setFdSoapMainName(String fdSoapMainName) {
		this.fdSoapMainName = fdSoapMainName;
	}
	
	// 数据源ID
	protected String fdCompDbcpId;
	
	public String getFdCompDbcpId() {
		return fdCompDbcpId;
	}

	public void setFdCompDbcpId(String fdCompDbcpId) {
		this.fdCompDbcpId = fdCompDbcpId;
	}
	
	// 数据源Name
	protected String fdCompDbcpName;
	
	public String getFdCompDbcpName() {
		return fdCompDbcpName;
	}

	public void setFdCompDbcpName(String fdCompDbcpName) {
		this.fdCompDbcpName = fdCompDbcpName;
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
	protected String fdLastDate;

	public String getFdLastDate() {
		return fdLastDate;
	}

	public void setFdLastDate(String fdLastDate) {
		this.fdLastDate = fdLastDate;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdInvokeType = null;
		fdFuncMark = null;
		fdSoapXml = null;
		fdUse = null;
		fdQuartzTime = null;
		fdQuartzId = null;
		fdQuartzName = null;
		fdSoapMainId = null;
		fdSoapMainName = null;
		fdCompDbcpId = null;
		fdCompDbcpName = null;
		fdSyncTableXpath = null;
		fdSyncType = null;
		fdTimeColumn = null;
		fdDelCondition = null;
		fdLastDate = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSoapSyncTempFunc.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdQuartzId",
					new FormConvertor_IDToModel("fdQuartz",
						TibSoapSyncJob.class));
			toModelPropertyMap.put("fdSoapMainId",
					new FormConvertor_IDToModel("fdSoapMain",
						TibSysSoapMain.class));
			toModelPropertyMap.put("fdCompDbcpId",
					new FormConvertor_IDToModel("fdCompDbcp",
							CompDbcp.class));
		}
		return toModelPropertyMap;
	}
}
