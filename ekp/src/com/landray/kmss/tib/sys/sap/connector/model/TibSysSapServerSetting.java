package com.landray.kmss.tib.sys.sap.connector.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import com.landray.kmss.common.convertor.ModelConvertor_ModelListToFormList;
import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapServerSettingForm;

/**
 * tibSysSap服务器配置
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
@SuppressWarnings("serial")
public class TibSysSapServerSetting extends BaseModel {

	/**
	 * 服务器编号
	 */
	protected String fdServerCode;

	/**
	 * @return 服务器编号
	 */
	public String getFdServerCode() {
		return fdServerCode;
	}

	/**
	 * @param fdServerCode
	 *            服务器编号
	 */
	public void setFdServerCode(String fdServerCode) {
		this.fdServerCode = fdServerCode;
	}

	/**
	 * 服务器名称
	 */
	protected String fdServerName;

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
	protected String fdServerIp;

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
	 * tibSysSap系统号
	 */
	protected String fdTibSysSapCode;

	/**
	 * @return tibSysSap系统号
	 */
	public String getFdTibSysSapCode() {
		return fdTibSysSapCode;
	}

	/**
	 * @param fdTibSysSapCode
	 *            tibSysSap系统号
	 */
	public void setFdTibSysSapCode(String fdTibSysSapCode) {
		this.fdTibSysSapCode = fdTibSysSapCode;
	}

	/**
	 * 客户端号
	 */
	protected String fdClientCode;

	/**
	 * @return 客户端号
	 */
	public String getFdClientCode() {
		return fdClientCode;
	}

	/**
	 * @param fdClientCode
	 *            客户端号
	 */
	public void setFdClientCode(String fdClientCode) {
		this.fdClientCode = fdClientCode;
	}

	/**
	 * 语言
	 */
	protected String fdLanguage;

	/**
	 * @return 语言
	 */
	public String getFdLanguage() {
		return fdLanguage;
	}

	/**
	 * @param fdLanguage
	 *            语言
	 */
	public void setFdLanguage(String fdLanguage) {
		this.fdLanguage = fdLanguage;
	}

	/**
	 * 扩展参数
	 */

	protected List<TibSysSapServerSettingExt> fdTibSysSapExtList = new ArrayList<TibSysSapServerSettingExt>();

	/**
	 * @return 扩展参数
	 */
	public List<TibSysSapServerSettingExt> getFdTibSysSapExtList() {
		return fdTibSysSapExtList;
	}

	/**
	 * @param fdTibSysSapExtList
	 *            扩展参数
	 */
	public void setFdTibSysSapExtList(List<TibSysSapServerSettingExt> fdTibSysSapExtList) {
		this.fdTibSysSapExtList = fdTibSysSapExtList;
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

	public Class getFormClass() {
		return TibSysSapServerSettingForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());

			toFormPropertyMap.put("fdTibSysSapExtList",
					new ModelConvertor_ModelListToFormList("fdTibSysSapExtList"));
		}
		return toFormPropertyMap;
	}

}
