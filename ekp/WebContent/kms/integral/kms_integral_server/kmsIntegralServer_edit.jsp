<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<style>
	table{margin:0 auto ;}
</style>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/resource/js/jquery.js"></script>
<script>Com_RegisterFile("calendar.js");Com_IncludeFile("popwin.js","jquery.js");</script>
<script type="text/javascript">
	function Com_Submit_NewTarget(){
		if(!validateKmsIntegralServerForm(kmsIntegralServerForm)) return;
			document.kmsIntegralServerForm.target="_self";
			var url=document.kmsIntegralServerForm.action;	
			document.kmsIntegralServerForm.action=Com_SetUrlParameter(url, "method","testConnect");
			document.kmsIntegralServerForm.submit();
	}
</script>
<c:if test="${!empty fdDbType }">
	<script type="text/javascript">
		window.onload = function (){
			document.getElementsByName("fdDatabaseType")[0].value = '${fdDbType }';
		}
	</script>
</c:if>
<html:form action="/kms/integral/kms_integral_server/kmsIntegralServer.do">
<div id="optBarDiv">
	<c:if test="${kmsIntegralServerForm.method_GET=='add'}">
		<input type=button value="<bean:message key="kms-integral:button.nowconfig"/>"
			onclick="Com_Submit(document.kmsIntegralServerForm, 'nowconfig');">
	</c:if>		
	<input type=button value="<bean:message  bundle="kms-integral" key="kmsIntegralServer.testConnect"/>"
			onclick="Com_Submit_NewTarget()">
	<c:if test="${kmsIntegralServerForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsIntegralServerForm, 'update');">
	</c:if>
	<c:if test="${kmsIntegralServerForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmsIntegralServerForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmsIntegralServerForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="kms-integral" key="table.kmsIntegralServer"/><bean:message bundle="kms-integral" key="kms.integral.public.set"/></p>

<center>
<html:hidden property="fdId"/>
<html:hidden property="fdServerType" value="1"/>

<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdName"/>
		</td><td width=35% colspan="3">
			<html:text property="fdName" style="width:85%"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdPrefix"/>
		</td><td width=35%>
			<html:text property="fdPrefix" style="width:90%"/><span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdUpdateTime"/>
		</td><td width=35%>
			<html:text  property="fdUpdateTime" readonly="true"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdDatabaseType"/>
		</td><td width=35%>
			<html:select property="fdDatabaseType" style="width:35%;">
				<option value='SQL SERVER' <c:if test="${'SQL SERVER' == kmsIntegralServerForm.fdDatabaseType}">selected</c:if>>SQL SERVER</option>
				<option value='ORACLE'<c:if test="${'ORACLE' == kmsIntegralServerForm.fdDatabaseType}">selected</c:if>>ORACLE</option>
				<option value='MYSQL'<c:if test="${'MYSQL' == kmsIntegralServerForm.fdDatabaseType}">selected</c:if>>MYSQL</option>
				<option value='DB2'<c:if test="${'DB2' == kmsIntegralServerForm.fdDatabaseType}">selected</c:if>>DB2</option>
			</html:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdDatabaseUrl"/>
		</td><td width=35%>
			<html:text property="fdDatabaseUrl" style="width:90%"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdUserName"/>
		</td><td width=35%>
			<html:text property="fdUserName" style="width:90%"/><span class="txtstrong">*</span>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdUserPw"/>
		</td><td width=35%>
			<html:password styleClass="inputsgl" property="fdUserPw" style="width:90%"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdStartOrStop"/>
		</td><td width=35% colspan="3">
			<input type="radio" name="fdStartOrStop" value="true" checked="checked"><bean:message  bundle="kms-integral" key="kmsIntegralServer.fdStart"/> <input type="radio" name="fdStartOrStop" value="false"><bean:message  bundle="kms-integral" key="kmsIntegralServer.fdStop"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmsIntegralServerForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
