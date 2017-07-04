<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%
Collection<SysUiMode> list = SysUiPluginUtil.getModes().values();
 
request.setAttribute("list",list);
%>
<script language="JavaScript"> 
</script>  
<div>

	<div id="optBarDiv">
		 
	</div>
  
	<table id="List_ViewTable">
		<tr>
			 <td>ID</td>
			 <td>名称</td>
		</tr>
		<c:forEach items="${list}" var="mode" varStatus="vstatus">
			<tr
				kmss_href="${ KMSS_Parameter_ContextPath }${ mode.fdHelp }" kmss_target="_self">
				<td>${ mode.fdId }</td>
				<td>${ mode.fdName }</td> 
			</tr>
		</c:forEach>
	</table> 
</div>
<%@ include file="/resource/jsp/list_down.jsp"%>
