package com.landray.kmss.common.forms;

import java.io.Serializable;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.ValidatorForm;

/**
 * Form基类，不建议直接继承，仅当ExtendForm完全无法满足实际业务需求时才继承该类。
 * 
 * @author 叶中奇
 * @version 1.0 2006-4-3
 */
public class BaseForm extends ValidatorForm implements Serializable {

	protected String method;

	protected String method_GET;

	public String toString() {
		return ToStringBuilder.reflectionToString(this,
				ToStringStyle.MULTI_LINE_STYLE);
	}

	public boolean equals(Object o) {
		return EqualsBuilder.reflectionEquals(this, o);
	}

	/**
	 * This validation method is designed to be a parent of all other Form's
	 * validate methods - this allows the cancel and delete buttons to bypass
	 * validation.
	 * 
	 * @param mapping
	 *            The <code>ActionMapping</code> used to select this instance
	 * @param request
	 *            The servlet request we are processing
	 * @return <code>ActionErrors</code> object that encapsulates any
	 *         validation errors
	 */
	public ActionErrors validate(ActionMapping mapping,
			HttpServletRequest request) {
		method = request.getParameter("method");
		if (request.getMethod().equals("GET"))
			this.setMethod_GET(method);
		if (!isValidate(mapping, request))
			return null;
		ActionErrors errors = super.validate(mapping, request);
		return customerValidate(errors, mapping, request);
	}

	/**
	 * 是否对表单进行校验。<br>
	 * 该函数将对save、saveadd和update的操作进行校验，若需要添加其他方法校验，请覆盖该方法。
	 * 
	 * @param mapping
	 * @param request
	 * @return 如果返回false，则不对表单进行校验。
	 */
	public boolean isValidate(ActionMapping mapping, HttpServletRequest request) {
		if (request.getMethod().equals("GET")) {
			return false;
		}
		if (method == null || method.equals("save") || method.equals("saveadd")
				|| method.equals("update"))
			return true;
		else
			return false;
	}

	/**
	 * 自定义校验。<br>
	 * 若需要加入特定的校验，请覆盖此方法。
	 * 
	 * @param errors
	 * @param mapping
	 * @param request
	 * @return ActionErrors
	 */
	public ActionErrors customerValidate(ActionErrors errors,
			ActionMapping mapping, HttpServletRequest request) {
		return errors;
	}

	/**
	 * @return 最后一次往服务器提交GET的Method
	 */
	public String getMethod_GET() {
		return method_GET;
	}

	public void setMethod_GET(String method_GET) {
		this.method_GET = method_GET;
	}

	/**
	 * @return 最后一次发往服务器请求的Method
	 */
	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}
}
