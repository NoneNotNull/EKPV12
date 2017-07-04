<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFtsearchMultisystemForm, 'deleteall');">
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
				<sunbor:column property="sysFtsearchMultisystem.fdUrl">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchMultisystem.fdSystemName">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSystemName"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchMultisystem.fdSystemModel">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSystemModel"/>
				</sunbor:column>
					<sunbor:column property="sysFtsearchMultisystem.fdModelUrl">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdModelUrl"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchMultisystem.fdSystemIndexdb">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSystemIndexdb"/>
				</sunbor:column>
				<sunbor:column property="sysFtsearchMultisystem.fdSelectFlag">
					<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchMultisystem.fdSelectFlag"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFtsearchMultisystem" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/ftsearch/expand/sys_ftsearch_multisystem/sysFtsearchMultisystem.do" />?method=view&fdId=${sysFtsearchMultisystem.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFtsearchMultisystem.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFtsearchMultisystem.fdUrl}" />
				</td>
				<td>
					<c:out value="${sysFtsearchMultisystem.fdSystemName}" />
				</td>
				<td>
					<c:out value="${sysFtsearchMultisystem.fdSystemModel}" />
				</td>
				<td>
					<c:out value="${sysFtsearchMultisystem.fdModelUrl}" />
				</td>
				<td>
					<c:out value="${sysFtsearchMultisystem.fdSystemIndexdb}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysFtsearchMultisystem.fdSelectFlag}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>