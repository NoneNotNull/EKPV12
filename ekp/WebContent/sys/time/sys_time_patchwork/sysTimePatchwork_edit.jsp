<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("doclist.js");
Com_IncludeFile("calendar.js");
function delete_WorkTime(){
	if(confirm('<bean:message  bundle="sys-time" key="sysTime.message.delete.confirm"/>')){
		DocList_DeleteRow();
	}
}

function submited(){
	var startTime = document.getElementsByName("fdStartTime")[0];
	var endTime = document.getElementsByName("fdEndTime")[0];
	if(startTime.value != "" && endTime.value != ""){
		var date = compareDate(endTime.value,startTime.value);
		if( date < 0){
			alert('<bean:message  bundle="sys-time" key="sysTimePatchwork.validate"/>');
			return false;
		}
	}
	var timeArray = new Array();
	var timeRange = null;
	for(var i=0; true; i++){
		var workStartTime = document.getElementsByName("sysTimePatchworkTimeFormList[" + i + "].fdWorkStartTime");
		var workEndTime = document.getElementsByName("sysTimePatchworkTimeFormList[" + i + "].fdWorkEndTime");
		if(workStartTime.length==0){
			if(i==0){
				alert('<bean:message  bundle="sys-time" key="sysTimePatchworkTime.time.null"/>');
				return false;
			}
			break;
		}
		if(workStartTime[0].value == "" ){
			alert('<bean:message  bundle="sys-time" key="sysTimePatchworkTime.fdWorkStartTime.validate"/>');
			return false;
		}
		if(workEndTime[0].value == "" ){
			alert('<bean:message  bundle="sys-time" key="sysTimePatchworkTime.fdWorkEndTime.validate"/>');
			return false;
		}
		time = compareTime(workEndTime[0].value,workStartTime[0].value);
		if(time <= 0){
			alert('<bean:message  bundle="sys-time" key="sysTimePatchworkTime.validate"/>');
			return false;
		}
		timeRange = new Object();
		timeRange.start = workStartTime[0].value;
		timeRange.end = workEndTime[0].value;
		timeArray[timeArray.length] = timeRange;
	}
	timeArray = timeArray.sort(timeComparer);
	for(var i = 1 ; i < timeArray.length ; i++ ){
		if(compareTime(timeArray[i].start,timeArray[i-1].end)< 0){
			alert('<bean:message bundle="sys-time" key="sysTimePatchworkTime.time.compare"/>');
			return false;
		}
	}
	return true;
}

function timeComparer(t1,t2){
	return compareTime(t1.start,t2.start);
}
</script>
<html:form action="/sys/time/sys_time_patchwork/sysTimePatchwork.do" onsubmit="return validateSysTimePatchworkForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTimePatchworkForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())Com_Submit(document.sysTimePatchworkForm, 'update');">
	</c:if>
	<c:if test="${sysTimePatchworkForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())Com_Submit(document.sysTimePatchworkForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())Com_Submit(document.sysTimePatchworkForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="top.close();">
</div>

<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimePatchwork"/></p>

<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<html:hidden property="sysTimeAreaId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.fdName"/>
		</td><td width=85% colspan=3>
			<html:text property="fdName" style="width:85%" styleClass="inputsgl"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.time"/>
		</td>
		<td width=85% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.start"/>
			<html:text property="fdStartTime" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectDate('fdStartTime');">
			<bean:message key="dialog.selectTime" /></a>
			<span class="txtstrong">*</span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimePatchwork.end"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<html:text property="fdEndTime" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectDate('fdEndTime');">
			<bean:message key="dialog.selectTime" /></a>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.docCreatorId"/>
		</td><td width=35%>
			${sysTimePatchworkForm.docCreatorName}			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimePatchwork.docCreateTime"/>
		</td><td width=35%>
			${sysTimePatchworkForm.docCreateTime}
		</td>
	</tr>
	<tr>
		<td colspan=4>
			<table class="tb_normal" width=100% id="TABLE_DocList">
				<tr>
					<td class="td_normal_title" align="center" width=5%>
						<img src="${KMSS_Parameter_StylePath}icons/add.gif" onclick="DocList_AddRow('TABLE_DocList');" style="cursor:pointer">
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimePatchworkTime.fdWorkStartTime"/>
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimePatchworkTime.fdWorkEndTime"/>
					</td>		
				</tr>
				<tr KMSS_IsReferRow="1" style="display:none">
					<td>
						<center>
						<img src="${KMSS_Parameter_StylePath}icons/delete.gif"
									onclick="delete_WorkTime();" style="cursor:pointer">
						</center>
					</td>
					<td>	
					     <input type="hidden"  class="inputSgl"   name="sysTimePatchworkTimeFormList[!{index}].fdWorkId" value = "${sysTimePatchworkForm.fdId}"/>
					     <input type="hidden"  class="inputSgl"   name="sysTimePatchworkTimeFormList[!{index}].fdId" value = ""/>
					     <input type="text"   class="inputSgl" style="width:70%" name="sysTimePatchworkTimeFormList[!{index}].fdWorkStartTime" value = "" readonly/>
					     <a href="#" onclick="selectTime('sysTimePatchworkTimeFormList[!{index}].fdWorkStartTime');" styleClass="inputsgl" >
						 <bean:message key="dialog.selectTime" /></a>
						 <span class="txtstrong">*</span>
					</td>
					<td>
					     <input type="text"   class="inputSgl" style="width:70%"   name="sysTimePatchworkTimeFormList[!{index}].fdWorkEndTime" value = "" readonly/>
					     <a href="#" onclick="selectTime('sysTimePatchworkTimeFormList[!{index}].fdWorkEndTime');" styleClass="inputsgl" >
						 <bean:message key="dialog.selectTime" /></a>
						 <span class="txtstrong">*</span>
					</td>					
				</tr>
				<c:forEach items="${sysTimePatchworkForm.sysTimePatchworkTimeFormList}" var="sysTimePatchworkTimeForm" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td>
						<center>
						<img src="${KMSS_Parameter_StylePath}icons/delete.gif"
									onclick="delete_WorkTime();" style="cursor:pointer">
						</center>
					</td>
					<td>
					    <input type="hidden" name="sysTimePatchworkTimeFormList[${vstatus.index}].fdWorkId" value = "${sysTimePatchworkForm.fdId}"/>
					    <input type="hidden" name="sysTimePatchworkTimeFormList[${vstatus.index}].fdId" value = "${sysTimePatchworkTimeForm.fdId}"/>
						<input type="text" class="inputSgl" style="width:70%" name="sysTimePatchworkTimeFormList[${vstatus.index}].fdWorkStartTime" value = "${sysTimePatchworkTimeForm.fdWorkStartTime}" readonly/>
					    <a href="#" onclick="selectTime('sysTimePatchworkTimeFormList[${vstatus.index}].fdWorkStartTime');" styleClass="inputsgl" >
						<bean:message key="dialog.selectTime" /></a>
						<span class="txtstrong">*</span>
					</td>	
					<td>
					     <input type="text"   class="inputSgl" style="width:70%"   name="sysTimePatchworkTimeFormList[${vstatus.index}].fdWorkEndTime" value = "${sysTimePatchworkTimeForm.fdWorkEndTime}" readonly/>
					     <a href="#" onclick="selectTime('sysTimePatchworkTimeFormList[${vstatus.index}].fdWorkEndTime');" styleClass="inputsgl" >
						 <bean:message key="dialog.selectTime" /></a>
						 <span class="txtstrong">*</span>
					</td>
				</tr>	
				</c:forEach>
			</table>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="sysTimePatchworkForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>