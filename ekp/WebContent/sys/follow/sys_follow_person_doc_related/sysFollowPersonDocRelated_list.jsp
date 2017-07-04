<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">		
		<list:data-column col="fdId"  escape="false">
			${item[0].fdId}
		</list:data-column>
		<list:data-column  col="docSubject" title="标题" escape="false">
			${item[0].docSubject}
		</list:data-column>
		<list:data-column col="from" escape="false" title="来自">
			${fromJson[item[2]]}
		</list:data-column>
		<list:data-column col="status" escape="false" title="状态">
			<c:if test='${item[1] == "1" }'>
				${lfn:message('sys-follow:sysFollowRelatedDoc.fdStatus.yes')}
			</c:if>
			<c:if test='${item[1] == "0" }'>
				${lfn:message('sys-follow:sysFollowRelatedDoc.fdStatus.no')}
			</c:if>
		</list:data-column>
		<list:data-column col="docCreateTime" escape="false" title="订阅时间">
			<kmss:showDate value="${item[0].docCreateTime }" type="date"></kmss:showDate>
		</list:data-column>
		
	</list:data-columns>
	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>


<%--
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysFollowPersonDocRelatedForm, 'deleteall');">
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
				<sunbor:column property="sysFollowPersonDocRelated.followDoc.docSubject">
					<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.followDoc"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonDocRelated.followConfig.fdSubject">
					<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.followConfig"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonDocRelated.isread">
					<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.isread"/>
				</sunbor:column>
				<sunbor:column property="sysFollowPersonDocRelated.readTime">
					<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.readTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysFollowPersonDocRelated" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/follow/sys_follow_doc/sysFollowDoc.do" />?method=view&fdId=${sysFollowPersonDocRelated.followDoc.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysFollowPersonDocRelated.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysFollowPersonDocRelated.followDoc.docSubject}" />
				</td>
				<td>
					<c:out value="${sysFollowPersonDocRelated.followConfig.fdSubject}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysFollowPersonDocRelated.isRead}" enumsType="sys_follow_related_doc_status" />
				</td>
				<td>
					<kmss:showDate value="${sysFollowPersonDocRelated.readTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%> --%>