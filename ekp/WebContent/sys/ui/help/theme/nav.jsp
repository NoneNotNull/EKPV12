<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="com.landray.kmss.sys.ui.xml.model.SysUiTheme"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	String fdId = request.getParameter("fdId");
	if(fdId==null){
		fdId = "default";
	}
	SysUiTheme theme = SysUiPluginUtil.getThemeById(fdId);
	request.setAttribute("sys.ui.theme", theme.getFdId());
	request.setAttribute("theme", theme);
%>
<script>
	function switchThemeHelpMenu(){
		var obj = LUI.$("#theme_help_menu");
		if(obj.css('left')=='0px'){
			var left = LUI.$(window).width()-obj.outerWidth(true);
			obj.css('left', left + "px");
		}else{
			obj.css('left', '0px');
		}
		LUI('theme_help_menu_pop').overlay.hide();
	}
	function returnThemeIndex(){
		var url = location.href;
		var i = url.lastIndexOf("/");
		location.href = Com_Parameter.ContextPath+Com_SetUrlParameter("sys/ui/help/theme/index.jsp", "from", url.substring(i+1));
	}
</script>
<div style="position: fixed; top:0px; left:0px; background-color: #FFEEEE; border:1px #FF9999 solid; z-index:9999" id="theme_help_menu">
	<div style="padding:4px 8px; cursor: pointer;">
		菜单
		<ui:popup align="down-left" style="background-color: white; display:none;" id="theme_help_menu_pop">
			<div style="padding:8px 8px 0px 8px;">
				<c:out value="${theme.fdName}" />(${theme.fdId})
			</div>
			<ui:toolbar layout="sys.ui.toolbar.ver.default" count="100" id="theme_help_menu_toolbar">
				<ui:button text="挡住我了" onclick="switchThemeHelpMenu();" order="1"/>
				<ui:button text="切换到通用样式" href="/sys/ui/help/theme/style.jsp?fdId=${theme.fdId}" target="_self"/>
				<ui:button text="切换到图标列表" href="/sys/ui/help/theme/icon.jsp?fdId=${theme.fdId}" target="_self"/>
				<ui:button text="切换到一级页面" href="/sys/ui/help/theme/portal.jsp?fdId=${theme.fdId}" target="_self"/>
				<ui:button text="切换到二级页面" href="/sys/ui/help/theme/list.jsp?fdId=${theme.fdId}" target="_self"/>
				<ui:button text="切换到三级页面" href="/sys/ui/help/theme/form.jsp?fdId=${theme.fdId}" target="_self"/>
				<ui:button text="返回到主题选择" href="javascript:returnThemeIndex();" target="_self"/>
			</ui:toolbar>
		</ui:popup>
	</div>
</div>