package com.landray.kmss.sys.news.model;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 文档模板关键字
 */
public class SysNewsTemplateKeyword extends BaseModel {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = -1689541349797663692L;

	/*
	 * 关键字
	 */
	protected java.lang.String docKeyword;

	/*
	 * 新闻模板设置
	 */
	protected SysNewsTemplate sysNewsTemplate = null;

	public SysNewsTemplateKeyword() {
		super();
	}

	/**
	 * @return 返回 关键字
	 */
	public java.lang.String getDocKeyword() {
		return docKeyword;
	}

	/**
	 * @param docKeyword
	 *            要设置的 关键字
	 */
	public void setDocKeyword(java.lang.String docKeyword) {
		this.docKeyword = docKeyword;
	}

	/**
	 * @return 返回 新闻模板设置
	 */
	public SysNewsTemplate getSysNewsTemplate() {
		return sysNewsTemplate;
	}

	/**
	 * @param sysNewsTemplate
	 *            要设置的 新闻模板设置
	 */
	public void setSysNewsTemplate(SysNewsTemplate sysNewsTemplate) {
		this.sysNewsTemplate = sysNewsTemplate;
	}

	public Class getFormClass() {
		return null;
	}

	public String getDocSubject() {
		// TODO 自动生成的方法存根
		return null;
	}
}
