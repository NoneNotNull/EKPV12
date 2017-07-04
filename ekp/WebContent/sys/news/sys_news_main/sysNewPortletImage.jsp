<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.util.StringUtil,
	com.landray.kmss.sys.news.model.SysNewsConfig,
	java.util.*
"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script>
Com_IncludeFile("portal.css", "style/"+Com_Parameter.Style+"/portal/");
</script>
</head>
<body>
<center>
<div id="_divFlashNews"></div>
<%
// 从数据库取得数据
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	RequestContext requestInfo = new RequestContext(request);
	IXMLDataBean bean = (IXMLDataBean) ctx.getBean("sysNewsMainPortletService");
	List newsList = bean.getDataList(requestInfo);
	pageContext.setAttribute("newsList", newsList);
%>

<script>
function getFlashNews()
{
	var i, j, tmpStr, content;
	var htmlCode = "<table width=100% border=0 cellspacing=0 cellpadding=0 ><tr><td>";
	//截断过长标题
	var getByLength = function(words, length) {
		if(length < words.length)
			words = words.substring(0, length-2) + "...";
		return Com_HtmlEscape(words.replace(/&/g, escape("&")));
	}
	var textLength = 20;
	var links = "";
	var texts = "";
	var pics = "";
	
	<c:forEach items="${newsList}" var="news">
		links += "|" + "${pageContext.request.contextPath}" + escape("${news.href}");
		texts += "|" + getByLength("${news.text}", textLength);
		pics += "|" + "${pageContext.request.contextPath}" + escape("${news.image}");
     </c:forEach>
    
    if(links.length > 0){
    	links = links.substring(1);
    	texts = texts.substring(1);
    	pics = pics.substring(1);
    }
    
	texts = texts.replace("'","="); // 获取控件页面有此调用，原因不详
	
	<%
	 String imageWidth = request.getParameter("imageWidth");
   	 String imageHeight = request.getParameter("imageHeight");
		%>
	<%
	SysNewsConfig sysNewsConfig = new SysNewsConfig();
	int imageW = sysNewsConfig.getfdImageW();
	if(imageW > 800){
		request.setAttribute("imageW",800);
	}else{
		request.setAttribute("imageW",sysNewsConfig.getfdImageW());
	}
	
	int imageH = sysNewsConfig.getfdImageH();
  	if(imageH > 600){
		request.setAttribute("imageH",600);
	}else{
		request.setAttribute("imageH",sysNewsConfig.getfdImageH());
	}
	%>	
	var focus_width = ${imageW};
	var focus_height = ${imageH}; // 原值是 175
	var text_height = 16;

	<%
	if(imageWidth !=null){		
	%>
	focus_width = "<%=imageWidth%>";
	<%}%>
	<%
	if(imageHeight !=null){		
	%>
	focus_height = "<%=imageHeight%>";
	<%}%>
	
	//var UrlCss = '';
	//var Play_M = 12;
	//var Bg_Color = '0xFFFFFF';
	//var Bg_Img = 'NO';
	//var text_padding = 5;
	var swf_height = focus_height + text_height;
	texts = encodeURI(texts);//对标题文本进行编码，避免标题有百分号等特殊字符时标题和图片不能正常显示
	htmlCode += "<table width=100% border=0 cellspacing=0 cellpadding=0><tr valign=top><td width=200px >";
	htmlCode += '<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0" width="'+ focus_width +'" height="'+ swf_height +'">';
	htmlCode += '<param name="allowScriptAccess" value="sameDomain"><param name="movie" value="'+Com_Parameter.ContextPath+'resource/plusin/picturenews.swf"><param name="quality" value="high"><param name="bgcolor" value="#fff">';
	htmlCode += '<param name="menu" value="false"><param name=wmode value="transparent">';
	htmlCode += '<param name="FlashVars" value="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'">';
	htmlCode += '<embed src="'+Com_Parameter.ContextPath+'resource/plusin/picturenews.swf" quality="high" FlashVars="pics='+pics+'&links='+links+'&texts='+texts+'&borderwidth='+focus_width+'&borderheight='+focus_height+'&textheight='+text_height+'" pluginspage="http://www.adobe.com/shockwave/download/download.cgi?P1_Prod_Version=ShockwaveFlash" wmode="transparent" type="application/x-shockwave-flash" width="'+ focus_width +'" height="'+ swf_height +'"><\/embed>'
	htmlCode += '</object></td><td style="padding-left:10px">';

	
	htmlCode += "</td></tr></table>";
	//var win = window.open();
	//win.document.write(htmlCode);
	return htmlCode;
}
document.all._divFlashNews.innerHTML = getFlashNews();
</script>

</center>

</body>
</html>