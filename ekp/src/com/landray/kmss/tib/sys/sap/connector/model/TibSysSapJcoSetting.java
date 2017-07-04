package com.landray.kmss.tib.sys.sap.connector.model;

import java.util.Date;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapJcoSettingForm;

/**
 * jco配置
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapJcoSetting extends BaseModel {

	/**
	 * 连接池名称
	 */
	protected String fdPoolName;

	/**
	 * @return 连接池名称
	 */
	public String getFdPoolName() {
		return fdPoolName;
	}

	/**
	 * @param fdPoolName
	 *            连接池名称
	 */
	public void setFdPoolName(String fdPoolName) {
		this.fdPoolName = fdPoolName;
	}

	/**
	 * 用户名
	 */
	protected String fdPoolAdmin;

	/**
	 * @return 用户名
	 */
	public String getFdPoolAdmin() {
		return fdPoolAdmin;
	}

	/**
	 * @param fdPoolAdmin
	 *            用户名
	 */
	public void setFdPoolAdmin(String fdPoolAdmin) {
		this.fdPoolAdmin = fdPoolAdmin;
	}

	/**
	 * 密码
	 */
	protected String fdPoolSecret;

	/**
	 * @return 密码
	 */
	public String getFdPoolSecret() {
		return fdPoolSecret;
	}

	/**
	 * @param fdPoolSecret
	 *            密码
	 */
	public void setFdPoolSecret(String fdPoolSecret) {
		this.fdPoolSecret = fdPoolSecret;
	}

	/**
	 * 状态
	 */
	protected Boolean fdPoolStatus;

	/**
	 * @return 状态
	 */
	public Boolean getFdPoolStatus() {
		return fdPoolStatus;
	}

	/**
	 * @param fdPoolStatus
	 *            状态
	 */
	public void setFdPoolStatus(Boolean fdPoolStatus) {
		this.fdPoolStatus = fdPoolStatus;
	}

	/**
	 * 连接类型
	 */
	protected Integer fdConnectType;

	/**
	 * @return 连接类型
	 */
	public Integer getFdConnectType() {
		return fdConnectType;
	}

	/**
	 * @param fdConnectType
	 *            连接类型
	 */
	public void setFdConnectType(Integer fdConnectType) {
		this.fdConnectType = fdConnectType;
	}

	/**
	 * 最大空闲连接数
	 */
	protected Integer fdPoolCapacity;

	/**
	 * @return 最大空闲连接数
	 */
	public Integer getFdPoolCapacity() {
		return fdPoolCapacity;
	}

	/**
	 * @param fdPoolCapacity
	 *            最大空闲连接数
	 */
	public void setFdPoolCapacity(Integer fdPoolCapacity) {
		this.fdPoolCapacity = fdPoolCapacity;
	}

	/**
	 * 最大活动连接数
	 */
	protected Integer fdPoolNumber;

	/**
	 * @return 最大活动连接数
	 */
	public Integer getFdPoolNumber() {
		return fdPoolNumber;
	}

	/**
	 * @param fdPoolNumber
	 *            最大活动连接数
	 */
	public void setFdPoolNumber(Integer fdPoolNumber) {
		this.fdPoolNumber = fdPoolNumber;
	}

	/**
	 * 连接超时时间
	 */
	protected Integer fdPoolTime;

	/**
	 * @return 连接超时时间
	 */
	public Integer getFdPoolTime() {
		return fdPoolTime;
	}

	/**
	 * @param fdPoolTime
	 *            连接超时时间
	 */
	public void setFdPoolTime(Integer fdPoolTime) {
		this.fdPoolTime = fdPoolTime;
	}

	/**
	 * 描述
	 */
	protected String fdDescribe;

	/**
	 * @return 描述
	 */
	public String getFdDescribe() {
		return fdDescribe;
	}

	/**
	 * @param fdDescribe
	 *            描述
	 */
	public void setFdDescribe(String fdDescribe) {
		this.fdDescribe = fdDescribe;
	}

	/**
	 * 更新时间
	 */
	protected Date fdUpdateTime;

	/**
	 * @return 更新时间
	 */
	public Date getFdUpdateTime() {
		return fdUpdateTime;
	}

	/**
	 * @param fdUpdateTime
	 *            更新时间
	 */
	public void setFdUpdateTime(Date fdUpdateTime) {
		this.fdUpdateTime = fdUpdateTime;
	}

	/**
	 * 所属tibSysSap服务器
	 */
	protected TibSysSapServerSetting fdTibSysSapCode;

	/**
	 * @return 所属tibSysSap服务器
	 */
	public TibSysSapServerSetting getFdTibSysSapCode() {
		return fdTibSysSapCode;
	}

	/**
	 * @param fdTibSysSapCode
	 *            所属tibSysSap服务器
	 */
	public void setFdTibSysSapCode(TibSysSapServerSetting fdTibSysSapCode) {
		this.fdTibSysSapCode = fdTibSysSapCode;
	}

	public Class getFormClass() {
		return TibSysSapJcoSettingForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdTibSysSapCode.fdId", "fdTibSysSapCodeId");
			toFormPropertyMap.put("fdTibSysSapCode.fdServerCode", "fdTibSysSapCodeName");
		}
		return toFormPropertyMap;
	}
}
