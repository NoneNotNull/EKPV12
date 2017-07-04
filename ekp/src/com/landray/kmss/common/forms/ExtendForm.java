package com.landray.kmss.common.forms;

import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.convertor.IFormToModelConvertor;
import com.landray.kmss.util.IDGenerator;

/**
 * 基于BaseForm扩展的类，建议大部分的Form继承。<br>
 * 该类强行定义了fdId这个域。
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public abstract class ExtendForm extends BaseForm implements IExtendForm {
	protected String fdId;

	public String getFdId() {
		if (fdId == null) {
			fdId = IDGenerator.generateID();
		}
		return fdId;
	}

	public void setFdId(String id) {
		this.fdId = id;
	}

	public FormToModelPropertyMap getToModelPropertyMap() {
		return new FormToModelPropertyMap();
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {
		fdId = IDGenerator.generateID();
		super.reset(mapping, request);
	}

	public ActionErrors customerValidate(ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request) {
		if (getToModelPropertyMap() == null)
			return errors;
		Map propertyMap = getToModelPropertyMap().getPropertyMap();
		for (Iterator keys = propertyMap.keySet().iterator(); keys.hasNext();) {
			String key = (String) keys.next();
			Object convertor = propertyMap.get(key);
			if (convertor == null)
				continue;
			if (convertor instanceof String)
				continue;
			IFormToModelConvertor formToModelConvertor = (IFormToModelConvertor) convertor;
			formToModelConvertor.validate(this, key, errors, mapping, request,
					getServlet());
		}
		return errors;
	}
}
