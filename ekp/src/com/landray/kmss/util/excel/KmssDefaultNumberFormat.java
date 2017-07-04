package com.landray.kmss.util.excel;

import java.text.NumberFormat;

public class KmssDefaultNumberFormat implements KmssFormat {

	public String format(Object obj) throws Exception {
		return numberFormat.format(obj);
	}
	private NumberFormat numberFormat = NumberFormat.getNumberInstance();
	private int fractionDigits; // 小数位数

	/**
	 * @return 小数位数
	 */
	public int getFractionDigits() {
		return fractionDigits;
	}

	/**
	 * 设置小数位数
	 * @param fractionDigits 小数位数
	 */
	public void setFractionDigits(int fractionDigits) {
		this.fractionDigits = fractionDigits;
		numberFormat.setMaximumFractionDigits(fractionDigits);
//		numberFormat.setMinimumFractionDigits(fractionDigits);
	}

}
