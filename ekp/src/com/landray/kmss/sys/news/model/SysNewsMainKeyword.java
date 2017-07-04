package com.landray.kmss.sys.news.model;

import com.landray.kmss.common.model.BaseModel;

/**
 * 创建日期 2007-Sep-17
 * 
 * @author 舒斌 文档关键字
 */
public class SysNewsMainKeyword extends BaseModel {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = -3865570535877129311L;

	/*
	 * 关键字
	 */
	protected java.lang.String docKeyword;

	/*
	 * 新闻主表单
	 */
	protected SysNewsMain sysNewsMain = null;

	public SysNewsMainKeyword() {
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
	 * @return 返回 新闻主表单
	 */
	public SysNewsMain getSysNewsMain() {
		return sysNewsMain;
	}

	/**
	 * @param sysNewsMain
	 *            要设置的 新闻主表单
	 */
	public void setSysNewsMain(SysNewsMain sysNewsMain) {
		this.sysNewsMain = sysNewsMain;
	}

	public Class getFormClass() {
		return null;
	}

	public String getDocSubject() {
		// TODO 自动生成的方法存根
		return null;
	}
}
