<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsKmapsCategoryForm, 'deleteall');">
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
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>  
				<sunbor:column property="kmsKmapsCategory.fdName">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.fdName"/>
				</sunbor:column> 
				<sunbor:column property="kmsKmapsCategory.docCreator.fdId">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docCreatorId"/> 
				</sunbor:column>
				<sunbor:column property="kmsKmapsCategory.docCreateTime">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKmapsCategory.docAlteror.fdId">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docAlterorId"/> 
				</sunbor:column> 
				<sunbor:column property="kmsKmapsCategory.docAlterTime">
					<bean:message  bundle="kms-kmaps" key="kmsKmapsCategory.docAlterTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKmapsCategory" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/kmaps/kms_kmaps_category/kmsKmapsCategory.do" />?method=view&fdId=${kmsKmapsCategory.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsKmapsCategory.fdId}">
				</td>
				<td>${vstatus.index+1}</td> 
				<td>
					<c:out value="${kmsKmapsCategory.fdName}" />
				</td> 
				<td>
					<c:out value="${kmsKmapsCategory.docCreator.fdName}" />
				</td> 
				<td> 
					<kmss:showDate value="${kmsKmapsCategory.docCreateTime}" type="datetime"/>
				</td>
				<td>
					<c:out value="${kmsKmapsCategory.docAlteror.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${kmsKmapsCategory.docAlterTime}" type="datetime"/>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
