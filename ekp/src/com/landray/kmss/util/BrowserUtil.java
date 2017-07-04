package com.landray.kmss.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * 处理浏览器信息的常用方法
 * 
 * @author 叶中奇
 * 
 */
public class BrowserUtil {
	private static final String TYPE_KEY = "com.landray.kmss.util.BrowserType";

	@SuppressWarnings("unchecked")
	public static List<String> getBrowserTypes(HttpServletRequest request) {
		List<String> results = (List<String>) request.getAttribute(TYPE_KEY);
		if (results == null) {
			results = new ArrayList<String>();
			request.setAttribute(TYPE_KEY, results);
		}
		return results;
	}

	/**
	 * 添加一种浏览器的模式
	 * 
	 * @param request
	 * @param type
	 */
	public static void addBrowserType(HttpServletRequest request, String type) {
		List<String> types = getBrowserTypes(request);
		if (!types.contains(type))
			types.add(type);
	}

	/**
	 * 判断浏览器是否支持某种模式
	 * 
	 * @param request
	 * @param type
	 * @return
	 */
	public static boolean containType(HttpServletRequest request, String type) {
		List<String> types = getBrowserTypes(request);
		return types.contains(type);
	}
}
