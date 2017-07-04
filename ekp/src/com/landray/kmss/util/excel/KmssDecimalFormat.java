package com.landray.kmss.util.excel;

import java.text.DecimalFormat;

public class KmssDecimalFormat implements KmssFormat {

	
	public String format(Object obj) throws Exception {
		return decimalFormat.format(obj);
	}
	private DecimalFormat decimalFormat = new DecimalFormat("#.00");
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
		decimalFormat.setMaximumFractionDigits(fractionDigits);
//		numberFormat.setMinimumFractionDigits(fractionDigits);
	}

}
