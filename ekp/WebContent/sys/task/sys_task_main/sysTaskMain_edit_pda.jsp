<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<link type="text/css" rel="stylesheet" href="<c:url value="/sys/task/css/common.css"/>" />
<link type="text/css" rel="stylesheet" href="<c:url value="/sys/task/css/icon/font-mui.css"/>" />
<%@ include file="/sys/task/sys_task_main/sysTaskMain_script.jsp"%>
<script>
    Com_IncludeFile("validator.jsp|validation.js|validation.jsp|xform.js", null, "js");
	Com_IncludeFile("calendar.js|data.js|jquery.js");
</script>
<script type='text/javascript'>
    Com_IncludeFile('kalendae.css','${KMSS_Parameter_ContextPath}third/pda/resource/style/','css',true);
    Com_IncludeFile('kalendae.js','${KMSS_Parameter_ContextPath}third/pda/resource/script/','js',true);
</script>
<script type="text/javascript"> 
function validateSysTaskMainFormData() {
	if (${sysTaskMainForm.method_GET=='add'}) {
		// 比较当前时间和计划完成时间
		var msg = '';
		var curr_time = new Date();
		var strDate = curr_time.getFullYear()+"-";
		strDate += curr_time.getMonth()+1+"-";
		strDate += curr_time.getDate()+" ";
		var strTime = curr_time.getHours()+":";
		strTime += curr_time.getMinutes();
		var _fdPlanCompleteDate = document.getElementsByName("fdPlanCompleteDate")[0];			
		var _fdPlanCompleteTime = document.getElementsByName("fdPlanCompleteTime")[0];
		if (_fdPlanCompleteTime != null && strDate != null && compareDate(_fdPlanCompleteDate.value+" "+_fdPlanCompleteTime.value, strDate+strTime) < 0) {
			msg += '<bean:message key="sys-task:sysTaskMain.min" argKey0="sys-task:sysTaskMain.fdPlanCompleteTime" argKey1="sys-task:sysTaskMain.fdCurrentTime" />' + '\r\n';
		}
		if (msg != '') {
			alert(msg);
			return false;
		}
	}
	return true;
}
function task_submit(){
	if(validateSysTaskMainFormData()){
	   Com_Submit(document.forms[0],'save');
	}  	
  }
</script>
<script type="text/javascript">
	function setDate(year_,month_,date_,hour_,minutes_){
		if(month_ < 10){
			month_ = "0"+month_;
		}
		if(year_ < 10){
			year_ = "0"+year_;
		}
		if(date_ < 10){
			date_ = "0"+date_;
		}
		document.getElementsByName("fdPlanCompleteDate")[0].value=year_ +"-"+month_+"-"+date_;
		document.getElementsByName("fdPlanCompleteTime")[0].value="08:30";
		
	}
	
</script>
     <%
	  	session.setAttribute("S_DocLink","/sys/task/pda/sysTaskMain_pda_index.jsp");
	  %>
<html:form action="/sys/task/sys_task_main/sysTaskMain.do?method=save">
			<div id="div_banner" class="div_banner">
			<script type="text/javascript">
					function gotoList(){		
							if(window.stopBubble)
								window.stopBubble();
							history.back();
					}
				</script>
				<div class="div_return" onclick="gotoList();">
					<div>
						<bean:message bundle="third-pda" key="phone.view.back" />
					</div>
					<div></div>
				</div>
			</div>
