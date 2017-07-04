<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
function submited(){
	var startDate = document.getElementsByName("fdStartDate")[0];
	var endDate = document.getElementsByName("fdEndDate")[0];
	var startTime = document.getElementsByName("fdStartTime")[0];
	var endTime = document.getElementsByName("fdEndTime")[0];
	if(startDate.value != "" && endDate.value != ""){
		var date = compareDate(endDate.value,startDate.value);
		if( date < 0){
			alert('<bean:message  bundle="sys-time" key="sysTimeVacation.date.validate"/>');
			return false;
		}
		if(date == 0){
			if(startTime.value != "" && endTime.value != ""){
				time = compareTime(endTime.value,startTime.value);
				if(time <= 0){
					alert('<bean:message  bundle="sys-time" key="sysTimeVacation.time.validate"/>');
					return false;
				}
			}
		}
	}
	return true;
}
</script>
<html:form action="/sys/time/sys_time_vacation/sysTimeVacation.do" onsubmit="return validateSysTimeVacationForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTimeVacationForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())Com_Submit(document.sysTimeVacationForm, 'update');">
	</c:if>
	<c:if test="${sysTimeVacationForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())Com_Submit(document.sysTimeVacationForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())Com_Submit(document.sysTimeVacationForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="top.close();">
</div>

<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimeVacation"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.fdName"/>
		</td>
		<td width=85% colspan=3>
			<html:text property="fdName" style="width:85%" styleClass="inputsgl"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.time"/>
		</td><td width=35% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimeVacation.start"/>
			<html:text property="fdStartDate" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectDate('fdStartDate');">
			<bean:message key="dialog.selectTime" /></a>
			<span class="txtstrong">*</span>
			<html:text property="fdStartTime" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectTime('fdStartTime');" styleClass="inputsgl" >
			<bean:message key="dialog.selectTime" /></a>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimeVacation.end"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<html:text property="fdEndDate" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectDate('fdEndDate');">
			<bean:message key="dialog.selectTime" /></a>
			<span class="txtstrong">*</span>
			<html:text property="fdEndTime" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectTime('fdEndTime');" styleClass="inputsgl" >
			<bean:message key="dialog.selectTime" /></a>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="txtstrong"><bean:message  bundle="sys-time" key="sysTimeVacation.explanation"/></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.docCreatorId"/>
		</td><td width=35%>
			${sysTimeVacationForm.docCreatorName}			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeVacation.docCreateTime"/>
		</td><td width=35%>
			${sysTimeVacationForm.docCreateTime}
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="sysTimeVacationForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>