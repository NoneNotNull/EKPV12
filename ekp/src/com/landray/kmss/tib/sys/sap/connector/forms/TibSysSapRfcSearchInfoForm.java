package com.landray.kmss.tib.sys.sap.connector.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sys.core.util.TibSysCoreUtil;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSearchInfo;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;


/**
 * rfc函数查询 Form
 * 
 * @author zhangtian
 * @version 1.0 2011-12-20
 */
public class TibSysSapRfcSearchInfoForm extends ExtendForm {

	/**
	 * 标题
	 */
	protected String docSubject = null;
	
	/**
	 * @return 标题
	 */
	public String getDocSubject() {
		return docSubject;
	}
	
	/**
	 * @param docSubject 标题
	 */
	public void setDocSubject(String docSubject) {
		this.docSubject = docSubject;
	}
	
	/**
	 * xml数据
	 */
	protected String fdData = null;
	
	// 用于将一些特殊字符转化后在前端展示
	public String getFdDataView() {
		return TibSysCoreUtil.filter(fdData);
	}
	
	/**
	 * @return xml数据
	 */
	public String getFdData() {
		return fdData;
	}
	
	/**
	 * @param fdData xml数据
	 */
	public void setFdData(String fdData) {
		this.fdData = fdData;
	}
	
	/**
	 * rfc函数_id的ID
	 */
	protected String fdRfcId = null;
	
	/**
	 * @return rfc函数_id的ID
	 */
	public String getFdRfcId() {
		return fdRfcId;
	}
	
	/**
	 * @param fdRfcId rfc函数_id的ID
	 */
	public void setFdRfcId(String fdRfcId) {
		this.fdRfcId = fdRfcId;
	}
	
	/**
	 * rfc函数_id的名称
	 */
	protected String fdRfcName = null;
	
	/**
	 * @return rfc函数_id的名称
	 */
	public String getFdRfcName() {
		return fdRfcName;
	}
	
	/**
	 * @param fdRfcName rfc函数_id的名称
	 */
	public void setFdRfcName(String fdRfcName) {
		this.fdRfcName = fdRfcName;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docSubject = null;
		fdData = null;
		fdRfcId = null;
		fdRfcName = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysSapRfcSearchInfo.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
			toModelPropertyMap.put("fdRfcId",
					new FormConvertor_IDToModel("fdRfc",
						TibSysSapRfcSetting.class));
		}
		return toModelPropertyMap;
	}
}
