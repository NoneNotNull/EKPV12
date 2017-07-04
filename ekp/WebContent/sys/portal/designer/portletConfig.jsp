<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
response.setHeader("Access-Control-Allow-Origin","*");
response.setHeader("Content-Security-Policy", "frame-src *;");
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<%@ include file="/sys/portal/designer/jsp/inc/head.jsp"%>
	<template:replace name="body">
	<style>
	.lui_toolbar_frame_float {
	 	position: static;
	}
	#panel_box {
		margin-top:20px !important;
	}
	</style>
	<div style="position: fixed; top:0px;right: 0px; left: 0px;bottom: 0px;background: white;opacity: 0.5;"></div>
	<div style="width: 700px;height: 460px;background: white;margin: 0 auto;position: relative;border: 1px red solid;">
	<script src="${LUI_ContextPath}/sys/portal/designer/js/ibm.js"></script>
	<script>
	var jsonConfig = '${param.jsonConfigContent}';
	var dialogWin = window;
	function onReady(){
		window.$ = LUI.$; 
		//LUI("btnPrevStep").setVisible(false);
		LUI.$.getJSON("${LUI_ContextPath}/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=panelLayout&scene="+window.scene,function(json){
			panelLayout = json;
			$($("[name='portlet_panel_height_ext']").get(0)).attr("checked",true);
			$($("[name='portlet_tabpanel_height_ext']").get(0)).attr("checked",true);
			if($.trim(jsonConfig) != ""){
				//编辑模式				
				onConfigWidget(LUI.toJSON(unescape($.trim(jsonConfig))));
			}else{		
				//新增模式
				
				//单标签
				portletChangePanelType();
				changePortletPanelLayout(document.getElementById("portlet_panel_layout"));

				//多标签
				portletChangeTabPanelType();
				changePortletTabPanelLayout(document.getElementById("portlet_tabpanel_layout"));
				
				onStep2();
			}
		});
		/*
		var boxh = $(document).height()-70;
		$("#panel_box").height(boxh);
		$(".portlet_table").height(boxh-60);
		*/
	}
	LUI.ready(onReady);
	function onEnter(){
		var value = getPortletReturnData();		
		if(validation(value)){
			value = LUI.stringify(value);
			$.post("${LUI_ContextPath}/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=genHtml",{"config":value},function(html){
				value = escape(value);
				html = ibm_portal($.trim(html),'<%=ResourceUtil.getKmssConfigString("kmss.urlPrefix")%>','${LUI_ContextPath}');
				domain.call(parent,"saveConfig",[value,escape(html)]);
			},'text');
		}		
	}
	</script>
	<%@ include file="/sys/portal/designer/jsp/inc/body.jsp"%>	
	</div>
	</template:replace>
</template:include>