<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
function  checkSelect(){
	var values="";
	var selected;
	var select = document.getElementsByName("List_Selected");
	for(var i=0;i<select.length;i++) {
		if(select[i].checked){
			values+=select[i].value;
			values+=",";
			selected=true;
		}
	}
	if(selected) {
		values = values.substring(0,values.length-1);
		if(selected) {
			Com_OpenWindow('<c:url value="/km/forum/km_forum_cate/kmForumCategory_changDirectory.jsp" />?values='+values);
			return;
		}
	}
	alert('<bean:message bundle="km-forum" key="kmForumCategory.chooseCategory" />');
	return false;
}
</script>
<html:form action="/km/forum/km_forum_cate/kmForumCategory.do">
	<div id="optBarDiv">
	<c:if test="${param.type=='directory'}">
		<kmss:auth
			requestURL="/km/forum/km_forum_cate/kmForumCategory.do?method=add"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum_cate/kmForumCategory.do" />?method=addDirectory');">
		</kmss:auth> 
	</c:if>
	<c:if test="${param.type=='forum'}">
		<kmss:auth
			requestURL="/km/forum/km_forum_cate/kmForumCategory.do?method=add"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/forum/km_forum_cate/kmForumCategory.do" />?method=add');">
		</kmss:auth>
		<input type="button"
		value='<bean:message bundle="km-forum" key="kmForumCategory.button.changeDirectory" />'
		onclick="checkSelect();">
	</c:if> 
	<kmss:auth
		requestURL="/km/forum/km_forum_cate/kmForumCategory.do?method=deleteall"
		requestMethod="GET">
		<input type="button" value="<bean:message  key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmForumCategoryForm, 'deleteall');">
			<c:set value="true" var="hasDeleteRight"/>
			
	</kmss:auth></div>
	<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%
	} else {
	%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<!-- 序号 -->
				<td width="40pt"><bean:message key="page.serial" /></td>
				<!-- 版块名称 -->
				<sunbor:column property="kmForumCategory.fdName">
					<bean:message bundle="km-forum" key="kmForumCategory.fdName" />
				</sunbor:column>
				<c:if test="${param.type!='directory'}">
					<!-- 上级板块 -->
					<sunbor:column property="kmForumCategory.hbmParent.fdId">
						<bean:message bundle="km-forum" key="kmForumCategory.fdParentId" />
					</sunbor:column>
					<!-- 版主 -->	
					<td><bean:message bundle="km-forum"
						key="kmForumCategory.forumManagers" /></td>
				</c:if>
				<!-- 板块创建人 -->
				<sunbor:column property="kmForumCategory.docCreator.fdName">
					<bean:message bundle="km-forum" key="kmForumCategory.docCreatorId" />
				</sunbor:column>
				<!-- 创建时间 -->
				<sunbor:column property="kmForumCategory.docCreateTime">
					<bean:message bundle="km-forum" key="kmForumCategory.docCreateTime" />
				</sunbor:column>

			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmForumCategory"
			varStatus="vstatus">
			<c:if test="${empty kmForumCategory.fdParent.fdId }">
			<tr	kmss_href="<c:url value="/km/forum/km_forum_cate/kmForumCategory.do" />?method=viewDirectory&fdId=${kmForumCategory.fdId}">
				</c:if>
				<c:if test="${!empty kmForumCategory.fdParent.fdId }">
				<tr	kmss_href="<c:url value="/km/forum/km_forum_cate/kmForumCategory.do" />?method=view&fdId=${kmForumCategory.fdId}">
				</c:if>
				<td><input type="checkbox" name="List_Selected"
					value="${kmForumCategory.fdId}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${kmForumCategory.fdName}" /></td>
				<c:if test="${param.type!='directory'}">
					<td><c:out value="${kmForumCategory.fdParent.fdName}" /></td>				
					<td><c:forEach items="${kmForumCategory.authAllEditors}"
						var="forumManager" varStatus="indx">
						<c:if test="${indx.index>0}">
								;
							</c:if>
						<c:out value="${forumManager.fdName}" />
					</c:forEach></td>
				</c:if>
				<td><c:out value="${kmForumCategory.docCreator.fdName}"/></td>
				<td><kmss:showDate value="${kmForumCategory.docCreateTime}"
					type="datetime" /></td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
