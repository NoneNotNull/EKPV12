<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<html:form action="/sys/webservice2/sys_webservice_log/sysWebserviceLog.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/webservice2/sys_webservice_log/sysWebserviceLog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysWebserviceLogForm, 'deleteall');">
		</kmss:auth>			
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysWebserviceLog.fdServiceName">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdServiceName"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceLog.fdServiceBean">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdServiceBean"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceLog.fdUserName">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdUserName"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceLog.fdClientIp">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdClientIp"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceLog.fdStartTime">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdStartTime"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceLog.fdEndTime">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdEndTime"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceLog.fdExecResult">
					<bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysWebserviceLog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/webservice2/sys_webservice_log/sysWebserviceLog.do" />?method=view&fdId=${sysWebserviceLog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysWebserviceLog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysWebserviceLog.fdServiceName}" />
				</td>
				<td>
					<c:out value="${sysWebserviceLog.fdServiceBean}" />
				</td>
				<td>
					<c:out value="${sysWebserviceLog.fdUserName}" />
				</td>
				<td>
					<c:out value="${sysWebserviceLog.fdClientIp}" />
				</td>
				<td>
					<kmss:showDate value="${sysWebserviceLog.fdStartTime}" />
				</td>
				<td>
					<kmss:showDate value="${sysWebserviceLog.fdEndTime}" />
				</td>
				<td>				
             		<c:if test="${sysWebserviceLog.fdExecResult == '0'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult.success"/>
                    </c:if> 
			        <c:if test="${sysWebserviceLog.fdExecResult == '1'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult.occur.exception"/>
                    </c:if> 					
			        <c:if test="${sysWebserviceLog.fdExecResult == '2'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult.unauthorized.user"/>
                    </c:if> 	
			        <c:if test="${sysWebserviceLog.fdExecResult == '3'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult.illegal.ip"/>
                    </c:if>   
			        <c:if test="${sysWebserviceLog.fdExecResult == '4'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceLog.fdExecResult.locked.user"/>
                    </c:if>                                        						
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>