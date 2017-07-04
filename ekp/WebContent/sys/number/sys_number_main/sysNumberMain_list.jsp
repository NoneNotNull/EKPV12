<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/number/sys_number_main/sysNumberMain.do">
	<div id="optBarDiv">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/number/sys_number_main/sysNumberMain.do" />?method=add&isSysnumberAdmin=${param.isSysnumberAdmin}&modelName=${modelName}&isCustom=2');">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysNumberMainForm, 'deleteall');">
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
				<sunbor:column property="sysNumberMain.fdName">
					<bean:message bundle="sys-number" key="sysNumberMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysNumberMain.docCreator.fdName">
					<bean:message bundle="sys-number" key="sysNumberMain.docCreator"/>
				</sunbor:column>
				<sunbor:column property="sysNumberMain.fdDefaultFlag">
					<bean:message bundle="sys-number" key="sysNumberMain.fdDefaultFlag"/>
				</sunbor:column>
				<sunbor:column property="sysNumberMain.docCreateTime">
					<bean:message bundle="sys-number" key="sysNumberMain.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysNumberMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/number/sys_number_main/sysNumberMain.do" />?method=view&isSysnumberAdmin=${param.isSysnumberAdmin}&fdId=${sysNumberMain.fdId}&modelName=${param.modelName}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysNumberMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysNumberMain.fdName}" />
				</td>
				<td>
					<c:out value="${sysNumberMain.docCreator.fdName}" />
				</td>
				<td>
					<c:if test="${sysNumberMain.fdDefaultFlag=='0' }">
						<bean:message key="message.yes"/>
					</c:if>
					<c:if test="${sysNumberMain.fdDefaultFlag=='1' }">
						<bean:message key="message.no"/>
					</c:if>
				</td>
				<td>
					<kmss:showDate value="${sysNumberMain.docCreateTime}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>