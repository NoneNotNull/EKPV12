package com.landray.kmss.tib.sys.sap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapJcoSetting;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapServerSetting;

/**
 * jco配置 Form
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapJcoSettingForm extends ExtendForm {

	/**
	 * 连接池名称
	 */
	protected String fdPoolName = null;

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
	protected String fdPoolAdmin = null;

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
	protected String fdPoolSecret = null;

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
	protected String fdPoolStatus = null;

	/**
	 * @return 状态
	 */
	public String getFdPoolStatus() {
		return fdPoolStatus;
	}

	/**
	 * @param fdPoolStatus
	 *            状态
	 */
	public void setFdPoolStatus(String fdPoolStatus) {
		this.fdPoolStatus = fdPoolStatus;
	}

	/**
	 * 连接类型
	 */
	protected String fdConnectType = null;

	/**
	 * @return 连接类型
	 */
	public String getFdConnectType() {
		return fdConnectType;
	}

	/**
	 * @param fdConnectType
	 *            连接类型
	 */
	public void setFdConnectType(String fdConnectType) {
		this.fdConnectType = fdConnectType;
	}

	/**
	 * 最大空闲连接数
	 */
	protected String fdPoolCapacity = null;

	/**
	 * @return 最大空闲连接数
	 */
	public String getFdPoolCapacity() {
		return fdPoolCapacity;
	}

	/**
	 * @param fdPoolCapacity
	 *            最大空闲连接数
	 */
	public void setFdPoolCapacity(String fdPoolCapacity) {
		this.fdPoolCapacity = fdPoolCapacity;
	}

	/**
	 * 最大活动连接数
	 */
	protected String fdPoolNumber = null;

	/**
	 * @return 最大活动连接数
	 */
	public String getFdPoolNumber() {
		return fdPoolNumber;
	}

	/**
	 * @param fdPoolNumber
	 *            最大活动连接数
	 */
	public void setFdPoolNumber(String fdPoolNumber) {
		this.fdPoolNumber = fdPoolNumber;
	}

	/**
	 * 连接超时时间
	 */
	protected String fdPoolTime = null;

	/**
	 * @return 连接超时时间
	 */
	public String getFdPoolTime() {
		return fdPoolTime;
	}

	/**
	 * @param fdPoolTime
	 *            连接超时时间
	 */
	public void setFdPoolTime(String fdPoolTime) {
		this.fdPoolTime = fdPoolTime;
	}

	/**
	 * 描述
	 */
	protected String fdDescribe = null;

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
	protected String fdUpdateTime = null;

	/**
	 * @return 更新时间
	 */
	public String getFdUpdateTime() {
		return fdUpdateTime;
	}

	/**
	 * @param fdUpdateTime
	 *            更新时间
	 */
	public void setFdUpdateTime(String fdUpdateTime) {
		this.fdUpdateTime = fdUpdateTime;
	}

	/**
	 * 所属tibSysSap服务器的ID
	 */
	protected String fdTibSysSapCodeId = null;

	/**
	 * @return 所属tibSysSap服务器的ID
	 */
	public String getFdTibSysSapCodeId() {
		return fdTibSysSapCodeId;
	}

	/**
	 * @param fdTibSysSapCodeId
	 *            所属tibSysSap服务器的ID
	 */
	public void setFdTibSysSapCodeId(String fdTibSysSapCodeId) {
		this.fdTibSysSapCodeId = fdTibSysSapCodeId;
	}

	/**
	 * 所属tibSysSap服务器的名称
	 */
	protected String fdTibSysSapCodeName = null;

	/**
	 * @return 所属tibSysSap服务器的名称
	 */
	public String getFdTibSysSapCodeName() {
		return fdTibSysSapCodeName;
	}

	/**
	 * @param fdTibSysSapCodeName
	 *            所属tibSysSap服务器的名称
	 */
	public void setFdTibSysSapCodeName(String fdTibSysSapCodeName) {
		this.fdTibSysSapCodeName = fdTibSysSapCodeName;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdPoolName = null;
		fdPoolAdmin = null;
		fdPoolSecret = null;
		fdPoolStatus = null;
		fdConnectType = null;
		fdPoolCapacity = null;
		fdPoolNumber = null;
		fdPoolTime = null;
		fdDescribe = null;
		fdUpdateTime = null;
		fdTibSysSapCodeId = null;
		fdTibSysSapCodeName = null;

		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSapJcoSetting.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdTibSysSapCodeId", new FormConvertor_IDToModel(
					"fdTibSysSapCode", TibSysSapServerSetting.class));
		}
		return toModelPropertyMap;
	}
}
