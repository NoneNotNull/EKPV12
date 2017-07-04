<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.sys.news.service.ISysNewsMainService,
	com.landray.kmss.common.actions.RequestContext,
	java.util.*
"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script>
Com_IncludeFile("portal.css", "style/"+Com_Parameter.Style+"/portal/");
</script>
<style>
#content{width: 100%;padding: 8px;height: 190px;overflow:hidden; zoom:1;line-height: 1.5;}
#content img{float:left;margin-left: -18px;margin-right: -10px;}
.text_dotted{float:right;height: 10px;width: 10px;margin-top: -15px;}
</style>
</head>
<body>

<%
// 从数据库取得数据
	

	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	RequestContext requestInfo = new RequestContext(request);
	ISysNewsMainService bean = (ISysNewsMainService) ctx.getBean("sysNewsMainService");
	Map<String,Object> newMap = bean.getPortletDataMap(requestInfo);
	String imageWidth = "165";
   	String imageHeight = "110";
	pageContext.setAttribute("image", newMap.get("image"));
	pageContext.setAttribute("url", newMap.get("href"));
	pageContext.setAttribute("content", newMap.get("content"));
	pageContext.setAttribute("description", newMap.get("description"));
	String imageWidth1 = request.getParameter("imageWidth");
	String imageHeight1 = request.getParameter("imageHeight");
	if(imageWidth1 !=null && imageWidth1.trim().length() >0 && !"undefined".equals(imageWidth1)){
		imageWidth = imageWidth1;
	}
	if(imageHeight1 !=null && imageHeight1.trim().length() >0 && !"undefined".equals(imageHeight1)){		
		imageHeight = imageHeight1;
	}
%>
<div id="content">
<a href="<c:url value="${url}"/>" target=_blank><img border=0 src="<c:url value="${image}"/>" width=<%=imageWidth%> height=<%=imageHeight %>  hspace=22></a>
<a href="<c:url value="${url}"/>" style="margin-left: 10px" target=_blank>${description}</a>
<!-- <a href="<c:url value="${url}"/>" target=_blank>${content}</a>-->
</div>
<a href="<c:url value="${url}"/>" target=_blank>
<div class="text_dotted" >…</div>
</a>
</body>
</html>