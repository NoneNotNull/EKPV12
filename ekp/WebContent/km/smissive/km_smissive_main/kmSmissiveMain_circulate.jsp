<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
	
	function fn_submit(){
		if(document.kmSmissiveMainForm.newReaderIds.value == "" 
		|| document.kmSmissiveMainForm.circulationReason.value == ""){
			alert('<bean:message bundle="km-smissive" key="kmSmissiveMain.circulate.info" />');
			return false;
		}else{
			document.kmSmissiveMainForm.submit();
			return true;
		}
	}
</script>
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=circulate" >
<div id="optBarDiv">
		
	<input type=button value="<bean:message key="button.submit"/>"
		onclick="fn_submit();">
	
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<html:hidden property="fdId"/>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
			bundle="km-smissive" key="kmSmissiveMain.circulate.authReaders" /></td>
		<td width="85%">
			${kmSmissiveMainForm.authReaderNames }
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
			bundle="km-smissive" key="kmSmissiveMain.circulate.newReaders" /></td>
		<td width="85%">
			<html:hidden property="newReaderIds" />
			<TEXTAREA type="text" name="newReaderNames" readonly="true" 
			style="width:90%;height:90px" styleClass="inputmul" ></TEXTAREA>
			<a href="#"
					onclick="Dialog_Address(true, 'newReaderIds','newReaderNames', ';', ORG_TYPE_ALL);">
			<bean:message key="dialog.selectOrg" /></a>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
			bundle="km-smissive" key="kmSmissiveMain.circulate.reason" /></td>
		<td width="85%">
			<html:text property="circulationReason" style="width:90%" />
				<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-smissive" key="kmSmissiveMain.circulate.notify" />
		</td>
		<td width="85%">
			<kmss:editNotifyType property="fdNotifyType" />
		</td>
	</tr>

</table>

</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmSmissiveMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>