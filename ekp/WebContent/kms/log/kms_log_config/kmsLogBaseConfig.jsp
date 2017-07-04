<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%request.setAttribute("method_GET", "edit"); %>
<html:form action="/kms/log/kms_log_config/kmsLogConfig.do">
<div id="optBarDiv">
	<kmss:authShow roles="ROLE_KMSLOG_ADMIN">
		<input type="button" value="<bean:message bundle="kms-log" key="kmsLog.init"/>"
			onclick="Com_Submit(document.kmsLogConfigForm, 'evaluateInit');">
	</kmss:authShow>
	<kmss:authShow roles="ROLE_KMSLOG_ADMIN">
		<input type="button" value="<bean:message bundle="kms-log" key="button.latestUpdate"/>"
			onclick="Com_Submit(document.kmsLogConfigForm, 'latestUpdate');">
	</kmss:authShow>
	<kmss:authShow roles="ROLE_KMSLOG_ADMIN">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="_submit()">
	</kmss:authShow>
</div>
<p class="txttitle"><bean:message bundle="kms-log" key="kmsLogConfig.logTypeConfigTitle"/></p>
<center>
<table class="tb_normal" width=80%>
	<input type='hidden'  name ='fdKmsLogTypes'  />
	<c:forEach items="${kmsLogTypes}" var="rules">
	<tr>
		<td width=25% style="line-height: 25px">
	<c:forEach items="${rules}" var="kmsLogGenerateRule" varStatus="status">
		<c:if test="${status.index==0}">
			<strong><label>${kmsLogGenerateRule['fdModuleName']}：</label></strong><br>
		</c:if>
		<label>
			<input id='${kmsLogGenerateRule['fdId']}' name="logType" type="checkbox" ${kmsLogGenerateRule['fdStatus']?"checked":""} 
			  value='${kmsLogGenerateRule['fdModelName']}'> 
			${kmsLogGenerateRule['text']} 
		</label>
	</c:forEach>	
		</td>
	</tr>		
	</c:forEach>	
</table> 

<!--<p class="txttitle" style="margin-top:50px;"><bean:message bundle="kms-log" key="kmsLogConfig.fdRetainMonthTitle"/></p>
<table class="tb_normal" width=80%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-log" key="kmsLogConfig.fdRetainMonth"/>
		</td><td width="85%">
			<xform:text property="fdRetainMonth"  style="width:85%" /><br/>
			<LABEL style="color:red;"><bean:message bundle="kms-log" key="kmsLogConfig.fdRetainMonth.msg"/></LABEL>
		</td>
	</tr>
</table>
--></center>
<script>

function _submit(){
	var fdKmsLogTypes = document.getElementsByName('fdKmsLogTypes')[0];
/**	var fdRetainMonth = document.getElementsByName('fdRetainMonth')[0].value*1;
	if(!fdRetainMonth ||
			(typeof fdRetainMonth!="number" || fdRetainMonth>3 || fdRetainMonth<1)){
		alert("<bean:message bundle='kms-log' key='kmsLogConfig.fdRetainMonth.validator'/>");
		return;
	}
**/
	var  kmsLogTypes="";
	$("input[name='logType']:checked").each(function(){
		kmsLogTypes+=this.id+";";
	});
	fdKmsLogTypes.value=kmsLogTypes;
	var myForm=document.forms['kmsLogConfigForm'];		 		
	myForm.action='<c:url value="/kms/log/kms_log_config/kmsLogConfig.do" />'+'?method=update ';
	myForm.method='POST';   
	myForm.submit(); 		
}


</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>