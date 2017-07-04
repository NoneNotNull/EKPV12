package com.landray.kmss.util;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.cookie.CookiePolicy;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * HttpClient调用的常用函数
 * 
 * @author 叶中奇
 * 
 */
@SuppressWarnings("unchecked")
public class HttpClientUtil {
	private static Log logger = LogFactory.getLog(HttpClientUtil.class);

	private static int ONE_DAY = 24 * 3600;

	private static final String SESSION_KEY = "com.landray.kmss.HttpClient";

	/**
	 * 创建一个HttpClient，该client不具有延续性
	 * 
	 * @return
	 */
	public static HttpClient createClient() {
		return new HttpClient();
	}

	/**
	 * 从当前用户会话的池里面中获取HttpClient，该client具有延续性<br>
	 * 警告：在使用该方法获取HttpClient后，必须使用restoreHttpClient方法回收
	 * 
	 * @param request
	 * @return
	 */
	public static HttpClient getClient(HttpServletRequest request) {
		List<HttpClient> pool = getPool(request);
		HttpClient client = null;
		synchronized (pool) {
			if (!pool.isEmpty()) {
				int index = pool.size() - 1;
				client = pool.get(index);
				pool.remove(index);
			}
		}
		if (client == null) {
			client = createClient();
			logger.debug("创建一个新的HttpClient");
		}
		return client;
	}

	/**
	 * 从request中获取Client池
	 * 
	 * @param request
	 * @return
	 */
	private static List<HttpClient> getPool(HttpServletRequest request) {
		HttpSession session = request.getSession();
		List<HttpClient> pool = (List<HttpClient>) session
				.getAttribute(SESSION_KEY);
		if (pool == null) {
			pool = new ArrayList<HttpClient>();
			session.setAttribute(SESSION_KEY, pool);
		}
		return pool;
	}

	/**
	 * 回收HttpClient对象，以备下次使用
	 * 
	 * @param request
	 * @param client
	 */
	public static void restoreHttpClient(HttpServletRequest request,
			HttpClient client) {
		List<HttpClient> pool = getPool(request);
		synchronized (pool) {
			if (!pool.contains(client))
				pool.add(client);
		}
	}

	/**
	 * 重置当前用户会话中的HttpClient
	 * 
	 * @param request
	 */
	public static void resetHttpClient(HttpServletRequest request) {
		request.getSession().removeAttribute(SESSION_KEY);
	}

	/**
	 * 往HttpClient添加一个Cookie值
	 * 
	 * @param client
	 * @param domain
	 * @param cookieName
	 * @param cookieValue
	 */
	public static void addCookieToHttpClient(HttpClient client, String domain,
			String cookieName, String cookieValue) {
		client.getParams().setCookiePolicy(CookiePolicy.RFC_2109);
		org.apache.commons.httpclient.Cookie cookie = new org.apache.commons.httpclient.Cookie(
				domain, cookieName, cookieValue, "/", ONE_DAY, false);
		client.getState().addCookie(cookie);
	}

