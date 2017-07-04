<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="javax.servlet.http.Cookie,com.landray.kmss.util.*"%>
<%@page import="com.landray.kmss.third.pda.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8" />
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no"/>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
<meta content="telephone=no" name="format-detection"/>
<script type="text/javascript">
<%String KMSS_Parameter_Style = request.getParameter("s_css");
			if (KMSS_Parameter_Style == null || KMSS_Parameter_Style.equals("")) {
				Cookie[] cookies = request.getCookies();
				if (cookies != null && cookies.length > 0)
					for (int i = 0; i < cookies.length; i++)
						if ("KMSS_Style".equals(cookies[i].getName())) {
							KMSS_Parameter_Style = cookies[i].getValue();
							break;
						}
			}
			if (KMSS_Parameter_Style == null || KMSS_Parameter_Style.equals(""))
				KMSS_Parameter_Style = "default";
			request.setAttribute("KMSS_Parameter_Style", KMSS_Parameter_Style);
			String KMSS_Parameter_ContextPath = request.getContextPath() + "/";
			request.setAttribute("KMSS_Parameter_ContextPath",
					KMSS_Parameter_ContextPath);
			String KMSS_Parameter_ResPath = KMSS_Parameter_ContextPath
					+ "resource/";
			request.setAttribute("KMSS_Parameter_ResPath",
					KMSS_Parameter_ResPath);
			String KMSS_Parameter_StylePath = KMSS_Parameter_ResPath + "style/"
					+ KMSS_Parameter_Style + "/";
			request.setAttribute("KMSS_Parameter_StylePath",
					KMSS_Parameter_StylePath);
			request.setAttribute("KMSS_Parameter_CurrentUserId", UserUtil
					.getUser().getFdId());
			request.setAttribute("KMSS_Parameter_CurrentUserName", UserUtil
					.getKMSSUser().getUserName());
			int pdaType = PdaFlagUtil.getPdaClientType(request);
			String isAppflag = request.getParameter("isAppflag");
			request.setAttribute("KMSS_PDA_TYPE" , pdaType);
			request.setAttribute("KMSS_PDA_NAME" , ResourceUtil.getString(request,"phone.pda.type.name"+pdaType,"third-pda"));
			request.setAttribute("KMSS_PDA_ISAPP" , (pdaType>1 ||"1".equalsIgnoreCase(isAppflag))?"1":"0");
//			request.setAttribute("KMSS_Parameter_CurrentUserOrgId", UserUtil
//					.getKMSSUser().getOrgTree());
//			request.setAttribute("KMSS_Parameter_CurrentUserOrgName", UserUtil
//					.getKMSSUser().getOrgTreeName());
%>
var Com_Parameter = {
	ContextPath:"${KMSS_Parameter_ContextPath}",
	ResPath:"${KMSS_Parameter_ResPath}",
	Style:"${KMSS_Parameter_Style}",
	JsFileList:new Array,
	StylePath:"${KMSS_Parameter_StylePath}",
	CurrentUserId:"${KMSS_Parameter_CurrentUserId}",
	CurrentUserName:"${KMSS_Parameter_CurrentUserName}",
//	CurrentUserOrgId:"${KMSS_Parameter_CurrentUserOrgId}",
//	CurrentUserOrgName:"${KMSS_Parameter_CurrentUserOrgName}",
	PdaType:"${KMSS_PDA_TYPE}",
	PdaName:"${KMSS_PDA_NAME}",
	IsAppFlag:"${KMSS_PDA_ISAPP}"
};
</script>
<script type="text/javascript"
	src="${KMSS_Parameter_ResPath}js/common.js"></script>
<link type="text/css" rel="stylesheet"
	href="<c:url value="/third/pda/resource/style/phone.css"/>" />
<script type="text/javascript">
	try{
		window.scrollTo(0, 1);
	}catch(e){}
</script>