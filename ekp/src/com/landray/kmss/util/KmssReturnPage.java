package com.landray.kmss.util;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

/**
 * 返回界面。<br>
 * 仅在Action的方法中调用，注意：<br>
 * 1、使用静态方法getInstance获取一个实例。<br>
 * 2、当所有参数设置完毕后，必须执行save的操作。
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class KmssReturnPage {
	/**
	 * 常量：返回按钮。
	 */
	public final static int BUTTON_RETURN = 1;

	/**
	 * 常量：关闭按钮。
	 */
	public final static int BUTTON_CLOSE = 0;

	private KmssMessage title = null;

	private KmssMessages messages = null;

	private List<List<String>> buttons = new ArrayList<List<String>>();

	private String operationKey = null;

	private List<String> scriptCodeList = new ArrayList<String>();

	// 存储错误跳转前路径
	private String requestURL = null;

	public String getRequestURL() {
		return requestURL;
	}

	public void setRequestURL(String requestURL) {
		this.requestURL = requestURL;
	}

	private KmssReturnPage() {
	}

	private HttpServletRequest request;

	public HttpServletRequest getRequest() {
		return request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	/**
	 * 获取一个返回界面类的实例。
	 * 
	 * @param request
	 * @return 返回界面类
	 */
	public static KmssReturnPage getInstance(HttpServletRequest request) {
		KmssReturnPage rtnPage = (KmssReturnPage) request
				.getAttribute("KMSS_RETURNPAGE");
		if (rtnPage == null) {
			rtnPage = new KmssReturnPage();
			rtnPage.setRequestURL(request.getRequestURL().toString());
			rtnPage.setRequest(request);
		}
		return rtnPage;
	}

	/**
	 * 添加信息表。
	 * 
	 * @param msgs
	 *            信息表
	 * @return 当前实例
	 */
	public KmssReturnPage addMessages(KmssMessages msgs) {
		if (messages == null)
			messages = msgs;
		else
			messages.concat(msgs);
		return this;
	}

	/**
	 * 在返回界面的JSP中调用，获取所有的按钮。
	 * 
	 * @return 按钮列表
	 */
	public List<List<String>> getButtons() {
		return buttons;
	}

	/**
	 * 添加一个系统内置的按钮。
	 * 
	 * @param defaultBtn
	 *            请使用本类的BUTTON_常量
	 * @return 当前实例
	 */
	public KmssReturnPage addButton(int defaultBtn) {
		switch (defaultBtn) {
		case BUTTON_RETURN:
			// 修复chrome下旧列表删除返回checkbox莫名选中的问题
			HttpServletRequest req = this.getRequest();
			String referer = req.getHeader("Referer");
			String jscode = StringUtil.isNotNull(referer) ? "location.href='"
					+ referer + "';" : "history.go(-1);";
			addButton("button.back", jscode, true);
			break;
		case BUTTON_CLOSE:
			addButton("button.close", "Com_CloseWindow();", true);
			break;
		}
		return this;
	}

	/**
	 * 添加一个自定义的按钮
	 * 
	 * 当msgKey在buttons中已存在时，则不再添加该按钮 alter by 张乐志 2013年1月7日
	 * 
	 * @param msgKey
	 *            按钮的value对应的key值
	 * @param href
	 *            javascript代码或链接信息，见下一个参数
	 * @param isJsCode
	 *            若该值为true，说明上一个参数传递的是javascript代码，否则，上一个参数传递的是一段URL
	 * @return 当前实例
	 */
	public KmssReturnPage addButton(String msgKey, String href, boolean isJsCode) {
		for (int i = 0; i < buttons.size(); i++) {
			List<String> ele = buttons.get(i);
			if (ele.contains(msgKey))
				return this;
		}
		List<String> btn = new ArrayList<String>();
		btn.add(msgKey);
		if (isJsCode) {
			btn.add(href);
		} else {
			href = href.replaceAll("\"", "&quot;");
			if (href.charAt(0) == '/') {
				href = "Com_Parameter.ContextPath+Com_SetUrlParameter(\""
						+ href.substring(1)
						+ "\",\"s_css\", Com_GetUrlParameter(location.href, \"s_css\"));";
			} else {
				href = "\"" + href + "\";";
			}
			btn.add("location.href=" + href);
		}
		buttons.add(btn);
		return this;
	}

	/**
	 * 在返回界面的JSP中调用，获取信息列表。
	 * 
	 * @return 信息列表
	 */
	public KmssMessages getMessages() {
		return messages;
	}

	/**
	 * 设置信息列表。
	 * 
	 * @param messages
	 *            信息列表
	 * @return 当前实例
	 */
	public KmssReturnPage setMessages(KmssMessages messages) {
		this.messages = messages;
		return this;
	}

	/**
	 * 在返回界面的JSP中调用，获取返回标题。
	 * 
	 * @return
	 */
	public KmssMessage getTitle() {
		return title;
	}

	/**
	 * 设置返回标题。
	 * 
	 * @param title
	 * @return 当前实例
	 */
	public KmssReturnPage setTitle(KmssMessage title) {
		this.title = title;
		return this;
	}

	/**
	 * 保存配置的信息。
	 * 
	 * @param request
	 */
	public void save(HttpServletRequest request) {
		if (request.getAttribute("KMSS_RETURNPAGE") == null)
			request.setAttribute("KMSS_RETURNPAGE", this);
	}

	public String getOperationKey() {
		return operationKey;
	}

	/**
	 * 设置当前操作的KEY值
	 * 
	 * @param operationKey
	 * @return
	 */
	public KmssReturnPage setOperationKey(String operationKey) {
		this.operationKey = operationKey;
		return this;
	}

	public KmssReturnPage addScriptCode(String scriptCode) {
		this.scriptCodeList.add(scriptCode);
		return this;
	}

	public List<String> getScriptCodeList() {
		return scriptCodeList;
	}
}
