<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.person.interfaces.LinkInfo" %>
<%@page import="com.landray.kmss.sys.zone.util.SysZoneConfigUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysZoneNavLink" list="${queryPage.list}">
		<list:data-column col="fdId" escape="false">
			${sysZoneNavLink.id}_${sysZoneNavLink.server}</list:data-column>
		<list:data-column  col="id" escape="false">
			${sysZoneNavLink.id}_${sysZoneNavLink.server}
		</list:data-column>
		<list:data-column property="name" title="${lfn:message('sys-zone:sysZoneNavLink.fdName') }" style="width:45%;">
		</list:data-column>
		<list:data-column property="url" title="${lfn:message('sys-zone:sysZoneNavLink.fdUrl') }">
		</list:data-column>
		<list:data-column property="server" title="服务器key值">
		</list:data-column>
		<list:data-column col="serverName" title="${lfn:message('sys-zone:sysZoneNavLink.server') }" escape="false">
			<%	
				 Object item = pageContext.getAttribute("sysZoneNavLink");
				if(item != null) {
					out.print(SysZoneConfigUtil.getServerName(((LinkInfo)item).getServer()));
				}
			%>
		</list:data-column>
		<list:data-column  title="窗口" col="targetText" escape="false">
			<sunbor:enumsShow enumsType="sysZone_fdTarget" value="${empty sysZoneNavLink.target ? '_self' : sysZoneNavLink.target}" />
		</list:data-column>
		<list:data-column col="target" title="${lfn:message('sys-zone:sysZoneNavLink.target') }" escape="false">
			${empty sysZoneNavLink.target ? '_self' : sysZoneNavLink.target}
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>