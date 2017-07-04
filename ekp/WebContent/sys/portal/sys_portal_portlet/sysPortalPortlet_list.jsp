<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiPortlet"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/portal/sys_portal_portlet/sysPortalPortlet.do">
	<div id="optBarDiv">
	 
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<script>
	function buttonSearch(val){
		var url = location.href;
		url = Com_SetUrlParameter(url,"q.__module",val);
		location.href = url;
	}
	</script>
	<table class="tb_normal" style="width: 100%;">
		<tr>
			<td style="padding: 8px;border: 1px #e8e8e8 solid;">
			模块&nbsp;&nbsp;&nbsp;&nbsp;<select style="width: 200px;" onchange="buttonSearch(this.value)">
						<option value="__all">=所有模块=</option>
						<%
						List<String> modules = new ArrayList<String>();
						Collection<SysUiPortlet>  portlets = SysUiPluginUtil.getPortlets().values();
						Iterator<SysUiPortlet> it = portlets.iterator();
						while(it.hasNext()){
							SysUiPortlet x = it.next();
							String key = x.getFdModule();
							String mkey = ResourceUtil.getMessage(key);
							if(!modules.contains(key)){
								modules.add(key);
								if(request.getParameter("q.__module")!=null && request.getParameter("q.__module").equals(key)){
									out.append("<option value='"+key+"' selected='true'>"+mkey+"</option>");
								}else{
									out.append("<option value='"+key+"'>"+mkey+"</option>");
								}
							}
						}
						%>
						</select>
			</td>
		</tr>
	</table>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td"> 
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<td>
					ID
				</td>
				<td>
					名称
				</td>
				<td>
					所属模块
				</td>
				<td>
					描述信息
				</td>
				<td>
					数据格式
				</td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPortalPortlet" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/portal/sys_portal_portlet/sysPortalPortlet.do" />?method=view&fdId=${sysPortalPortlet.fdId}">
			 
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPortalPortlet.fdId}" />
				</td>
				<td>
					<c:out value="${sysPortalPortlet.fdName}" />
				</td>
				<td>
					<c:out value="${sysPortalPortlet.fdModule}" />			
				</td>
				<td>
					<c:out value="${sysPortalPortlet.fdDescription}" />			
				</td>
				<td>
					<c:out value="${sysPortalPortlet.fdFormat}" />			
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>