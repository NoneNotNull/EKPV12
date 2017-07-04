package com.landray.kmss.util;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.landray.kmss.sys.log.model.SysLogError;
import com.landray.kmss.sys.log.service.ISysLogErrorService;

/**
 * 拼装页面显示的HTML代码。普通程序请勿使用
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public class KmssMessageWriter {
	private static final Log logger = LogFactory
			.getLog(KmssMessageWriter.class);

	private KmssReturnPage rtnPage = null;

	private HttpServletRequest request = null;

	private ISysLogErrorService logErrorService = null;

	private ISysLogErrorService getLogErrorService() {
		if (logErrorService == null) {
			ApplicationContext ctx = WebApplicationContextUtils
					.getRequiredWebApplicationContext(request.getSession()
							.getServletContext());
			logErrorService = (ISysLogErrorService) ctx
					.getBean("sysLogErrorService");
		}
		return logErrorService;
	}

	public KmssMessageWriter(HttpServletRequest request, KmssReturnPage rtnPage) {
		this.rtnPage = rtnPage;
		this.request = request;
	}

	public String DrawTitle() {
		boolean isErrorPage = false;
		if (rtnPage != null && rtnPage.getMessages() != null
				&& rtnPage.getMessages().hasError())
			isErrorPage = true;
		return DrawTitle(isErrorPage);
	}

	public String DrawTitle(boolean isErrorPage) {
		KmssMessage msg = null;
		StringBuffer rtnVal = new StringBuffer();
		String rtnOptKey;
		// String rtnKey;
		if (rtnPage != null) {
			msg = rtnPage.getTitle();
			List<String> scriptCodeList = rtnPage.getScriptCodeList();
			if (!scriptCodeList.isEmpty()) {
				rtnVal.append("<script>");
				for (int i = 0; i < scriptCodeList.size(); i++) {
					rtnVal.append(scriptCodeList.get(i));
					rtnVal.append("\r\n");
				}
				rtnVal.append("</script>\r\n");
			}
		}
		if (isErrorPage) {
			rtnVal.append("<div class=errortitle>");
			rtnOptKey = "return.optFailure";
			// rtnKey = "return.failure";
		} else {
			rtnVal.append("<div class=msgtitle>");
			rtnOptKey = "return.optSuccess";
			// rtnKey = "return.success";
		}
		if (msg == null) {
			// if (rtnPage == null || rtnPage.getOperationKey() == null) {
			// msgKey = request.getParameter("method");
			// if (msgKey != null)
			// msgKey = "button." + msgKey;
			// } else {
			// msgKey = rtnPage.getOperationKey();
			// }
			// if (msgKey != null)
			// msgKey = ResourceUtil.getString(msgKey, request.getLocale());
			// if (msgKey == null)
			rtnVal.append(ResourceUtil
					.getString(rtnOptKey, request.getLocale()));
			// else
			// rtnVal.append(ResourceUtil.getString(rtnKey, null,
			// request.getLocale(), msgKey));
		} else {
			rtnVal.append(getMessageInfo(msg));
		}
		return rtnVal.append("</div>").toString();
	}

	public String DrawMessages() {
		if (rtnPage == null || rtnPage.getMessages() == null)
			return "";
		StringBuffer rtnVal = new StringBuffer();
		List<KmssMessage> msgList = rtnPage.getMessages().getMessages();
		for (int i = 0; i < msgList.size(); i++) {
			KmssMessage msg = msgList.get(i);
			String msgInfo = getMessageInfo(msg);
			String moreInfo = null;
			if (msg.getThrowable() == null) {
				rtnVal.append("<span class='success_dot'></span>");
			} else {
				moreInfo = ExceptionUtil.getExceptionString(msg.getThrowable());
				logError(msg, msgInfo, moreInfo);
				rtnVal.append("<span onclick='showMoreErrInfo(" + i
						+ ", this);' class='showMoreError_plus'></span>");
			}
			if (msg.getMessageType() == KmssMessage.MESSAGE_ERROR)
				rtnVal.append("<span class=errorlist>");
			else
				rtnVal.append("<span class=msglist>");
			rtnVal.append(msgInfo);
			rtnVal.append("</span>\r\n");
			if (moreInfo != null) {
				rtnVal.append("<div style='display:none' id='moreErrInfo" + i
						+ "'>");
				rtnVal.append("<pre class='brush: bash;'>");
				rtnVal.append(StringUtil.XMLEscape(moreInfo));
				rtnVal.append("</pre>");
				rtnVal.append("</div>");
			}
			rtnVal.append("<br style='font-size:18px'>\r\n");
		}
		return rtnVal.toString();
	}

	public JSONObject DrawJsonMessage(boolean isErrorPage) {
		JSONObject json = new JSONObject();
		
		JSONArray message = new JSONArray();
		if (rtnPage != null && rtnPage.getMessages() != null) {
			List<KmssMessage> msgList = rtnPage.getMessages().getMessages();
			for (int i = 0; i < msgList.size(); i++) {
				JSONObject jso = new JSONObject();
				KmssMessage xmsg = msgList.get(i);
				String msgInfo = getMessageInfo(xmsg);
				String moreInfo = null;
				if (xmsg.getThrowable() == null) {
					jso.put("isOk", true);
				} else {
					moreInfo = ExceptionUtil.getExceptionString(xmsg
							.getThrowable());
					logError(xmsg, msgInfo, moreInfo);
					jso.put("isOk", false);
					isErrorPage = true;
				}
				jso.put("msg", msgInfo);
				message.add(jso);
			}
		}
		json.put("message", message);
		
		if (isErrorPage) {
			json.put("status", false);
		} else {
			json.put("status", true);
		}
		String title = null;
		// String msgKey = null;
		String rtnOptKey = null;
		// String rtnKey = null;
		if (isErrorPage) {
			rtnOptKey = "return.optFailure";
			// rtnKey = "return.failure";
		} else {
			rtnOptKey = "return.optSuccess";
			// rtnKey = "return.success";
		}
		KmssMessage msg = rtnPage != null ? rtnPage.getTitle() : null;
		if (msg == null) {
			// if (rtnPage == null || rtnPage.getOperationKey() == null) {
			// msgKey = request.getParameter("method");
			// if (msgKey != null)
			// msgKey = "button." + msgKey;
			// } else {
			// msgKey = rtnPage.getOperationKey();
			// }
			// if (msgKey != null)
			// msgKey = ResourceUtil.getString(msgKey, request.getLocale());
			// if (msgKey == null)
			title = (ResourceUtil.getString(rtnOptKey, request.getLocale()));
			// else
			// title = (ResourceUtil.getString(rtnKey, null,
			// request.getLocale(), msgKey));
		} else {
			title = getMessageInfo(msg);
		}
		json.put("title", title);
		return json;
	}

	private void logError(KmssMessage msg, String msgInfo, String moreInfo) {
		try {
			String url = getUrl(rtnPage, request);
			logger.error(msgInfo + "，URL=" + url, msg.getThrowable());

			SysLogError logerror = new SysLogError();
			logerror.setFdCreateTime(new Date());
			logerror.setFdOperator(UserUtil.getKMSSUser().getUserName());
			logerror.setFdOperatorId(UserUtil.getKMSSUser().getUserId());
			logerror.setFdIp(request.getRemoteAddr());
			logerror.setFdMethod(request.getMethod());
			logerror.setFdUrl(url);
			String errorInfo = msgInfo;
			if (StringUtil.isNotNull(moreInfo)) {
				errorInfo += "\r\n" + moreInfo;
			}
			logerror.setFdErrorInfo(errorInfo);
			getLogErrorService().add(logerror);
		} catch (Exception e) {
			logger.error("保存错误日志信息时发生错误", e);
		}
	}

	private String getUrl(KmssReturnPage rtnPage, HttpServletRequest request) {
		String queryStr = request.getQueryString();
		if (StringUtil.isNull(queryStr))
			queryStr = "";
		else
			queryStr = "?" + queryStr;

		if (rtnPage != null && StringUtil.isNotNull(rtnPage.getRequestURL())) {
			return rtnPage.getRequestURL() + queryStr;
		}

		return request.getRequestURL().toString() + queryStr;
	}

	public String DrawButton() {
		if (rtnPage == null)
			return "";
		StringBuffer rtnVal = new StringBuffer();
		List<List<String>> btnList = rtnPage.getButtons();
		for (int i = 0; i < btnList.size(); i++) {
			List<String> btn = btnList.get(i);
			// if (i > 0)
			// rtnVal.append("&nbsp;&nbsp;");
			rtnVal.append("<div class='btnmsg_l'>");
			rtnVal.append("<div class='btnmsg_r'>");
			rtnVal.append("<input type=button class=btnmsg value=\""
					+ ResourceUtil.getString((String) btn.get(0), request
							.getLocale()) + "\" onclick=\""
					+ StringUtil.XMLEscape((String) btn.get(1)) + "\">\r\n");
			rtnVal.append("</div>");
			rtnVal.append("</div>");
		}
		return rtnVal.toString();
	}

	private String getMessageInfo(KmssMessage msg) {
		Object[] params = msg.getParameter();
		if (params != null) {
			for (int i = 0; i < params.length; i++) {
				if (params[i] instanceof KmssMessage) {
					params[i] = getMessageInfo((KmssMessage) params[i]);
				}
			}
			return ResourceUtil.getString(msg.getMessageKey(), null, request
					.getLocale(), params);
		} else {
			return ResourceUtil.getString(msg.getMessageKey(), request
					.getLocale());
		}
	}
}