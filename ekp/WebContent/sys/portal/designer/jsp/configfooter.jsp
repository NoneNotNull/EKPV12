<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.portal.xml.model.SysPortalFooter"%>
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
		<ui:toolbar layout="sys.ui.toolbar.float" count="10" var-navwidth="100%">
			<ui:button onclick="onEnter()" text="确定"></ui:button>
		</ui:toolbar>
		<script>
		seajs.use(['theme!form']);
		</script>
		<style type="text/css">
			#portal_page_footer_select {
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
			val.fdFooter = $("#portal_page_footer_select").val();
			val.fdFooterName = $("#portal_page_footer_select option:selected").text();
			if(window['portal_page_footer_opts_var']!=null){
				val.fdFooterVars = escape(LUI.stringify(window['portal_page_footer_opts_var'].getValue()));
			}
			window.$dialog.hide(val);
		}
		function fdFooterSelectChange(val){
			var sindex = document.getElementById("portal_page_footer_select").selectedIndex;
			if( sindex > 0){
				var opt = document.getElementById("portal_page_footer_select").options[sindex];
				var footerId = opt.value;
				LUI.$("#fdFooter").val(footerId);
				LUI.$("#portal_page_footer_img").attr("src","${LUI_ContextPath}"+opt.getAttribute("img")).show();
				LUI.$("#portal_page_footer_opts").html(lodingImg).show().attr("jsname","portal_page_footer_opts_var").load("${LUI_ContextPath}/sys/portal/designer/jsp/vars/footer.jsp?x="+(new Date().getTime()),{"fdId":footerId,"jsname":"portal_page_footer_opts_var"},function(){
					 if(val != null){
						 window['portal_page_footer_opts_var'].setValue(val);
					 }
				});
			}else{
				LUI.$("#fdFooter").val("");
				LUI.$("#portal_page_footer_opts").empty().hide();
				window['portal_page_header_opts_var']=null;
				LUI.$("#portal_page_footer_img").hide();
			}
		}
		function onReady(){
			if(window.$dialog == null){
				window.setTimeout(onReady, 100);
				return
			}
			window.$ = LUI.$;
			var value = window.$dialog.dialogParameter;
			if(value != null && $.trim(value.fdFooter) != ""){
				LUI.$("#portal_page_footer_select").val(value.fdFooter);
				var val = null;
				if($.trim(value.fdFooterVars)!=""){
					val = LUI.toJSON(unescape(value.fdFooterVars));
					fdFooterSelectChange(val);
				}else{
					fdFooterSelectChange();
				}
			}else{
				$("#portal_page_footer_select option").each(function(){
					if($(this).val().endWith(".default")){
						$(this).attr("selected","true");
					}
				});
				fdFooterSelectChange();
			}
		}
		LUI.ready(onReady);
		</script>
	
		<select id="portal_page_footer_select" onchange="fdFooterSelectChange()">
		<option value="">无页脚</option>							
		<% 
		List fs = PortalUtil.getPortalFooters(request);
		for(int i=0;i<fs.size();i++){
			SysPortalFooter f = (SysPortalFooter)fs.get(i);
			out.println("<option value='"+f.getFdId()+"' img='"+f.getFdThumb()+"'>" +f.getFdName()+"</option>");
		}
		%>	
		</select>		
		<div style="height: 5px;"></div>
		<table style="width:670px;padding: 0px;border: 0px;margin: 0 auto;">
			<tr>
				<td><img id="portal_page_footer_img" src="" height="50" style="max-width: 670px;"></td>
			</tr>
			<tr>
				<td><div id="portal_page_footer_opts" style="height: 250px;overflow: auto;"></div></td>
			</tr>
		</table>
		
	</template:replace>
</template:include>