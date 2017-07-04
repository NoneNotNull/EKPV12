<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("jquery.js");</script>
<script>
$(document).ready(function (){
	var val ="${kmImeetingDeviceForm.fdIsAvailable}";  
	if(val=='1'||val=='true'){
		document.getElementsByName("fdIsAvailable")[0].checked="checked";
	}else{
		document.getElementsByName("fdIsAvailable")[1].checked="checked";
	}
});
</script>
<html:form action="/km/imeeting/km_imeeting_device/kmImeetingDevice.do">
<div id="optBarDiv">
	<c:if test="${kmImeetingDeviceForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmImeetingDeviceForm, 'update');">
	</c:if>
	<c:if test="${kmImeetingDeviceForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmImeetingDeviceForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmImeetingDeviceForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-imeeting" key="table.kmImeetingDevice"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<%--设备名称--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdName"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdName" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%--排序号--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdOrder"/>
		</td>
		<td width="85%" colspan="3">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
	</tr>
	<tr>
		<%--是否有效--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingDevice.fdIsAvailable"/>
		</td>
		<td width="85%" colspan="3">
			<xform:radio property="fdIsAvailable">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>