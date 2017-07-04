<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
	Com_IncludeFile("data.js|dialog.js|calendar.js|jquery.js");
</script>
<script type="text/javascript">
<!--
	function checkProgressAutoBox(obj){
		if(obj.checked){
			document.getElementsByName("fdProgressAuto")[0].value="true";
			document.getElementsByName("fdProgressAuto")[1].value="true";
		}else{
			document.getElementsByName("fdProgressAuto")[0].value="false";
			document.getElementsByName("fdProgressAuto")[1].value="false";
		}
	}
	function checkResolveFlagBox(obj){
		if(obj.checked){
			document.getElementsByName("fdResolveFlag")[0].value="true";
			document.getElementsByName("fdResolveFlag")[1].value="true";
		}else{
			document.getElementsByName("fdResolveFlag")[0].value="false";
			document.getElementsByName("fdResolveFlag")[1].value="false";
		}
	}
//-->
</script>
<style type="text/css">
<!--
.STYLE1 {
	color: #FF0000
}
-->
</style>
<script type="text/javascript">
	function setDate(year_,month_,date_){
		if(month_ < 10){
			month_ = "0"+month_;
		}
		if(year_ < 10){
			year_ = "0"+year_;
		}
		if(date_ < 10){
			date_ = "0"+date_;
		}
		
		document.sysTaskMainForm.fdPlanCompleteDate.value=year_ +"-"+month_+"-"+date_;
		document.sysTaskMainForm.fdPlanCompleteTime.value="00:00";
	}
	
	function changeDateTime(obj){
		var _date = new Date();
		var month_ = getMonth(_date);
		var year_ = getYear(_date);
		var date_  = getDate(_date);
		var hour_ = getHours(_date);
		var minutes_ = getMinutes(_date);
		if(obj == '1'){
			 month_ = getMonth(_date);
			 year_ = getYear(_date);
			 date_  = getDate(_date);
			 hour_ = getHours(_date);
			 minutes_ = getMinutes(_date);
			 setDate(year_,month_,date_);
		}
		if(obj == '2'){
			_date.setDate(_date.getDate()+1);
			 month_ = getMonth(_date);
			  year_ = getYear(_date);
			 date_  = getDate(_date);
			 hour_ = getHours(_date);
			 minutes_ = getMinutes(_date);
			 setDate(year_,month_,date_);
		}
		if(obj == '3'){
			_date.setDate(_date.getDate()+2);
			month_ = getMonth(_date);
			 year_ = getYear(_date);
			 date_  = getDate(_date);
			 hour_ = getHours(_date);
			 minutes_ = getMinutes(_date);
			 setDate(year_,month_,date_);
		}
		if(obj == '4'){
			_date.setDate(_date.getDate()+7);
			month_ = getMonth(_date);
			 year_ = getYear(_date);
			 date_  = getDate(_date);
			 hour_ = getHours(_date);
			 minutes_ = getMinutes(_date);
			 setDate(year_,month_,date_);
		}
		if(obj == '5'){
			_date.setMonth(_date.getMonth()+1);
			 month_ = getMonth(_date);
			 year_ = getYear(_date);
			 date_  = getDate(_date);
			 hour_ = getHours(_date);
			 minutes_ = getMinutes(_date);
			 setDate(year_,month_,date_);
		}
	}
	function getMinutes(obj){
		return obj.getMinutes();
	}
	function getHours(obj){
		return obj.getHours();
	}
	function getDate(obj){
		return obj.getDate();
	}
	function getMonth(obj){
		return obj.getMonth()+1;
	}
	function getYear(obj){
		//return obj.getYear();
		return obj.getFullYear();
	}
	function showMoreSet(){
		if(document.getElementById("show_more_set_id").style.display==""){
			document.getElementById("show_more_set_id").style.display="none";
		}else{
			document.getElementById("show_more_set_id").style.display="";
		}
		
	}
	function Com_Submit_update(){
		if(document.getElementsByName("fdProgressAuto")[1].checked){
			document.getElementsByName("fdProgressAuto")[0].value="true";
			document.getElementsByName("fdProgressAuto")[1].value="true";	
		}else{
			document.getElementsByName("fdProgressAuto")[0].value="false";
			document.getElementsByName("fdProgressAuto")[1].value="false";	
		}
		if(document.getElementsByName("fdResolveFlag")[1].checked){
			document.getElementsByName("fdResolveFlag")[0].value="true";
			document.getElementsByName("fdResolveFlag")[1].value="true";	
		}else{
			document.getElementsByName("fdResolveFlag")[0].value="false";
			document.getElementsByName("fdResolveFlag")[1].value="false";	
		}
		var parentId = document.getElementsByName("fdParentId")[0].value;
		if( parentId != null && parentId != undefined && parentId != ''){
			var currentWeight = document.getElementsByName("fdWeights")[0].value;	
			if(isNaN(currentWeight)){
				alert("<bean:message bundle='sys-task' key='sysTaskMain.fdWeights.message.number'/>");
				return;	
			}else{	
				var tempWeight = parseInt(currentWeight);
				if(tempWeight!=currentWeight){
					alert("<bean:message bundle='sys-task' key='sysTaskMain.fdWeights.message.integer'/>");
					return;
				}
			}
		}
		Com_Submit(document.sysTaskMainForm, 'update')
	}
	function calculateParentWeight(){
		var currentWeight = document.getElementsByName("fdWeights")[0].value;	
		if(isNaN(currentWeight)){
			alert("<bean:message bundle='sys-task' key='sysTaskMain.fdWeights.message.number'/>");
			return;	
		}else{	
			var tempWeight = parseInt(currentWeight);
			if(tempWeight!=currentWeight){
				alert("<bean:message bundle='sys-task' key='sysTaskMain.fdWeights.message.integer'/>");
				return;
			}
		}
		var otherWeight = document.getElementsByName("fdOtherChildWeights")[0].value;
		var allWeight = parseFloat(currentWeight)+parseFloat(otherWeight);
		if(otherWeight==0){
			$(document.getElementById("parentWeight")).text(100);
		}else{
			var percent = (100/allWeight)*parseInt(currentWeight);
			$(document.getElementById("parentWeight")).text(Math.round(percent*100)/100);
		}
	}
	function putQuickSelectValue(rtnVal){
		var creatorId = document.getElementsByName("docCreatorId")[0].value;
		var quickSelect = document.getElementById("select_quick");
		var kmssData = new KMSSData();
		kmssData.AddBeanData("sysTaskMainTreeService&creatorId="+creatorId);
		var selectData = kmssData.GetHashMapArray();
		for(var j =1 ; j < quickSelect.options.length; j++){
			quickSelect.options.remove(1);
		}
		for(var i = 0; i< selectData.length; i++){
			quickSelect.options.add(new Option(selectData[i]['name'],selectData[i]['id'])); 
		}		
	}
	function changePerform(obj){
		  if(obj.selectedIndex != 0){
			  var performId=obj.options[obj.selectedIndex].value;    
	          var performName=obj.options[obj.selectedIndex].text;    
	          document.getElementsByName("fdPerformId")[0].value = performId;
	          document.getElementsByName("fdPerformName")[0].value = performName;
		  }
	}
	function validateSysTaskMainFormData(thisObj) {
		var temp = validateSysTaskMainForm(thisObj);
		if (temp && ${sysTaskMainForm.method_GET=='add'}) {
			// 比较当前时间和计划完成时间
			var msg = '';
			var curr_time = new Date();
			var strDate = curr_time.getFullYear()+"-";
			strDate += curr_time.getMonth()+1+"-";
			strDate += curr_time.getDate()+" ";
			var strTime = curr_time.getHours()+":";
			strTime += curr_time.getMinutes();
			var _fdPlanCompleteDate = document.getElementById("fdPlanCompleteDate");			
			var _fdPlanCompleteTime = document.getElementById("fdPlanCompleteTime");
			//alert(_fdPlanCompleteDate.value+" "+_fdPlanCompleteTime.value+"-------------------"+strDate+strTime);
			if (_fdPlanCompleteTime != null && strDate != null && compareDate(_fdPlanCompleteDate.value+" "+_fdPlanCompleteTime.value, strDate+strTime) < 0) {
				msg += '<bean:message key="sys-task:sysTaskMain.min" argKey0="sys-task:sysTaskMain.fdPlanCompleteTime" argKey1="sys-task:sysTaskMain.fdCurrentTime" />' + '\r\n';
			}
			if (msg != '' && ${sysTaskMainForm.method_GET=='add'} ) {
				alert(msg);
				return false;
			}
		}
		return temp;
	}
