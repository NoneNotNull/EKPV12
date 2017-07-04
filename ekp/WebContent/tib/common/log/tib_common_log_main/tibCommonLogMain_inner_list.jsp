<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
Com_AddEventListener(window,'load',function(){
	var newForm = document.forms[0];
	if('autocomplete' in newForm)
		newForm.autocomplete = "off";
	else
		newForm.setAttribute("autocomplete","off");
});
</script>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("calendar.js|jquery.js");
</script>
<script type="text/javascript">
	//页面加载完以后把当前窗口的父窗口高度重新设置
	$(document).ready(function(){
			var height=$(document).height();
			var father =window.parent.document;
			if(father){
				var listframe=father.getElementById("listframe");
				$(listframe).attr("height",height);
				}
		})
</script>
<html:form action="/tib/common/log/tib_common_log_main/tibCommonLogMain.do">
<div id="optBarDiv">
		<kmss:auth requestURL="/tib/common/log/tib_common_log_main/tibCommonLogMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.tibCommonLogMainForm, 'deleteall');">
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
				<sunbor:column property="tibCommonLogMain.fdPoolName">
					<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdPoolName"/>
				</sunbor:column>
				<sunbor:column property="tibCommonLogMain.fdUrl">
					<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdUrl"/>
				</sunbor:column>
				<sunbor:column property="tibCommonLogMain.fdStartTime">
					<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdStartTime"/>
				</sunbor:column>
				<sunbor:column property="tibCommonLogMain.fdEndTime">
					<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdEndTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibCommonLogMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/tib/common/log/tib_common_log_main/tibCommonLogMain.do" />?method=view&fdId=${tibCommonLogMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${tibCommonLogMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${tibCommonLogMain.fdPoolName}" />
				</td>
				<td>
					<c:out value="${tibCommonLogMain.fdUrl}" />
				</td>
				<td>
					<kmss:showDate value="${tibCommonLogMain.fdStartTime}" />
				</td>
				<td>
					<kmss:showDate value="${tibCommonLogMain.fdEndTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>