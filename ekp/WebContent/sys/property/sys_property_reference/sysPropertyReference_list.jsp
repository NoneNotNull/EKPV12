<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/property/sys_property_reference/sysPropertyReference.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/property/sys_property_reference/sysPropertyReference.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_reference/sysPropertyReference.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/property/sys_property_reference/sysPropertyReference.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPropertyReferenceForm, 'deleteall');">
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
				<sunbor:column property="sysPropertyReference.fdDisplayName">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdDisplayName"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyReference.fdIsNotNull">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdIsNotNull"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyReference.fdDisplayInLine">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdDisplayInLine"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyReference.fdOrder">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdOrder"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyReference.fdTemplateId">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdTemplateId"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyReference.fdDefine.fdName">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdDefine"/>
				</sunbor:column>
				<sunbor:column property="sysPropertyReference.fdTemplate.fdId">
					<bean:message bundle="sys-property" key="sysPropertyReference.fdTemplate"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPropertyReference" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/property/sys_property_reference/sysPropertyReference.do" />?method=view&fdId=${sysPropertyReference.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPropertyReference.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPropertyReference.fdDisplayName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysPropertyReference.fdIsNotNull}" enumsType="common_yesno" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysPropertyReference.fdDisplayInLine}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${sysPropertyReference.fdOrder}" />
				</td>
				<td>
					<c:out value="${sysPropertyReference.fdTemplateId}" />
				</td>
				<td>
					<c:out value="${sysPropertyReference.fdDefine.fdName}" />
				</td>
				<td>
					<c:out value="${sysPropertyReference.fdTemplate.fdId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>