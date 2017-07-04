<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ sysTaskMainForm.method_GET == 'addChildTask' }">
				<c:out value="${ lfn:message('sys-task:button.sub.task') } - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${sysTaskMainForm.docSubject} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<c:choose>
				<%--addChildTask页面的按钮--%>
				<c:when test="${ sysTaskMainForm.method_GET == 'addChildTask' }">
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save','false');">
					</ui:button>
				</c:when>
				<%--edit页面的按钮--%>
				<c:when test="${ sysTaskMainForm.method_GET == 'edit' }">
					<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod_update('update','false');">
					</ui:button>
				</c:when>
			</c:choose>
			<%--关闭--%>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" >
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	
	<%--子任务安排表单--%>
	<template:replace name="content"> 
		<style>
			.task_slideDown {margin-left: 12px;padding-left: 15px;font-size: 12px;text-decoration: underline;background: url(../images/icon_arrowd_blue.png) no-repeat 0 3px;cursor: pointer;}
			.task_slideUp {margin-left: 12px;padding-left: 15px;font-size: 12px;text-decoration: underline;background: url(../images/icon_arrowU_blue.png) no-repeat 0 3px;cursor: pointer;}
		</style>
		<script language="JavaScript">
			Com_IncludeFile("data.js|dialog.js|validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js|calendar.js",null,"js");
			seajs.use(['lui/jquery','lui/dialog'], function($,dialog) {
				//设置自动进度、权限范围仅限于此文档的checkbox值
				var setCheckBoxValue=function(){
					/*
					var fdProgressAuto=document.getElementsByName("fdProgressAuto")[1];
					if(fdProgressAuto.checked){
						document.getElementsByName("fdProgressAuto")[0].value="true";
						fdProgressAuto.value="true";
					}else{
						document.getElementsByName("fdProgressAuto")[0].value="false";
						fdProgressAuto.value="false";
					}
					*/
					var fdResolveFlag=document.getElementsByName("fdResolveFlag")[1];
					if(fdResolveFlag.checked){
						document.getElementsByName("fdResolveFlag")[0].value="true";
						fdResolveFlag.value="true";
					}else{
						document.getElementsByName("fdResolveFlag")[0].value="false";
						fdResolveFlag.value="false";
					}
				};
				//时间比较
				var checkTime=function(commitType){
					var _fdPlanCompleteDate = document.getElementsByName("fdPlanCompleteDate")[0];			
					var _fdPlanCompleteTime = document.getElementsByName("fdPlanCompleteTime")[0];
					var ParentPlanCompleteDate='${sysTaskMainForm.fdParentPlanCompleteDate}';
					var ParentPlanCompleteTime='${sysTaskMainForm.fdParentPlanCompleteTime}';
					//新建提交时检测要求完成时间是否小于当前时间
					if('save'==commitType){
						var msg = '';
						var curr_time = new Date();
						var strDate = curr_time.getFullYear()+"-";
						strDate += curr_time.getMonth()+1+"-";
						strDate += curr_time.getDate()+" ";
						var strTime = curr_time.getHours()+":";
						strTime += curr_time.getMinutes();
						if (_fdPlanCompleteTime != null && strDate != null && compareDate(_fdPlanCompleteDate.value+" "+_fdPlanCompleteTime.value, strDate+strTime) < 0) {
							msg += '<bean:message key="sys-task:sysTaskMain.min" argKey0="sys-task:sysTaskMain.fdPlanCompleteTime" argKey1="sys-task:sysTaskMain.fdCurrentTime" />' + '\r\n';
						}
						if (msg != '') {
								dialog.alert(msg);
							return false;
						}
					}
					//子任务完成时间不得晚于父任务完成时间
					if((_fdPlanCompleteDate.value > ParentPlanCompleteDate)||((_fdPlanCompleteDate.value == ParentPlanCompleteDate)&&(_fdPlanCompleteTime.value > ParentPlanCompleteTime))){			
						dialog.alert("<bean:message bundle='sys-task' key='sysTaskMain.ChildNotLateThanFather'/>");
						return false;
					}
					return true;
				};
				//提交表单
				window.commitMethod=function(commitType, saveDraft){
					var result=checkTime();
						if(result==false) return;
					setCheckBoxValue();//设置自动进度、权限范围仅限于此文档的checkbox值
					var formObj = document.sysTaskMainForm;
					var docStatus = document.getElementsByName("docStatus")[0];
					if(saveDraft=="true"){
						docStatus.value="10";
					}else{
						docStatus.value="20";
					}
					if('save'==commitType){
						Com_Submit(formObj, commitType,'fdId');
				    }else{
				    	Com_Submit(formObj, commitType); 
				    }
				};
				//更新前校验
				window.commitMethod_update=function(commitType, saveDraft){
					var parentId = document.getElementsByName("fdParentId")[0].value;
					if( parentId != null && parentId != undefined && parentId != ''){
						var currentWeight = document.getElementsByName("fdWeights")[0].value;	
						if(isNaN(currentWeight)){
							dialog.alert("<bean:message bundle='sys-task' key='sysTaskMain.fdWeights.message.number'/>");
							return;	
						}else{	
							var tempWeight = parseInt(currentWeight);
							if(tempWeight!=currentWeight){
								dialog.alert("<bean:message bundle='sys-task' key='sysTaskMain.fdWeights.message.integer'/>");
								return;
							}
						}
					}
					commitMethod(commitType,saveDraft);
				};
				//快速选择时间
				window.changeDateTime=function(obj){
					var date=new Date();
					switch(obj){
						case "1":date.setDate(date.getDate());break;
						case "2":date.setDate(date.getDate()+1);break;
						case "3":date.setDate(date.getDate()+2);break;
						case "4":date.setDate(date.getDate()+7);break;
						case "5":date.setMonth(date.getMonth()+1);break;
					}
					var month=date.getMonth()+1<10?"0"+(date.getMonth()+1):""+(date.getMonth()+1);
					var day=date.getDate()<10?"0"+date.getDate():""+date.getDate();
					document.sysTaskMainForm.fdPlanCompleteDate.value=date.getFullYear() +"-"+month+"-"+day;
					document.sysTaskMainForm.fdPlanCompleteTime.value="00:00";
				};
				//展开、收起
				window.showMoreSet=function(){
					if(document.getElementById("show_more_set_id").style.display==""){
						document.getElementById("showMoreSet").className ="task_slideDown";
						document.getElementById("showMoreSet").innerHTML="<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideDown' />";
						document.getElementById("show_more_set_id").style.display="none";
					}else{
						document.getElementById("showMoreSet").className ="task_slideUp";
						document.getElementById("showMoreSet").innerHTML="<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideUp' />";
						document.getElementById("show_more_set_id").style.display="";
					}
				};
				//计算权重
				window.calculateParentWeight=function(){
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
						document.getElementById("parentWeight").innerHTML=100;
					}else{
						var percent = (100/allWeight)*parseInt(currentWeight);
						document.getElementById("parentWeight").innerHTML=Math.round(percent*100)/100;
					}
				};
				//修改接收人
				window.changePerform=function(obj){
					if(obj.selectedIndex != 0){
						  var performId=obj.options[obj.selectedIndex].value;    
				          var performName=obj.options[obj.selectedIndex].text;    
				          document.getElementsByName("fdPerformId")[0].value = performId;
				          document.getElementsByName("fdPerformName")[0].value = performName;
					  }
				};
			});
			//快速选择接收人初始化
			window.putQuickSelectValue=function(){
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
			};
		</script>
		<html:form action="/sys/task/sys_task_main/sysTaskMain.do" >
			<html:hidden property="fdId"/>
			<html:hidden property="fdStatus"/> 
			<html:hidden property="docStatus"/> 
			<html:hidden property="fdRootId"/>
			<html:hidden property="docCreatorId"/>
			<html:hidden property="fdModelId" />
			<html:hidden property="fdModelName" />
			<html:hidden property="fdKey" />
			<html:hidden property="method_GET"/>
			<div class="lui_form_content_frame" style="padding-top: 10px;">
				<table class="tb_normal" width=100%>	
					<tr>
						<%--任务名称--%>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-task" key="sysTaskMain.docSubject" />
						</td>
						<td width="35%">
							<xform:text	property="docSubject" className="inputsgl" style="width:95%;"  showStatus="edit"/>
						</td>
						<%--指派人--%>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-task" key="sysTaskMain.fdAppoint" />
						</td>
						<td width="35%">
							<xform:address isLoadDataDict="false" style="width:95%" required="true" subject="${lfn:message('sys-task:sysTaskMain.fdAppoint') }" propertyId="fdAppointId" propertyName="fdAppointName" orgType='ORG_TYPE_PERSON' showStatus="edit"></xform:address>
						</td>
					</tr>
					<tr>
						<%--接收人--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskMainPerform.fdPerformId" />
						</td>
						<td width="35%">
							<xform:address isLoadDataDict="false" style="width:60%" required="true" subject="${lfn:message('sys-task:sysTaskMainPerform.fdPerformId') }"  propertyId="fdPerformId" propertyName="fdPerformName" orgType='ORG_TYPE_PERSON' mulSelect="true" showStatus="edit"></xform:address>
							<%--快速选择--%>
							<select id="select_quick"  onchange="changePerform(this);"  style="vertical-align: top;">
								<option value="0"><bean:message bundle="sys-task" key="sysTaskMain.quick.select"/></option>
							</select>
						</td>	
						<%--抄送人--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskMainCc.fdCcId" />
						</td>
						<td width="35%">
							<xform:address style="width:95%" propertyId="fdCcIds" propertyName="fdCcNames" orgType='ORG_TYPE_ALL' showStatus="edit" mulSelect="true"></xform:address>
						</td>
					</tr>
					<tr>
						<%--要求完成时间--%>
						<td width="15%" class="td_normal_title" >
							<bean:message bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" />
						</td>
						<td width="35%">
							<xform:datetime isLoadDataDict="false" required="true" subject="${lfn:message('sys-task:sysTaskMain.fdPlanCompleteDate') }"  property="fdPlanCompleteDate" dateTimeType="date" style="width:35%"  showStatus="edit"></xform:datetime>
							<xform:datetime isLoadDataDict="false" required="true" subject="${lfn:message('sys-task:sysTaskMain.fdPlanCompleteTime') }" property="fdPlanCompleteTime" dateTimeType="time" style="width:25%" showStatus="edit"></xform:datetime>
							<%--快速选择--%>
							<select name="select_time" onChange="changeDateTime(this.value)" style="vertical-align: top;">
								<option value="0"><bean:message bundle="sys-task" key="sysTaskMain.quick.select" /></option>
								<option value="1"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.today" /></option>
								<option value="2"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.tomorrow" /></option>
								<option value="3"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.after.tomorrow" /></option>
								<option value="4"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.next.week" /></option>
								<option value="5"><bean:message bundle="sys-task" key="sysTaskMain.DateTime.next.month" /></option>
							</select>
						</td>
						<%--任务来源--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskMain.fdSourceSubject" />
						</td>
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
						<%--上级任务--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskMain.fdParentId" />
						</td>
						<td width="35%">
							<html:hidden property="fdParentId" />
							<c:choose> 
								<c:when test="${sysTaskMainForm.fdParentName != null}">
									<c:out value="${sysTaskMainForm.fdParentName}" />
								</c:when>
								<c:otherwise>
									<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
								</c:otherwise>
							</c:choose>
						</td>
						<%--上级任务要求完成时间--%>
						<td class="td_normal_title" width="15%">
   							<bean:message bundle="sys-task" key="sysTaskMain.parent.fdPlanCompleteTime"/> 
  						</td>
  						<td width="35%">
  							<c:out value="${sysTaskMainForm.fdParentPlanCompleteDate}"/>&nbsp;<c:out value="${sysTaskMainForm.fdParentPlanCompleteTime}"/>
  						</td>
					</tr>
					<tr>
						<%--任务内容描述--%>
						<td class="td_normal_title" width="15%" valign="middle">
							<bean:message bundle="sys-task" key="sysTaskMain.docContent" />
						</td>
						<td colspan="3">
							<kmss:editor property="docContent" toolbarSet="Default" width="98%"/>
						</td>
					</tr>
					<tr>
						<%--相关附件--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskMain.attachment" />
						</td>
						<td colspan="3">
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment" />
								<c:param name="fdModelId" value="${sysTaskMainForm.fdId }" />
								<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
							</c:import>
						</td>
					</tr>
					<tr>
						<%--更多设置按钮--%>
						<td colspan="4" style="text-align: center;">
							<a href="javascript:void(0);" onclick="showMoreSet();" id="showMoreSet"  class="task_slideDown">
							<bean:message bundle='sys-task' key='sysTaskMain.more.set.slideDown' /></a>
						</td>
					</tr>  
					<tr id="show_more_set_id" style="display: none">
						<%--设置--%>
						<td  width="100%" colspan=4 style="padding: 0px;">
							<table width="100%" class="tb_normal" height="100%">
								<tr>
									<%--权限范围仅限此文档 --%>
									<td class="td_normal_title" colspan="4" width="15%">
										<html:hidden property="fdResolveFlag" />
										<html:checkbox property="fdResolveFlag" />
										<bean:message bundle="sys-task" key="sysTaskMain.fdResolveFlag" />						
										<span class="com_help"><bean:message bundle="sys-task" key="sysTaskMain.fdResolveFlag.help" /></span>
									</td>
								</tr>
								
								<%-- 
								<tr>	
									
									<td class="td_normal_title" width="15%">
										<bean:message bundle="sys-task" key="sysTaskFeedback.fdProgress" />
									</td>
									<td width=85% colspan=3>
										
										<html:checkbox property="fdProgressAuto" />
										<bean:message bundle="sys-task" key="sysTaskMain.fdProgressAuto" />
									</td>
								</tr>
								--%>
								
								<%-- #11654 移除“自动根据子任务更新进度 ”,为兼容旧数据,暂时保留字段 --%>
								<html:hidden property="fdProgressAuto" value="true"/>
								<html:hidden property="fdProgress" />
								
								<tr>
									<%--任务类型--%>
		    						<td class="td_normal_title" width="15%"> 
		      							<bean:message key="sysTaskMain.fdCategoryId" bundle="sys-task"/>
		      						</td>
		    						<td width="35%">	
		     							<kmss:dropList property="fdCategoryId" serviceBean="sysTaskCategoryService" whereBlock="sysTaskCategory.fdIsAvailable = 1" orderBy="sysTaskCategory.fdOrder asc"></kmss:dropList>
		   							 </td>
		   							 <%--权重--%>
		   							<td class="td_normal_title" width=15%>
										 <bean:message  bundle="sys-task" key="sysTaskMain.fdWeights"/></td>
									<td width=35%>
										<xform:text className="inputsgl" style="width:10%;" property="fdWeights" htmlElementProperties="onchange ='calculateParentWeight()'" showStatus="edit"></xform:text>
										 <html:hidden property="fdOtherChildWeights" />
										 <bean:message  bundle="sys-task" key="sysTaskMain.fdWeights.message"/><span id = "parentWeight"><c:out value="${sysTaskMainForm.fdParentWeights}"/></span>%
									</td>
								 </tr>
								 <tr>
									<%--可阅读者--%>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="sys-task" key="sysTaskMainReader.docReaderIds" />
									</td>
									<td colspan="3">
										<xform:address style="width:95%" propertyId="docReaderIds" propertyName="docReaderNames" orgType='ORG_TYPE_ALL' showStatus="edit" mulSelect="true"></xform:address>
										<br/><span class="com_help"><bean:message bundle="sys-task" key="sysTaskMainReader.docReaderIds.message" /></span>
									</td>
								</tr>
								<tr>
									<%--通知类型--%>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="sys-task" key="sysTaskMain.fdNotifyType" />
									</td>
									<td width="35%" colspan=3>
										<kmss:editNotifyType property="fdNotifyType" />
									</td>
								</tr>
								<tr>
									<%--创建人--%>
									<td class="td_normal_title" width="15%"><bean:message bundle="sys-task" key="sysTaskMain.docCreatorId" /></td>
									<td width="35%"><html:text property="docCreatorName" readonly="true" /></td>
									<%--创建时间--%>
									<td class="td_normal_title" width="15%"><bean:message bundle="sys-task" key="sysTaskMain.docCreateTime" /></td>
									<td width="35%"><html:text property="docCreateTime" readonly="true" /></td>
								</tr>
							</table>
						</td>
					</tr>	
				</table>
			</div>
			<ui:tabpage expand="false">
				<ui:content title="${ lfn:message('sys-agenda:module.sys.agenda.syn') }">
					<table class="tb_normal" width=100%>
						<tr>
						   <td width="15%"  class="tb_normal">
						   		<%--同步时机--%>
						       	<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
						   </td>
						   <td width="85%" colspan="3">
						       <xform:radio property="syncDataToCalendarTime" showStatus="edit">
						       		<xform:enumsDataSource enumsType="sysTaskMain_syncDataToCalendarTime" />
								</xform:radio>
						   </td>
						</tr>
						<tr>
							<td colspan="4" style="padding: 0px;">
								 <c:import url="/sys/agenda/import/sysAgendaMain_general_edit.jsp"	charEncoding="UTF-8">
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
				</ui:content>
			</ui:tabpage>
		</html:form>
		<script language="JavaScript">
			putQuickSelectValue(null);//初始化接收人
			$KMSSValidation(document.forms['sysTaskMainForm']);//加载校验框架
		</script>
	</template:replace>
</template:include>