package com.landray.kmss.tib.sys.core.provider.forms;

import javax.servlet.http.HttpServletRequest;
import org.apache.struts.action.ActionMapping;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.util.AutoArrayList;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.convertor.FormConvertor_FormListToModelList;
import com.landray.kmss.common.convertor.FormConvertor_IDToModel;
import com.landray.kmss.common.convertor.FormConvertor_IDsToModelList;

import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreTag;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;


/**
 * 标签信息 Form
 * 
 * @author 
 * @version 1.0 2013-03-27
 */
public class TibSysCoreTagForm extends ExtendForm {

	/**
	 * 标签名称
	 */
	protected String fdTagName = null;
	
	/**
	 * @return 标签名称
	 */
	public String getFdTagName() {
		return fdTagName;
	}
	
	/**
	 * @param fdTagName 标签名称
	 */
	public void setFdTagName(String fdTagName) {
		this.fdTagName = fdTagName;
	}
	
	/**
	 * 排序号
	 */
	protected String fdOrder = null;
	
	/**
	 * @return 排序号
	 */
	public String getFdOrder() {
		return fdOrder;
	}
	
	/**
	 * @param fdOrder 排序号
	 */
	public void setFdOrder(String fdOrder) {
		this.fdOrder = fdOrder;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdTagName = null;
		fdOrder = null;
		
		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibSysCoreTag.class;
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
