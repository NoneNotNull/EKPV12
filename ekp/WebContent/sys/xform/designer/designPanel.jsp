<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
 </HEAD>
 <script>Com_IncludeFile("jquery.js");</script>
<script type="text/javascript">
	Com_IncludeFile("dialog.js|calendar.js|formula.js|doclist.js|docutil.js");
<%@ include file="lang.jsp" %>
<%@ page import="com.landray.kmss.sys.xform.base.service.spring.SysFormTemplateControlUtils"%>
</script>
	<script type="text/javascript" src="dtree/dtree.js"></script>
	<script type="text/javascript" src="builder.js"></script>
	<script type="text/javascript" src="panel.js"></script>
	<script type="text/javascript" src="control.js"></script>
	<script type="text/javascript" src="dash.js"></script>
	<script type="text/javascript" src="config_ext.js"></script>
	<script type="text/javascript" src="config.js"></script>
	<script type="text/javascript" src="attachment.js"></script>
	<script type="text/javascript" src="jspcontrol.js"></script>
	<script type="text/javascript" src="buttons.js"></script>
	<script type="text/javascript" src="toolbar.js"></script>
	<script type="text/javascript" src="effect.js"></script>
	<script type="text/javascript" src="treepanel.js"></script>
	<script type="text/javascript" src="attrpanel.js"></script>
	<script type="text/javascript" src="shortcuts.js"></script>
	<script type="text/javascript" src="cache.js"></script>
	<script type="text/javascript" src="rightmenu.js"></script>

	<!-- 扩展 -->
	<%--script type="text/javascript" src="detailstable.js"></script--%>
	<%
	pageContext.setAttribute("jsFiles",SysFormTemplateControlUtils.getControlJsFiles());
	%>
	<c:forEach items="${jsFiles}" var="jsFile">
	<script type="text/javascript" src="<c:url value="${jsFile}" />"></script>
	</c:forEach>
	
	<script type="text/javascript" src="hidden.js"></script>
	<script type="text/javascript" src="right.js"></script>
	<script type="text/javascript" src="srceditor.js"></script>
	<%
	// 单独的js嵌入
	pageContext.setAttribute("jsFiles", SysFormTemplateControlUtils.getDesignJsFiltes());
	%>
	<c:forEach items="${jsFiles}" var="jsFile">
	<script type="text/javascript" src="<c:url value="${jsFile}" />"></script>
	</c:forEach>
	<script type="text/javascript" src="designer.js"></script>
	
	<link href="style/designer.css" type="text/css" rel="stylesheet" />
	<link href="<%=request.getContextPath() %>/resource/style/default/doc/document.css" type="text/css" rel="stylesheet" />
	<!--[if IE 6]>
	<link href="style/designer_ie6.css" type="text/css" rel="stylesheet" />
	<![endif]-->
	<link href="dtree/dtree.css" type="text/css" rel="stylesheet" />
	<c:set var="sysFormTemplateFormPrefix" value="${param.sysFormTemplateFormPrefix}" />
<script type="text/javascript">
var XForm_Design_Has_Init = false;
var parentIframe = null;
function XForm_DesignOnLoad(){
	if (XForm_Design_Has_Init) return;
	XForm_Design_Has_Init = true;
	var td_template = parent.document.getElementById("TD_FormTemplate_${param.fdKey}");
	var iframe = td_template.getElementsByTagName("IFRAME")[0];
	parentIframe = iframe;
	iframe.height = screen.height - 350;
	var fdDesignerHtmlObj = parent.document.getElementsByName("${sysFormTemplateFormPrefix}fdDesignerHtml")[0];
	if(fdDesignerHtmlObj.value != ''){
		if ('${param.method}' == 'view') {
			$(document.getElementById('designPanel')).html(fdDesignerHtmlObj.value);
			
			setTimeout(function(){XForm_AdjustViewHeight(iframe);}, 200);
		} else {
			//Designer.Initialize();
			Designer.instance.initialize(document.getElementById('designPanel'));
			Designer.instance.hasInitialized = false;
			Designer.instance.setHTML(fdDesignerHtmlObj.value, true);
			Designer.instance.fdKey = '${param.fdKey}';
			Designer.instance.hasInitialized = true;
		}
	} else {
		Designer.instance.initialize(document.getElementById('designPanel'));
		Designer.instance.fdKey = '${param.fdKey}';
		Designer.instance.hasInitialized = true;
		Designer.instance.builder.createControl('standardTable'); // 初始化新建一个表格
	}
}
function XForm_AdjustViewHeight(iframe) {
	debugger;
	var height = document.body.scrollHeight + 10;
	if (height < 50) {
		iframe.height = 100;
		setTimeout(function(){XForm_AdjustViewHeight(iframe);}, 200);
		return;
	} else {
		iframe.height = height;
	}
	_height = document.getElementById("designPanel").offsetHeight;
	if (height < _height) {
		iframe.height = _height + 10;
	}
}
var XForm_GetWfAuditNodes = null;
Com_AddEventListener(window, 'load', XForm_DesignOnLoad);

//禁用chrome等其他浏览器自己的右键菜单 作者 曹映辉 #日期 2015年3月26日
$(function(){
     $("#designPanel").bind("contextmenu",function(){
	  return false;
	});
});	 
</script>
 <BODY leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" style='overflow:scroll;overflow-x:auto;background-color: #fff;'>
  <div id="designPanel">
  </div>
 </BODY>
</HTML>