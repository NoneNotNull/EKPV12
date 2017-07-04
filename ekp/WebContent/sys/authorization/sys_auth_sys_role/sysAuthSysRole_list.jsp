<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>	
<%@ include file="/resource/jsp/list_top.jsp"%>
<%
   if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<td>
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdName"/>
			</td>
			<td>
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdType"/>
			</td>
			<td>
				<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription"/>
			</td>
		</tr>
		<logic:iterate id="sysAuthRole" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/authorization/sys_auth_sys_role/sysAuthSysRole.do" />?method=view&fdId=<bean:write name="sysAuthRole" property="fdId"/>">
				<td width="200px" style="text-align: left;">
					<kmss:message key="${sysAuthRole.fdName}" />
				</td>
				<td width="150px">
					<xform:select property="fdType" value="${sysAuthRole.fdType}" showStatus="view">
						<xform:enumsDataSource enumsType="sys_authorization_fd_type" />
					</xform:select>
				</td>
				<td style="text-align: left;">
					<kmss:message key="${sysAuthRole.fdDescription}" />
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
<%@ include file="/resource/jsp/list_down.jsp"%>