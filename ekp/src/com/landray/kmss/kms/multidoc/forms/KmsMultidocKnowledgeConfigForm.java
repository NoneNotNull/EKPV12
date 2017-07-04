package com.landray.kmss.kms.multidoc.forms;

import com.landray.kmss.common.forms.BaseForm;

/**
 * 创建日期 2010-六月-19
 * 
 * @author zhuangwl 我的常用文档目录配置
 */
public class KmsMultidocKnowledgeConfigForm extends BaseForm {

	/**
	 * 类别IDS
	 */
	private String fdCategoryIds = null;

	public String getFdCategoryIds() {
		return fdCategoryIds;
	}

	public void setFdCategoryIds(String fdCategoryIds) {
		this.fdCategoryIds = fdCategoryIds;
	}

	/**
	 * 类别名称
	 */
	private String fdCategoryNames = null;

	public String getFdCategoryNames() {
		return fdCategoryNames;
	}

	public void setFdCategoryNames(String fdCategoryNames) {
		this.fdCategoryNames = fdCategoryNames;
	}

}
