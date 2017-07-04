<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do" >
	
<div id="optBarDiv">	
	<kmss:auth requestURL="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do?method=add" requestMethod="GET">
	<input type="button" value="<bean:message key="button.add"/>" onclick="Com_OpenWindow('<c:url value="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do" />?method=add');"> 
	</kmss:auth>
	<kmss:auth requestURL="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do?method=deleteall" requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>" onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysPropertyFilterMainForm, 'deleteall');">
 	</kmss:auth>
 	<input type="button" value="<bean:message key="button.refresh"/>" onclick="history.go(0);">
</div>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<script type="text/javascript">
  function addNewFilterConfig(){
	 url+="${request.localAddr}/sys/property/sys_property_filter_main/sysPropertyFilterMainAction.do?method=add";
	 Com_OpenWindow(url,"_black");
}
  function deleteFilterConfig() {
	 
}
</script>

<table id="List_ViewTable">
	<tr>
		<sunbor:columnHead htmlTag="td">
			<td width="10pt"><input
				type="checkbox"
				name="List_Tongle"></td>
			<td width="40pt"><bean:message key="page.serial" /></td>
			 
			<sunbor:column property="sysPropertyFilterMain.fdName">
				<bean:message bundle="sys-property" key="sysPropertyFilterMain.fdName" />
			</sunbor:column>
			<sunbor:column property="sysPropertyFilterMain.fdOrder">
				<bean:message bundle="sys-property" key="sysPropertyFilterMain.fdOrder" />
			</sunbor:column>
			<sunbor:column property="sysPropertyFilterMain.fdRemark">
				 <bean:message bundle="sys-property" key="sysPropertyFilterMain.fdRemark" />
			</sunbor:column>
			<sunbor:column property="sysPropertyFilterMain.fdIsEnabled">
				 <bean:message bundle="sys-property" key="sysPropertyFilterMain.fdIsEnabled" />
			</sunbor:column>
		</sunbor:columnHead>
	</tr>
	<c:forEach
		items="${queryPage.list}"
		var="sysPropertyFilterMain"
		varStatus="vstatus">
		<tr kmss_href="<c:url value="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do?method=view&fdId=${sysPropertyFilterMain.fdId}" />" 
			kmss_target="_blank">
			<td><input
				type="checkbox"
				name="List_Selected"
				value="${sysPropertyFilterMain.fdId}"></td>
			<td>${vstatus.index+1}</td>
			<td kmss_wordlength="50"><c:out value="${sysPropertyFilterMain.fdName}" /></td>
			<td><c:out value="${sysPropertyFilterMain.fdOrder}" /></td>
			<td><c:out value="${sysPropertyFilterMain.fdRemark}" /></td>
			<td><sunbor:enumsShow value="${sysPropertyFilterMain.fdIsEnabled}" enumsType="common_yesno" /></td>
		</tr>
	</c:forEach>
</table>
	 
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}	%>
</html:form>	
<%@ include file="/resource/jsp/list_down.jsp"%>
