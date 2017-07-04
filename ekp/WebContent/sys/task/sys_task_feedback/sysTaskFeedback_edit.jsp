<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
<!--
    var sliderImage;
	Com_IncludeFile("calendar.js");
	var progress;
	var currentProgress = "0";
	function onSubmit(obj){
		if(validateSysTaskFeedbackForm(obj)){
			var fdCompleteTime = document.sysTaskFeedbackForm.fdCompleteTime.value;
			var fdCompleteDate = document.sysTaskFeedbackForm.fdCompleteDate.value;
			document.sysTaskFeedbackForm.fdCompleteDateTime.value = fdCompleteDate+" "+fdCompleteTime;	
			return true;		
		}
	}
	function clickCheckBox(obj){
		if(obj.checked){
			document.getElementsByName("fdProgressAuto")[0].value="true";
			document.getElementsByName("fdProgress")[0].disabled = "true";
			currentProgress = document.getElementsByName("fdProgress")[0].value;
			document.getElementsByName("fdProgress")[0].value = progress;			
			document.getElementById("sliderProcess").style.display = "none";		
		}else{
			document.getElementsByName("fdProgressAuto")[0].value="false";
			document.getElementsByName("fdProgress")[0].disabled = "";
			document.getElementsByName("fdProgress")[0].value = currentProgress;
			document.getElementById("sliderProcess").style.display = "";
			sliderImage.setValue(getElementById('fdProgress').value)
			
		}
	}
	function initCheckBox(obj){
		if(obj == 'true'){
			document.getElementsByName("fdProgressAuto")[0].value="true";
			document.getElementsByName("fdProgress")[0].disabled = "true";
			document.getElementById("sliderProcess").style.display = "none";
		}else{
			document.getElementById("fdProgreeAuto_id").style.display="none";
			document.getElementsByName("fdProgressAuto")[0].value="false";
			document.getElementsByName("fdProgress")[0].disabled = "";
			document.getElementById("sliderProcess").style.display = "";
		}
	}
//-->
</script>
<html:form action="/sys/task/sys_task_feedback/sysTaskFeedback.do" onsubmit="return onSubmit(this);">
<div id="optBarDiv">
	<c:if test="${sysTaskFeedbackForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskFeedbackForm, 'update');">
	</c:if>
	<c:if test="${sysTaskFeedbackForm.method_GET=='add' || sysTaskFeedbackForm.method_GET=='quoteAdd'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskFeedbackForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskFeedback"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdTaskId"/>
		<html:hidden property="fdCompleteDateTime"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdAppoint"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdAppointName}"/>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMainPerform.fdPerformId"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPerformName}"/>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdParentId"/>
		</td><td width=35%>
			<c:choose> 
				<c:when test="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName != null}">
					<c:out
					value="${sysTaskFeedbackForm.sysTaskMainForm.fdParentName}" />
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>	
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdSourceSubject"/>
		</td><td width=35%>
			<c:choose> 
				<c:when test="${not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject && not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}">
					<a href='<c:url value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
						<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject}" />
					</a>
				</c:when>
				<c:when test="${not empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject && empty sysTaskFeedbackForm.sysTaskMainForm.fdSourceUrl}">
					<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdSourceSubject}" />
				</c:when>
				<c:otherwise>
					<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
				</c:otherwise>
			</c:choose>			
		</td>
	</tr>
		
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
		</td><td width=35%>
			<a href="../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskFeedbackForm.sysTaskMainForm.fdId}"  target="_blank"><c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docSubject}"/></a>		
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteDate}"/>&nbsp;<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.fdPlanCompleteTime}"/>	
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docContent"/>
		</td><td width=85% colspan=3>
			<c:out value="${sysTaskFeedbackForm.sysTaskMainForm.docContent}" escapeXml="false"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-task" key="sysTaskMain.pastdue.yesno"/>
		</td><td width=85% colspan=3>
			<sunbor:enumsShow value="${sysTaskFeedbackForm.fdPastDue}" enumsType="sys_task_yesno"></sunbor:enumsShow>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdProgress"/>
		</td><td width=85% colspan=3>
			<html:text style="width:25px" property="fdProgress" onchange="sliderImage.setValue(document.getElementsByName('fdProgress')[0].value)"/>%
			<span id="fdProgreeAuto_id">
			<input type="hidden"  name="fdProgressAuto"  value="${sysTaskFeedbackForm.sysTaskMainForm.fdProgressAuto}" onclick="clickCheckBox(this);"/>
			<input type="checkbox"  name="fdProgressAuto" checked  onclick="clickCheckBox(this);"/>
			<bean:message bundle="sys-task" key="sysTaskMain.fdProgressAuto" /><div id="sliderProcess" style="height:15px;margin:5px 0px 5px 0px"></div></span> 		
	    <style type="text/css" media="all">
		.imageSlider { margin:0;padding:0; height:20px; width:285px; background-image:url("${KMSS_Parameter_ContextPath}sys/task/images/horizBg.png"); }
		.imageBar    { margin:0;padding:0; height:15px; width:14px; background-image:url("${KMSS_Parameter_ContextPath}sys/task/images/horizSlider.png"); }
 		</style>
	    	<script type="text/javascript" src="${KMSS_Parameter_ContextPath}sys/task/js/slider_extras.js"></script>
	        <script type="text/javascript">
			 sliderImage = new neverModules.modules.slider(
				{targetId: "sliderProcess",
					sliderCss: "imageSlider",
					barCss: "imageBar",
					min: 0,
					max: 100,
					hints: ""
				});
				sliderImage.onstart  = function () {
					
					document.getElementsByName("fdProgress")[0].value = sliderImage.getValue();
				}
				sliderImage.onchange = function () {
					document.getElementsByName("fdProgress")[0].value = sliderImage.getValue();
				};
				sliderImage.onend = function () {
					document.getElementsByName("fdProgress")[0].value = sliderImage.getValue();
				}
				sliderImage.create();
				window.onload=function (){
					sliderImage.setValue(document.getElementsByName("fdProgress")[0].value);
				};
        </script>

			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdCompleteTime"/>
		</td><td width=85% colspan=3>
			<html:text property="fdCompleteDate" size="10"/><span class="txtstrong">*</span><a href="#" onclick="selectDate('fdCompleteDate');"><bean:message key="dialog.selectOrg" /></a>
			<html:text property="fdCompleteTime" size="4"/><span class="txtstrong">*</span><a href="#" onclick="selectTime('fdCompleteTime');"><bean:message key="dialog.selectOrg" /></a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.docContent"/>
		</td><td width=85% colspan=3>
			<kmss:editor property="docContent" height="300" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.attachment"/>
		</td><td width=85% colspan=3>
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="attachment"/>
			</c:import>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreatorId"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.docCreatorName}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskFeedbackForm.docCreateTime}"/>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskFeedback.fdNotifyType"/>
		</td><td width=35%>
			<sunbor:multiSelectCheckbox formName="sysTaskFeedbackForm"  enumsType="sysTaskFreedback_fdNotifyType" property="fdNotifyTypeList"></sunbor:multiSelectCheckbox>
		</td>
		<td class="td_normal_title" width="15%"><bean:message
						bundle="sys-task" key="sysTaskFeedback.fdNotifyWay" /></td>
		<td width="35%"><kmss:editNotifyType  property="fdNotifyWay" /></td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTaskFeedbackForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<script>
initCheckBox("${sysTaskFeedbackForm.sysTaskMainForm.fdProgressAuto}");
progress = document.sysTaskFeedbackForm.fdProgress.value;
currentProgress = progress;
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>