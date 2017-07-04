package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.util.ObjectUtil;

public abstract class BaseModelConvertor {
	protected String tPropertyName;

	public String getTPropertyName() {
		return tPropertyName;
	}

	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		String sProperty = (String) context.getParameter("sProperty");
		PropertyDescriptor descriptor = ObjectUtil.getPropertyDescriptor(
				fromClass, sProperty);
		if (descriptor == null || descriptor.getReadMethod() == null)
			context.addError(fromClass, "getToModelPropertyMap", 1, "源属性"
					+ sProperty + "无getter方法");

		descriptor = ObjectUtil.getPropertyDescriptor(toClass, tPropertyName);
		if (descriptor == null || descriptor.getWriteMethod() == null)
			context.addError(fromClass, "getToFormPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
	}
}
