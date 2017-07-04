package com.landray.kmss.tib.common.init.forms;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.tib.common.init.model.TibCommonInit;


/**
 * 主文档 Form
 * 
 * @author 
 * @version 1.0 2013-06-17
 */
public class TibCommonInitForm extends ExtendForm {

	public void reset(ActionMapping mapping, HttpServletRequest request) {

		super.reset(mapping, request);
	}

	public Class getModelClass() {
		return TibCommonInit.class;
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
