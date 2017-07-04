<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%--bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
	charEncoding="UTF-8">
	<c:param name="fdTitleProName" value="docSubject" />
	<c:param name="fdModelName"
		value="com.landray.kmss.km.review.model.KmReviewMain" />
</c:import>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName"
		value="com.landray.kmss.km.review.model.KmReviewMain" />
</c:import>
<c:import url="/sys/right/cchange_doc_right/cchange_doc_right_button.jsp" charEncoding="UTF-8">
	<c:param name="modelName" value="com.landray.kmss.km.review.model.KmReviewMain" /> 
	<c:param name="authReaderNoteFlag" value="2" /> 
</c:import>
<script language="JavaScript">
		Com_IncludeFile("dialog.js");
</script>
<script type="text/javascript">
	function checkSelect() {
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
					Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewChangeTemplate.jsp" />?values='+values+'&categoryId=${param.categoryId}');
					return;
				}
			}
			alert("<bean:message bundle="km-review" key="message.trans_doc_select" />");
			return false;
		}
	<c:if test="${param.method == 'result'}">
	function showExportDialog() {
		var exportDialogObj = {exportUrl: "${exportURL}", exportNum: "${queryPage.totalrows}"};
		Dialog_PopupWindow("<c:url value="/sys/search/search_result_export.jsp?fdModelName=${param.fdModelName}&searchId=${param.searchId}"/>", 460, 480, exportDialogObj);
	}
	</c:if>
</script>
<html:form action="/km/review/km_review_main/kmReviewMain.do">

	<div id="optBarDiv">
	<%--按规范，转移在新建前 modify by zhouchao--%>
	<kmss:auth
				requestURL="/km/review/km_review_main/kmReviewMain.do?method=changeTemplate&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
				requestMethod="GET">
	<input type="button"
		value="<bean:message key="button.translate" bundle="km-review"/>"
		onclick="checkSelect();">
	</kmss:auth>	
	<c:if test="${param.categoryId==null || param.nodeType=='CATEGORY'}">	
	<kmss:authShow
		roles="ROLE_KMREVIEW_CREATE">
		<input type="button" value="<bean:message key="button.add"/>"
			onclick="Dialog_Template('com.landray.kmss.km.review.model.KmReviewTemplate','<c:url value="/km/review/km_review_main/kmReviewMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');">
	</kmss:authShow>
	</c:if>
	<c:if test="${param.nodeType=='TEMPLATE'}">
	<kmss:auth
		requestURL="/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=${param.categoryId}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewMain.do" />?method=add&fdTemplateId=${param.categoryId}');">
	</kmss:auth>
	</c:if>	 
	<kmss:auth
		requestURL="/km/review/km_review_main/kmReviewMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmReviewMainForm, 'deleteall');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.search"/>"
		onclick="Search_Show();">
	<c:if test="${param.method == 'result'}">
	<kmss:auth requestURL="/sys/search/search.do?method=export&fdModelName=${param.fdModelName}">
		<input type=button value="<bean:message key="button.export"/>" onclick="showExportDialog();">
	</kmss:auth>
	</c:if>
	</div>
	<%@ include file="/km/review/km_review_main/kmReviewMain_list_content.jsp"%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
