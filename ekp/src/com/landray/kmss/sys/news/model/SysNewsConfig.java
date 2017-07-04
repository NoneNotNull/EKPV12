package com.landray.kmss.sys.news.model;

import com.landray.kmss.sys.appconfig.model.BaseAppConfig;
import com.landray.kmss.util.StringUtil;

public class SysNewsConfig extends BaseAppConfig {

	public SysNewsConfig() throws Exception {
		super();
		String str = "";
		str = super.getValue("fdImageW");
		if (StringUtil.isNull(str)) {
			str = "312";
		}
		super.setValue("fdImageW", str);
		str = super.getValue("fdImageH");
		if (StringUtil.isNull(str)) {
			str = "234";
		}
		super.setValue("fdImageH", str);
	}

	@Override
	public String getJSPUrl() {
		return "/sys/news/sys_news_main/sysNewsMain_config.jsp";
	}
	public int getfdImageW() {
		String fdImageW = (String) getDataMap().get("fdImageW");
		if (StringUtil.isNotNull(fdImageW)) {
			return Integer.parseInt(fdImageW);
		}else
		return 234;
	}
	public int getfdImageH() {
		String fdImageH = (String) getDataMap().get("fdImageH");
		if (StringUtil.isNotNull(fdImageH)) {
			return Integer.parseInt(fdImageH);
		}else
		return 312;
	}
}
