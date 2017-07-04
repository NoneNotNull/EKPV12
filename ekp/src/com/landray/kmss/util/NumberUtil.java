package com.landray.kmss.util;

import java.text.DecimalFormat;

/**
 * 常用的数据格式转换方法。
 * 
 * @author 吴兵
 * @version 1.0 2006-09-25
 */
public class NumberUtil {

	/**
	 * 用###,###.##格式化字符串值。
	 * 
	 * @param value
	 *            - 值
	 * @return 被转换后的字符串。
	 */
	public static String roundDecimal(Object value) {
		return roundDecimal(value, "###,###.##");
	}

	/**
	 * 用指定格式格式化字符串值。
	 * 
	 * @param value
	 *            - 值
	 * @param pattern
	 *            -格式
	 * @return 被转换后的字符串。
	 */
	public static String roundDecimal(Object value, String pattern) {
		String res = null;
		if (pattern == null || pattern.trim().equals(""))
			pattern = "###,###.##";
		DecimalFormat df = new DecimalFormat(pattern);
		try {
			if (value instanceof String) {
				res = df.format(new Double(value.toString()));
			} else {
				res = df.format(value);
			}

		} catch (IllegalArgumentException e) {
			e.printStackTrace();
		}
		return res;
	}

	/**
	 * 保留两位小数。
	 * 
	 * @param fTemp
	 *            - 要保留的数据
	 * @return 被转换后的字符串。
	 */
	public static String roundDecimal(double fTemp) {
		DecimalFormat df = new DecimalFormat("#.##");
		return df.format(fTemp);
	}

	public static String roundDecimal(float fTemp) {
		return roundDecimal((double) fTemp);
	}

	/**
	 * 保留指定的位小数。
	 * 
	 * @param fTemp
	 *            - 要保留的数据
	 * @param pos
	 *            - 指定的位数
	 * @return 被转换后的字符串。
	 */
	public static String roundDecimal(double fTemp, int pos) {
		// String s = "";
		// for (int i = 0; i < pos; i++) {
		// s += "#";
		// }
		// DecimalFormat df = new DecimalFormat("#." + s);
		DecimalFormat df = new DecimalFormat("#.################");
		df.setMaximumFractionDigits(pos);
		return df.format(fTemp);
	}

	public static String roundDecimal(float fTemp, int pos) {
		return roundDecimal((double) fTemp, pos);
	}

	public static Double round(double doubleParam, int digit) {
		String digitString = "0";
		for (int i = 0; i < digit; i++) {
			digitString = digitString + "0";
		}
		DecimalFormat df = new DecimalFormat("#." + digitString);
		df.setMaximumFractionDigits(digit);
		Double rtnDouble = Double.valueOf(df.format(doubleParam));
		return rtnDouble;
	}

	/**
	 * 修正double的误差
	 * 
	 * @param d
	 * @return
	 */
	public static double correctDouble(double d) {
		DecimalFormat df = new DecimalFormat("#.################");
		String s = df.format(d);
		int begin = s.indexOf(".");
		if (begin == -1) {
			return d;
		}
		int index = s.indexOf("00000", begin);
		if (index == -1) {
			index = s.indexOf("99999", begin);
		}
		if (index == -1) {
			return d;
		}
		StringBuffer sb = new StringBuffer("#.");
		for (int i = 2; i < index; i++) {
			sb.append('#');
		}
		sb.append("E0");
		df.applyPattern(sb.toString());
		return Double.parseDouble(df.format(d));
	}

	private static DecimalFormat simpleDecimalFormat = new DecimalFormat(
			"#.################");

	public static String toSimpleString(double d) {
		return simpleDecimalFormat.format(d);
	}
}
