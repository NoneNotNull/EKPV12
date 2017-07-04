package com.landray.kmss.util.excel;

import java.text.SimpleDateFormat;
import java.util.Locale;

public class KmssDateFormat implements KmssFormat {

	public String format(Object obj) {
		SimpleDateFormat sf = new SimpleDateFormat(patten, locale);
		return sf.format(obj);
	}

	private Locale locale; // 如果为空则使用WorkBook的缺省设置
	private String patten;

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}

	public String getPatten() {
		return patten;
	}

	public void setPatten(String patten) {
		this.patten = patten;
	}

}
