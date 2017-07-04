<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("doclist.js|jquery.js");
</script>
<script type="text/javascript">
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
			alert('<bean:message  bundle="sys-time" key="sysTimeWork.validate"/>');
			return false;
		}
	}
	
	var startWeek = document.getElementsByName("fdWeekStartTime")[0];
	var endWeek = document.getElementsByName("fdWeekEndTime")[0];
	if(startWeek.value !="" && endWeek.value !=""){
		if(endWeek.value < startWeek.value){
			alert('<bean:message  bundle="sys-time" key="sysTimeWork.week.explanation"/>');
			return false;
		}
	}
	
	var timeArray = new Array();
	var timeRange = null;
	for(var i=0; true; i++){
		var workStartTime = document.getElementsByName("sysTimeWorkTimeFormList[" + i + "].fdWorkStartTime");
		var workEndTime = document.getElementsByName("sysTimeWorkTimeFormList[" + i + "].fdWorkEndTime");
		if(workStartTime.length==0){
			if(i==0){
				alert('<bean:message  bundle="sys-time" key="sysTimeWorkTime.time.null"/>');
				return false;
			}
			break;
		}
		if(workStartTime[0].value == "" ){
			alert('<bean:message  bundle="sys-time" key="sysTimeWorkTime.fdWorkStartTime.validate"/>');
			return false;
		}
		if(workEndTime[0].value == "" ){
			alert('<bean:message  bundle="sys-time" key="sysTimeWorkTime.fdWorkEndTime.validate"/>');
			return false;
		}
		time = compareTime(workEndTime[0].value,workStartTime[0].value);
		if(time <= 0){
			alert('<bean:message  bundle="sys-time" key="sysTimeWorkTime.validate"/>');
			return false;
		}
		timeRange = new Object();
		timeRange.start = workStartTime[0].value;
		timeRange.end = workEndTime[0].value;
		timeArray[timeArray.length] = timeRange;
	}
	//班次交错比较
	timeArray = timeArray.sort(timeComparer);
	for(var i = 1 ; i<timeArray.length ; i++){
		if(compareTime(timeArray[i].start,timeArray[i-1].end)<=0){
			alert('<bean:message bundle="sys-time" key="sysTimeWorkTime.time.compare"/>');
			return false;
		}
	}
	return true;
}

function checkWeekCue(){
	var startWeek = document.getElementsByName("fdWeekStartTime")[0];
	var endWeek = document.getElementsByName("fdWeekEndTime")[0];
	if(startWeek.value !="" && endWeek.value !=""){
		var weekCue = document.getElementById("weekCue");
		if(endWeek.value < startWeek.value){
			//weekCue.innerText = "<bean:message  bundle="sys-time" key="sysTimeWork.week.explanation"/>";
			$(weekCue).text("<bean:message  bundle="sys-time" key="sysTimeWork.week.explanation"/>");
		}else{
			//weekCue.innerText = "您选择的日期范围为：";
			$(weekCue).text("您选择的日期范围为：");
			if("textContent" in weekCue){
				for(var i=startWeek.value;i<=endWeek.value;i++){
					if(i=='1'){
						weekCue.textContent += "<bean:message key="date.weekDay0"/>";
					}else if(i=='2'){
						weekCue.textContent += "<bean:message key="date.weekDay1"/>";
					}else if(i=='3'){
						weekCue.textContent += "<bean:message key="date.weekDay2"/>";
					}else if(i=='4'){
						weekCue.textContent += "<bean:message key="date.weekDay3"/>";
					}else if(i=='5'){
						weekCue.textContent += "<bean:message key="date.weekDay4"/>";
					}else if(i=='6'){
						weekCue.textContent += "<bean:message key="date.weekDay5"/>";
					}else if(i=='7'){
						weekCue.textContent += "<bean:message key="date.weekDay6"/>";
					}
					if(endWeek.value - startWeek.value>=1&&i!=endWeek.value){
						weekCue.textContent += "、";
					}
				}
			}else{
				for(var i=startWeek.value;i<=endWeek.value;i++){
					if(i=='1'){
						weekCue.innerText += "<bean:message key="date.weekDay0"/>";
					}else if(i=='2'){
						weekCue.innerText += "<bean:message key="date.weekDay1"/>";
					}else if(i=='3'){
						weekCue.innerText += "<bean:message key="date.weekDay2"/>";
					}else if(i=='4'){
						weekCue.innerText += "<bean:message key="date.weekDay3"/>";
					}else if(i=='5'){
						weekCue.innerText += "<bean:message key="date.weekDay4"/>";
					}else if(i=='6'){
						weekCue.innerText += "<bean:message key="date.weekDay5"/>";
					}else if(i=='7'){
						weekCue.innerText += "<bean:message key="date.weekDay6"/>";
					}
					if(endWeek.value - startWeek.value>=1&&i!=endWeek.value){
						weekCue.innerText += "、";
					}
				}
			}
		}
	}
}

function timeComparer(t1, t2){
	return compareTime(t1.start,t2.start);
}
</script>
<html:form action="/sys/time/sys_time_work/sysTimeWork.do" onsubmit="return validateSysTimeWorkForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTimeWorkForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="if(submited())Com_Submit(document.sysTimeWorkForm, 'update');">
	</c:if>
	<c:if test="${sysTimeWorkForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if(submited())Com_Submit(document.sysTimeWorkForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if(submited())Com_Submit(document.sysTimeWorkForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="top.close();">
