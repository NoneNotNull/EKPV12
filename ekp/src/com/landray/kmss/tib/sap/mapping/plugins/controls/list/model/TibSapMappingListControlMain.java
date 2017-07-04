package com.landray.kmss.tib.sap.mapping.plugins.controls.list.model;

import java.util.Date;

import net.sf.cglib.transform.impl.InterceptFieldEnabled;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.forms.TibSapMappingListControlMainForm;

/**
 * 主文档
 * 
 * @author 
 * @version 1.0 2013-04-24
 */
public class TibSapMappingListControlMain extends BaseModel implements InterceptFieldEnabled {

	/**
	 * 创建时间
	 */
	protected Date docCreateTime;
	
	/**
	 * @return 创建时间
	 */
	public Date getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(Date docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 唯一标识
	 */
	protected String fdKey;
	
	/**
	 * @return 唯一标识
	 */
	public String getFdKey() {
		return fdKey;
	}
	
	/**
	 * @param fdKey 唯一标识
	 */
	public void setFdKey(String fdKey) {
		this.fdKey = fdKey;
	}
	
	/**
	 * 显示数据
	 */
	protected String fdShowData;
	
	/**
	 * @return 显示数据
	 */
	public String getFdShowData() {
		return (String) readLazyField("fdShowData", fdShowData);
	}
	
	/**
	 * @param fdShowData 显示数据
	 */
	public void setFdShowData(String fdShowData) {
		this.fdShowData = (String) writeLazyField("fdShowData",
				this.fdShowData, fdShowData);
	}
	
	/**
	 * 传出参数
	 */
	protected String fdExportParam;
	
	/**
	 * @return 传出参数
	 */
	public String getFdExportParam() {
		return (String) readLazyField("fdExportParam", fdExportParam);
	}
	
	/**
	 * @param fdExportParam 传出参数
	 */
	public void setFdExportParam(String fdExportParam) {
		this.fdExportParam = (String) writeLazyField("fdExportParam",
				this.fdExportParam, fdExportParam);
	}

	public Class getFormClass() {
		return TibSapMappingListControlMainForm.class;
	}

	private static ModelToFormPropertyMap toFormPropertyMap;

	public ModelToFormPropertyMap getToFormPropertyMap() {
		if (toFormPropertyMap == null) {
			toFormPropertyMap = new ModelToFormPropertyMap();
			toFormPropertyMap.putAll(super.getToFormPropertyMap());
		}
		return toFormPropertyMap;
	}
}