</script>
<html:form action="/sys/task/sys_task_main/sysTaskMain.do"
	onsubmit="return validateSysTaskMainFormData(this);">
	<div id="optBarDiv">
	<c:if
		test="${sysTaskMainForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit_update();">
	</c:if> 
	<c:if test="${sysTaskMainForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskMainForm, 'save');">
		<!-- <input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTaskMainForm, 'saveadd');"> -->
	</c:if> 
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="sys-task"
		key="table.sysTaskMain" /></p>

	<center>
	<table class="tb_normal" width="95%">
		<html:hidden property="fdId" />
		<html:hidden property="fdStatus" />
		<html:hidden property="fdRootId" />
		<html:hidden property="docCreatorId" />
		<html:hidden property="fdWorkId" />
		<html:hidden property="fdPhaseId" />
		<html:hidden property="fdModelId" /> 
		<html:hidden property="fdModelName" />
		<html:hidden property="fdKey" />
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.docSubject" /></td>
			<td width="35%"><html:text property="docSubject"
				style="width:80%" /><span class="txtStrong">*</span></td>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.fdAppoint" /></td>
			<td width="35%"><html:hidden property="fdAppointId" /> <html:text
				property="fdAppointName" styleClass="inputsgl" style="35%" readonly="true" /><span
				class="txtStrong">*</span> <a href="#"
				onclick="Dialog_Address(false, 'fdAppointId','fdAppointName', ';',ORG_TYPE_PERSON,putQuickSelectValue);">
			<bean:message key="dialog.selectOrg" /></a></td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" /></td>
			<td width="35%" colspan=3><html:text
				property="fdPlanCompleteDate" size="10"  readonly="true" styleClass="inputsgl"/> <span class="txtStrong">*</span><a
				href="#" onclick="selectDate('fdPlanCompleteDate');"><bean:message
				key="dialog.selectOrg" /></a> <html:text property="fdPlanCompleteTime"
				size="4" readonly="true" styleClass="inputsgl"/><a href="#" onclick="selectTime('fdPlanCompleteTime');"><span class="txtStrong">*</span><bean:message
				key="dialog.selectOrg" /></a> <select name="select_time"
				onChange="changeDateTime(this.value)">
				<option value="0"><bean:message bundle="sys-task"
					key="sysTaskMain.quick.select" /></option>
				<option value="1"><bean:message bundle="sys-task"
					key="sysTaskMain.DateTime.today" /></option>
				<option value="2"><bean:message bundle="sys-task"
					key="sysTaskMain.DateTime.tomorrow" /></option>
				<option value="3"><bean:message bundle="sys-task"
					key="sysTaskMain.DateTime.after.tomorrow" /></option>
				<option value="4"><bean:message bundle="sys-task"
					key="sysTaskMain.DateTime.next.week" /></option>
				<option value="5"><bean:message bundle="sys-task"
					key="sysTaskMain.DateTime.next.month" /></option>
			</select></td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMainPerform.fdPerformId" /></td>
			<td width="35%"><html:hidden property="fdPerformId" /> <html:text
				property="fdPerformName" styleClass="inputsgl"  readonly="true" /><span
				class="txtStrong">*</span> <a href="#"
				onclick="Dialog_Address(true, 'fdPerformId','fdPerformName', ';',ORG_TYPE_PERSON);">
			<bean:message key="dialog.selectOrg" /></a>			
			<select id="select_quick" onchange="changePerform(this);">
				<option value="0"><bean:message bundle="sys-task" key="sysTaskMain.quick.select"/></option>
			</select>
			</td>
			
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMainCc.fdCcId" /></td>
			<td width="35%"><html:hidden property="fdCcIds" /> <html:text
				property="fdCcNames" style="width:60%" styleClass="inputsgl" readonly="true" /> <a
				href="#"
				onclick="Dialog_Address(true, 'fdCcIds','fdCcNames', ';',ORG_TYPE_ALL);">
			<bean:message key="dialog.selectOrg" /></a></td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.fdParentId" /></td>
			<td width="35%"><html:hidden property="fdParentId" />
			<c:choose> 
				<c:when test="${sysTaskMainForm.fdParentName != null}">
					<c:out
					value="${sysTaskMainForm.fdParentName}" />
					<html:hidden property="fdParentId"/>
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>
			</td>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.fdSourceSubject" /></td>
			<td width="35%">
			<c:choose> 
				<c:when test="${not empty sysTaskMainForm.fdSourceSubject && not empty sysTaskMainForm.fdSourceUrl}">
					<a href='<c:url value="${sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
						<c:out value="${sysTaskMainForm.fdSourceSubject}" />
					</a>
					<html:hidden property="fdSourceSubject"/>
					<html:hidden property="fdSourceUrl"/>
				</c:when>
				<c:when test="${not empty sysTaskMainForm.fdSourceSubject && empty sysTaskMainForm.fdSourceUrl}">
					<c:out value="${sysTaskMainForm.fdSourceSubject}" />
					<html:hidden property="fdSourceSubject"/>
					<html:hidden property="fdSourceUrl"/>
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.docContent" /></td>
			<td colspan="3"><kmss:editor property="docContent" height="300" /></td>
		</tr>
		
		<tr>
			<td class="td_normal_title" width="15%"><bean:message
				bundle="sys-task" key="sysTaskMain.attachment" /></td>
			<td colspan="3"><c:import
				url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
				charEncoding="UTF-8">
				<c:param name="fdKey" value="attachment" />
				<c:param name="fdModelId" value="${sysTaskMainForm.fdId }" />
				<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
			</c:import></td>
		</tr>
		<tr>
			<td colspan=4><a href="#" onclick="showMoreSet();"><bean:message
				bundle="sys-task" key="sysTaskMain.more.set.message" /></a></td>
		</tr>
		<tr id="show_more_set_id" style="display: none">
			<td width="100%" colspan=4>
			<table width="100%" class="tb_normal" height="100%">
				<tr>
					<td class="td_normal_title" colspan="4" width="15%">
					<input
						type="hidden" name="fdResolveFlag" />
					<html:checkbox
						property="fdResolveFlag" onclick="checkResolveFlagBox(this);" /> <bean:message bundle="sys-task"
						key="sysTaskMain.fdResolveFlag" /></td>
				</tr>
				<tr>
					<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-task" key="sysTaskFeedback.fdProgress" /></td>
					<td width=85% colspan=3><html:hidden property="fdProgress" />
					<html:hidden
						property="fdProgressAuto" />
					<html:checkbox property="fdProgressAuto"
						onclick="checkProgressAutoBox(this)" /> <bean:message bundle="sys-task"
						key="sysTaskMain.fdProgressAuto" /></td>
				</tr>
				<tr>
					<c:choose>
						<c:when test="${sysTaskMainForm.fdParentId != null}">
							<td class="td_normal_title" width="15%"><bean:message
								key="sysTaskMain.fdCategoryId" bundle="sys-task" /></td>
							<td width="35%">							
							<kmss:dropList property="fdCategoryId"
								serviceBean="sysTaskCategoryService" whereBlock="sysTaskCategory.fdIsAvailable = 1" orderBy="sysTaskCategory.fdOrder asc"></kmss:dropList></td>
							<td class="td_normal_title" width=15%><bean:message
								bundle="sys-task" key="sysTaskMain.fdWeights" /></td>
							<td width=35%><!-- 权重 --> <html:text property="fdWeights" size="3"  onchange = "calculateParentWeight()"/>
							<html:hidden property="fdOtherChildWeights" /><bean:message bundle="sys-task"
								key="sysTaskMain.fdWeights.message" />
								<span id = "parentWeight"><c:out value="${sysTaskMainForm.fdParentWeights}"/></span>%
								</td>
						</c:when>
						<c:otherwise>
							<td class="td_normal_title" width="15%"><bean:message
								key="sysTaskMain.fdCategoryId" bundle="sys-task" /></td>
							<td width="85%" colspan=3><kmss:dropList property="fdCategoryId"
								serviceBean="sysTaskCategoryService" whereBlock="sysTaskCategory.fdIsAvailable = 1" orderBy="sysTaskCategory.fdOrder asc"></kmss:dropList>
							</td>
						</c:otherwise>
					</c:choose>
				</tr>
				<tr>
					<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-task" key="sysTaskMainReader.docReaderIds" /></td>
					<td colspan="3"><html:hidden property="docReaderIds" />
					 <html:text property="docReaderNames" style="width:90%" readonly="true" styleClass="inputsgl" /> 
					 <a
						href="#"
						onclick="Dialog_Address(true, 'docReaderIds','docReaderNames', ';', ORG_TYPE_ALL);">
					<bean:message key="dialog.selectOrg" /></a><br>
					<bean:message bundle="sys-task"
						key="sysTaskMainReader.docReaderIds.message" /></td>
				</tr>
				<tr>

					<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-task" key="sysTaskMain.fdNotifyType" /></td>
					<td width="35%" colspan=3><kmss:editNotifyType
						property="fdNotifyType" /></td>
				</tr>
				<tr>
					<td class="td_normal_title"><bean:message bundle="sys-task"
						key="sysTaskMain.docCreatorId" /></td>
					<td><html:text property="docCreatorName" readonly="true" /></td>
					<td class="td_normal_title"><bean:message bundle="sys-task"
						key="sysTaskMain.docCreateTime" /></td>
					<td><html:text property="docCreateTime" readonly="true" /></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<html:javascript formName="sysTaskMainForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<script type="text/javascript">
putQuickSelectValue(null);
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
