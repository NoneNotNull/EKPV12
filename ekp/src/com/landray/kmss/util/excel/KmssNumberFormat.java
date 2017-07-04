package com.landray.kmss.util.excel;

import java.text.NumberFormat;

public class KmssNumberFormat implements KmssFormat {

	public String format(Object obj) throws Exception {
		return numberFormat.format(obj);
	}

	private NumberFormat numberFormat;

	public NumberFormat getNumberFormat() {
		return numberFormat;
	}

	public void setNumberFormat(NumberFormat numberFormat) {
		this.numberFormat = numberFormat;
	}
}
