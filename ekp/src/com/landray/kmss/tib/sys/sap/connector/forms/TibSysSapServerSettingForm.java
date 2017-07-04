package com.landray.kmss.tib.sys.sap.connector.forms;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapServerSetting;
import com.landray.kmss.util.AutoArrayList;

/**
 * tibSysSap服务器配置 Form
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapServerSettingForm extends ExtendForm {
	/**
	 * 扩展参数
	 */
	protected List<TibSysSapServerSettingExtForm> fdTibSysSapExtList = new AutoArrayList(
			TibSysSapServerSettingExtForm.class);

	/**
	 * 服务器编号
	 */
	protected String fdServerCode = null;

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
	protected String fdServerName = null;

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
	protected String fdServerIp = null;

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
	protected String fdTibSysSapCode = null;

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
	protected String fdClientCode = null;

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
	protected String fdLanguage = null;

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

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdServerCode = null;
		fdServerName = null;
		fdServerIp = null;
		fdTibSysSapCode = null;
		fdClientCode = null;
		fdLanguage = null;
		fdUpdateTime = null;
		fdDescribe = null;
		fdTibSysSapExtList.clear();
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSapServerSetting.class;
	}

	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());

			toModelPropertyMap.put("fdTibSysSapExtList",
					new FormConvertor_FormListToModelList("fdTibSysSapExtList",
							"TibSysSapServerSetting"));
		}
		return toModelPropertyMap;
	}

	public List<TibSysSapServerSettingExtForm> getFdTibSysSapExtList() {
		return fdTibSysSapExtList;
	}

	public void setFdTibSysSapExtList(List<TibSysSapServerSettingExtForm> fdTibSysSapExtList) {
		this.fdTibSysSapExtList = fdTibSysSapExtList;
	}

}
