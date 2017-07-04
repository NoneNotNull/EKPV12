<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
	
	function fn_submit(){
		document.kmSmissiveMainForm.submit();
		return true;
	}
</script>
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=modifyRight" >
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
			bundle="km-smissive" key="kmSmissiveMain.right.type" /></td>
		<td width="85%">
			<html:radio name="kmSmissiveMainForm" property="rightType" value="add" onclick="changeRightType(this)">
				<bean:message bundle="km-smissive" key="kmSmissiveMain.right.type.add" />
			</html:radio>
			<html:radio name="kmSmissiveMainForm" property="rightType" value="modify" onclick="changeRightType(this)">
				<bean:message bundle="km-smissive" key="kmSmissiveMain.right.type.modify" />
			</html:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
			bundle="km-smissive" key="kmSmissiveMain.right.reader" /></td>
		<td width="85%">
			<div id="divModify">
				<html:hidden property="authReaderIds" />
				<html:textarea property="authReaderNames" readonly="true" 
				style="width:90%;height:90px" styleClass="inputmul" /> 
				<a href="#"
						onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';', ORG_TYPE_ALL);">
				<bean:message key="dialog.selectOrg" /></a>
			</div>
			<div id="divAdd" style="display:none">
				<html:hidden property="newReaderIds" />
				<TEXTAREA type="text" name="newReaderNames" readonly="true" 
				style="width:90%;height:90px" styleClass="inputmul" ></TEXTAREA>
				<a href="#"
						onclick="Dialog_Address(true, 'newReaderIds','newReaderNames', ';', ORG_TYPE_ALL);">
				<bean:message key="dialog.selectOrg" /></a>
			</div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%"><bean:message
			bundle="km-smissive" key="kmSmissiveMain.right.notify" /></td>
		<td width="85%">
			<kmss:editNotifyType property="fdNotifyType" />
		</td>
	</tr>

</table>
<script type="text/javascript">
	function changeRightType(obj){
		if(obj.value == "add"){
			divModify.style.display = "none";
			divAdd.style.display = "block";
		}else{
			divModify.style.display = "block";
			divAdd.style.display = "none";
		}
	}
</script>

</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmSmissiveMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>