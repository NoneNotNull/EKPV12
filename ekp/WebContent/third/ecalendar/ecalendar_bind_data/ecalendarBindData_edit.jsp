<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
function changeSynchroState(obj){
	var enableSynchro = document.getElementsByName("fdEnableSynchro")[0];
	var bind_data_table = document.getElementById("bind_data_table");
	if(obj.checked){
		bind_data_table.style.display = "";
		enableSynchro.value="true";
	}else{
		bind_data_table.style.display = "none";
		enableSynchro.value="false";
	}
}


</script>
<html:form action="/third/ecalendar/ecalendar_bind_data/ecalendarBindData.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.ecalendarBindDataForm, 'update');">
	
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle">exchange账号绑定</p>

<center>
<table class="tb_normal" width=95% style="border: 0;">
	<tr>
		<td class="td_normal_title" style="border: 0;">
			<input type="checkbox" <c:if test="${ecalendarBindDataForm.fdEnableSynchro }">checked="checked"</c:if> value="true" onclick="changeSynchroState(this);" /><bean:message bundle="third-ecalendar" key="ecalendarBindData.fdEnableSynchro"/>
		</td>
		<input type="hidden" name="fdEnableSynchro" value="${ecalendarBindDataForm.fdEnableSynchro }"></input>
	</tr>
	</table>
	
	<table class="tb_normal" width=95% id="bind_data_table" <c:if test="${!ecalendarBindDataForm.fdEnableSynchro }">style="display:none;"</c:if>>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-ecalendar" key="ecalendarBindData.fdAccount"/>
		</td><td width="35%">
			<xform:text property="fdAccount" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="third-ecalendar" key="ecalendarBindData.fdPassword"/>
		</td><td width="35%">
			<%-- 
			<xform:text property="fdPassword" style="width:85%" />
			--%>
			<input type="password" name="fdPassword" style="width:85%" value="${ecalendarBindDataForm.fdPassword }"></input>
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