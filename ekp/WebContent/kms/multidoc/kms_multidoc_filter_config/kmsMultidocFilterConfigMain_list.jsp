<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do" >
	
<div id="optBarDiv">	
	<kmss:auth requestURL="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do?method=add" requestMethod="GET">
	<input type="button" value="<bean:message key="button.add"/>" onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do" />?method=add');"> 
	</kmss:auth>
	<kmss:auth requestURL="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do?method=deleteall" requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>" onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsMultidocFilterConfigMainForm, 'deleteall');">
 	</kmss:auth>
 	<input type="button" value="<bean:message key="button.refresh"/>" onclick="location.reload();">
</div>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<script type="text/javascript">
  function addNewFilterConfig(){
	 url+="${request.localAddr}/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMainAction.do?method=add";
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
			 
			<sunbor:column property="kmsMultidocFilterConfigMain.fdName">
				 名称
			</sunbor:column>
			<sunbor:column property="kmsMultidocFilterConfigMain.fdOrder">
				 排序号
			</sunbor:column>
			<sunbor:column property="kmsMultidocFilterConfigMain.fdRemark">
				 备注
			</sunbor:column>
			<sunbor:column property="kmsMultidocFilterConfigMain.fdIsEnabled">
				 是否有效
			</sunbor:column>
		</sunbor:columnHead>
	</tr>
	<c:forEach
		items="${queryPage.list}"
		var="kmsMultidocFilterConfigMain"
		varStatus="vstatus">
		<tr kmss_href="<c:url value="/kms/multidoc/kms_multidoc_filter_config/kmsMultidocFilterConfigMain.do?method=view&fdId=${kmsMultidocFilterConfigMain.fdId}" />" 
			kmss_target="_blank">
			<td><input
				type="checkbox"
				name="List_Selected"
				value="${kmsMultidocFilterConfigMain.fdId}"></td>
			<td>${vstatus.index+1}</td>
			<td kmss_wordlength="50"><c:out value="${kmsMultidocFilterConfigMain.fdName}" /></td>
			<td><c:out value="${kmsMultidocFilterConfigMain.fdOrder}" /></td>
			<td><c:out value="${kmsMultidocFilterConfigMain.fdRemark}" /></td>
			<td><sunbor:enumsShow value="${kmsMultidocFilterConfigMain.fdIsEnabled}" enumsType="common_yesno" /></td>
		</tr>
	</c:forEach>
</table>
	 
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}	%>
</html:form>	
<%@ include file="/resource/jsp/list_down.jsp"%>
