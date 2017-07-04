package com.landray.kmss.km.review.forms;

import com.landray.kmss.sys.right.interfaces.BaseAuthForm;

/**
 * 创建日期 2010-六月-19
 * 
 * @author zhuangwl 我的常用流程模板配置
 */
public class KmReviewCommonConfigForm extends BaseAuthForm {

	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 7650027625915143426L;
	/**
	 * 模板IDS
	 */
	private String fdTemplateIds = null;

	public String getFdTemplateIds() {
		return fdTemplateIds;
	}

	public void setFdTemplateIds(String fdTemplateIds) {
		this.fdTemplateIds = fdTemplateIds;
	}

	/**
	 * 模板名称
	 */
	private String fdTemplateNames = null;

	public String getFdTemplateNames() {
		return fdTemplateNames;
	}

	public void setFdTemplateNames(String fdTemplateNames) {
		this.fdTemplateNames = fdTemplateNames;
	}

	public Class getModelClass() {
		// TODO 自动生成的方法存根
		return null;
	}

}
