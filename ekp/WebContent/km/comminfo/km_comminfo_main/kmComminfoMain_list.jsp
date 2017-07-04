<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>


<%-- 收藏机制 --%>
	<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
		charEncoding="UTF-8">
		<c:param name="fdTitleProName" value="docSubject" />
		<c:param name="fdModelName" value="com.landray.kmss.km.comminfo.model.KmComminfoMain" />
	</c:import>
<%-- 收藏机制 --%>

<%-- 全文检索 --%>
	<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
		<c:param name="fdModelName" value="com.landray.kmss.km.comminfo.model.KmComminfoMain" />
	</c:import>
<%-- 全文检索 --%>

<html:form action="/km/comminfo/km_comminfo_main/kmComminfoMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/comminfo/km_comminfo_main/kmComminfoMain.do" />?method=add&categoryId=${param.docCategoryId }');">
		</kmss:auth>
		<kmss:auth requestURL="/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmComminfoMainForm, 'deleteall');">
		</kmss:auth>
		<input  type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">
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
    			<sunbor:column property="kmComminfoMain.docSubject">
					<bean:message  bundle="km-comminfo" key="kmComminfoMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmComminfoMain.docCategory.fdName">
					<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCategoryId"/>
				</sunbor:column>
				<sunbor:column property="kmComminfoMain.docCreator.fdName">
					<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="kmComminfoMain.docCreateTime">
					<bean:message  bundle="km-comminfo" key="kmComminfoMain.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmComminfoMain" varStatus="vstatus">
			<tr kmss_href="<c:url value="/km/comminfo/km_comminfo_main/kmComminfoMain.do" />?method=view&fdId=${kmComminfoMain.fdId}">
				<td><input type="checkbox" name="List_Selected" value="${kmComminfoMain.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td style="text-align:left;"><c:out value="${kmComminfoMain.docSubject}" /></td>
				<td><c:out value="${kmComminfoMain.docCategory.fdName}" /></td>
				<td><c:out value="${kmComminfoMain.docCreator.fdName}" /></td>
				<td><kmss:showDate value="${kmComminfoMain.docCreateTime}" type="datetime" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>