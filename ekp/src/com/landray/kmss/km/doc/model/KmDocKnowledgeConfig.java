package com.landray.kmss.km.doc.model;

import com.landray.kmss.sys.appconfig.model.BaseAppConfig;
import com.landray.kmss.sys.appconfig.service.ISysAppConfigService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2010-六月-19
 * 
 * @author zhuangwl 我的常用文档目录配置
 */
public class KmDocKnowledgeConfig extends BaseAppConfig {

	private static ISysAppConfigService sysAppConfigService;

	public KmDocKnowledgeConfig() throws Exception {
		super();
	}

	public String getJSPUrl() {
		return "km/doc/km_doc_knowledge_config/kmDocKnowledgeConfig_edit.jsp";
	}

	public String getFdCategoryIds() {
		return getValue("fdCategoryIds");
	}

	public void setFdCategoryIds(String fdCategoryIds) {
		setValue("fdCategoryIds", fdCategoryIds);
	}

	public void save() throws Exception {
		getSysAppConfigService().add(
				getClass().getName() + "_" + UserUtil.getUser().getFdId(),
				getDataMap());
	}

	private static ISysAppConfigService getSysAppConfigService() {
		if (sysAppConfigService == null)
			sysAppConfigService = (ISysAppConfigService) SpringBeanUtil
					.getBean("sysAppConfigService");
		return sysAppConfigService;
	}

}
