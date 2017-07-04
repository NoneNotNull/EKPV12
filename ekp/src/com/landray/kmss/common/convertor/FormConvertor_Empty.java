package com.landray.kmss.common.convertor;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionServlet;

import com.landray.kmss.code.examine.ExamineContext;

/**
 * Form的空转换器，常用于属性不执行转换
 * 
 * @author 缪贵荣
 * 
 */
public class FormConvertor_Empty implements IFormToModelConvertor {

	public static final IFormToModelConvertor INSTANCE = new FormConvertor_Empty();

	public String getTPropertyName() {
		return StringUtils.EMPTY;
	}

	public void excute(ConvertorContext ctx) throws Exception {
		// do nothing
	}

	@SuppressWarnings("unchecked")
	public void examine(ExamineContext context, Class fromClass, Class toClass) {
		// do nothing
	}

	public void validate(Object form, String property, ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request,
			ActionServlet servlet) {
		// do nothing
	}

}
