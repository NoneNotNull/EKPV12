<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
	Com_IncludeFile("dialog.js|jquery.js");
</script>
<html:form action="/km/imeeting/km_imeeting_res/kmImeetingRes.do">
	<div id="optBarDiv">
		<%-- 存在分类ID --%>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=add&categoryId=${param.docCategoryId}">
			<c:if test="${not empty param.docCategoryId}">
				<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do" />?method=add&categoryId=${param.docCategoryId}');">
			</c:if>
		</kmss:auth>
		<%-- 不存在分类ID --%>
		<c:if test="${empty param.docCategoryId}">
			<kmss:auth requestURL="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=add">
				<input type="button" value="<bean:message key="button.add"/>"
						onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.km.imeeting.model.KmImeetingResCategory',
						'<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do" />?method=add&categoryId=!{id}&categoryName=!{name}');">
			</kmss:auth>
		</c:if>
		<%-- 删除 --%>
		<kmss:auth requestURL="/km/imeeting/km_imeeting_res/kmImeetingRes.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmImeetingResForm, 'deleteall');">
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
				<sunbor:column property="kmImeetingRes.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingRes.fdName"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingRes.docCategory.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingRes.docCategory"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingRes.fdAddressFloor">
					<bean:message bundle="km-imeeting" key="kmImeetingRes.fdAddressFloor"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingRes.fdSeats">
					<bean:message bundle="km-imeeting" key="kmImeetingRes.fdSeats"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingRes.docKeeper.fdName">
					<bean:message bundle="km-imeeting" key="kmImeetingRes.docKeeper"/>
				</sunbor:column>
				<sunbor:column property="kmImeetingRes.fdIsAvailable">
					<bean:message bundle="km-imeeting" key="kmImeetingRes.fdIsAvailable"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmImeetingRes" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/km/imeeting/km_imeeting_res/kmImeetingRes.do" />?method=view&fdId=${kmImeetingRes.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmImeetingRes.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmImeetingRes.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingRes.docCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmImeetingRes.fdAddressFloor}" />
				</td>
				<td>
					<c:out value="${kmImeetingRes.fdSeats}" />
				</td>
				<td>
					<c:out value="${kmImeetingRes.docKeeper.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${kmImeetingRes.fdIsAvailable}" enumsType="common_yesno" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>