package com.landray.kmss.util.excel;

import java.util.Locale;

import com.landray.kmss.util.EnumerationTypeUtil;

public class KmssEnumFormat implements KmssFormat {

	public String format(Object obj) throws Exception {
		return EnumerationTypeUtil.getColumnEnumsLabel(enumType, obj.toString(), locale);
//		return null;
	}

	private String enumType;
	private Locale locale;

	public String getEnumType() {
		return enumType;
	}

	public void setEnumType(String enumType) {
		this.enumType = enumType;
	}

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}
}
