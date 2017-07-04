<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script language="JavaScript">

function op(type) {
	if(!List_CheckSelect()){
		return;
	}

	Com_Submit(document.sysWebserviceMainForm, type);
}
</script>
<html:form action="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=startall">
			<input type="button" value="<bean:message key="button.startservice" bundle="sys-webservice2"/>"
				onclick="op('startall');">
		</kmss:auth>	
		<kmss:auth requestURL="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=stopall">
			<input type="button" value="<bean:message key="button.stopservice" bundle="sys-webservice2"/>"
				onclick="op('stopall');">
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
				<sunbor:column property="sysWebserviceMain.fdName">
					<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceMain.fdServiceBean">
					<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceBean"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceMain.fdServiceStatus">
					<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceStatus"/>
				</sunbor:column>
				<sunbor:column property="sysWebserviceMain.fdStartupType">
					<bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdStartupType"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysWebserviceMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do" />?method=view&fdId=${sysWebserviceMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysWebserviceMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysWebserviceMain.fdName}" />
				</td>
				<td>
					<c:out value="${sysWebserviceMain.fdServiceBean}" />
				</td>
				<td>
			        <c:if test="${sysWebserviceMain.fdServiceStatus == 1}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceStatus.start"/>
                    </c:if> 
			        <c:if test="${sysWebserviceMain.fdServiceStatus == 0}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdServiceStatus.stop"/>
                    </c:if> 					
				</td>
				<td>
             		<c:if test="${sysWebserviceMain.fdStartupType == '0'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdStartupType.auto"/>
                    </c:if> 
			        <c:if test="${sysWebserviceMain.fdStartupType == '1'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdStartupType.manual"/>
                    </c:if> 					
			        <c:if test="${sysWebserviceMain.fdStartupType == '2'}"> 
                        <bean:message bundle="sys-webservice2" key="sysWebserviceMain.fdStartupType.disable"/>
                    </c:if> 					
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>