<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do">
	<div id="optBarDiv">
		<c:if test="${'false' != param.isAllDoc }">
			<input
			type="button"
			value="<bean:message key="right.button.changeRightBatch" bundle="sys-right"/>"
			onclick="changeRightCheckSelect();">
			
		</c:if>
		
		<c:if test="${'false' == param.isAllDoc }">
			<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=recoverall&categoryId=${param.categoryId}">
					<input type="button" value="${param.fala} ${lfn:message('kms-knowledge:kmsKnowledge.button.recover') }"
						onclick="recoverAll()">
			</kmss:auth>
		</c:if>
		<kmss:auth requestURL="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=deleteall&categoryId=${param.categoryId}">
				<input type="button" value="${lfn:message('kms-knowledge:kmsKnowledge.button.delete') }"
					onclick="deleteAll();">
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
				<sunbor:column property="kmsKnowledgeBaseDoc.docSubject">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeBaseDoc.docAuthor">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docAuthor"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeBaseDoc.docCreateTime">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docCreateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsKnowledgeBaseDoc.docCategory.fdName">
					<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.docCategory"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsKnowledgeBaseDoc" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do" />?method=view&fdId=${kmsKnowledgeBaseDoc.fdId}&fdKnowledgeType=${kmsKnowledgeBaseDoc.fdKnowledgeType}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsKnowledgeBaseDoc.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${kmsKnowledgeBaseDoc.docSubject}" />
				</td>
				<td>
					<c:out value="${kmsKnowledgeBaseDoc.docAuthor.fdName }"/>
				</td>
				<td>
					<kmss:showDate value="${kmsKnowledgeBaseDoc.docCreateTime}" />
				</td>
				<td>
					<c:out value="${kmsKnowledgeBaseDoc.docCategory.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
	<input type="hidden" name="reason">
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
<script>
	Com_IncludeFile('jquery.js');
</script>
<script>
		function __submitrecover(){
			Com_Submit(document.kmsKnowledgeBaseDocForm, 'recoverall');
		}
		function recoverAll() {
			if(!List_CheckSelect())
				return;
			var left = $(window).width()/2 - 100,
			     top = $(window).height()/2,
			    url = "<c:url value='/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc_recover.jsp' />",
			    style = 'left='+left+',top='+top+',height=300px, width=600px, toolbar=0, menubar=0, scrollbars=0, resizable=1, status=1, location=no';
				Com_OpenWindow(url, '_blank' ,style);
		}
		
		function deleteAll() {
			if(!(List_CheckSelect() && confirm("${lfn:message('kms-knowledge:kmsKnowledge.confirm.deleteall')}")))
				return;
			Com_Submit(document.kmsKnowledgeBaseDocForm, 'deleteall');
		}
</script>

<script type="text/javascript">
<!-- 
function changeRightCheckSelect() {
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
			var url="<c:url value="/sys/right/rightDocChange.do"/>";
			url+="?method=docRightEdit&modelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc&categoryId=${param.categoryId}";
			url+="&authReaderNoteFlag=${param.authReaderNoteFlag}";
			//url+="&fdIds="+values;
			Com_OpenWindow(url,'_blank','height=650, width=800, toolbar=0, menubar=0, scrollbars=1, resizable=1, status=1');
			return;
		}
	}
	alert("<bean:message bundle="sys-right" key="right.change.batch.selectdocfirst" />");
	return ;
}
// -->
</script>