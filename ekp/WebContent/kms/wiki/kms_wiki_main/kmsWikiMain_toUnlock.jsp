<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script language="JavaScript">
	  Com_IncludeFile("jquery.js"); 
</script>
<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=allToUnlock">
			<input type="button" value="<bean:message bundle="kms-wiki" key="kmsWikiMain.unlock"/>"
				onclick="unlockWiki();">
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
				<sunbor:column property="kmsWikiMain.docSubject">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.fdVersion">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.fdVersion"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.docCreateTime">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.docAlterTime">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docAlterTime"/>
				</sunbor:column>
				<sunbor:column property="kmsWikiMain.docAlteror.fdName">
					<bean:message bundle="kms-wiki" key="kmsWikiMain.docAlteror"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsWikiMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=view&fdId=${kmsWikiMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsWikiMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsWikiMain.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsWikiMain.fdVersion}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiMain.docCreateTime}" />
				</td>
				<td>
					<kmss:showDate value="${kmsWikiMain.docAlterTime}" />
				</td>
				<td>
					<c:if test="${not empty kmsWikiMain.docAlterTime}"><c:out value="${kmsWikiMain.docCreator.fdName}" /></c:if>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
<script language="JavaScript">
	function unlockWiki(){
		var checkedList = $('input[name="List_Selected"]:checked');
		var rowsize = checkedList.length;
		if (!rowsize) {
			alert("<bean:message key="page.noSelect"/>");
			return;
		}
		var id = [];
		$('input[name="List_Selected"]:checked').each(
				function(i) {
					id[i] = 'List_Selected=' + $(this).val();
				});
		var ids = id.join('&');
		// 显示报错信息 2012-5-17
		$.ajax({
			url : '<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do" />?method=updateUnlock',
			cache : false,
			data : ids,
			type : 'post',
			success : function(data) {
				if (data && data['error']) {
					art.artDialog.alert(data['error']);
				} else {
					window.location.reload();// 刷新页面
				}
			},
			error : function(error) {
				// 完善提示信息 2012-12-25
				window.location.reload();// 刷新页面
			}
		})
	}
</script>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>