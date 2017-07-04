<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
Com_IncludeFile("dialog.js");

function checkCategoryParameter(){ 
	var url = '<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdCategoryIds=${param.fdCategoryIds}'; 
	var categoryId = Com_GetUrlParameter(url, "fdCategoryIds");
	 if(categoryId==null || categoryId==""){
		 Dialog_Tree(false, 'fdKmsAskCategoryId', null, null, 'kmsAskCategoryTreeService&selectId=!{value}&type=all', 
		 	'<bean:message  bundle="kms-ask" key="kmsAskCategory.select"/>',
		 	 null,afterCategorySelect, null, null,true);
	 }
	 else{
		Com_OpenWindow('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdKmsAskCategoryId=${param.fdCategoryIds}');
	 } 
}

function afterCategorySelect(rtnVal){
	if(rtnVal!=null){
		url = Com_SetUrlParameter('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add', "fdKmsAskCategoryId", rtnVal.GetHashMapArray()[0].id);
		Com_OpenWindow(url);
	} 
}
</script>
<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do">
	<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.wiki.model.KmsWikiMain" />
	<c:param
		name="docFkName"
		value="docCategory" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.kms.ask.model.KmsAskCategory" />
</c:import>
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=add&fdKmsAskCategoryId=${param.categoryId}">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=add&fdCategoryId=${param.categoryId}');">
		</kmss:auth>
		<kmss:auth requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsAskTopicForm, 'deleteall');">
		</kmss:auth>
	</div>
	<html:hidden property="fdKmsAskCategoryId" />
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
				<sunbor:column property="kmsAskTopic.docSubject">
					<bean:message bundle="kms-ask" key="kmsAskTopic.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsAskTopic.fdCategory.fdId">
					<bean:message bundle="kms-ask" key="kmsAskTopic.fdCategory.fdId" />
				</sunbor:column> 
				<sunbor:column property="kmsAskTopic.fdScore">
					<bean:message bundle="kms-ask" key="kmsAskTopic.fdScore"/>
				</sunbor:column>
				<sunbor:column property="kmsAskTopic.fdPostTime">
					<bean:message bundle="kms-ask" key="kmsAskTopic.fdPostTime"/>
				</sunbor:column>
				<sunbor:column property="kmsAskTopic.fdReplyCount">
					<bean:message bundle="kms-ask" key="kmsAskTopic.fdReplyCount"/>
				</sunbor:column>
				<sunbor:column property="kmsAskTopic.fdStatus">
					<bean:message bundle="kms-ask" key="kmsAskTopic.fdStatus"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsAskTopic" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do" />?method=view&fdId=${kmsAskTopic.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsAskTopic.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsAskTopic.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsAskTopic.fdKmsAskCategory.fdName}" />
				</td>
				<td>
					<c:out value="${kmsAskTopic.fdScore}" />
				</td>
				<td>
					<kmss:showDate value="${kmsAskTopic.fdPostTime}" />
				</td>
				<td>
					<c:out value="${kmsAskTopic.fdReplyCount}" />
				</td>
				<td>
					<c:if test="${kmsAskTopic.fdStatus == 0}">
						<img src="${KMSS_Parameter_StylePath}answer/icn_time.gif" border="0">
					</c:if> 
					<c:if test="${kmsAskTopic.fdStatus != 0}">
						<img src="${KMSS_Parameter_StylePath}answer/icn_ok.gif" border="0">
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>