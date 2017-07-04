package com.landray.kmss.work.cases.test;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.TagSupport;

public class UserTag extends TagSupport{

	private static final long serialVersionUID = 1L;
	private String name;
	private String value;
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
	@Override
	public int doStartTag() throws JspException {
		JspWriter out = this.pageContext.getOut();
		try {
			if (name == null){
				 out.println("No name Found...");
	             return SKIP_BODY;
			}
			out.print("<input type='text' name=" + name + " value=" + value + ">");
			return SKIP_BODY;
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return super.doStartTag();
	}
	
	@Override
	public int doEndTag() throws JspException {
		return super.doEndTag();
	}
	
	@Override
	public void release() {
		super.release();
		this.name = "";
		this.value = "";
	}
}
