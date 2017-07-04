<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/material/sys_material_main/sysMaterialMain.do?method=deleteall">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysMaterialMainForm, 'deleteall');">
			</kmss:auth>
</div>
 
	
<html:form action="/sys/material/sys_material_main/sysMaterialMain.do">
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
				<sunbor:column property="sysMaterialMain.docCreateTime">
					<bean:message bundle="sys-material" key="sysMaterialMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysMaterialMain.fdAttId">
					<bean:message bundle="sys-material" key="sysMaterialMain.fdAttId"/>
				</sunbor:column>
				<sunbor:column property="sysMaterialMain.fdModelTitle">
					<bean:message bundle="sys-material" key="sysMaterialMain.fdModelTitle"/>
				</sunbor:column>
				<sunbor:column property="sysMaterialMain.fdModelName">
					<bean:message bundle="sys-material" key="sysMaterialMain.fdModelName"/>
				</sunbor:column>
				<sunbor:column property="sysMaterialMain.fdType">
					<bean:message bundle="sys-material" key="sysMaterialMain.fdType"/>
				</sunbor:column>
				<sunbor:column property="sysMaterialMain.docCreator.fdName">
					<bean:message bundle="sys-material" key="sysMaterialMain.docCreator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysMaterialMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/material/sys_material_main/sysMaterialMain.do" />?method=view&fdId=${sysMaterialMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysMaterialMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<kmss:showDate value="${sysMaterialMain.docCreateTime}" />
				</td>
				<td>
					<c:out value="${sysMaterialMain.fdAttId}" />
				</td>
				<td>
					<c:out value="${sysMaterialMain.fdModelTitle}" />
				</td>
				<td>
					<c:out value="${sysMaterialMain.fdModelName}" />
				</td>
				<td>
					<c:out value="${sysMaterialMain.fdType}" />
				</td>
				<td>
					<c:out value="${sysMaterialMain.docCreator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>