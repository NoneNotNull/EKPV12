<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="com.landray.kmss.sys.person.interfaces.LinkInfo"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@ page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysPersonLink" list="${queryPage.list}">
		<list:data-column property="id">
		<%
			Object xobj = pageContext.getAttribute("sysPersonLink");
			String server = null;
			String id = null;
			if(xobj instanceof LinkInfo){
				LinkInfo xlink = (LinkInfo)xobj;
				server = xlink.getServer();
				id = xlink.getId();
			} 
			if(xobj instanceof Map){
				Map xlink = (Map)xobj;
				server = xlink.get("server") == null ? null : xlink.get("server").toString();
				id = xlink.get("id").toString();
			}
			if(LinkInfo.isMultiServer()){
				out.print(server+SysUiConstant.SEPARATOR+id);
			}else{
				out.print(id);
			}
		%>
		</list:data-column>
		<list:data-column col="fdId">
		<%
			Object xobj = pageContext.getAttribute("sysPersonLink");
			String server = null;
			String id = null;
			if(xobj instanceof LinkInfo){
				LinkInfo xlink = (LinkInfo)xobj;
				server = xlink.getServer();
				id = xlink.getId();
			} 
			if(xobj instanceof Map){
				Map xlink = (Map)xobj;
				server = xlink.get("server") == null ? null : xlink.get("server").toString();
				id = xlink.get("id").toString();
			}
			if(LinkInfo.isMultiServer()){
				out.print(server+SysUiConstant.SEPARATOR+id);
			}else{
				out.print(id);
			}
		%>
		</list:data-column>
		<list:data-column property="name" title="${lfn:message('sys-person:sysPersonLink.name') }" style="width:45%;">
		</list:data-column>
		<list:data-column col="server" title="服务器">
			<%
				Object xobj = pageContext.getAttribute("sysPersonLink");
				String server = null;
				if(xobj instanceof LinkInfo){
					LinkInfo xlink = (LinkInfo)xobj;
					server = xlink.getServer();
				} 
				if(xobj instanceof Map){
					Map xlink = (Map)xobj;
					server = xlink.get("server") == null ? null : xlink.get("server").toString();
				}
				out.print(LinkInfo.getServerNameByKey(server));
			%>
		</list:data-column>
		<list:data-column property="url" title="${lfn:message('sys-person:sysPersonLink.url') }">
		</list:data-column>
		<list:data-column property="icon">
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>