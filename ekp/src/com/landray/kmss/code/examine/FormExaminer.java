package com.landray.kmss.code.examine;

import java.beans.PropertyDescriptor;

import org.apache.commons.beanutils.PropertyUtils;

import com.landray.kmss.common.convertor.FormToModelPropertyMap;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;

public class FormExaminer implements IExaminer {
	public void examine(ExamineContext context) {
		Class c = context.getCurrentClass();
		if (c == null || !IExtendForm.class.isAssignableFrom(c))
			return;
		IExtendForm form;
		try {
			form = (IExtendForm) c.newInstance();
			if (form.getModelClass() == null)
				return;
		} catch (Exception e) {
			return;
		}
		context.setParameter("form", form);
		try {
			context.setParameter("model", form.getModelClass().newInstance());
		} catch (Exception e) {
			context.addError(c, "getModelClass", 1, "对应的Model无法实例化");
			return;
		}
		PropertyDescriptor[] descriptors = PropertyUtils
				.getPropertyDescriptors(c);
		for (int i = 0; i < descriptors.length; i++) {
			if (IBaseModel.class.isAssignableFrom(descriptors[i]
					.getPropertyType()))
				context.addWarn(c, descriptors[i].getName(), 1,
						"Form中出现Model的对象");
		}
		FormToModelPropertyMap formToModelPropertyMap = form
				.getToModelPropertyMap();
		if (formToModelPropertyMap != null)
			formToModelPropertyMap.examine(context, c, form.getModelClass());
	}
}
