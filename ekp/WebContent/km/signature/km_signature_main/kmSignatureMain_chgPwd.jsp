<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
function checkInput(){
	var p1 = document.getElementsByName("fdNewPassword")[0].value;
	var p2 = document.getElementsByName("fdConfirmPassword")[0].value;
	if(p1 == null || p1 == ""){
		alert('<bean:message bundle="km-signature" key="signature.warn8"/>');
		return false;
	}
	if(p1==p2){
		return true;
	}else{
		alert('<bean:message bundle="km-signature" key="signature.warn2"/>');
		return false;
	}
}
</script>
<html:form action="/km/signature/km_signature_main/kmSignatureMain.do?method=savePwd" onsubmit="return checkInput();">
<html:hidden property="fdId"/>
<div id="optBarDiv">
	<input type=submit value="<bean:message key="button.submit"/>">
	<input type="button" value="<bean:message key="button.close"/>" onClick="Com_CloseWindow();">
</div>
<center>
<table class="tb_normal" width=300px style="border: #c0c0c0 1px solid">
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="km-signature" key="signature.newPassword"/>
		</td><td width=70%>
			<input type="password" name="fdNewPassword" style="width:100%" class="inputsgl"/>
		</td>
	</tr>
	<tr>
		<td width=30% class="td_normal_title">
			<bean:message bundle="km-signature" key="signature.confirmPassword"/>
		</td><td width=70%>
			<input type="password" name="fdConfirmPassword" style="width:100%" class="inputsgl"/>
		</td>
	</tr>
</table>
</center>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>