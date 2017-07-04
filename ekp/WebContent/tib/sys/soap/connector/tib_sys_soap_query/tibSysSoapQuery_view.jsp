<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js|doclist.js");
	function confirmDelete(msg){
		var del = confirm("<bean:message key="page.comfirmDelete"/>");
		return del;
	}
</script>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.reQuery"/>"
		onclick="Com_Submit(document.tibSysSoapQueryForm, 'reQuery');">
	<kmss:auth requestURL="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('tibSysSoapQuery.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-sys-soap-connector" key="table.tibSysSoapQuery"/></p>
<html:form action="/tib/sys/soap/connector/tib_sys_soap_query/tibSysSoapQuery.do">
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docSubject"/>
		</td><td colspan="3" width="85%">
			${tibSysSoapQueryForm.docSubject }
			<input type="hidden" name="docSubject" value="${tibSysSoapQueryForm.docSubject }"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docInputParam"/>
		</td><td colspan="3" width="85%">
			<c:out value="${tibSysSoapQueryForm.docInputParam }"/>
			<textarea name="docInputParam" rows="" cols="" style="display:none;">${tibSysSoapQueryForm.docInputParam }</textarea>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docOutputParam"/>
		</td><td colspan="3" width="85%">
			<c:out value="${tibSysSoapQueryForm.docOutputParam }"/>
			<textarea name="docOutputParam" rows="" cols="" style="display:none;">${tibSysSoapQueryForm.docOutputParam }</textarea>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapMain.func.faultParam"/>
		</td><td colspan="3" width="85%">
			<c:out value="${tibSysSoapQueryForm.docFaultInfo}"/>
			<textarea name="docFaultInfo" rows="" cols="" style="display:none;">${tibSysSoapQueryForm.docFaultInfo }</textarea>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docCreator"/>
		</td><td width="35%">
			<c:out value="${tibSysSoapQueryForm.docCreatorName}" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-sys-soap-connector" key="tibSysSoapQuery.docCreateTime"/>
		</td><td width="35%">
			<xform:datetime property="docCreateTime" />
		</td>
	</tr>
</table>
<input type="hidden" name="fdId" value="${param.fdId }"/>
<input type="hidden" name="fdMainId" value="${tibSysSoapQueryForm.tibSysSoapMainId }"/>
</center>
</html:form>
<%@ include file="/resource/jsp/view_down.jsp"%>
