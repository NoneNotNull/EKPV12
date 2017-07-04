<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="com.landray.kmss.sys.person.interfaces.LinkInfo"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysPersonLink" list="${queryPage.list}">
		<list:data-column col="id">
		<%
			LinkInfo info = (LinkInfo)pageContext.getAttribute("sysPersonLink");
			if(LinkInfo.isMultiServer()){
				out.print(info.getServer()+SysUiConstant.SEPARATOR+info.getId());
			}else{
				out.print(info.getId());
			}
		%>
		</list:data-column>
		<list:data-column col="fdId">
		<%
			LinkInfo info = (LinkInfo)pageContext.getAttribute("sysPersonLink");
			if(LinkInfo.isMultiServer()){
				out.print(info.getServer()+SysUiConstant.SEPARATOR+info.getId());
			}else{
				out.print(info.getId());
			}
		%>
		</list:data-column>
		<list:data-column property="name" title="${lfn:message('sys-person:sysPersonLink.name') }" style="width:45%;">
		</list:data-column>
		<list:data-column property="url" title="${lfn:message('sys-person:sysPersonLink.url') }">
		</list:data-column>
		<list:data-column col="server" title="服务器">
		<%
			LinkInfo info = (LinkInfo)pageContext.getAttribute("sysPersonLink");
			out.print(LinkInfo.getServerNameByKey(info.getServer()));
		%>
		</list:data-column>
		<list:data-column property="icon">
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>