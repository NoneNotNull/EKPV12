package com.landray.kmss.tib.common.init.model;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.model.BaseModel;
import com.landray.kmss.tib.common.init.forms.TibCommonInitForm;

/**
 * 主文档
 * 
 * @author 
 * @version 1.0 2013-06-17
 */
public class TibCommonInit extends BaseModel {

	public Class getFormClass() {
		return TibCommonInitForm.class;
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
