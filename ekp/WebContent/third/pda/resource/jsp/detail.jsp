
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@page import="com.landray.kmss.third.pda.constant.PdaModuleConfigConstant"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.third.pda.model.PdaVersionConfig"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%
		JSONObject detailObj = new JSONObject();
		/* 版本信息 */
		String version = (new PdaVersionConfig()).getMenuVersion();
		detailObj.accumulate("version",StringUtil.isNotNull(version) ? version : "");// 版本号
		/* 登录信息 */
		JSONObject login = new JSONObject();
		login.accumulate("url", PdaFlagUtil.formatUrl(request,"/j_acegi_security_check"));// 登录表单提交地址
		login.accumulate("nameField", "j_username"); // 登录表单用户名字段
		login.accumulate("passwordField", "j_password");// 登录表单密码字段
		detailObj.element("login", login);
		/* 注销信息 */
		JSONObject logout = new JSONObject();
		logout.accumulate("url", PdaFlagUtil.formatUrl(request,"/logout.jsp"));//注销地址
		detailObj.element("logout", logout);
		/* 菜单与图片版本信息 */
		detailObj.accumulate("configVersionUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_CONFIG_VERSION_URL));
		/* 菜单与图片版本信息 */
		detailObj.accumulate("menuDetailUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_MENU_DETAIL_URL));
		/* 详细菜单信息 */
		detailObj.accumulate("iconDetailUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_ICON_DETAIL_URL));
		/*收集信息推送所需的手机信息Url*/
		detailObj.accumulate("settingMsgUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_MSG_PUSH_MODIFY_URL));
		/*收集信息推送所需的手机信息Url*/
		detailObj.accumulate("requestMsgUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_MSG_PUSH_ADD_URL));
		/*推送信息请求数据URL,获取待办链接*/
		detailObj.accumulate("pdaMsgPushDataRequestUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_MSG_PUSH_DATA_URL));
		//ipad主页设置请求URL
		detailObj.accumulate("homePageUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PDA_HOME_PAGE_CONFIG));

		/*全文检索请求url*/
		detailObj.accumulate("ftSearchUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.FTSEARCH_URL));
		/*属性筛选请求路径*/
		detailObj.accumulate("propertyFilterUrl", PdaFlagUtil.formatUrl(
				request, PdaModuleConfigConstant.PROPERTYFILTER_URL));

		/* 搜索参数信息 */
		JSONObject search = new JSONObject();
		search.accumulate("modelNameField", "modelName");
		search.accumulate("keywordField", "keyword");
		detailObj.element("search", search);
        
		/* 构建参数配置对象 */
		PdaRowsPerPageConfig pdaRow = new PdaRowsPerPageConfig();
		
		/* 列表页面信息 */
		JSONObject list = new JSONObject();
		list.accumulate("startField", "start");// 下一页的参数
		list.accumulate("pagenoField", "pageno");// list页面中的第几页
		list.accumulate("rowsizeField", "rowsize"); // list页面中的每页多少条
		String rowsize = pdaRow.getFdRowsNumber();
		list.accumulate("rowsize", StringUtil.isNotNull(rowsize) ? rowsize : "15");
		detailObj.element("list", list);

		/* androidpn安卓消息推送服务器参数 */
		//为兼容历史ekp版本，去掉缺省值，避免缺省值导致报错
		JSONObject androidpn = new JSONObject();
		String host = StringUtil.isNotNull(pdaRow.getPushMsgServerIpAndriod())?pdaRow.getPushMsgServerIpAndriod():"";
		String port = StringUtil.isNotNull(pdaRow.getPushMsgServerPortAndriod())?pdaRow.getPushMsgServerPortAndriod():"";
		String apikey = StringUtil.isNotNull(pdaRow.getApiKeyAndriod())?pdaRow.getApiKeyAndriod():"";
		androidpn.accumulate("host", host);
		androidpn.accumulate("port", port);
		androidpn.accumulate("apikey", apikey);
		detailObj.element("androidpn", androidpn);
	%>
	<%=detailObj.toString()%>