	/**
	 * 创建一个Get方法
	 * 
	 * @param url
	 * @return
	 */
	public static GetMethod createGetMethod(String url) {
		GetMethod method = new GetMethod(url);
		method.setRequestHeader("Connection", "close");
		// 设置成了默认的恢复策略，在发生由于网络原因引起的异常时，将自动重试3次。
		method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
				new DefaultHttpMethodRetryHandler());
		return method;
	}

	/**
	 * 创建一个Post方法
	 * 
	 * @param url
	 * @return
	 */
	public static PostMethod createPostMethod(String url) {
		PostMethod method = new PostMethod(url);
		method.setRequestHeader("Connection", "close");
		// 设置成了默认的恢复策略，在发生由于网络原因引起的异常时，将自动重试3次。
		method.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
				new DefaultHttpMethodRetryHandler());
		return method;
	}

	/**
	 * 查找指定名称的cookie值，如果没有找到则返回null
	 * 
	 * @param request
	 * @param cookieName
	 * @return
	 */
	public static String getCookie(HttpServletRequest request, String cookieName) {
		Cookie[] cookies = request.getCookies();
		if (cookies == null)
			return null;
		for (Cookie cookie : cookies) {
			if (cookie.getName().equalsIgnoreCase(cookieName))
				return cookie.getValue();
		}
		return null;
	}

	/**
	 * 对于Base64编码的cookie值，可能后面的=号会被截断，通过该方法可以补完
	 * 
	 * @param value
	 * @return
	 */
	public static String formatBase64Value(String value) {
		if (value == null)
			return null;
		int n = value.length() % 8;
		String result = value;
		for (int i = 0; i < n; i++)
			result += "=";
		return result;
	}

	/**
	 * 从URL中获取Domain
	 * 
	 * @param url
	 * @return
	 */
	public static String getDomainByUrl(String url) {
		int index = url.indexOf("://");
		String domain = url.substring(index + 3);
		for (; domain.startsWith("/");) {
			domain = domain.substring(1);
		}
		index = domain.indexOf('/');
		if (index > -1) {
			domain = domain.substring(0, index);
		}
		return domain;
	}

	/**
	 * 获取Http数据
	 * 
	 * @param client
	 * @param method
	 * @return
	 * @throws HttpException
	 * @throws IOException
	 */
	public static String getDataByHttpClient(HttpClient client,
			HttpMethod method) throws HttpException, IOException {
		try {
			int statusCode = client.executeMethod(method);
			if (statusCode != HttpStatus.SC_OK) {
				// 执行错误
				logger.error("HttpClient GET方法执行失败： " + method.getStatusLine());
			}
			byte[] responseBody = method.getResponseBody();
			// 处理内容
			String result = new String(responseBody, "UTF-8");
			if (result != null)
				result = result.trim();
			return result;
		} finally {
			method.releaseConnection();
		}
	}

	/**
	 * 获取Http数据的简单调用
	 * 
	 * @param request
	 * @param url
	 * @param cookieName
	 * @param formatCookie
	 * @return
	 * @throws HttpException
	 * @throws IOException
	 */
	public static String getDataByHttpClient(HttpServletRequest request,
			String url, String cookieName, boolean formatCookie)
			throws HttpException, IOException {
		HttpClient client = getClient(request);
		try {
			String cookieValue = getCookie(request, cookieName);
			if (formatCookie)
				cookieValue = formatBase64Value(cookieValue);
			addCookieToHttpClient(client, getDomainByUrl(url), cookieName,
					cookieValue);
			return getDataByHttpClient(client, createGetMethod(url));
		} finally {
			restoreHttpClient(request, client);
		}
	}

	/**
	 * 获取Http数据的简单调用，不转换cookie的值
	 * 
	 * @param request
	 * @param url
	 * @param cookieName
	 * @return
	 * @throws HttpException
	 * @throws IOException
	 */
	public static String getDataByHttpClient(HttpServletRequest request,
			String url, String cookieName) throws HttpException, IOException {
		return getDataByHttpClient(request, url, cookieName, false);
	}

	public static void main(String[] args) throws Exception {
		String url = "http://ekptest.yutong.com/ekp/sys/common/dataxml.jsp?s_bean=sysHomePortletDialog";
		String cookieValue = "0e8e2f9171eb11da2beb804be61143fbe692d5c3c1aec77de659e0d1adf00cbf8008412091b83febee671870ef289e7dd5b788d68f9f0363c907816ac8126ee4ce9b0973caa2eab6044c654f2d89169c4e499674fa848a0a1f3b4504be1b16bdec85d16da81ac3e9d4ac30f0743a18a38751b880c3c694c9f417e8ae9c27fca4";
		HttpClient client = createClient();
		for (int i = 0; i < 1; i++) {
			long t = System.currentTimeMillis();
			addCookieToHttpClient(client, getDomainByUrl(url), "LRToken",
					cookieValue);
			HttpMethod method = createGetMethod(url);
			System.out.println(getDataByHttpClient(client, method));
			System.out.println("============ "
					+ (System.currentTimeMillis() - t) + " ============");
		}
	}
}
