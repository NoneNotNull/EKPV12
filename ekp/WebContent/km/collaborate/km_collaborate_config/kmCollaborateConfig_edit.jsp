<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/km/collaborate/km_collaborate_config/kmCollaborateConfig.do">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmCollaborateConfigForm, 'update');">
</div>
<script type="text/javascript">
window.onload = function(){
	var fdcheckbox=document.getElementsByName("fdcheckbox")[0];
	var fdIsEdit=document.getElementsByName("fdIsEdit")[0];
	if(fdIsEdit.value=="1"){
		fdcheckbox.checked=true;
	}else 
		fdcheckbox.checked=false;
};
function changeValue(){
	var fdcheckbox=document.getElementsByName("fdcheckbox")[0];
	var fdIsEdit=document.getElementsByName("fdIsEdit")[0];
	if(fdcheckbox.checked){
		fdIsEdit.value="1";
	}else{
		fdIsEdit.value="0";
	}
}
</script>
<p class="txttitle"><bean:message bundle="km-collaborate" key="table.kmCollaborateConfig"/></p>
<center>
<table class="tb_normal" width=95%>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateConfig.fdDefaultReply" />
		</td><td colspan=3>
		    <xform:textarea property="fdDefaultReply" style="width:100%"></xform:textarea>
		</td>
	</tr>
   <tr>
   <td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateConfig.fdDefaultRemindersDay"/>
		</td><td  colspan="3">
			<xform:text property="defaultDays" subject="${lfn:message('km-collaborate:kmCollaborateConfig.fdDefaultRemindersDay')}" validators="required digits" style="width:20px"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateConfig.fdNotifyType"/>
		</td><td  colspan="3">
			<kmss:editNotifyType property="defaultNotifyType" />
		</td>
	</tr>
    <tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateConfig.ComPersonNum.default" />
		</td><td colspan=3>
			<xform:text property="defaultComNums" style="width:40px" subject="${lfn:message('km-collaborate:kmCollaborateConfig.ComPersonNum.default')}" validators="required digits" /><span class="txtstrong">*</span>
		</td>
	</tr>
    <tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateConfig.editable"/>
		</td>
		<td colspan="3">
		    <html:hidden property="fdIsEdit"/>
		    <input name="fdcheckbox" type="checkbox" onclick="changeValue();"/>
			<bean:message bundle="km-collaborate" key="kmCollaborateConfig.config.Notedit"/>
		</td>		
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script>
var kmCollaborateConfigFormValidator = new $KMSSValidation(document.forms['kmCollaborateConfigForm'], {onSubmit:false, immediate:false});
Com_Parameter.event["submit"].push(function() {
	return kmCollaborateConfigFormValidator.validate();
});
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>