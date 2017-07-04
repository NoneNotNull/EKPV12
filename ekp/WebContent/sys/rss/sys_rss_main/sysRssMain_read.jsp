<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>

<script>
Com_IncludeFile("portal.css", "style/"+Com_Parameter.Style+"/portal/");
Com_IncludeFile("jquery.js", null, "js");
Com_IncludeFile("domain.js", null, "js");
</script>
</head>
<%--
	用于展现RSS，可以直接带 url 参数，便直接访问此 url 所标示的地址。
--%>
<body>
<center>
	<div style="width: 100%;" id=TB_Content>
	<table width=100% >
		<tr>
			<td id='rssError'><bean:message bundle="sys-rss" key="rss.loading.hint"/></td>
		</tr>
	</table>
	</div>
	
</center>
<c:if test="${not empty param.url}">
<%
	String qs = request.getQueryString();
	qs = qs.substring(4);
	pageContext.setAttribute("rssUrl", qs);
%>
</c:if>

<script>
var RSSReader = function(url, callback) {
	this.xmlsource = '<c:url value="/sys/rss/sys_rss_main/sysRssMain.do?method=proxy&url=" />' 
		+ encodeURIComponent(url);
	this.root = null;
	this.title = null;
	this.items = null;
	this.xmlDoc = null;
	this.callback = callback;
	this.loadXML(this.xmlsource);
}
RSSReader.prototype = {
	createXMLDoc: function(url) {
		var xmldom;
		if (window.ActiveXObject){
			var xmldom = new ActiveXObject("Microsoft.XMLDOM");
		} else {
			 var oXmlHttp = new XMLHttpRequest() ;
	            oXmlHttp.open( "GET", url, false ) ;
	            oXmlHttp.send(null) ; 
	           return oXmlHttp.responseXML;
		}
		xmldom.async=false;
		xmldom.load(url);
		return xmldom;
	},
	loadXML: function(url) {
		this.xmlDoc = this.createXMLDoc(url);
		this.init();
	},
	init: function() {
		if (window.ActiveXObject) {
			if (this.xmlDoc.readyState == 4) {
	   			this.initChannel();
	  		} else {
	  			var t = this;
	   			setTimeout(function() {t.init();}, 10);
	   		}
   		} else {
   			this.xmlDoc.onload = this.initChannel();
   		}
	},
	initChannel: function() {
		try {
			this.root = this.xmlDoc.getElementsByTagName("channel")[0];
	  		this.title = this.root.getElementsByTagName("title")[0];
	  		this.items = this.root.getElementsByTagName("item");
	  		this.callback(this);
  		} catch (e) {
			onError(e);
		}
	}
};
var showDate = function(rss) {
	var items = rss.items;
	var htmlCode = "<table width=100% >";
	for(var i=0,l=items.length-1; i<=l ;i++) {
		htmlCode += output(items[i]);
	}
	htmlCode += "</table>";
	document.getElementById("TB_Content").innerHTML = htmlCode;
};
var output = function(item) {
	var htmlCode = "";
	var title = item.getElementsByTagName("title")[0];
	var link = item.getElementsByTagName("link")[0];
	var description = item.getElementsByTagName("description")[0];
	htmlCode = "<tr><td><font id=\"limit_content_no\" class=\"limit_content_icon\">·</font>&nbsp;";
	htmlCode += "<a href=\"" + $(link).text() + "\" target='_bank' ";
	htmlCode += "title=\"" + $(title).text() + "\" >";
	htmlCode += $(title).text() + "</a></td></tr>";
	return htmlCode;
};
var onError = function(e) {
	var msg = '<bean:message bundle="sys-rss" key="rss.load.error"/>';
	if (false) {
		msg += "<br>" + (e.number & 0xFFFF) + " : " + e.description;
	}
	document.getElementById("rssError").innerHTML = msg;
}
try {
	new RSSReader('<c:url value="${rssUrl}" />', showDate);
} catch (e) {
	onError(e);
}
domain.autoResize();
</script>

</body>
</html>
