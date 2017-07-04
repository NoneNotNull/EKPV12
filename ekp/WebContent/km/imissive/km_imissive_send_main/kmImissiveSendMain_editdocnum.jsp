<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script>
seajs.use(['theme!form']);
Com_IncludeFile("doclist.js|dialog.js|calendar.js");
</script>
<script>
Com_SetWindowTitle('<bean:message bundle="km-imissive" key="kmImissiveSendMain.editdocnum"/>');
function submitForm(){
	var validateFlag = true;
	var fdDocNum = document.getElementsByName("fdDocNum")[0];
	if(fdDocNum.value == null || fdDocNum.value == ""){
		alert('<bean:message key="kmImissiveSendMain.message.error.fdDocNum" bundle="km-imissive" />');
		validateFlag = false;
	}
	
	if(validateFlag){
		Com_Submit(document.kmImissiveSendMainForm, 'updateDocNum');
	}
}
</script>
<html:form action="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do">

<p class="txttitle"><bean:message bundle="km-imissive" key="kmImissiveSendMain.editdocnum"/></p>

<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdDocNum"/>
		</td><td width=85%>
			<html:text property="fdDocNum" style="width:85%"/>
		</td>
	</tr>
		<tr>
	<td colspan="2">
	   <font size="2px"><bean:message  bundle="km-imissive" key="kmImissiveSendMain.editdocnum.info"/></font>
	</td>
	</tr>
</table>
<div style="padding-top:17px">
	   <ui:button text="${ lfn:message('button.submit') }"  onclick="submitForm();">
	   </ui:button>
	   <ui:button text="${ lfn:message('button.close') }" order="5" styleClass="lui_toolbar_btn_gray"  onclick="Com_CloseWindow()">
	    </ui:button>
 </div>
</center>
<html:hidden property="method_GET"/>
</html:form>
	</template:replace>
</template:include>
