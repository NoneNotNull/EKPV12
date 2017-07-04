<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("calendar.js");
</script>
<script type="text/javascript">
<!-- 
	function checkData(){
		var day = document.getElementsByName("fdKeepDay")[0];
		if(day!=null){
			if(isNaN(day.value)||day.value<0){
				alert("<bean:message key="kmCalendarBaseConfig.fdKeepDay.number.validate" bundle="km-calendar"/>");
				return false;
			}else{
				return true;
			}
		}else{
			return true;
		}
	}
//-->
</script>
<html:form action="/km/calendar/km_calendar_base_config/kmCalendarBaseConfig.do" onsubmit="return checkData();">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>" onclick="Com_Submit(document.kmCalendarBaseConfigForm, 'update');">
</div>
<p class="txttitle">
<c:if test="${!empty type and type=='day'}">
	<bean:message bundle="km-calendar" key="table.kmCalendarBaseConfigKeepTime"/>
</c:if>
<c:if test="${!empty type and type=='time'}">
	<bean:message bundle="km-calendar" key="table.kmCalendarBaseConfigSetTime"/>
</c:if></p>
<center>
<table class="tb_normal" width=95%>
	<input type="hidden" value="${type }" name="type">
	<c:if test="${!empty type and type=='day'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-calendar" key="kmCalendarBaseConfig.fdKeepDay"/>
			 </td>
			 <td colspan=3>
				<html:text property="fdKeepDay"/><span class="txtstrong">*</span>
				<span id='dateDescription'>
				<br><font color="red" ><bean:message  bundle="km-calendar" key="kmCalendarType.dateDescription"/></font></span>
			</td>
		</tr>
	</c:if>
	<c:if test="${!empty type and type=='time'}">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-calendar" key="kmCalendarBaseConfig.fdStartTime"/>
			</td>
			<td width=35%>
				<html:text property="fdStartTime" readonly="true" styleClass="inputsgl" style="width:85%"/>
				<a href="#" onclick="selectTime('fdStartTime');"><bean:message key="dialog.selectTime"/></a>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-calendar" key="kmCalendarBaseConfig.fdEndTime"/>
			</td><td width=35%>
				<html:text property="fdEndTime" readonly="true" styleClass="inputsgl" style="width:85%"/>
				<a href="#" onclick="selectTime('fdEndTime');"><bean:message key="dialog.selectTime"/></a>
			</td>
		</tr>
	</c:if>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
