<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script src="/resource/js/data.js">
</script>
<script>

	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
function confirmStop(msg){
	var del = confirm(msg);
	return del;
}
function confirmAttention(){
	var rtn = confirm("<bean:message bundle="sys-task" key="button.attention.confirm.message"/>");
	return rtn;
}
function noconfirmAttention(){
	var rtn = confirm("<bean:message bundle="sys-task" key="button.noattention.confirm.message"/>");
	return rtn;
}
function showMoreSet(){
	if(document.getElementById("show_more_set_id").style.display==""){
		document.getElementById("show_more_set_id").style.display="none";
	}else{
		document.getElementById("show_more_set_id").style.display="";
	}
	
}
function checkLeverNumber(){
	//debugger;
	var lever = ${currentLevel};
	if(lever == 3){
		alert("<bean:message bundle="sys-task" key="sysTaskMain.lever.number.message"/>");
		return false;
	}
	return true;
}
</script>
<div id="optBarDiv">
<!--设为关注任务  --> 
<kmss:auth
	requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&fdTaskId=${param.fdId}"
	requestMethod="GET">
	<c:if test="${isAttention != null&&isAttention=='false' }">
		<input type="button"
			value="<bean:message key="button.attention" bundle="sys-task"/>"
			onclick="if(!confirmAttention())return;Com_OpenWindow('sysTaskMain.do?method=updateAttention&fdTaskId=${param.fdId}','_self');">
	</c:if>
	<c:if test="${isAttention != null&&isAttention=='true' }">
		<input type="button"
			value="<bean:message key="sysTask.button.disAttention" bundle="sys-task"/>"
			onclick="if(!noconfirmAttention())return;Com_OpenWindow('sysTaskMain.do?method=updateAttention&fdTaskId=${param.fdId}&isAttention=true','_self');">
	</c:if>
</kmss:auth> 
<!--分解子任务--> 
<c:if
	test="${sysTaskMainForm.fdStatus != '4' && sysTaskMainForm.fdStatus != '3' }">
	<c:if test="${sysTaskMainForm.fdResolveFlag != 'true' }">
		<kmss:auth
			requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}"
			requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.sub.task" bundle="sys-task"/>"
				onclick="if(!checkLeverNumber())return;Com_OpenWindow('sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}','_blank');">
		</kmss:auth>
	</c:if>
</c:if>
<!--执行反馈  --> 
	<kmss:auth
		requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
		requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.feedback" bundle="sys-task"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"/>','_blank');">
	</kmss:auth> 
<!--驳回任务  --> 
	<c:if test="${sysTaskMainForm.fdStatus == '3'}">
	<kmss:auth requestURL="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=add&fdTaskId=${param.fdId}" requestMethod="GET">
		
			<input type="button" value="<bean:message key="table.sysTaskOverrule" bundle="sys-task"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=add&fdTaskId=${param.fdId}"/>','_blank');">
	</kmss:auth> 
	</c:if>
<!--任务评价  --> 
<kmss:auth
	requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
	requestMethod="GET">
	<input type="button"
		value="<bean:message key="button.evaluate" bundle="sys-task"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"/>','_blank');">
</kmss:auth>
<!--终止任务  -->
<c:if
	test="${sysTaskMainForm.fdStatus != '4' && sysTaskMainForm.fdStatus != '1' && sysTaskMainForm.fdStatus != '3' && sysTaskMainForm.fdStatus != '5'}">
	<kmss:auth
		requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=updateStop&fdTaskId=${param.fdId}"
		requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.terminate" bundle="sys-task"/>"
			onclick="if(!confirmStop('<bean:message bundle='sys-task' key='button.terminate.confirm.message'/>'))return;Com_OpenWindow('sysTaskMain.do?method=updateStop&fdTaskId=${param.fdId}','_self');">
	</kmss:auth>
