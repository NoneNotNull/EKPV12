<%@page import="com.landray.kmss.sys.portal.util.SysPortalUtil.ModuleInfo"%>
<%@page import="com.landray.kmss.sys.portal.util.SysPortalUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.sys.portal.util.PortalUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiPortlet"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">${ lfn:message('sys-portal:desgin.msg.addwidget') }</template:replace>
	<template:replace name="body">
	<script>
		seajs.use(['theme!form']);
		</script>
	<script>
		function selectPortletSource(id,name,rid,rname,format,formats,operations){
			//debugger;
			var data = {
					"uuid":"opt_<%=IDGenerator.generateID()%>",
					"sourceId":id,
					"sourceName":name,
					"sourceFormat":format,
					"sourceFormats":formats,
					"renderId":rid,
					"renderName":rname,
					"operations":LUI.toJSON(unescape(operations))
			};
			window.$dialog.hide(data);
		}
		function buttonSearch(){
			//LUI("sourceList");
			var val = LUI.$("#moduleList").val();
			var keyword = LUI.$("#searchInput :text").val();
			seajs.use(['lui/topic'],function(topic){
				//var evt = {"a":"a"};
				var topicEvent = {
						criterions : [],
						query : []
					};
				
				topicEvent.query.push({"key":"__seq","value":[(new Date()).getTime()]});
				topicEvent.criterions.push({"key":"__module","value":[val]});
				topicEvent.criterions.push({"key":"__keyword","value":[keyword]});
				topic.publish("criteria.changed", topicEvent);				
			});
		}
		LUI.ready(function(){
			buttonSearch();
		});
	</script>
	<div style="margin:20px auto;width:95%;">
		<div style="border: 1px #e8e8e8 solid;padding: 5px;">
				<table class="tb_noborder" style="width: 100%">
					<tr>
						<td width="100">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.module') }</td>
						<td>
						<select id="moduleList" style="width: 200px;" onchange="buttonSearch(this.value)">
						<option value="__all">=${ lfn:message('sys-portal:sysPortalPage.desgin.msg.allmodule') }=</option>
						<%
						String sourceId = request.getParameter("sourceId");
						String moduleId = null;
						if(StringUtil.isNotNull(sourceId)){
							if(sourceId.endsWith(".source")){
								String portalId = sourceId.substring(0,sourceId.length()-7);
								try{
									moduleId = SysUiPluginUtil.getPortletById(portalId).getFdModule();
								}catch(Exception exx){
									//异常是有可能部件被删除了。
								}
							}							
						}
						List<?> modules = SysPortalUtil.getPortalModules(); 
						boolean isMultiServer = modules.size()>1;
						pageContext.setAttribute("isMultiServer",isMultiServer);
						if(isMultiServer){
							for(int i=0;i<modules.size();i++){
								ModuleInfo info=(ModuleInfo)modules.get(i);
								out.append("<optgroup label='"+info.getName()+"'>");
								Iterator<?> it = info.getChildren().iterator();
								while(it.hasNext()){
									ModuleInfo xxx = (ModuleInfo)it.next(); 
									if(xxx.getCode().equals(moduleId)){
										out.append("<option value='"+xxx.getCode()+"' selected>"+xxx.getName()+"</option>");
									}else{
										out.append("<option value='"+xxx.getCode()+"'>"+xxx.getName()+"</option>");
									}
								}
								out.append("</optgroup>");
							}
						}else{
							ModuleInfo info=(ModuleInfo)modules.get(0);
							Iterator<?> it = info.getChildren().iterator();
							while(it.hasNext()){
								ModuleInfo xxx = (ModuleInfo)it.next(); 
								if(xxx.getCode().equals(moduleId)){
									out.append("<option value='"+xxx.getCode()+"' selected>"+xxx.getName()+"</option>");
								}else{
									out.append("<option value='"+xxx.getCode()+"'>"+xxx.getName()+"</option>");
								}
							}
						}
						%>
						</select>
						</td>
						<td width="100">${ lfn:message('sys-portal:sysPortalPage.desgin.msg.keyword') }</td>
						<td>
						
						<div id="searchInput" data-lui-type="lui/search_box!SearchBox">
							<script type="text/config">
							{
								placeholder: "${ lfn:message('sys-portal:sysPortalPage.desgin.msg.inputq') }",
								width: '90%'
							}
							</script>
							<ui:event event="search.changed" args="evt">
								buttonSearch();
							</ui:event>
						</div>
						</td>
					</tr>
				</table>
			</div>	 
			<%-- &q.__module=<%= (moduleId == null ? "" : moduleId) %> --%>
			<div style="border: 1px #e8e8e8 solid;border-top-width: 0px;padding: 5px;height:430px;">
				<list:listview id="sourceList"  cfg-criteriaInit="true">
					<ui:source type="AjaxJson">
						{"url":"/sys/portal/sys_portal_portlet/sysPortalPortlet.do?method=selectSource&scene=${ param['scene'] }"}
					</ui:source>
					<list:colTable sort="false" layout="sys.ui.listview.listtable" onRowClick="selectPortletSource('!{fdSource}','!{fdName}','!{fdRenderId}','!{fdRenderName}','!{fdFormat}','!{fdFormats}',escape('!{operations}'))">
						<list:col-serial></list:col-serial>
						<c:if test="${isMultiServer}">
						<list:col-html title="服务器">
							{$
								{%row['fdServer']%}
							$}
						</list:col-html>
						</c:if>
						<list:col-auto props="fdName,fdModule,fdDescription"></list:col-auto>
						<list:col-html title="">
							{$
								<a class='com_btn_link' href="javascript:void(0)" onclick="selectPortletSource('{%row['fdSource']%}','{%row['fdName']%}','{%row['fdRenderId']%}','{%row['fdRenderName']%}','{%row['fdFormat']%}','{%row['fdFormats']%}','{%escape(row['operations'])%}')">${ lfn:message('sys-portal:sysPortalPage.msg.select') }</a>
							$}
						</list:col-html>
					</list:colTable>
				</list:listview>
				<div style="height: 10px;"></div>
				<list:paging layout="sys.ui.paging.simple"></list:paging>
			</div>
	</div>
	</template:replace>
</template:include>