<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do" />?method=add&categoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibSysSoapMainForm, 'deleteall');">
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
				<sunbor:column property="tibSysSoapMain.docSubject">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.docSubject"/>
				</sunbor:column>
				<%-- <sunbor:column property="tibSysSoapMain.docStatus">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docStatus"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapMain.docCreateTime">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapMain.docAlterTime">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docAlterTime"/>
				</sunbor:column> --%>
				<sunbor:column property="tibSysSoapMain.wsBindFunc">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsBindFunc"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapMain.wsEnable">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsEnable"/>
				</sunbor:column>
				<%-- <sunbor:column property="tibSysSoapMain.wsSoapVersion">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsSoapVersion"/>
				</sunbor:column> --%>
				
				<%-- <sunbor:column property="tibSysSoapMain.wsMarks">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsMarks"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapMain.wsBindFuncInfo">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsBindFuncInfo"/>
				</sunbor:column> --%>
				<sunbor:column property="tibSysSoapMain.tibSysSoapSetting.docSubject">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.wsServerSetting"/>
				</sunbor:column>
				<sunbor:column property="tibSysSoapMain.docCategory.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCategory"/>
				</sunbor:column>
				
				<%-- <sunbor:column property="tibSysSoapMain.docCreator.fdName">
					<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.docCreator"/>
				</sunbor:column> --%>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSysSoapMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain.do" />?method=view&fdId=${tibSysSoapMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibSysSoapMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibSysSoapMain.docSubject}" />
				</td>
				<%-- <td>
					<c:out value="${tibSysSoapMain.docStatus}" />
				</td>
				<td>
					<kmss:showDate value="${tibSysSoapMain.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${tibSysSoapMain.docAlterTime}" />
				</td> --%>
				<td>
					<c:out value="${tibSysSoapMain.wsBindFunc}" />
				</td>
				<td>
					<xform:select value="${tibSysSoapMain.wsEnable}" property="wsEnable" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:select>
				</td>
				<%-- <td>
					<c:out value="${tibSysSoapMain.wsSoapVersion}" />
				</td> --%>
				
				<%-- <td>
					<c:out value="${tibSysSoapMain.wsMarks}" />
				</td>
				<td>
					<c:out value="${tibSysSoapMain.wsBindFuncInfo}" />
				</td>--%>
				<td>
					<c:out value="${tibSysSoapMain.tibSysSoapSetting.docSubject}" />
				</td>
				<td> 
					<c:out value="${tibSysSoapMain.docCategory.fdName}" />
				</td>
				
				<%-- <td>
					<c:out value="${tibSysSoapMain.docCreator.fdName}" />
				</td> --%>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
