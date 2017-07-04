<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
function List_ConfirmSaveValidateTags(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message key="sysTagTags.confirmSaveValidateTags" bundle="sys-tag"/>");
}
function List_ConfirmSaveInvalidateTags(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message key="sysTagTags.confirmSaveInvalidateTag" bundle="sys-tag"/>");
}
function List_ConfirmDel(checkName){
	return List_CheckSelect(checkName) && confirm("<bean:message key="sysTagTags.deleteAll" bundle="sys-tag"/>");
}
</script>
<c:if test="${param.fdStatus == '1' || param.fdCategoryId != null}">
	<c:import
		url="/sys/tag/sys_tag_tags/sysTagTags_move_button.jsp?fdCategoryId=${param.fdCategoryId}"
		charEncoding="UTF-8">
	</c:import>
	<c:import
		url="/sys/tag/sys_tag_tags/sysTagTags_merger_button.jsp?fdCategoryId=${param.fdCategoryId}"
		charEncoding="UTF-8">
		<c:param
			name="type"
			value="main" />
	</c:import>
</c:if>
<c:if test="${param.fdStatus == '0' || (param.fdStatus == null && param.fdCategoryId == null)}">
	<c:import
		url="/sys/tag/sys_tag_tags/sysTagTags_validate_button.jsp?fdCategoryId=${param.fdCategoryId}"
		charEncoding="UTF-8">
	</c:import>
</c:if>
<html:form action="/sys/tag/sys_tag_tags/sysTagTags.do">
	<div id="optBarDiv">
		<c:if test="${param.fdStatus == '1' || param.fdCategoryId != null}">
			<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=saveInvalidateTags&fdCategoryId=${param.fdCategoryId}" requestMethod="GET">
				<input type="button" value="<bean:message key="sysTagTags.button.saveInvalidateTags" bundle="sys-tag"/>"
					onclick="if(!List_ConfirmSaveInvalidateTags())return;Com_Submit(document.sysTagTagsForm, 'saveInvalidateTags');">
			</kmss:auth>
		</c:if>
		<c:if test="${param.fdStatus == null && param.fdCategoryId == null}">
			<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=saveInvalidateTags&fdCategoryId=${param.fdCategoryId}" requestMethod="GET">
				<input type="button" value="<bean:message key="sysTagTags.button.saveInvalidateTags" bundle="sys-tag"/>"
					onclick="if(!List_ConfirmSaveInvalidateTags())return;Com_Submit(document.sysTagTagsForm, 'saveInvalidateTags');">
			</kmss:auth>
		</c:if>
		<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=add&categoryId=${param.fdCategoryId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
					onclick="Com_OpenWindow('<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do" />?method=add&categoryId=${param.fdCategoryId}&fdIsPrivate=${param.fdIsPrivate}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=deleteall&fdCategoryId=${param.fdCategoryId}" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTagTagsForm, 'deleteall');">
		</kmss:auth>
		<c:if test="${param.fdIsPrivate == '0'}">
			<kmss:auth requestURL="/sys/tag/sys_tag_tags/sysTagTags.do?method=updateFromPriToPubInList" requestMethod="GET">
				<input type="button" value="<bean:message  bundle="sys-tag" key="sysTagTags.button.updateFromPriToPub"/>"
					onclick="Com_Submit(document.sysTagTagsForm, 'updateFromPriToPubInList');">
			</kmss:auth>
		</c:if>
		<input  type="button" value="<bean:message key="button.search"/>" onclick="Com_OpenWindow('<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.sys.tag.model.SysTagTags"/>')">		
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
				<sunbor:column property="sysTagTags.fdName">
					<bean:message  bundle="sys-tag" key="sysTagTags.fdName"/>
				</sunbor:column>
				<td>
					<bean:message  bundle="sys-tag" key="sysTagTags.fdAlias"/>
				</td>
				<sunbor:column property="sysTagTags.fdCategory.fdName">
					<bean:message  bundle="sys-tag" key="sysTagTags.fdCategoryId"/>
				</sunbor:column>
				<sunbor:column property="sysTagTags.fdStatus">
					<bean:message  bundle="sys-tag" key="sysTagTags.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="sysTagTags.docCreator.fdName">
					<bean:message  bundle="sys-tag" key="sysTagTags.docCreatorId"/>
				</sunbor:column>
				<sunbor:column property="sysTagTags.docCreateTime">
					<bean:message  bundle="sys-tag" key="sysTagTags.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="sysTagTags.fdCountQuoteTimes">
					<bean:message  bundle="sys-tag" key="sysTagTags.fdQuoteTimes"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysTagTags" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do" />?method=view&fdId=${sysTagTags.fdId}&fdCategoryId=${param.fdCategoryId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysTagTags.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysTagTags.fdName}" />
				</td>
				<td kmss_wordlength="25" >
					<kmss:joinListProperty value="${sysTagTags.hbmAlias}" properties="fdName" split=";" />
				</td>
				<td>
					<c:out value="${sysTagTags.fdCategory.fdName}" />
				</td>
				<td>
					<sunbor:enumsShow value="${sysTagTags.fdStatus}" enumsType="sysTagTags_fdStatus" bundle="sys-tag"/>
				</td>
				<td>
					<c:out value="${sysTagTags.docCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${sysTagTags.docCreateTime}" type="datetime"/>
				</td>
				<td>
					<c:out value="${sysTagTags.fdCountQuoteTimes}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>