</c:if>
<!-- 取消终止 -->
<c:if
	test="${sysTaskMainForm.fdStatus == '4'}">
	<kmss:auth
		requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=updateStop&fdTaskId=${param.fdId}"
		requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.cancel.terminate" bundle="sys-task"/>"
			onclick="if(!confirmStop('<bean:message bundle='sys-task' key='button.terminate.cancel.confirm.message'/>'))return;Com_OpenWindow('sysTaskMain.do?method=updateCancelStop&fdTaskId=${param.fdId}','_self');">
	</kmss:auth>
</c:if>  
<!-- 编缉 -->
<kmss:auth
	requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=edit&flag=${param.flag}&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('sysTaskMain.do?method=edit&flag=${param.flag}&fdId=${param.fdId}','_self');">
</kmss:auth> 
<!-- 删除 --> 
<kmss:auth
	requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=delete&flag=${param.flag}&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('sysTaskMain.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> 
<!-- 关闭 -->
<input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
<input type="button" value="<bean:message key="button.refresh"/>" onclick="history.go(0);">		
</div>
<center>
<table width="95%" height="100%" border = 0>
	<tr>
		<td colspan=4  align="right"> 
		<img src="../images/STATUS_INACTIVE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>
		<img src="../images/STATUS_PROGRESS.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>
		<img src="../images/STATUS_COMPLETE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>
		<img src="../images/STATUS_OVERRULE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>
		<img src="../images/STATUS_TERMINATE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>
		<select onchange="swapProcess(this)">
		<option value="task" selected><bean:message bundle="sys-task" key = "sysTaskMain.processIco.task"/></option>
		<option value="person"><bean:message bundle="sys-task" key = "sysTaskMain.processIco.person"/></option>
		</select>
		<script>
		function swapProcess(el){
			for(var i=0;i<el.length;i++){
				if(i==el.selectedIndex){
					document.getElementById(el.options[i].value+"Canvas").style.display="";
				}else{
					document.getElementById(el.options[i].value+"Canvas").style.display="none";
				}
			}
		}
		</script>
		</td>
	</tr>
	<tr width="100%" height="50%">
		<td width="100%"><script>
			${jsonString}	
			</script>
<style>
.noteDiv {
	position: absolute;
	/*overflow:"hidden";*/
	white-space: nowrap;
	height: 100px;
	width: 250px;
}

.ttb_noborder, .ttd_noborder, .ttb_noborder td{
	border: 0px;
	padding:0px;
	border-collapse:collapse;
}
</style>
		<script type="text/javascript"
			src="${KMSS_Parameter_ContextPath}sys/task/js/wz_jsgraphics.js"></script>
		<script>
			var _rurl = "${KMSS_Parameter_ContextPath}sys/task/";
			var _url = "<%=request.getContextPath()%>";
			if(_url.length==1){
				_url = _url.substring(1,_url.lenght);
			}
		</script>
		<div id="taskCanvas"
			style="position: relative; height: ${level*100-20}; width: 100%;"></div>
		<div id="personCanvas"
			style="position: relative; height: ${level*100-20}; width: 100%;display:none;"></div>
		<%@ include file="../js/task.jsp"%>
		</td>
	</tr>
	<tr height="50%">
		<td align="center">
		<table id="Label_Tabel" width="100%" >
			<tr LKS_LabelName="<bean:message key="tag.task" bundle="sys-task"/>"  >
				<td height="350" valign="top" align="center">
				<table class="tb_normal" width=100%>
					
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="sysTaskMain.docSubject" /></td>
						<td width=35%><c:out value="${sysTaskMainForm.docSubject}" />
						</td>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="sysTaskMain.fdAppoint" /></td>
						<td width=35%><c:out value="${sysTaskMainForm.fdAppointName}" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" /></td>
						<td width=35%><c:out
							value="${sysTaskMainForm.fdPlanCompleteDate}" />&nbsp;<c:out
							value="${sysTaskMainForm.fdPlanCompleteTime}" /></td>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.pastdue.yesno"/>
						</td><td width=35%>
							<sunbor:enumsShow value="${sysTaskMainForm.fdPastDue}" enumsType="sys_task_yesno"></sunbor:enumsShow>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="table.sysTaskMainPerform" /></td>
						<td width=35%><c:out value="${sysTaskMainForm.fdPerformName}" />
						</td>
						<td class="td_normal_title" width="15%"><bean:message
								bundle="sys-task" key="sysTaskMainCc.fdCcId" /></td>
						<td width="35%"><c:out value="${sysTaskMainForm.fdCcNames}" /></td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="sysTaskMain.fdParentId" /></td>
						<td width=35%>
							<c:choose> 
								<c:when test="${sysTaskMainForm.fdParentName != null}">
									<a href="../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMainForm.fdParentId}"  target="_blank"><c:out
									value="${sysTaskMainForm.fdParentName}" /></a>
								</c:when>
								<c:otherwise>
									<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
								</c:otherwise>
							</c:choose>
						</td>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="sysTaskMain.fdSourceSubject" /></td>
						<td width=35%>
							<c:choose>
								<c:when test="${not empty sysTaskMainForm.fdSourceSubject && not empty sysTaskMainForm.fdSourceUrl}">
									<a href='<c:url value="${sysTaskMainForm.fdSourceUrl}"/>' target="_blank" >
										<c:out value="${sysTaskMainForm.fdSourceSubject}" />
									</a>
								</c:when>
								<c:when test="${not empty sysTaskMainForm.fdSourceSubject && empty sysTaskMainForm.fdSourceUrl}">
									<c:out value="${sysTaskMainForm.fdSourceSubject}" />
								</c:when>
								<c:otherwise>
									<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
								</c:otherwise>
							</c:choose>
						</td>
					</tr>										
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							key="sysTaskMain.fdStatus" bundle="sys-task" /></td>
						<td width=35%>
							<kmss:showTaskStatus taskStatus="${sysTaskMainForm.fdStatus}" showText= "true" />
							
						</td>
						<td class="td_normal_title" width=15%><bean:message
										bundle="sys-task" key="sysTaskFeedback.fdProgress" /></td>
							<td width=35%><c:out value="${sysTaskMainForm.fdProgress}" />%
								<kmss:auth
									requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
									requestMethod="GET">
								<input type="button" value="<bean:message bundle="sys-task" key="button.feedback.progress"/>" onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"/>','_blank');"/>
								</kmss:auth>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title" width=15%></br><bean:message
							bundle="sys-task" key="sysTaskMain.docContent" /><br></br></td>
						<td width=35% colspan="3"><c:out
							value="${sysTaskMainForm.docContent}" escapeXml="false" /></td>
					</tr>
					
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-task" key="sysTaskMain.attachment" /></td>
						<td width=35% colspan=3><c:import
							url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="fdKey" value="attachment" />
							<c:param name="formBeanName" value="sysTaskMainForm" />

						</c:import></td>
					</tr>
					<tr>
						<td colspan=4><a href="#" onclick="showMoreSet();"><bean:message
								bundle="sys-task" key="sysTaskMain.more.set.message" /></a>
						</td>
					</tr>
					<tr id="show_more_set_id" style="display: none">
						<td width="100%" colspan=4>
							<table width="100%" class="tb_normal" height="100%" cellspacing="1" cellpadding="5">
								<tr>
									<td class="td_normal_title" colspan="4" width="15%">
									<c:choose>
										<c:when test="${sysTaskMainForm.fdResolveFlag == 'true'}">
											<input type="checkbox" checked disabled/>
										</c:when>
										<c:otherwise>
											<input type="checkbox"  disabled/>
										</c:otherwise>
									</c:choose>						
									<bean:message bundle="sys-task"
										key="sysTaskMain.fdResolveFlag" /></td>
								</tr>
								<tr>
									<td class="td_normal_title" width="15%"><bean:message
										bundle="sys-task" key="sysTaskFeedback.fdProgress" /></td>
									<td width=85% colspan=3>
										<c:choose>
											<c:when test="${sysTaskMainForm.fdProgressAuto == 'true'}">
												<input type="checkbox" checked disabled/>
											</c:when>
											<c:otherwise>
												<input type="checkbox"  disabled/>
											</c:otherwise>
										</c:choose>
										 <bean:message bundle="sys-task"
											key="sysTaskMain.fdProgressAuto" />
									</td>
								</tr>
								<tr>
									<c:choose>
										<c:when test="${sysTaskMainForm.fdParentId != null}">
											<td class="td_normal_title" width="15%"><bean:message
												key="sysTaskMain.fdCategoryId" bundle="sys-task" /></td>
											<td width="35%">							
												<c:out
												value="${sysTaskMainForm.fdCategoryName}" />
											</td>
											<td class="td_normal_title" width=15%><bean:message
												bundle="sys-task" key="sysTaskMain.fdWeights" /></td>
											<td width=35%><c:out value="${sysTaskMainForm.fdParentWeights}"/>%
												</td>
										</c:when>
										<c:otherwise>
											<td class="td_normal_title" width="15%"><bean:message
												key="sysTaskMain.fdCategoryId" bundle="sys-task" /></td>
											<td width=85% colspan=3><c:out
												value="${sysTaskMainForm.fdCategoryName}" /></td>
											</td>
										</c:otherwise>
									</c:choose>									
								</tr>
								<tr>
									<td class="td_normal_title" width="15%"><bean:message
									bundle="sys-task" key="sysTaskMainReader.docReaderIds" /></td>
									<td  colspan=3><c:out value="${sysTaskMainForm.docReaderNames}"/></td>
								</tr>
								<tr>
									<td class="td_normal_title" width="15%"><bean:message
										bundle="sys-task" key="sysTaskMain.fdNotifyType" /></td>
									<td width="35%" colspan=3><kmss:showNotifyType
										value="${sysTaskMainForm.fdNotifyType}" /></td>
								</tr>
								<tr>
									<td class="td_normal_title" width=15%><bean:message
										bundle="sys-task" key="sysTaskMain.docCreatorId" /></td>
									<td width=35%><c:out
										value="${sysTaskMainForm.docCreatorName}" /></td>
									<td class="td_normal_title" width=15%><bean:message
										bundle="sys-task" key="sysTaskMain.docCreateTime" /></td>
									<td width=35%><c:out value="${sysTaskMainForm.docCreateTime}" />
									</td>
								</tr>
							</table>
						</td>
					</td>					
				</table>
				</td>
			</tr>									
			<tr LKS_LabelName="<bean:message key="tag.feedback" bundle="sys-task"/>" >
				<td height="350"><iframe width="100%" height="100%"
					frameborder="0"
					src="<c:url value="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=list&fdTaskId=${param.fdId}"/>">
				</iframe></td>
			</tr>
			<tr
				LKS_LabelName="<bean:message key="tag.evaluate" bundle="sys-task"/>">
				<td height="350"><iframe width="100%" height="100%"
					frameborder="0"
					src="<c:url value="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=list&fdTaskId=${param.fdId}"/>">
				</iframe></td>
			</tr>
			<tr
				LKS_LabelName="<bean:message key="sysTaskOverrule.record" bundle="sys-task"/>">
				<td height="350"><iframe width="100%" height="100%"
					frameborder="0"
					src="<c:url value="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=list&fdTaskId=${param.fdId}&orderby=docCreateTime&ordertype=down"/>">
				</iframe></td>
			</tr>
			<kmss:ifModuleExist  path = "/sys/communicate/">
			<%request.setAttribute("communicateTitle",ResourceUtil.getString("sysTaskMain.communicateTitle","sys-task"));%>
			<c:import
				url="/sys/communicate/include/sysCommunicateMain_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="commuTitle"
					value="${communicateTitle}" />
				<c:param
					name="formName"
					value="sysTaskMainForm" />
				<c:param
					name="styleValue"
					value="height=350px" />
			</c:import>
			</kmss:ifModuleExist>
			<c:import url="/sys/readlog/include/sysReadLog_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="sysTaskMainForm" />
				<c:param
					name="styleValue"
					value="height=350px" />
			</c:import>
		</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>