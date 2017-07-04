package com.landray.kmss.util;

import javax.servlet.http.HttpServletRequest;

import com.landray.sso.client.util.StringUtil;

/**
 * 跟cookie相关的帮助类
 * 
 * @author 苏轶 2010-3-15
 */
public class CookieHelper {
	/**
	 * 查找指定名称的cookie值，如果没有找到则返回null
	 * 
	 * @param request
	 * @param cookieName
	 * @return
	 */
	public static String getCookie(HttpServletRequest request, String cookieName) {
		// Cookie[] cookies = request.getCookies();
		// if (cookies != null) {
		// for (Cookie cookie : cookies) {
		// if (cookie.getName().equalsIgnoreCase(cookieName))
		// return cookie.getValue();
		// }
		// }
		// 解决Cookie值等于号取不到的问题。
		String cookieHeader = request.getHeader("Cookie");
		if (StringUtil.isNotNull(cookieHeader)) {
			String[] cookies = cookieHeader.split(";");
			if (cookies != null) {
				for (int i = 0; i < cookies.length; i++) {
					String cookie = cookies[i].trim();
					if (cookie.substring(0, cookie.indexOf("="))
							.equalsIgnoreCase(cookieName)) {
						return cookie.substring(cookie.indexOf("=") + 1, cookie
								.length());
					}
				}
			}
		}
		return null;
	}
}
