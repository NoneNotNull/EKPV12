package com.landray.kmss.km.review.model;

import com.landray.kmss.sys.appconfig.model.BaseAppConfig;
import com.landray.kmss.util.StringUtil;

public class KmReviewConfigNotify extends BaseAppConfig {

	public String getJSPUrl() {
		return "/km/review/km_review_notify_config/km_review_notify_config.jsp";
	}

	public KmReviewConfigNotify() throws Exception {
		super();
		String str = "";
		str = super.getValue("fdNotifyType");
		if (StringUtil.isNull(str)) {
			str = "todo";
		}
		super.setValue("fdNotifyType", str);
		str = super.getValue("base");
		if(str==null){
			str = "base";
		}
		super.setValue("base", str);
		str = super.getValue("info");
		if(str==null){
			str = "info";
		}
		super.setValue("info", str);
		str = super.getValue("note");
		if(str==null){
			str = "note";
		}
		super.setValue("note", str);
	}

	public void setFdNotifyType(String fdNotifyType) {
		setValue("fdNotifyType", fdNotifyType);
	}

	public String getFdNotifyType() {
		String str = "";
		str = super.getValue("fdNotifyType");
		if (StringUtil.isNull(str)) {
			str = "todo";
			return str;
		}
		return getValue("fdNotifyType");
	}
	
	public String getBase() {
		return getValue("base");
	}

	public void setBase(String base) {
		setValue("base", base);
	}
	public String getInfo() {
		return getValue("info");
	}

	public void setInfo(String info) {
		setValue("info", info);
	}
	public String getNote() {
		return getValue("note");
	}

	public void setNote(String note) {
		setValue("note", note);
	}
}
