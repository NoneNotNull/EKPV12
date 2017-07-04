package com.landray.kmss.util;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import org.htmlparser.Parser;
import org.htmlparser.beans.StringBean;
import org.htmlparser.util.ParserException;

/**
 * 常用的String转换方法。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class StringUtil {
	private final static String[] hex = { "00", "01", "02", "03", "04", "05",
			"06", "07", "08", "09", "0A", "0B", "0C", "0D", "0E", "0F", "10",
			"11", "12", "13", "14", "15", "16", "17", "18", "19", "1A", "1B",
			"1C", "1D", "1E", "1F", "20", "21", "22", "23", "24", "25", "26",
			"27", "28", "29", "2A", "2B", "2C", "2D", "2E", "2F", "30", "31",
			"32", "33", "34", "35", "36", "37", "38", "39", "3A", "3B", "3C",
			"3D", "3E", "3F", "40", "41", "42", "43", "44", "45", "46", "47",
			"48", "49", "4A", "4B", "4C", "4D", "4E", "4F", "50", "51", "52",
			"53", "54", "55", "56", "57", "58", "59", "5A", "5B", "5C", "5D",
			"5E", "5F", "60", "61", "62", "63", "64", "65", "66", "67", "68",
			"69", "6A", "6B", "6C", "6D", "6E", "6F", "70", "71", "72", "73",
			"74", "75", "76", "77", "78", "79", "7A", "7B", "7C", "7D", "7E",
			"7F", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89",
			"8A", "8B", "8C", "8D", "8E", "8F", "90", "91", "92", "93", "94",
			"95", "96", "97", "98", "99", "9A", "9B", "9C", "9D", "9E", "9F",
			"A0", "A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "AA",
			"AB", "AC", "AD", "AE", "AF", "B0", "B1", "B2", "B3", "B4", "B5",
			"B6", "B7", "B8", "B9", "BA", "BB", "BC", "BD", "BE", "BF", "C0",
			"C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "CA", "CB",
			"CC", "CD", "CE", "CF", "D0", "D1", "D2", "D3", "D4", "D5", "D6",
			"D7", "D8", "D9", "DA", "DB", "DC", "DD", "DE", "DF", "E0", "E1",
			"E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "EA", "EB", "EC",
			"ED", "EE", "EF", "F0", "F1", "F2", "F3", "F4", "F5", "F6", "F7",
			"F8", "F9", "FA", "FB", "FC", "FD", "FE", "FF" };

	private final static byte[] val = { 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x00, 0x01,
			0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F,
			0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F, 0x3F };
	private static char[] HEXCHAR = { '0', '1', '2', '3', '4', '5', '6', '7',
			'8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

	/**
	 * 将字节数组还原成16进制字符串
	 * 
	 * @param b
	 * @return
	 */
	public static String toHexString(byte[] b) {
		StringBuffer sb = new StringBuffer(b.length * 2);
		for (int i = 0; i < b.length; i++) {
			sb.append(HEXCHAR[(b[i] & 0xf0) >>> 4]);
			sb.append(HEXCHAR[b[i] & 0x0f]);
		}
		return sb.toString();
	}

	/**
	 * 将16进制字符串转换成字节数组
	 * 
	 * @param s
	 * @return
	 */
	public static final byte[] toBytes(String s) {
		byte[] bytes;
		bytes = new byte[s.length() / 2];
		for (int i = 0; i < bytes.length; i++) {
			bytes[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2),
					16);
		}
		return bytes;
	}

	/**
	 * URL编码，其功能等同于javascript的escape函数
	 * 
	 * @param sourceStr
	 *            需要转换的字符串
	 * @return 返回已完成的字符串
	 */
	public static String escape(String sourceStr) {
		StringBuffer sbuf = new StringBuffer();
		int len = sourceStr.length();
		for (int i = 0; i < len; i++) {
			int ch = sourceStr.charAt(i);
			if ('A' <= ch && ch <= 'Z') {
				sbuf.append((char) ch);
			} else if ('a' <= ch && ch <= 'z') {
				sbuf.append((char) ch);
			} else if ('0' <= ch && ch <= '9') {
				sbuf.append((char) ch);
			} else if (ch == '-' || ch == '_' || ch == '.' || ch == '!'
					|| ch == '~' || ch == '*' || ch == '\'' || ch == '('
					|| ch == ')') {
				sbuf.append((char) ch);
			} else if (ch <= 0x007F) {
				sbuf.append('%');
				sbuf.append(hex[ch]);
			} else if (ch == ' ') {
				sbuf.append("%20");
			} else {
				sbuf.append('%');
				sbuf.append('u');
				sbuf.append(hex[(ch >>> 8)]);
				sbuf.append(hex[(0x00FF & ch)]);
			}
		}
		return sbuf.toString();
	}

	/***************************************************************************
	 * URL解码，功能相当于javascript的unescape函数。本方法保证 不论参数s是否经过escape()编码，均能得到正确的“解码”结果
	 * 
	 * @param sourceStr
	 *            需要解码的字符串
	 * @return 返回已解码的字符串
	 */
	public static String unescape(String sourceStr) {
		StringBuffer sbuf = new StringBuffer();
		int i = 0;
		int len = sourceStr.length();
		while (i < len) {
			int ch = sourceStr.charAt(i);
			if ('A' <= ch && ch <= 'Z') {
				sbuf.append((char) ch);
			} else if ('a' <= ch && ch <= 'z') {
				sbuf.append((char) ch);
			} else if ('0' <= ch && ch <= '9') {
				sbuf.append((char) ch);
			} else if (ch == '-' || ch == '_' || ch == '.' || ch == '!'
					|| ch == '~' || ch == '*' || ch == '\'' || ch == '('
					|| ch == ')') {
				sbuf.append((char) ch);
			} else if (ch == '%') {
				int cint = 0;
				if ('u' != sourceStr.charAt(i + 1)) {
					cint = (cint << 4) | val[sourceStr.charAt(i + 1)];
					cint = (cint << 4) | val[sourceStr.charAt(i + 2)];
					i += 2;
				} else {
					cint = (cint << 4) | val[sourceStr.charAt(i + 2)];
					cint = (cint << 4) | val[sourceStr.charAt(i + 3)];
					cint = (cint << 4) | val[sourceStr.charAt(i + 4)];
					cint = (cint << 4) | val[sourceStr.charAt(i + 5)];
					i += 5;
				}
				sbuf.append((char) cint);
			} else {
				sbuf.append((char) ch);
			}
			i++;
		}
		return sbuf.toString();
	}

	/**
	 * 转换字符串中HTML/XML敏感的字符。
	 * 
	 * @param src
	 *            源字符串
	 * @return 转换后的字符串
	 */
	public static String XMLEscape(String src) {
		if (src == null)
			return null;
		String rtnVal = src.replaceAll("&", "&amp;");
		rtnVal = rtnVal.replaceAll("\"", "&quot;");
		rtnVal = rtnVal.replaceAll("<", "&lt;");
		rtnVal = rtnVal.replaceAll(">", "&gt;");
		rtnVal = rtnVal.replaceAll("[\\x00-\\x08\\x0b-\\x0c\\x0e-\\x1f]", "");
		return rtnVal;
	}

	/**
	 * 获取query中的参数值
	 * 
	 * @param query
	 *            样例：a=1&b=2，注意：不带?符号
	 * @param param
	 *            参数名，如：a
	 * @return 参数值
	 */
	public static String getParameter(String query, String param) {
		Pattern p = Pattern.compile("&" + param + "=([^&]*)");
		Matcher m = p.matcher("&" + query);
		if (m.find())
			return m.group(1);
		return null;
	}

	/**
	 * 将query的值转换为哈希表，哈希表的格式类似request.getParameterMap
	 * 
	 * @param query
	 *            样例：a=1,b=2，其中splitStr=,
	 * @param splitStr
	 *            多个参数分隔符
	 * @return 哈希表，key值为query的参数名，value为一个String[]，为参数对应的值
	 */
	@SuppressWarnings("unchecked")
	public static Map getParameterMap(String query, String splitStr) {
		Map rtnVal = new HashMap();
		if (isNull(query))
			return rtnVal;
		String[] parameters = query.split("\\s*" + splitStr + "\\s*");
		for (int i = 0; i < parameters.length; i++) {
			int j = parameters[i].indexOf('=');
			if (j > -1)
				rtnVal.put(parameters[i].substring(0, j),
						new String[] { parameters[i].substring(j + 1) });
		}
		return rtnVal;
	}

	public static Map<String, String> getQueryStringMap(
			HttpServletRequest request) {
		String query = request.getQueryString();
		Map<String, String> rtnVal = new HashMap<String, String>();
		if (isNull(query))
			return rtnVal;
		String[] parameters = query.split("\\s*&\\s*");
		for (int i = 0; i < parameters.length; i++) {
			int j = parameters[i].indexOf('=');
			if (j > -1)
				rtnVal.put(parameters[i].substring(0, j),
						parameters[i].substring(j + 1));
		}
		return rtnVal;
	}

	/**
	 * 替换URL中?后面部分的参数。
	 * 
	 * @param query
	 *            URL?后面部分的字符串
	 * @param param
	 *            参数名
	 * @param value
	 *            参数值
	 * @return 替换后的字符串
	 */
	public static String setQueryParameter(String query, String param,
			String value) {
		String rtnVal = null;
		try {
			String m_query = isNull(query) ? "" : "&" + query;
			String m_param = "&" + param + "=";
			String m_value = URLEncoder.encode(value, "UTF-8");
			Pattern p = Pattern.compile(m_param + "[^&]*");
			Matcher m = p.matcher(m_query);
			if (m.find())
				rtnVal = m.replaceFirst(m_param + m_value);
			else
				rtnVal = m_query + m_param + m_value;
			rtnVal = rtnVal.substring(1);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return rtnVal;
	}

	/**
	 * 替换字符串中的指定字符，类似String.replaceAll的方法，但去除了正则表达式的应用
	 * 
	 * @param srcText
	 *            源字符串
	 * @param fromStr
	 *            需要替换的字符串
	 * @param toStr
	 *            替换为的字符串
	 * @return 替换后的字符串
	 */
	public static String replace(String srcText, String fromStr, String toStr) {
		if (srcText == null)
			return null;
		StringBuffer rtnVal = new StringBuffer();
		String rightText = srcText;
		for (int i = rightText.indexOf(fromStr); i > -1; i = rightText
				.indexOf(fromStr)) {
			rtnVal.append(rightText.substring(0, i));
			rtnVal.append(toStr);
			rightText = rightText.substring(i + fromStr.length());
		}
		rtnVal.append(rightText);
		return rtnVal.toString();
	}

	/**
	 * 格式化URL，若传递的参数中以/开始，该函数会自动添加DNS和ContextPath
	 * 
	 * @param url
	 *            源URL
	 * @return 格式化后的URL
	 */
	public static String formatUrl(String url) {
		return formatUrl(url, true);
	}

	/**
	 * 格式化URL，若传递的参数中以/开始，该函数会自动添加DNS或者ContextPath,
	 * 
	 * @param url
	 *            源URL
	 * @param isNeedDNS
	 *            是否需要添加dns，falase则只添加ContextPath
	 * @return 格式化后的URL
	 */
	public static String formatUrl(String url, boolean isNeedDNS) {
		String rtnVal = url;
		String urlPrefix = "";
		if (rtnVal.startsWith("/")) {
			urlPrefix = ResourceUtil.getKmssConfigString("kmss.urlPrefix");
			if (!isNeedDNS) {
				if (urlPrefix.indexOf("http://") == 0) {
					int index = urlPrefix.indexOf("/", 7);
					if (index > 0) {
						urlPrefix = urlPrefix.substring(index);

					} else {
						urlPrefix = "";
					}
				}
			}
		}
		return urlPrefix + url;
	}

	/**
	 * 往url中加前缀
	 * 
	 * @param url
	 * @param urlPrefix
	 * @return 格式化后的URL
	 */
	public static String formatUrl(String url, String urlPrefix) {
		if (!url.startsWith("/")) {
			return url;
		}
		return urlPrefix + url;
	}

	/**
	 * 连接字符串，常用与HQL语句的拼装，当左边值为空时返回右边值，当右边值为空时返回左边值，左右的值都不为空时返回左边值+连接串+右边值
	 * 
	 * @param leftStr
	 *            左边的值
	 * @param linkStr
	 *            连接字符串
	 * @param rightStr
	 *            右边的值
	 * @return 连接后的字符串
	 */
	public static String linkString(String leftStr, String linkStr,
			String rightStr) {
		if (isNull(leftStr))
			return rightStr;
		if (isNull(rightStr))
			return leftStr;
		return leftStr + linkStr + rightStr;
	}

	/**
	 * 判断一个字符串是否为null或空
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isNull(String str) {
		return str == null || str.trim().length() == 0;
	}

	/**
	 * 判断一个字符串是否为null或空
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isNotNull(String str) {
		return !isNull(str);
	}

	/**
	 * 检查给定的字符串既不是空，也不是长度为0。
	 * <p>
	 * 样例：
	 * 
	 * <pre>
	 * StringUtils.hasLength(null) = false
	 * StringUtils.hasLength(&quot;&quot;) = false
	 * StringUtils.hasLength(&quot; &quot;) = true
	 * StringUtils.hasLength(&quot;Hello&quot;) = true
	 * </pre>
	 * 
	 * @param str
	 *            需检查的字符串(可以为<code>null</code>)
	 * @return 若字符串不为null或长度不为0，则返回<code>true</code>。
	 */
	public static boolean hasLength(String str) {
		return (str != null && str.length() > 0);
	}

	/**
	 * 过滤字符串null
	 * 
	 * @param s
	 *            要过滤的字符串
	 * @return 过滤后的字符串
	 */
	public static String getString(String s) {
		return s == null ? "" : (s.equals("null") ? "" : s);
	}

	/**
	 * 将多个path字符串拼接起来，过滤多余的路径分隔符
	 * 
	 * @param paths
	 *            多个路径
	 * @return 拼接后的路径，最后是否带带路径分隔符由最后一个路径决定
	 */
	public static String linkPathString(String... paths) {
		if (null == paths || paths.length == 0)
			return "";

		StringBuilder sb = new StringBuilder();

		sb.append(paths[0]);

		for (int i = 1; i < paths.length; i++) {
			if (paths[i - 1].endsWith("\\") || paths[i - 1].endsWith("/")) {
				if (paths[i].startsWith("\\") || paths[i].startsWith("/")) {
					sb.append(paths[i].substring(1));
				} else {
					sb.append(paths[i]);
				}
			} else {
				if (paths[i].startsWith("\\") || paths[i].startsWith("/")) {
					sb.append(paths[i]);
				} else {
					sb.append("/").append(paths[i]);
				}
			}

		}
		return sb.toString();
	}

	/**
	 * 将字符串转换为数字，如果有错，采用缺省值
	 * 
	 * @param value
	 *            字符串
	 * @param defaultValue
	 *            缺省值
	 * @return
	 */
	public static int getIntFromString(String value, int defaultValue) {
		int ret = defaultValue;
		if (StringUtil.isNotNull(value)) {
			try {
				ret = Integer.parseInt(value);
			} catch (NumberFormatException e) {
				ret = defaultValue;
			}
		}
		return ret;
	}

	/**
	 * 合并2个string[],并去掉重复项
	 * 
	 * @param ary1
	 * @param ary2
	 * @return
	 */
	public static String[] mergeStringArray(String[] ary1, String[] ary2) {
		if (null == ary1)
			return ary2;
		if (null == ary2)
			return ary1;

		List<String> l1 = new ArrayList<String>(Arrays.asList(ary1));
		List<String> l2 = Arrays.asList(ary2);
		for (String s : l2) {
			if (!l1.contains(s)) {
				l1.add(s);
			}
		}
		String[] strings = new String[l1.size()];
		l1.toArray(strings);
		return strings;
	}

	// 空的数组返回null
	public static String[] emptyArray2Null(String[] ary1) {
		if (null == ary1 || ary1.length == 0) {
			return null;
		} else {
			return ary1;
		}
	}

	public static String clearScriptTag(String html) {
		// 过滤掉script标签
		Pattern scriptTag = Pattern
				.compile("<script[^>]*>.*(?=<\\/script>)<\\/script>");
		Matcher mTag = scriptTag.matcher(html);
		html = mTag.replaceAll("");

		// 过滤掉Dom节点事件
		String regx = "(<[^<]*)(on\\w*\\x20*=|javascript:)";
		Pattern pattern = Pattern.compile(regx, Pattern.CASE_INSENSITIVE
				+ Pattern.MULTILINE);// 不区分大小写
		Matcher matcher;
		String ts = html;
		// 此处需要循环匹配，防止恶意构造的字符串如 onclick=onclick=XXX
		while ((matcher = pattern.matcher(ts)).find()) {
			ts = matcher.replaceAll("$1" + "_disibledevent=");
		}
		return ts;
	}

	public static String join(String[] array, String separator) {
		if (array == null) {
			return null;
		}
		if (separator == null) {
			separator = "";
		}
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < array.length; ++i) {
			if (i > 0) {
				buf.append(separator);
			}
			if (array[i] != null) {
				buf.append(array[i]);
			}
		}
		return buf.toString();
	}

	public static String clearHTMLTag(String htmlStr) {
		try {
			Parser parse = new Parser();
			parse.setEncoding("UTF-8");
			parse.setInputHTML(htmlStr);
			StringBean sb = new StringBean();
			sb.setCollapse(true);
			sb.setLinks(false);
			sb.setReplaceNonBreakingSpaces(true);
			parse.visitAllNodesWith(sb);
			return sb.getStrings();
		} catch (ParserException e) {
		}
		return htmlStr;
	}

	public static String join(Iterable iterable, String separator) {
		if (iterable == null) {
			return null;
		}
		return join(iterable.iterator(), separator);
	}

	public static String join(Iterator iterator, String separator) {
		if (iterator == null) {
			return null;
		}
		if (!(iterator.hasNext())) {
			return "";
		}
		Object first = iterator.next();
		if (!(iterator.hasNext())) {
			return ((first == null) ? "" : first.toString());
		}

		StringBuffer buf = new StringBuffer(256);
		if (first != null) {
			buf.append(first);
		}

		while (iterator.hasNext()) {
			if (separator != null) {
				buf.append(separator);
			}
			Object obj = iterator.next();
			if (obj != null) {
				buf.append(obj);
			}
		}
		return buf.toString();
	}

	public static void main(String[] args) {
		String html = "<div asdf onclick='aa'  asdf onfolasdf='a' asdf> "
				+ " ... "
				+ " <script type=\"text/javascript\" ...> "
				+ "  .... "
				+ "  document.writeln(\"<h1>在JS代码里也可能会嵌套HTML标签等等，各种符合语法的嵌套</h1>\"); "
				+ "    .... " + " </script> " + "  .<p>ad</p>.. " + "  </div> ";

		System.out.println(clearScriptTag(html));
	}

}
