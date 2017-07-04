package com.landray.kmss.km.review.model;

import com.landray.kmss.sys.appconfig.model.BaseAppConfig;
import com.landray.kmss.sys.appconfig.service.ISysAppConfigService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 创建日期 2010-六月-19
 * 
 * @author zhuangwl 我的常用流程模板配置
 */
public class KmReviewCommonConfig extends BaseAppConfig {

	private static ISysAppConfigService sysAppConfigService;

	public KmReviewCommonConfig() throws Exception {
		super();
	}

	public String getJSPUrl() {
		return "km/review/km_review_common_config/kmReviewCommonConfig_edit.jsp";
	}

	public String getFdTemplateIds() {
		return getValue("fdTemplateIds");
	}

	public void setFdTemplateIds(String fdTemplateIds) {
		setValue("fdTemplateIds", fdTemplateIds);
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
