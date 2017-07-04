package com.landray.kmss.code.examine;

import java.beans.PropertyDescriptor;

import org.apache.commons.beanutils.PropertyUtils;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;

public class ModelExaminer implements IExaminer {
	private DataDictExaminer dataDictExaminer = new DataDictExaminer();

	public void examine(ExamineContext context) throws Exception {
		Class c = context.getCurrentClass();
		if (c == null || !IBaseModel.class.isAssignableFrom(c))
			return;
		IBaseModel model;
		try {
			model = (IBaseModel) c.newInstance();
			if (model.getFormClass() == null)
				return;
		} catch (Exception e) {
			return;
		}
		context.setParameter("model", model);
		try {
			context.setParameter("form", model.getFormClass().newInstance());
		} catch (Exception e) {
			context.addError(c, "getFormClass", 1, "对应的Form无法实例化");
			return;
		}
		PropertyDescriptor[] descriptors = PropertyUtils
				.getPropertyDescriptors(c);
		for (int i = 0; i < descriptors.length; i++) {
			if (descriptors[i].getPropertyType() == null)
				continue;
			if (IExtendForm.class.isAssignableFrom(descriptors[i]
					.getPropertyType()))
				context.addWarn(c, descriptors[i].getName(), 1,
						"Model中出现Form的对象");
		}
		ModelToFormPropertyMap modelToFormPropertyMap = model
				.getToFormPropertyMap();
		if (modelToFormPropertyMap != null)
			modelToFormPropertyMap.examine(context, c, model.getFormClass());

		dataDictExaminer.examine(context);
	}
}
