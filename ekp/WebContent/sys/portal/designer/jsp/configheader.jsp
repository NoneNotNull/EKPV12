<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalHeader"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">配置页眉</template:replace>
	<template:replace name="body">
		<script>
		seajs.use(['theme!form']);
		</script>
		<ui:toolbar layout="sys.ui.toolbar.float" count="10" var-navwidth="100%">
			<ui:button onclick="onEnter()" text="确定"></ui:button>
		</ui:toolbar>
		<style type="text/css">
			#portal_page_header_select {
				position: fixed;
				top: 6px;
				z-index: 20;
				width: 200px;
				left: 20px;
			}
		</style>
		<script src="${LUI_ContextPath}/sys/ui/js/var.js"></script>
		<script>
		String.prototype.startWith=function(str){     
			  var reg=new RegExp("^"+str);     
			  return reg.test(this);        
		}  

		String.prototype.endWith=function(str){     
		  var reg=new RegExp(str+"$");     
		  return reg.test(this);        
		}

		lodingImg = "<img src='${LUI_ContextPath}/sys/ui/js/ajax.gif'/>"
		function onEnter(){
			var val = {};
			val.fdHeader = $("#portal_page_header_select").val();
			val.fdHeaderName = $("#portal_page_header_select option:selected").text();
			if(window['portal_page_header_opts_var']!=null){
				val.fdHeaderVars = escape(LUI.stringify(window['portal_page_header_opts_var'].getValue()));
			}
			window.$dialog.hide(val);
		}
		function fdHeaderSelectChange(val){
			var sindex = document.getElementById("portal_page_header_select").selectedIndex;
			if( sindex > 0){
				var opt = document.getElementById("portal_page_header_select").options[sindex];
				var headerId = opt.value;
				LUI.$("#fdHeader").val(headerId);
				LUI.$("#portal_page_header_img").attr("src","${LUI_ContextPath}"+opt.getAttribute("img")).show();
				LUI.$("#portal_page_header_opts").html(lodingImg).show().attr("jsname","portal_page_header_opts_var").load("${LUI_ContextPath}/sys/portal/designer/jsp/vars/header.jsp?x="+(new Date().getTime()),{"fdId":headerId,"jsname":"portal_page_header_opts_var"},function(){
					 if(val != null){
						 window['portal_page_header_opts_var'].setValue(val);
					 }
				});
			}else{
				LUI.$("#fdHeader").val("");
				LUI.$("#portal_page_header_opts").empty().hide();
				window['portal_page_header_opts_var']=null;
				LUI.$("#portal_page_header_img").hide();
			}
		}
		function onReady(){
			if(window.$dialog == null){
				window.setTimeout(onReady, 100);
				return
			}
			window.$ = LUI.$;
			var value = window.$dialog.dialogParameter;
			if(value != null && $.trim(value.fdHeader) != ""){
				LUI.$("#portal_page_header_select").val(value.fdHeader);
				var val = null;
				if($.trim(value.fdHeaderVars)!=""){
					val = LUI.toJSON(unescape(value.fdHeaderVars));
					fdHeaderSelectChange(val);
				}else{
					fdHeaderSelectChange();					
				}
			}else{
				$("#portal_page_header_select option").each(function(){
					if($(this).val().endWith(".default")){
						$(this).attr("selected","true");
					}
				});
				fdHeaderSelectChange();
			}
		}
		LUI.ready(onReady);
		</script>
	
		<select id="portal_page_header_select" onchange="fdHeaderSelectChange()">
		<option value="">无页眉</option>
		<% 
		List hs = PortalUtil.getPortalHeaders(request);
		for(int i=0;i < hs.size(); i++){
			SysPortalHeader h = (SysPortalHeader)hs.get(i);
			out.println("<option value='"+h.getFdId()+"' img='"+h.getFdThumb()+"'>" +h.getFdName()+"</option>");
		}
		%>								
		</select>
		<div style="height: 5px;"></div>
		<table style="width: 670px;padding: 0px;border: 0px;margin: 0 auto;">
			<tr>
				<td style="text-align:center;">
					<img id="portal_page_header_img" src="" style="max-width: 670px;" title="样例图片">
				</td>
			</tr>
			<tr>
				<td><div id="portal_page_header_opts" style='height: 250px;overflow: auto;'></div></td>
			</tr>
		</table> 
		
	</template:replace>
</template:include>