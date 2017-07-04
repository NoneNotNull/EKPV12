package com.landray.kmss.util.comparator;

import java.util.Locale;

import net.sourceforge.pinyin4j.PinyinHelper;
import net.sourceforge.pinyin4j.format.HanyuPinyinCaseType;
import net.sourceforge.pinyin4j.format.HanyuPinyinOutputFormat;
import net.sourceforge.pinyin4j.format.HanyuPinyinToneType;
import net.sourceforge.pinyin4j.format.exception.BadHanyuPinyinOutputFormatCombination;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class ChinesePinyinComparator {
	public static int compare(String str1, String str2) {
		/* null 最小 */
		if (str1 == null && str2 == null)
			return 0;
		if (str1 == null && str2 != null)
			return -1;
		if (str1 != null && str2 == null)
			return 1;

		/* 一些特殊情况 */
		if (str1.equals(str2))
			return 0;
		if (str1.startsWith(str2))
			return 1;
		if (str2.startsWith(str1))
			return -1;

		char[] charArray1 = str1.toCharArray();
		char[] charArray2 = str2.toCharArray();

		for (int i = 0; i < charArray1.length; i++) {
			char c1 = charArray1[i];
			char c2 = charArray2[i];
			if (c1 == c2)
				continue; // 两个字符相等，则比较下一个字符
			String p1 = getPinyinString(c1);
			String p2 = getPinyinString(c2);

			// 两个字符都不是中文字符，则直接进行减法操作
			if (p1 == null && p2 == null)
				return c1 - c2;
			// 中文字符排最后
			if (p1 == null && p2 != null)
				return -1;
			// 中文字符排最后
			if (p1 != null && p2 == null)
				return 1;
			// 都是中文字符，则比较其拼音字符串
			return p1.compareTo(p2);
		}

		// 理论上不可能运行到此处
		return 168;
	}

	/**
	 * 将输入的汉字字符转换成拼音字符串返回， 如果是多音字则返回第一个读音，如果不是汉字则返回null
	 * 
	 * @param c
	 *            要转换的汉字字符
	 * @return
	 */
	public static String getPinyinString(char c) {
		String[] pinYinArray = PinyinHelper.toHanyuPinyinStringArray(c);
		if (pinYinArray == null || pinYinArray.length == 0)
			return null;
		else
			return pinYinArray[0];
	}

	private static Log logger = LogFactory
			.getLog(ChinesePinyinComparator.class);

	public static String getPinyinString(String message) {
		if (message == null)
			return null;
		char[] chars = message.toCharArray();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < chars.length; i++) {
			String[] pinYinArray = PinyinHelper
					.toHanyuPinyinStringArray(chars[i]);
			if (pinYinArray == null || pinYinArray.length == 0) {
				logger.warn("无法获取\"" + message + "\"中\"" + chars[i] + "\"的拼音！");
				return null;
			} else
				sb.append(pinYinArray[0]);
		}
		return sb.toString();
	}

	/**
	 * 将输入的汉字字符转换成拼音字符串返回，设置返回格式为小写不带音标， 如果是多音字则返回第一个读音，如果不是汉字则返回原文
	 * 
	 * @author limh
	 * @param c
	 *            要转换的汉字字符
	 * @return
	 */
	public static String getPinyinStringWithDefaultFormat(String message) {
		if (StringUtil.isNull(message))
			return "";
		// 创建汉语拼音处理类
		HanyuPinyinOutputFormat defaultFormat = new HanyuPinyinOutputFormat();
		// 输出设置，大小写，音标方式
		defaultFormat.setCaseType(HanyuPinyinCaseType.LOWERCASE);
		defaultFormat.setToneType(HanyuPinyinToneType.WITHOUT_TONE);
		char[] chars = message.toCharArray();
		StringBuffer sb = new StringBuffer();
		for (int i = 0; i < chars.length; i++) {
			try {
				String[] pinYinArray = PinyinHelper.toHanyuPinyinStringArray(
						chars[i], defaultFormat);
				if (pinYinArray == null || pinYinArray.length == 0) {
					sb.append(Character.toLowerCase(chars[i]));
				} else {
					sb.append(pinYinArray[0]);
				}
			} catch (BadHanyuPinyinOutputFormatCombination e) {
				logger.warn("字符串转化为拼音出现异常：" + e);
			}
		}
		return sb.toString();
	}

	/**
	 * 获取指定资源的拼音首字母，如果资源不是中文字符串则返回null
	 * 
	 * @param messageKey
	 *            <bundle>:<key>
	 * @param locale
	 * @return
	 */
	public static Character getFirstPinyinChar(String messageKey, Locale locale) {
		return getFirstPinyinChar(ResourceUtil.getString(messageKey, locale));
	}

	public static Character getFirstPinyinChar(String message) {
		if (message == null || message.length() < 1)
			return null;
		String pinyin = getPinyinString(message.charAt(0));
		if (pinyin == null || pinyin.length() < 1)
			return null;
		char c = pinyin.charAt(0);
		c = Character.toUpperCase(c);
		return new Character(c);
	}

	public static void main(String[] args) {
		System.out.println(getPinyinStringWithDefaultFormat("UIt"));
	}
}
