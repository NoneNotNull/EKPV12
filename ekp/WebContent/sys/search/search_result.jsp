<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionEntry" %>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="com.landray.kmss.sys.search.web.SearchResultColumn"%>
<%@page import="com.landray.kmss.sys.search.web.SearchResult"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.common.actions.*" %>
<!--  -->
<kmss:windowTitle subject="${searchResultInfo.title}" />
<script type="text/javascript">
Com_IncludeFile("document.css", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("dialog.js");
function showExportDialog() {
	var exportDialogObj = {exportUrl: "${exportURL}", exportNum: "${queryPage.totalrows}"};
	var returnValue = Dialog_PopupWindow(Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url='+encodeURIComponent(Com_Parameter.ContextPath+'sys/search/search_result_export.jsp?fdModelName=${param.fdModelName}&searchId=${param.searchId}'), 460, 480, exportDialogObj);
	if(returnValue==null || returnValue==undefined){  
		return;  
	}
	document.getElementsByName("fdNum")[0].value = ${queryPage.totalrows};
	document.getElementsByName("fdNumStart")[0].value = returnValue["fdNumStart"];
	document.getElementsByName("fdNumEnd")[0].value = returnValue["fdNumEnd"];
	document.getElementsByName("fdKeepRtfStyle")[0].checked = returnValue["fdKeepRtfStyle"];
	document.getElementsByName("fdColumns")[0].value = returnValue["fdColumns"];
	if(!confirm('<bean:message bundle="sys-search" key="search.export.confirm" />')){
		return;
	}
	exportForm.action = exportDialogObj.exportUrl;
	exportForm.submit();
}
//隐藏table的行
function hid(obj)
{
if(obj.checked)
obj.parentNode.parentNode.style.display= "none ";
}
window.onload =function (){
	setTimeout(dyniFrameSize,100);
}; 
	function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementsByTagName("table")[0];
		if (arguObj != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch (e) {}
};

</script>
<div style="display:none">
	<form name="exportForm" action="" method="POST">	
		<input type="hidden" name="fdColumns" />
		<input name="fdNum" class="inputsgl" style="width:35px" />
		<input name="fdNumStart" class="inputsgl" style="width:35px" />
		<input name="fdNumEnd" class="inputsgl" style="width:35px" />
		<input type="checkbox" value="true" name="fdKeepRtfStyle" checked="checked"/>
	</form>
</div>
<div id="optBarDiv">
	<kmss:auth requestURL="/sys/search/search.do?method=export&fdModelName=${param.fdModelName}">
		<input type=button value="<bean:message key="button.export"/>" onclick="showExportDialog();">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>"	onclick='Com_CloseWindow();'>
</div>
<!--  
	<p class="txttitle"><c:out value="${searchResultInfo.title}"/></p>-->
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<c:forEach items="${searchResultInfo.columns}" var="searchResultColumn">
					<c:if test="${searchResultColumn.calculated || searchResultColumn.property.type == 'RTF'}">
						<td>${searchResultColumn.label}</td>
					</c:if>
					<c:if test="${!searchResultColumn.calculated && searchResultColumn.property.type != 'RTF'}">
						<sunbor:column property="${searchResultColumn.name}">
							${searchResultColumn.label}
						</sunbor:column>
					</c:if>
				</c:forEach>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="resultModel" varStatus="vstatus">
			<%
				Object resultModel = pageContext.getAttribute("resultModel");
				pageContext.setAttribute("modelURL", ModelUtil.getModelUrl(resultModel));
				SearchResult searchResult = (SearchResult) request.getAttribute("searchResultInfo");
			%>
			<c:forEach items="<%=searchResult.getColumnRowIter(resultModel) %>" var="columnRow" varStatus="colVstatus">
			<tr kmss_href="<c:url value="${modelURL}"/>">
				<c:if test="${colVstatus.index == 0 }">
				<td style="width:10px" rowspan="<%=searchResult.getColumnRowMaxSize() %>"><input type="checkbox" name="List_Selected" ></td>
				<td rowspan="<%=searchResult.getColumnRowMaxSize() %>">${vstatus.index+1}</td>
				</c:if>
				<c:forEach items="${columnRow.columns}" var="searchResultColumn">
					<c:if test="${colVstatus.index == 0 or searchResultColumn.rowSpan == 1}">
					<td rowspan="${searchResultColumn.rowSpan }">${searchResultColumn.propertyValue}</td>
					</c:if>
				</c:forEach>
			</tr>
			</c:forEach>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
<%@ include file="/resource/jsp/list_down.jsp"%>