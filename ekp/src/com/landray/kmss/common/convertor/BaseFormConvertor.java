package com.landray.kmss.common.convertor;

import java.beans.PropertyDescriptor;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.commons.validator.Validator;
import org.apache.commons.validator.ValidatorException;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.validator.Resources;

import com.landray.kmss.code.examine.ExamineContext;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;

public abstract class BaseFormConvertor {
	private static final Log logger = LogFactory
			.getLog(BaseFormConvertor.class);

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
			context.addError(fromClass, "getToModelPropertyMap", 1, "目标属性"
					+ tPropertyName + "无setter方法");
	}

	public void validate(Object form, String sProperty, ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request,
			ActionServlet servlet) {
	}

	protected void validateChild(Object form, ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request,
			ActionServlet servlet) {
		if (form == null || !(form instanceof ExtendForm))
			return;
		ExtendForm validatorForm = (ExtendForm) form;
		validatorForm.setServlet(servlet);
		ServletContext application = servlet.getServletContext();
		String validationKey = ModelUtil.getModelTableName(validatorForm);
		Validator validator = Resources.initValidator(validationKey,
				validatorForm, application, request, errors, validatorForm
						.getPage());
		try {
			validator.validate();
		} catch (ValidatorException e) {
			logger.error(e.getMessage(), e);
		}
		validatorForm.customerValidate(errors, mapping, request);
	}
}
