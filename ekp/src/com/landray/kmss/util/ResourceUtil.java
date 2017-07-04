package com.landray.kmss.util;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.Globals;

import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.config.action.SysConfigAdminUtil;

/**
 * @author Administrator
 * 
 */
public class ResourceUtil {
	public static String APPLICATION_RESOURCE_NAME = "ApplicationResources";

	private static Properties kmssConfigBundle = new Properties();
	static {
		SysConfigAdminUtil.loadKmssConfigProperties(kmssConfigBundle);
		loadSystemProperties();
	}

	private static final String PARAM_LANDRAY = "Landray.";

	public static boolean debug = false;

	/**
	 * 加载启动参数。例如：JAVA_OPTS=-DLandray.serverName1=test1（key:serverName1,
	 * value:test1）
	 */
	private static void loadSystemProperties() {
		Properties tmp = new Properties();
		Properties props = System.getProperties();
		Iterator<Map.Entry<Object, Object>> iter = props.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry<Object, Object> entry = iter.next();
			String key = entry.getKey().toString();
			if (key.startsWith(PARAM_LANDRAY)) {
				tmp.put(key.substring(PARAM_LANDRAY.length()), entry.getValue());
			}
		}
		kmssConfigBundle.putAll(tmp);
	}

	public static String KMSS_RESOURCE_PATH = kmssConfigBundle
			.getProperty("kmss.resource.path");

	private static Locale OFFICIAL_LANG;

	static {
		OFFICIAL_LANG = getLocale(getKmssConfigString("kmss.lang.official"));
		if (OFFICIAL_LANG == null) {
			OFFICIAL_LANG = Locale.CHINA;
		}
		Locale.setDefault(Locale.CHINA);
	}

	public static String getMessage(String key) {
		if (StringUtil.isNotNull(key)) {
			String val = "";
			if (key.startsWith("{") && key.endsWith("}")) {
				val = ResourceUtil
						.getString(key.substring(1, key.length() - 1));
			} else {
				val = key;
			}
			return val;
		} else {
			return key;
		}
	}

	/**
	 * 获取默认资源的值
	 * 
	 * @param key
	 * @return
	 */
	public static String getString(String key) {
		return getString(key, null, null);
	}

	/**
	 * 获取指定bundle的的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @return
	 */
	public static String getString(String key, String bundle) {
		return getString(key, bundle, null);
	}

	/**
	 * 获取用户选择的语言环境的资源值
	 * 
	 * @param key
	 * @param locale
	 * @return
	 */
	public static String getString(String key, Locale locale) {
		return getString(key, null, locale);
	}

	/**
	 * 获取指定bundle和用户选择的语言环境的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @param locale
	 *            该参数已经废除
	 * @return
	 */
	public static String getString(String key, String bundle, Locale locale) {
		return getStringValue(key, bundle, getLocaleByUser());
	}

	/**
	 * 设置用户语言
	 * 
	 * @param request
	 */
	public static void setUserLocal(HttpServletRequest request) {
		HttpSession session = request.getSession();
		KMSSUser user = UserUtil.getKMSSUser((HttpServletRequest) request);
		Locale newLocale = ResourceUtil.getLocale(request
				.getParameter("j_lang"));
		if (newLocale != null) {
			user.setLocale(newLocale);
			session.setAttribute(Globals.LOCALE_KEY, newLocale);
		} else {
			session.setAttribute(Globals.LOCALE_KEY, user.getLocale());
		}
	}

	/**
	 * 获取当前用户的locale 字符串
	 * 
	 * @return
	 */
	public static String getLocaleStringByUser() {
		return getLocaleByUser().toString().toLowerCase().replace('_', '-');
	}

	/**
	 * 获取当前用户的locale 字符串
	 * 
	 * @param request
	 * @return
	 */
	public static String getLocaleStringByUser(HttpServletRequest request) {
		return getLocaleByUser(request).toString().toLowerCase()
				.replace('_', '-');
	}

	/**
	 * 获取当前用户的locale
	 * 
	 * @return
	 */
	private static Locale getLocaleByUser() {
		return getLocaleByUser(null);
	}

	/**
	 * 获取当前用户的locale
	 * 
	 * @param request
	 * @return
	 */
	private static Locale getLocaleByUser(HttpServletRequest request) {
		Locale locale = null;
		KMSSUser user = null;
		if (request != null) {
			user = UserUtil.getKMSSUser(request);
		} else {
			user = UserUtil.getKMSSUser();
		}
		if (user != null && !user.isAnonymous()) {
			locale = user.getLocale();
		}
		if (locale == null)
			locale = OFFICIAL_LANG;
		return locale;
	}

	/**
	 * 获取官方的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @return
	 */
	public static String getOfficialString(String key) {
		return getOfficialString(key, null);
	}

	/**
	 * 获取指定bundle的官方的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @return
	 */
	public static String getOfficialString(String key, String bundle) {
		return getStringValue(key, bundle, OFFICIAL_LANG);
	}

	public static String getString(HttpServletRequest request, String key,
			String bundle) {
		return getStringValue(key, bundle, getLocaleByUser(request));
	}

	/**
	 * 获取指定语言的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @return
	 */
	public static String getString(HttpSession session, String key) {
		return getString(session, null, key);
	}

	/**
	 * 获取指定bundle和语言环境的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @return
	 */
	public static String getString(HttpSession session, String bundle,
			String key) {
		Locale locale = (Locale) session.getAttribute(Globals.LOCALE_KEY);
		if (locale == null) {
			locale = getLocaleByUser();
		}
		return getStringValue(key, bundle, locale);
	}

	/**
	 * 获取指定bundle和语言环境的资源值
	 * 
	 * @param key
	 * @param bundle
	 * @param locale
	 * @return
	 */
	public static String getStringValue(String key, String bundle, Locale locale) {
		if (StringUtil.isNull(key)) {
			return "";
		}
		if (StringUtil.isNull(bundle)) {
			int i = key.indexOf(':');
			if (i > -1) {
				bundle = key.substring(0, i);
				key = key.substring(i + 1);
			}
		}
		String resource;
		if (StringUtil.isNull(bundle))
			resource = APPLICATION_RESOURCE_NAME;
		else
			resource = "com.landray.kmss." + bundle.replaceAll("-", ".") + "."
					+ APPLICATION_RESOURCE_NAME;
		try {
			ResourceBundle resourceBundle = null;
			if (locale == null)
				resourceBundle = ResourceBundle.getBundle(resource);
			else
				resourceBundle = ResourceBundle.getBundle(resource, locale);
			if (debug) {
				return "[" + resourceBundle.getString(key) + "]";
			} else {
				return resourceBundle.getString(key);
			}
		} catch (Exception e) {
			try {
				if (locale == null) {
					return null;
				} else {
					if (debug) {
						return "{"
								+ ResourceBundle.getBundle(resource).getString(
										key) + "}";
					} else {
						return ResourceBundle.getBundle(resource)
								.getString(key);
					}
				}
			} catch (Exception e2) {
				return null;
			}
		}
	}

	public static String getString(HttpServletRequest request, String key,
			String bundle, Object[] args) {
		String rtnVal = getString(request, key, bundle);
		for (int i = 0; i < args.length; i++)
			rtnVal = StringUtil.replace(rtnVal, "{" + i + "}",
					String.valueOf(args[i]));
		return rtnVal;
	}

	/**
	 * 获取指定bundle和语言环境的资源值，并自动将资源值中的{0}替换为arg
	 * 
	 * @param key
	 * @param bundle
	 * @param locale
	 * @param arg
	 * @return
	 */
	public static String getString(String key, String bundle, Locale locale,
			Object arg) {
		return getString(key, bundle, locale, new Object[] { arg });
	}

	/**
	 * 获取指定bundle和语言环境的资源值，并自动将资源值中的{i}替换为args[i]
	 * 
	 * @param key
	 * @param bundle
	 * @param locale
	 * @param args
	 * @return
	 */
	public static String getString(String key, String bundle, Locale locale,
			Object[] args) {
		String rtnVal = getString(key, bundle, locale);
		for (int i = 0; i < args.length; i++)
			rtnVal = StringUtil.replace(rtnVal, "{" + i + "}",
					String.valueOf(args[i]));
		return rtnVal;
	}

	/**
	 * 获取kmss-config.proerties的信息
	 * 
	 * @param key
	 * @return
	 */
	public static String getKmssConfigString(String key) {
		try {
			return kmssConfigBundle.getProperty(key);
		} catch (Exception e) {
			return null;
		}
	}

	public static Map<String, String> getKmssUiConfig() {
		Map<String, String> map = new HashMap<String, String>();
		Iterator<Object> iter = kmssConfigBundle.keySet().iterator();
		while (iter.hasNext()) {
			String key = iter.next().toString();
			if (key.startsWith("kmss.sys.ui")) {
				map.put(key, kmssConfigBundle.getProperty(key));
			}
		}
		return map;
	}

	/**
	 * 根据语言设置获取语言locale
	 * 
	 * @param lang
	 * @return
	 */
	public static Locale getLocale(String lang) {
		if (StringUtil.isNull(lang)) {
			return null;
		}
		if (lang.indexOf(";") > -1) {
			lang = lang.substring(0, lang.indexOf(";"));
		}
		if (StringUtil.isNull(lang)) {
			return null;
		}
		if (lang.indexOf("|") > -1) {
			lang = lang.substring(lang.indexOf("|") + 1);
		}
		String[] langArr = lang.trim().split("-");
		if (langArr.length == 1) {
			return new Locale(langArr[0]);
		}
		if (langArr.length == 2) {
			return new Locale(langArr[0], langArr[1]);
		}
		return new Locale(langArr[0], langArr[1], langArr[2]);
	}

}