</div>

<p class="txttitle"><bean:message  bundle="sys-time" key="table.sysTimeWork"/></p>

<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<html:hidden property="sysTimeAreaId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.validTime"/>
		</td>
		<td width=85% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimeWork.validTime.start"/>
			<html:text property="fdStartTime" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectDate('fdStartTime');">
			<bean:message key="dialog.selectTime" /></a>
			<span class="txtstrong">*</span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimeWork.validTime.end"/>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<html:text property="fdEndTime" readonly="true" styleClass="inputsgl"/>
			<a href="#" onclick="selectDate('fdEndTime');">
			<bean:message key="dialog.selectTime" /></a>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<span class="txtstrong"><bean:message  bundle="sys-time" key="sysTimeWork.validTime.explanation"/></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.week"/>
		</td><td width=85% colspan=3>
			<bean:message  bundle="sys-time" key="sysTimeWork.week.start"/>
			<sunbor:enums property="fdWeekStartTime" enumsType="common_week_type" elementType="select" htmlElementProperties="onchange=checkWeekCue();"/>&nbsp;&nbsp;
			<bean:message  bundle="sys-time" key="sysTimeWork.week.end"/>
			<sunbor:enums property="fdWeekEndTime" enumsType="common_week_type" elementType="select" htmlElementProperties="onchange=checkWeekCue();"/>&nbsp;&nbsp;
			<span id="weekCue" class="txtstrong"></span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.docCreatorId"/>
		</td><td width=35%>
			${sysTimeWorkForm.docCreatorName}			
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-time" key="sysTimeWork.docCreateTime"/>
		</td><td width=35%>
			${sysTimeWorkForm.docCreateTime}
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
						<bean:message  bundle="sys-time" key="sysTimeWorkTime.fdWorkStartTime"/>
					</td>
					<td class="td_normal_title" align="center" width=45%>
						<bean:message  bundle="sys-time" key="sysTimeWorkTime.fdWorkEndTime"/>
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
					     <input type="hidden"  class="inputSgl"   name="sysTimeWorkTimeFormList[!{index}].fdWorkId" value = "${sysTimeWorkForm.fdId}"/>
					     <input type="hidden"  class="inputSgl"   name="sysTimeWorkTimeFormList[!{index}].fdId" value = ""/>
					     <input type="text"   class="inputSgl" style="width:70%" name="sysTimeWorkTimeFormList[!{index}].fdWorkStartTime" value = "" readonly/>
					     <a href="#" onclick="selectTime('sysTimeWorkTimeFormList[!{index}].fdWorkStartTime');" styleClass="inputsgl" >
						 <bean:message key="dialog.selectTime" /></a>
						 <span class="txtstrong">*</span>
					</td>
					<td>
					     <input type="text"   class="inputSgl" style="width:70%"   name="sysTimeWorkTimeFormList[!{index}].fdWorkEndTime" value = "" readonly/>
					     <a href="#" onclick="selectTime('sysTimeWorkTimeFormList[!{index}].fdWorkEndTime');" styleClass="inputsgl" >
						 <bean:message key="dialog.selectTime" /></a>
						 <span class="txtstrong">*</span>
					</td>					
				</tr>
				<c:forEach items="${sysTimeWorkForm.sysTimeWorkTimeFormList}" var="sysTimeWorkTimeForm" varStatus="vstatus">
				<tr KMSS_IsContentRow="1">
					<td>
						<center>
						<img src="${KMSS_Parameter_StylePath}icons/delete.gif"
									onclick="delete_WorkTime();" style="cursor:pointer">
						</center>
					</td>
					<td>
					    <input type="hidden"   name="sysTimeWorkTimeFormList[${vstatus.index}].fdWorkId" value = "${sysTimeWorkForm.fdId}"/>
					    <input type="hidden"   name="sysTimeWorkTimeFormList[${vstatus.index}].fdId" value = "${sysTimeWorkTimeForm.fdId}"/>
						<input type="text"   class="inputSgl" style="width:70%" name="sysTimeWorkTimeFormList[${vstatus.index}].fdWorkStartTime" value = "${sysTimeWorkTimeForm.fdWorkStartTime}" readonly/>
					    <a href="#" onclick="selectTime('sysTimeWorkTimeFormList[${vstatus.index}].fdWorkStartTime');" styleClass="inputsgl" >
						<bean:message key="dialog.selectTime" /></a>
						<span class="txtstrong">*</span>
					</td>	
					<td>
					     <input type="text"   class="inputSgl" style="width:70%"   name="sysTimeWorkTimeFormList[${vstatus.index}].fdWorkEndTime" value = "${sysTimeWorkTimeForm.fdWorkEndTime}" readonly/>
					     <a href="#" onclick="selectTime('sysTimeWorkTimeFormList[${vstatus.index}].fdWorkEndTime');" styleClass="inputsgl" >
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
<script language="JavaScript">
	Com_IncludeFile("calendar.js");
	checkWeekCue();
</script>
<html:javascript formName="sysTimeWorkForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>