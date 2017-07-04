<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/property/sys_property_filter/sysPropertyFilter.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/property/sys_property_filter/sysPropertyFilter.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_filter/sysPropertyFilter.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_filter/sysPropertyFilter.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPropertyFilterForm, 'deleteall');">
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
				<sunbor:column property="sysPropertyFilter.fdName">
					<bean:message bundle="sys-property" key="sysPropertyFilter.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilter.fdOrder">
					<bean:message bundle="sys-property" key="sysPropertyFilter.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilter.fdTemplateId">
					<bean:message bundle="sys-property" key="sysPropertyFilter.fdTemplateId"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilter.fdPropertyName">
					<bean:message bundle="sys-property" key="sysPropertyFilter.fdPropertyName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilter.fdReference.fdId">
					<bean:message bundle="sys-property" key="sysPropertyFilter.fdReference"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyFilter.fdTemplate.fdId">
					<bean:message bundle="sys-property" key="sysPropertyFilter.fdTemplate"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPropertyFilter" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/property/sys_property_filter/sysPropertyFilter.do" />?method=view&fdId=${sysPropertyFilter.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPropertyFilter.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPropertyFilter.fdName}" />
				</td>
				<td>
					<c:out value="${sysPropertyFilter.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysPropertyFilter.fdTemplateId}" />
				</td>
				<td>
					<c:out value="${sysPropertyFilter.fdPropertyName}" />
				</td>
				<td>
					<c:out value="${sysPropertyFilter.fdReference.fdId}" />
				</td>
				<td>
					<c:out value="${sysPropertyFilter.fdTemplate.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>