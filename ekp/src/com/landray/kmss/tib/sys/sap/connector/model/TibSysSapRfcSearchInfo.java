package com.landray.kmss.tib.sys.sap.connector.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcSearchInfoForm;

/**
 * rfc函数查询
 * 
 * @author zhangtian
 * @version 1.0 2011-12-20
 */
public class TibSysSapRfcSearchInfo extends BaseModel {

	/**
	 * 标题
	 */
	protected String docSubject;
	
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
	protected String fdData;
	
	/**
	 * @return xml数据
	 */
	public String getFdData() {
		return (String) readLazyField("fdData", fdData);
	}
	
	/**
	 * @param fdData xml数据
	 */
	public void setFdData(String fdData) {
		this.fdData = (String) writeLazyField("fdData",
				this.fdData, fdData);
	}
	
	/**
	 * rfc函数_id
	 */
	protected TibSysSapRfcSetting fdRfc;
	
	/**
	 * @return rfc函数_id
	 */
	public TibSysSapRfcSetting getFdRfc() {
		return fdRfc;
	}
	
	/**
	 * @param fdRfc rfc函数_id
	 */
	public void setFdRfc(TibSysSapRfcSetting fdRfc) {
		this.fdRfc = fdRfc;
	}
	
	public Class getFormClass() {
		return TibSysSapRfcSearchInfoForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
			toFormPropertyMap.put("fdRfc.fdId", "fdRfcId");
			toFormPropertyMap.put("fdRfc.fdFunctionName", "fdRfcName");
		}
		return toFormPropertyMap;
	}
}