<center>
<div style="width:100%">
		<table class="docView" width="100%" id="tbObj">
		<html:hidden property="fdId" />
		<html:hidden property="fdStatus" />
		<html:hidden property="fdRootId" />
		<html:hidden property="docCreatorId" />
		<html:hidden property="fdKey" /> 
		<html:hidden property="fdProgressAuto"  value="true"/>
		<html:hidden property="fdResolveFlag" value="false"/>
		<div style="display:none"><kmss:editNotifyType property="fdNotifyType" /></div>
		<tr>
			<td   width=28%>
			   <div>
					<span class="mui mui-subject mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.docSubject" /></p></div>
			   </div>
			</td>
			<td class="td_common" width=70%>
			<xform:text property="docSubject" className="input2" showStatus="edit" validators="maxLength(200)" style="width:85%" required="true" subject='<%=ResourceUtil.getString(request,"sysTaskMain.docSubject","sys-task")%>'></xform:text>
		    </td>		
		</tr>
		<tr>
			<td   width=28%>
			   <div>
					<span class="mui mui-receive mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMainPerform.fdPerformId" /></p></div>
			   </div>
			</td>
			<td class="td_common" width=70%>
			<script type="text/javascript" src="<c:url value="/third/pda/resource/script/address.js"/>"></script>
			      <label id="_fdPerformId_label"></label>
			      <input type="text" name="fdPerformId"  style="display:none" value="${sysTaskMainForm.fdPerformId}" validate="required" subject='<%=ResourceUtil.getString(request,"sysTaskMainPerform.fdPerformId","sys-task")%>'/>
			      <input type="text" name="fdPerformName" style="display:none" value="${sysTaskMainForm.fdPerformName}"/>
			      <input type="button" class="selectStyle" onclick="Pda_Address('fdPerformId', 'fdPerformName', true, ';', ORG_TYPE_PERSON);"
			        value=''/><span class="txtstrong">*</span>
			</td>		
		</tr>
		<tr>
			<td   width=28%>
			   <div>
					<span class="mui mui-cal mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" /></p></div>
			   </div>
			</td>
			<td class="td_common" width=70%>
			    <div>
			       <ul class="txt_c_date">
                            <li><span onclick="changeDateTime('1');"><bean:message bundle="sys-task"  key="sysTaskMain.DateTime.today" /></span>
								<span onclick="changeDateTime('2');"><bean:message bundle="sys-task"  key="sysTaskMain.DateTime.tomorrow" /></span>
								<span onclick="changeDateTime('3');"><bean:message bundle="sys-task"  key="sysTaskMain.DateTime.after.tomorrow" /></span>
							    <span onclick="changeDateTime('4');"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.next.week" /></span>
								<span onclick="changeDateTime('5');"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.next.month" /></span></li>
                            <li>
                            <span><input name="fdPlanCompleteDate" onblur="__xformDispatch(this.value, this);setWeek(this.value);"  id="fdStartDate" readonly class="auto-kal" value="${sysTaskMainForm.fdPlanCompleteDate }" type="text" style="WIDTH:75px;height:25px" /></span>
                            <span id="weekspan"></span>
                            <span>
                     <select name="fdPlanCompleteTime" onchange="__xformDispatch(this.value, this);" value="" style="width:65px;height:25px">
					<option value="00:00">00:00</option>
					<option value="00:30">00:30</option>
					<option value="01:00">01:00</option>
					<option value="01:30">01:30</option>
					<option value="02:00">02:00</option>
					<option value="02:30">02:30</option>
					<option value="03:00">03:00</option>
					<option value="03:30">03:30</option>
					<option value="04:00">04:00</option>
					<option value="04:30">04:30</option>
					<option value="05:00">05:00</option>
					<option value="05:30">05:30</option>
					<option value="06:00">06:00</option>
					<option value="06:30">06:30</option>
					<option value="07:00">07:00</option>
					<option value="07:30">07:30</option>
					<option value="08:00">08:00</option>
					<option value="08:30">08:30</option>
					<option value="09:00">09:00</option>
					<option value="09:30">09:30</option>
					<option value="10:00">10:00</option>
					<option value="10:30">10:30</option>
					<option value="11:00">11:00</option>
					<option value="11:30">11:30</option>
					<option value="12:00">12:00</option>
					<option value="12:30">12:30</option>
					<option value="13:00">13:00</option>
					<option value="13:30">13:30</option>
					<option value="14:00">14:00</option>
					<option value="14:30">14:30</option>
					<option value="15:00">15:00</option>
					<option value="15:30">15:30</option>
					<option value="16:00">16:00</option>
					<option value="16:30">16:30</option>
					<option value="17:00">17:00</option>
					<option value="17:30">17:30</option>
					<option value="18:00">18:00</option>
					<option value="18:30">18:30</option>
					<option value="19:00">19:00</option>
					<option value="19:30">19:30</option>
					<option value="20:00">20:00</option>
					<option value="20:30">20:30</option>
					<option value="21:00">21:00</option>
					<option value="21:30">21:30</option>
					<option value="22:00">22:00</option>
					<option value="22:30">22:30</option>
					<option value="23:00">23:00</option>
					<option value="23:30">23:30</option>
					</select>			
					</span></li>
                   </ul>
				</div>
			</td>
		</tr>
	    <tr>
			<td   width=28%>
			   <div>
					<span class="mui mui-content mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.docContent" /></p></div>
			   </div>
			</td>
			<td class="td_common" width=70%><textarea name="docContent" class="input2"  style="width:85%"></textarea></td>
		</tr>
		 <tr style="display:none">
			<td   width=28%>
			   <div>
					<span class="mui mui-appoint mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMain.fdAppoint" /></p></div>
			   </div>
			</td>
			<td class="td_common" width=70%>
			<%
			request.setAttribute("fdAppointId",UserUtil.getUser().getFdId());
			request.setAttribute("fdAppointName",UserUtil.getUser().getFdName());
			%>
			<html:hidden property="fdAppointId" value="${fdAppointId}"/> 
			<html:hidden property="fdAppointName" value="${fdAppointName}"/>
			${fdAppointName}
			</td>
		</tr>
		<tr style="display:none">
		<td   width=28%>
		   <div>
					<span class="mui mui-copy mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p><bean:message bundle="sys-task" key="sysTaskMainCc.fdCcId" /></p></div>
		   </div>
		</td>
			<td class="td_common" width=70%>
			      <html:hidden property="fdCcIds" value=""/>
			      <html:hidden property="fdCcNames" value=""/>
			      <input type="button" class="selectStyle" onclick="Pda_Address('fdCcIds', 'fdCcNames', true, ';', ORG_TYPE_ALL);" 
			        value=''/>	
			</td>
		</tr>
		<tr style="display:none">
		   <td width="28%"  >
		      <div>
					<span class="mui mui-sync mui-1x titleSpan fontColor"></span>
					<div class="titleName"><p>同步方式</p></div>
		     </div>
		   </td>
		   <td class="td_common" width="70%">
		       <xform:radio property="syncDataToCalendarTime" showStatus="edit">
		       		<xform:enumsDataSource enumsType="sysTaskMain_syncDataToCalendarTime" />
				</xform:radio>
		   </td>
		</tr>
		<tr style="display:none">
			<td style="padding: 0px;" colspan="2">
				 <c:import url="/sys/agenda/import/sysAgendaMain_general_pda_edit.jsp"	charEncoding="UTF-8">
			    	<c:param name="formName" value="sysTaskMainForm" />
			    	<c:param name="fdKey" value="taskMainDoc" />
			    	<c:param name="fdPrefix" value="sysAgendaMain_formula_edit" />
			    	<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
			    	<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
					<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
					<c:param name="noSyncTimeValues" value="noSync" />
			 	</c:import>
			</td>
		</tr>
	</table>
	<div class="com_btnBox">
	    <a href="javascript:void(0);" onclick="showCondiction(this);" id="showMoreSet" data-status="0" class="task_slideDown">
		<bean:message bundle="sys-task" key="sysTaskMain.more.set.slideDown" />
		</a>
    </div>
	<div class="com_btnBox">
            <input type="button" id="btn_submit" value="<bean:message key="button.submit"/>" class="button_one" onclick="task_submit();"/>
    </div>
	</div>
	</center>
	<html:hidden property="method_GET" />
</html:form>
<script language="JavaScript">
		$KMSSValidation(document.forms['sysTaskMainForm']);
</script>
