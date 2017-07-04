<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/tib/common/log/tib_common_log_main/tibCommonLogMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibCommonLogMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-common-log" key="table.tibCommonLogMain"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdPoolName"/>
		</td><td width="35%">
			<xform:text property="fdPoolName" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdUrl"/>
		</td><td width="35%">
			<xform:text property="fdUrl" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdLogType"/>
		</td><td width="35%" colspan="3">
			${tibCommonLogMainForm.displayTypeName}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdStartTime"/>
		</td><td width="35%">
			<xform:datetime property="fdStartTime" />
			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdEndTime"/>
		</td><td width="35%"> 
			<xform:datetime property="fdEndTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdImportPar"/>
		</td><td colspan="3" width="85%">
			<c:choose> 
				<c:when test="${tibCommonLogMainForm.fdLogType eq '4'}">
					${tibCommonLogMainForm.fdImportPar }
				</c:when>
				<c:otherwise>
					<c:out value="${tibCommonLogMainForm.fdImportPar }"/>
				</c:otherwise>
			</c:choose> 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdExportPar"/>
		</td><td colspan="3" width="85%">
			<c:choose> 
				<c:when test="${tibCommonLogMainForm.fdLogType eq '4'}">
					${tibCommonLogMainForm.fdExportPar }
				</c:when>
				<c:otherwise>
					<c:out value="${tibCommonLogMainForm.fdExportPar }"/>
				</c:otherwise>
			</c:choose>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-common-log" key="tibCommonLogMain.fdMessages"/>
		</td><td colspan="3" width="85%">
			${tibCommonLogMainForm.fdMessages }
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>