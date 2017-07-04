<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.UserUtil"%>	
<%@ page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ page import="com.landray.kmss.sys.authorization.util.SysAuthAreaHelper"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<% 
   String type = request.getParameter("type");
   boolean crFlag = !ISysAuthConstant.IS_AREA_ENABLED || SysAuthAreaHelper.canCreateRole() 
                 || !ISysAuthConstant.ROLE_AREA.equals(type);   
%>
<html:form action="/sys/authorization/sys_auth_role/sysAuthRole.do">
	<div id="optBarDiv">
	    <%if(crFlag) { %>
		<kmss:auth requestURL="/sys/authorization/sys_auth_role/sysAuthRole.do?method=add&type=${param.type}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/authorization/sys_auth_role/sysAuthRole.do" />?method=add&type=${param.type}&categoryId=${param.categoryId}');" />
		</kmss:auth>
		<% } %>		
		<kmss:auth requestURL="/sys/authorization/sys_auth_role/sysAuthRole.do?method=deleteall" requestMethod="POST">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return; Com_Submit(document.sysAuthRoleForm, 'deleteall');">
		</kmss:auth>
	</div>
<%
   if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<sunbor:column property="sysAuthRole.fdName">
					<bean:message bundle="sys-authorization" key="sysAuthRole.fdName"/>
				</sunbor:column>
<%-- 				
				<c:if test="${param.type=='1'}">
				<td>
					<bean:message bundle="sys-authorization" key="sysAuthRole.authArea"/>
				</td>
				</c:if>
 --%>				
				<sunbor:column property="sysAuthRole.sysAuthCategory">
					<bean:message bundle="sys-authorization" key="sysAuthRole.sysAuthCategory"/>
				</sunbor:column>
			    <c:if test="${param.type=='1'}">
				    <td>
					    <bean:message bundle="sys-authorization" key="sysAuthRole.isCommon"/>
				    </td>	
			    </c:if>					
				<sunbor:column property="sysAuthRole.fdCreator.fdName">
					<bean:message bundle="sys-authorization" key="sysAuthRole.fdCreator"/>
				</sunbor:column>			
				<td>
					<bean:message bundle="sys-authorization" key="sysAuthRole.fdDescription"/>
				</td>
				

			</sunbor:columnHead>
		</tr>
		<logic:iterate id="sysAuthRole" name="queryPage" property="list" indexId="index">
			<tr kmss_href="<c:url value="/sys/authorization/sys_auth_role/sysAuthRole.do" />?method=view&fdId=<bean:write name="sysAuthRole" property="fdId"/>&type=${param.type}">
				<td>
					<input type="checkbox" name="List_Selected" value="<bean:write name="sysAuthRole" property="fdId"/>">
				</td>
				<td>
					<bean:write name="sysAuthRole" property="fdName"/> 
				</td>
<%--				
				<c:if test="${param.type=='1'}">
				<td>
					<kmss:joinListProperty value="${sysAuthRole.authArea}" properties="fdName" />
				</td>
				</c:if>
--%>				
				<td>
					<c:out value="${sysAuthRole.sysAuthCategory.fdName}" />
				</td>
			    <c:if test="${param.type=='1'}">			    
			        <c:choose>
			        <c:when test="${sysAuthRole.fdType=='2'}">
				        <td>
				            <bean:message bundle="sys-authorization" key="sysAuthRole.common.yes"/>
				        </td>
				    </c:when>
			        <c:otherwise>
				        <td>
				            <bean:message bundle="sys-authorization" key="sysAuthRole.common.no"/>
				        </td>
			        </c:otherwise>
			        </c:choose> 				    
			    </c:if>					
				<td>
					<c:out value="${sysAuthRole.fdCreator.fdName}" />
				</td> 				
				<td>
					<bean:write name="sysAuthRole" property="fdDescription"/> 
				</td>
			</tr>
		</logic:iterate>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>