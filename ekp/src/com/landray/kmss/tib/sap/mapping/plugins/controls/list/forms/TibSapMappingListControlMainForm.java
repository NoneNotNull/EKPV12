package com.landray.kmss.tib.sap.mapping.plugins.controls.list.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.model.TibSapMappingListControlMain;


/**
 * 主文档 Form
 * 
 * @author 
 * @version 1.0 2013-04-24
 */
public class TibSapMappingListControlMainForm extends ExtendForm {

	/**
	 * 创建时间
	 */
	protected String docCreateTime = null;
	
	/**
	 * @return 创建时间
	 */
	public String getDocCreateTime() {
		return docCreateTime;
	}
	
	/**
	 * @param docCreateTime 创建时间
	 */
	public void setDocCreateTime(String docCreateTime) {
		this.docCreateTime = docCreateTime;
	}
	
	/**
	 * 唯一标识
	 */
	protected String fdKey = null;
	
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
	protected String fdShowData = null;
	
	/**
	 * @return 显示数据
	 */
	public String getFdShowData() {
		return fdShowData;
	}
	
	/**
	 * @param fdShowData 显示数据
	 */
	public void setFdShowData(String fdShowData) {
		this.fdShowData = fdShowData;
	}
	
	/**
	 * 传出参数
	 */
	protected String fdExportParam = null;
	
	/**
	 * @return 传出参数
	 */
	public String getFdExportParam() {
		return fdExportParam;
	}
	
	/**
	 * @param fdExportParam 传出参数
	 */
	public void setFdExportParam(String fdExportParam) {
		this.fdExportParam = fdExportParam;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		docCreateTime = null;
		fdKey = null;
		fdShowData = null;
		fdExportParam = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSapMappingListControlMain.class;
	}
	
	private static FormToModelPropertyMap toModelPropertyMap;

	public FormToModelPropertyMap getToModelPropertyMap() {
		if (toModelPropertyMap == null) {
			toModelPropertyMap = new FormToModelPropertyMap();
			toModelPropertyMap.putAll(super.getToModelPropertyMap());
		}
		return toModelPropertyMap;
	}
}
