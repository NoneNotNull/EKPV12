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
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=modifyAttachmentRight" >
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
			bundle="km-smissive" key="kmSmissiveMain.right.att" />
		</td>
		<td width="85%">
		<bean:message
			bundle="sys-right" key="right.att.authAttCopys" />
		<html:checkbox property="authAttNocopy" value="1" onclick="refreshDisplay(this,'copyDiv')"/>
					<bean:message key="right.att.authAttNocopy" bundle="sys-right"/>
		<br>
		<div id="copyDiv" <c:if test="${kmSmissiveMainForm.authAttNocopy == 'true'}">style="display:none"</c:if> > 						
		<html:hidden property="authAttCopyIds" /> <html:textarea
			property="authAttCopyNames" readonly="true"
			style="width:90%;height:90px" styleClass="inputmul" /> 
			<a href="#"
				onclick="Dialog_Address(true, 'authAttCopyIds','authAttCopyNames', ';', ORG_TYPE_ALL);">
			<bean:message key="dialog.selectOrg" /> </a>
			<br>
			<bean:message key="right.att.authAttCopys.note" bundle="sys-right"/>
		</div>
		
		<bean:message
			bundle="sys-right" key="right.att.authAttDownloads" />
		<html:checkbox property="authAttNodownload" value="1" onclick="refreshDisplay(this,'downloadDiv')"/>
					<bean:message key="right.att.authAttNodownload" bundle="sys-right"/>
		<br>
		<div id="downloadDiv" <c:if test="${kmSmissiveMainForm.authAttNodownload == 'true'}">style="display:none"</c:if> > 						
		<html:hidden property="authAttDownloadIds" /> <html:textarea
			property="authAttDownloadNames" readonly="true"
			style="width:90%;height:90px" styleClass="inputmul" /> 
			<a href="#"
				onclick="Dialog_Address(true, 'authAttDownloadIds','authAttDownloadNames', ';', ORG_TYPE_ALL);">
			<bean:message key="dialog.selectOrg" /> </a>
			<br>
			<bean:message key="right.att.authAttDownloads.note" bundle="sys-right"/>
		</div>
		
		<bean:message
			bundle="sys-right" key="right.att.authAttPrints" />
		<html:checkbox property="authAttNoprint" value="1" onclick="refreshDisplay(this,'printDiv')"/>
					<bean:message key="right.att.authAttNoprint" bundle="sys-right"/>
		<br>
		<div id="printDiv" <c:if test="${kmSmissiveMainForm.authAttNoprint == 'true'}">style="display:none"</c:if> > 						
		<html:hidden property="authAttPrintIds" /> <html:textarea
			property="authAttPrintNames" readonly="true"
			style="width:90%;height:90px" styleClass="inputmul" /> 
			<a href="#"
				onclick="Dialog_Address(true, 'authAttPrintIds','authAttPrintNames', ';', ORG_TYPE_ALL);">
			<bean:message key="dialog.selectOrg" /> </a>
			<br>
			<bean:message key="right.att.authAttPrints.note" bundle="sys-right"/>
		</div>
		
		</td>
	</tr>	

</table>

<script>
function refreshDisplay(obj,divName){
	var divObj = document.getElementById(divName);
	divObj.style.display=(obj.checked?"none":"");
}
</script>

</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmSmissiveMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>