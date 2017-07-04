<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<template:include ref="default.view" sidebar="no">
	<%-- 标签页标题--%>
	<template:replace name="title">
		<c:out value="${sysTaskMainForm.docSubject} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>
	</template:replace>
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="5">
			
			<%--未结项的任务才可以进行执行反馈、任务评价、更新进度、终止任务/取消终止、分解子任务、编辑、驳回任务等操作--%>	
			<c:if test="${sysTaskMainForm.fdStatus != '6' }">
			<%--执行反馈--%>	
			<kmss:auth
				requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('sys-task:button.feedback')}" order="3" id="feedback"
					onclick="Com_OpenWindow('${LUI_ContextPath}/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}','_blank');">
				</ui:button>
			</kmss:auth>
			<%--任务评价--%>	
			<kmss:auth
				requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('sys-task:button.evaluate')}" order="3" id="evaluate"
					onclick="Com_OpenWindow('${LUI_ContextPath}/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}','_blank');">
				</ui:button>
			</kmss:auth>
			<%--任务结项--%>	
			<kmss:auth
				requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=closeTask&flag=${param.flag}&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('sys-task:button.closeTask')}"  order="4" id="closeTask" onclick="closeTask();">
				</ui:button>
			</kmss:auth>
			<%--分解子任务--%>
			<c:if test="${sysTaskMainForm.fdStatus != '4' && sysTaskMainForm.fdStatus != '3' }">
				<c:if test="${sysTaskMainForm.fdResolveFlag != 'true' }">
					<kmss:auth
						requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}"
						requestMethod="GET">
						<ui:button text="${lfn:message('sys-task:button.sub.task')}" order="3" id="addChildTask"
							onclick="if(!checkLeverNumber())return;Com_OpenWindow('${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}','_blank');">
						</ui:button>
					</kmss:auth>
				</c:if>
			</c:if>
			<kmss:auth
				requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=updateStop&fdTaskId=${param.fdId}"
				requestMethod="GET">
				<%--终止任务--%>
				<c:if test="${sysTaskMainForm.fdStatus != '4' && sysTaskMainForm.fdStatus != '1' && sysTaskMainForm.fdStatus != '3' && sysTaskMainForm.fdStatus != '5'}">
					<ui:button text="${lfn:message('sys-task:button.terminate')}"  order="3" id="updateStop"
						onclick="LUIconfirm('${lfn:message('sys-task:button.terminate.confirm.message')}','sysTaskMain.do?method=updateStop&fdTaskId=${param.fdId}');">
					</ui:button>
				</c:if>
				<%--取消终止--%>
				<c:if test="${sysTaskMainForm.fdStatus == '4'}">
					<ui:button text="${lfn:message('sys-task:button.cancel.terminate')}" order="3" id="updateCancelStop"
						onclick="LUIconfirm('${lfn:message('sys-task:button.terminate.cancel.confirm.message')}','sysTaskMain.do?method=updateCancelStop&fdTaskId=${param.fdId}');">
					</ui:button>
				</c:if>
			</kmss:auth>
			<%--驳回任务(不存在子任务的任务才可以进行驳回)--%>
			<c:if test="${sysTaskMainForm.fdStatus == '3' && childSize == 0 }">
				<kmss:auth requestURL="/sys/task/sys_task_overrule/sysTaskOverrule.do?method=add&fdTaskId=${param.fdId}" requestMethod="GET">
					<ui:button text="${lfn:message('sys-task:table.sysTaskOverrule')}" order="4" id="overrule"
						onclick="Com_OpenWindow('${LUI_ContextPath}/sys/task/sys_task_overrule/sysTaskOverrule.do?method=add&fdTaskId=${param.fdId}','_blank');">
					</ui:button>
				</kmss:auth> 
			</c:if>
			<%--编辑--%>
			<kmss:auth
				requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=edit&flag=${param.flag}&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}" order="4" id="edit"
					onclick="Com_OpenWindow('sysTaskMain.do?method=edit&flag=${param.flag}&fdId=${param.fdId}','_self');">
				</ui:button>
			</kmss:auth>
			</c:if>
			<%--设为关注--%>
			<c:if test="${isAttention != null&&isAttention=='false' }">
				<ui:button text="${lfn:message('sys-task:button.attention')}"  order="4" id="attention" onclick="attention();">
				</ui:button>
			</c:if>
			<%--取消关注--%>
			<c:if test="${isAttention != null&&isAttention=='true' }"> 
				<ui:button text="${lfn:message('sys-task:sysTask.button.disAttention')}" order="4" id="disAttention" onclick="disAttention();">
				</ui:button>
			</c:if>
			<%--删除--%>
			<kmss:auth
				requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=delete&flag=${param.flag}&fdId=${param.fdId}"
				requestMethod="GET">
					<ui:button text="${lfn:message('button.delete')}"  order="5" id="delete"
						onclick="LUIconfirm('${ lfn:message('page.comfirmDelete')}','sysTaskMain.do?method=delete&fdId=${param.fdId}');">
					</ui:button>
			</kmss:auth>
			<%--关闭--%> 
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();" id="closeWindow">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" href="/sys/task/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }" href="/sys/task/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<%--主内容--%>
	<template:replace name="content">
		<%--任务样式--%>
		<style>
			.noteDiv {
				position: absolute;
				white-space: nowrap;
				height: 100px;
				width: 250px;
			}
			.ttb_noborder, .ttd_noborder, .ttb_noborder td{
				border: 0px;
				padding:0px;
				border-collapse:collapse;
			}
			.task_slideDown {margin-left: 12px;padding-left: 15px;font-size: 12px;text-decoration: underline;background: url(../images/icon_arrowd_blue.png) no-repeat 0 3px;cursor: pointer;}
			.task_slideUp {margin-left: 12px;padding-left: 15px;font-size: 12px;text-decoration: underline;background: url(../images/icon_arrowU_blue.png) no-repeat 0 3px;cursor: pointer;}
			.pro_barline {width: 113px;height: 7px;display:inline-block; background: #e5e4e1;border: 1px solid #d2d1cc;text-align: left;border-radius: 4px;}
			.pro_barline .complete{height: 7px;background: #00a001;border-radius: 3px;}
			.pro_barline .uncomplete{height: 7px;background: #ff8b00;border-radius: 3px;}
		</style>
		<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog,topic,toolbar) {
				
				//任务反馈后会发回刷新事件，在这个事件中再查找上一级页面刷新待办
				topic.subscribe('successReloadPage', function() {
					try{
						if(window.opener!=null) {
							try {
								if (window.opener.LUI) {
									window.opener.LUI.fire({ type: "topic", name: "successReloadPage" });
									return;
								}
							} catch(e) {}
							if (window.LUI) {
								LUI.fire({ type: "topic", name: "successReloadPage" }, window.opener);
							}
							var hrefUrl= window.opener.location.href;
							var localUrl = location.href;
							if(hrefUrl.indexOf("/sys/notify/")>-1 && localUrl.indexOf("/sys/notify/")==-1)
								window.opener.location.reload();
						}
					}catch(e){}
				});				
				
				
				//设为关注
				window.attention=function(){
					window._load = dialog.loading();
					$.post('<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&fdTaskId=${param.fdId}"/>',
						function(data){ 
							if(window._load!=null)
								window._load.hide();
							if(data!=null && data.status==true){
								dialog.success('<bean:message key="button.attention.message" bundle="sys-task"/>');
								 LUI('toolbar').removeButton(LUI('attention'));
								 LUI('toolbar').addButtons([toolbar.buildButton({text:'${lfn:message("sys-task:sysTask.button.disAttention")}',id:'disAttention',click:'disAttention()',order:'4'})]);
							}else{
								dialog.failure('<bean:message key="return.optFailure" />');
							}
						},'json');
				};
				//取消关注
				window.disAttention=function(){
					window._load = dialog.loading();
					$.post('<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=updateAttention&fdTaskId=${param.fdId}&isAttention=true"/>',
						function(data){
							if(window._load!=null)
								window._load.hide();
							if(data!=null && data.status==true){
								dialog.success('<bean:message key="button.noattention.message" bundle="sys-task" />');
								 LUI('toolbar').removeButton(LUI('disAttention'));
								 LUI('toolbar').addButtons([toolbar.buildButton({text:'${lfn:message("sys-task:button.attention")}',id:'attention',click:'attention()',order:'4'})]);
							}else{
								dialog.failure('<bean:message key="return.optFailure" />');
							}
						},'json');
				};
				//任务结项
				window.closeTask=function(){
					var msg="${lfn:message('sys-task:button.closeTask.confirm.message')}";
					dialog.confirm(msg,function(value){
						if(value==true){
							window._load = dialog.loading();
							$.post('<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=closeTask&fdId=${param.fdId}"/>',
								function(data){
									if(window._load!=null)
										window._load.hide();
									if(data!=null && data.status==true){
										dialog.success('<bean:message key="sysTaskMain.status.close" bundle="sys-task"/>');
										 window.location.reload();
									}else{
										dialog.failure('<bean:message key="return.optFailure" />');
									}
								},'json');
						}
					});
				};
				//确认框
				window.LUIconfirm=function(msg,url){
					window.taskURL=url;
					dialog.confirm(msg,function(value){
						if(value==true){
							Com_OpenWindow(window.taskURL,"_self");
						}
					});
				};
				//任务分解级别不能超过3层
				window.checkLeverNumber=function(){
					var lever = ${currentLevel};
					if(lever == 3){
						dialog.alert("${ lfn:message('sys-task:sysTaskMain.lever.number.message')}");
						return false;
					}
					return true;
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
				//切换任务显示图(任务分解图/责任分解图)
				window.swapProcess=function(el){
					for(var i=0;i<el.length;i++){
						if(i==el.selectedIndex){
							document.getElementById(el.options[i].value+"Canvas").style.display="";
						}else{
							document.getElementById(el.options[i].value+"Canvas").style.display="none";
						}
					}
				};
				
			});
		</script>
		<html:form action="/sys/task/sys_task_main/sysTaskMain.do">
			<html:hidden property="fdId" />
			<html:hidden property="docStatus" />
			<html:hidden property="fdRootId" />
			<html:hidden property="docCreatorId" />
			<html:hidden property="fdWorkId" />
			<html:hidden property="fdPhaseId" />
			<html:hidden property="fdModelId" /> 
			<html:hidden property="fdModelName" />
			<html:hidden property="fdKey" />
			<html:hidden property="method_GET" />
			<div class="lui_form_content_frame" >
				<p class="lui_form_subject">
					<bean:message bundle="sys-task" key="table.sysTaskMain" />
				</p>
				<table class="tb_normal" width=100%>	
					<tr><td colspan="4" >
						<%--任务分解图/责任分解图选项--%>
						<div style="float: right;margin: 10px;">
							<img src="../images/STATUS_INACTIVE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>
							<img src="../images/STATUS_PROGRESS.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>
							<img src="../images/STATUS_COMPLETE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>
							<img src="../images/STATUS_OVERRULE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>
							<img src="../images/STATUS_TERMINATE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>
							<img src="../images/STATUS_CLOSE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.close"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.close"/>
							<select onchange="swapProcess(this)">
								<option value="task" selected><bean:message bundle="sys-task" key = "sysTaskMain.processIco.task"/></option>
								<option value="person"><bean:message bundle="sys-task" key = "sysTaskMain.processIco.person"/></option>
							</select>
						</div>
						<%--任务分解图/责任分解图--%>
						<div style="clear: both;">
							<script>${jsonString}</script>
							<script type="text/javascript"src="${LUI_ContextPath}/sys/task/js/wz_jsgraphics.js"></script>
							<script>
								var _rurl = "${LUI_ContextPath}/sys/task/";
								var _url = "<%=request.getContextPath()%>";
								if(_url.length==1){
									_url = _url.substring(1,_url.lenght);
								}
							</script>
							<div id="taskCanvas" style="position: relative; left:-50px;height: ${level*100-20}px;width: 100%;"></div>
							<div id="personCanvas" style="position: relative;left:-50px; height: ${level*100-20}px; width: 100%;display:none;"></div>
							<%@ include file="../js/task.jsp"%>
						</div>
					</td></tr>
					<tr>
						<%--任务名称--%>
						<td width="15%" class="td_normal_title">
							<bean:message bundle="sys-task" key="sysTaskMain.docSubject" />
						</td>
						<td width="35%">
							<c:out value="${sysTaskMainForm.docSubject}" />
						</td>
						<%--指派人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.fdAppoint" />
						</td>
						<td width="35%">
							<c:out value="${sysTaskMainForm.fdAppointName}" />
						</td>
					</tr>
					<tr>
						<%--接收人--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="table.sysTaskMainPerform" />
						</td>
						<td width=35%>
							<c:out value="${sysTaskMainForm.fdPerformName}" />
						</td>
						<%--抄送人--%>
						<td class="td_normal_title" width="15%">
							<bean:message bundle="sys-task" key="sysTaskMainCc.fdCcId" />
						</td>
						<td width="35%">
							<c:out value="${sysTaskMainForm.fdCcNames}" />
						</td>
					</tr>
					<tr>
						<%--要求完成时间--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.fdPlanCompleteTime" />
						</td>
						<td width=35%>
							<c:out value="${sysTaskMainForm.fdPlanCompleteDate}" />&nbsp;<c:out value="${sysTaskMainForm.fdPlanCompleteTime}" />
						</td>
						<%--是否过期--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.pastdue.yesno"/>
						</td>
						<td width=35%>
							<sunbor:enumsShow value="${sysTaskMainForm.fdPastDue}" enumsType="sys_task_yesno"></sunbor:enumsShow>
						</td>
					</tr>
					
					<tr>
						<%--上级任务--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.fdParentId" />
						</td>
						<td width=35% colspan="3"><c:choose> 
							<c:when test="${sysTaskMainForm.fdParentName != null}">
								<a class="com_btn_link" href="../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMainForm.fdParentId}"  target="_self">
									<c:out value="${sysTaskMainForm.fdParentName}" />
								</a>
							</c:when>
							<c:otherwise>
								<bean:message bundle="sys-task" key="sysTaskMain.no.message"/>
							</c:otherwise>
						</c:choose></td>
					</tr>
					<tr>
						<%--任务来源--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.fdSourceSubject" />
						</td>
						<td colspan="3"><c:choose>
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
						</c:choose></td>
					</tr>
					<tr>
						<%--任务状态--%>
						<td class="td_normal_title" width=15%>
							<bean:message key="sysTaskMain.fdStatus" bundle="sys-task" />
						</td>
						<td width=35%>
							<kmss:showTaskStatus taskStatus="${sysTaskMainForm.fdStatus}" showText= "true" />
						</td>
						<%--任务进度--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskFeedback.fdProgress" />
						</td>
						<td width=35%>
							<c:out value="${sysTaskMainForm.fdProgress}" />%
							<div class='pro_barline'>
								<c:if test="${sysTaskMainForm.fdProgress=='100' }">
									<div class='complete' style="width:${sysTaskMainForm.fdProgress}%"></div>
								</c:if>
								<c:if test="${sysTaskMainForm.fdProgress!='100' }">
									<div class='uncomplete' style="width:${sysTaskMainForm.fdProgress}%"></div>
								</c:if>
							</div>
							<%--更新进度按钮--%>
							<c:if test="${sysTaskMainForm.fdStatus != '6' && childSize==0 }">
							<kmss:auth
								requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
								requestMethod="GET">
								<ui:button text="${lfn:message('sys-task:button.feedback.progress')}"  style="margin-left:10px;"
									onclick="Com_OpenWindow('${LUI_ContextPath}/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}','_blank');">
								</ui:button>
							</kmss:auth>
							</c:if>
							
						</td>
					</tr>
					<tr>
						<%--任务内容描述--%>
						<td class="td_normal_title" width=15% valign="middle">
							<bean:message bundle="sys-task" key="sysTaskMain.docContent" />
						</td>
						<td width=35% colspan="3">
							<xform:rtf property="docContent"></xform:rtf>
						</td>
					</tr>
					<tr>
						<%--附件--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskMain.attachment" />
						</td>
						<td width=35% colspan=3>
							<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
								<c:param name="fdKey" value="attachment" />
								<c:param name="formBeanName" value="sysTaskMainForm" />
							</c:import>
						</td>
					</tr>
					<tr>
						<%--更多设置按钮--%>
						<td colspan="4" style="text-align: center;">
							<a href="javascript:void(0);" onclick="showMoreSet();" id="showMoreSet"  class="task_slideDown"><bean:message bundle='sys-task' key='sysTaskMain.more.set.slideDown' /></a>
						</td>
					</tr>
					<tr id="show_more_set_id" style="display: none">
						<%--设置--%>
						<td width="100%" colspan=4 style="padding: 0px;">
							<table width="100%" class="tb_normal" height="100%" cellspacing="1" cellpadding="5">
								<tr>
									<%--权限范围仅限此文档 --%>
									<td class="td_normal_title" colspan="4" width="15%">
										<c:choose>
											<c:when test="${sysTaskMainForm.fdResolveFlag == 'true'}">
												<input type="checkbox" checked disabled/>
											</c:when>
											<c:otherwise>
												<input type="checkbox"  disabled/>
											</c:otherwise>
										</c:choose>
										<bean:message bundle="sys-task" key="sysTaskMain.fdResolveFlag" />						
										<span class="com_help"><bean:message bundle="sys-task" key="sysTaskMain.fdResolveFlag.help" /></span>
									</td>
								</tr>
								<%--当前进度
								<tr>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="sys-task" key="sysTaskFeedback.fdProgress" />
									</td>
									<td width=85% colspan=3><c:choose>
										<c:when test="${sysTaskMainForm.fdProgressAuto == 'true'}">
											<input type="checkbox" checked disabled/>
										</c:when>
										<c:otherwise>
											<input type="checkbox"  disabled/>
										</c:otherwise>
									</c:choose><bean:message bundle="sys-task" key="sysTaskMain.fdProgressAuto" /></td>
								</tr>
								--%>
								<html:hidden property="fdProgressAuto"/>
								
								<tr>
									<%--任务类型--%>
									<td class="td_normal_title" width="15%">
										<bean:message key="sysTaskMain.fdCategoryId" bundle="sys-task" />
									</td>
									<c:choose>
										<c:when test="${sysTaskMainForm.fdParentId != null}">
											<td width="35%">							
												<c:out value="${sysTaskMainForm.fdCategoryName}" />
											</td>
											<%--如果存在父任务,显示权重--%>
											<td class="td_normal_title" width=15%>
												<bean:message bundle="sys-task" key="sysTaskMain.fdWeights" />
											</td>
											<td width=35%><c:out value="${sysTaskMainForm.fdParentWeights}"/>%</td>
										</c:when>
										<c:otherwise>
											<td width=85% colspan=3>
												<c:out value="${sysTaskMainForm.fdCategoryName}" />
											</td>
										</c:otherwise>
									</c:choose>									
								</tr>
								<tr>
									<%--可阅读者--%>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="sys-task" key="sysTaskMainReader.docReaderIds" />
									</td>
									<td  colspan=3><c:out value="${sysTaskMainForm.docReaderNames}"/></td>
								</tr>
								<tr>
									<%--通知方式--%>
									<td class="td_normal_title" width="15%">
										<bean:message bundle="sys-task" key="sysTaskMain.fdNotifyType" />
									</td>
									<td width="35%" colspan=3>
										<kmss:showNotifyType value="${sysTaskMainForm.fdNotifyType}" />
									</td>
								</tr>
								<tr>
									<%--创建者--%>
									<td class="td_normal_title" width=15%>
										<bean:message bundle="sys-task" key="sysTaskMain.docCreatorId" />
									</td>
									<td width=35%>
										<c:out value="${sysTaskMainForm.docCreatorName}" />
									</td>
									<%--创建时间--%>
									<td class="td_normal_title" width=15%>
										<bean:message bundle="sys-task" key="sysTaskMain.docCreateTime" />
									</td>
									<td width=35%>
										<c:out value="${sysTaskMainForm.docCreateTime}" />
									</td>
								</tr>
							</table>		
						</td>	
					</tr>
				</table>
			</div>
			<ui:tabpage expand="false" >
				<%--执行反馈页签--%>
				<ui:content title="${lfn:message('sys-task:tag.feedback')}">
					<ui:event event="show"> 
						document.getElementById("feedbackList").src= '<c:url value="/sys/task/sys_task_feedback_ui/sysTaskFeedback_list.jsp" />?fdTaskId=${param.fdId}';
					</ui:event>
					<iframe id="feedbackList" width=100% height=100% frameborder=0 scrolling=no></iframe>
				</ui:content>
				<%--评价页签 --%>
				<ui:content title="${lfn:message('sys-task:tag.evaluate')}">
					<ui:event event="show"> 
						document.getElementById("evaluateList").src= '<c:url value="/sys/task/sys_task_evaluate_ui/sysTaskEvaluate_list.jsp" />?fdTaskId=${param.fdId}';
					</ui:event>
					<iframe id="evaluateList" width=100% height=100% frameborder=0 scrolling=no></iframe>
				</ui:content>
				<%-- 驳回记录--%>
				<ui:content title="${lfn:message('sys-task:sysTaskOverrule.record')}">
					<ui:event event="show" > 
						document.getElementById("overruleList").src= '<c:url value="/sys/task/sys_task_overrule_ui/sysTaskOverrule_list.jsp" />?fdTaskId=${param.fdId}';;
					</ui:event>
					<iframe id="overruleList" width=100% height=100% frameborder=0 scrolling=no></iframe>
				</ui:content>
				<kmss:ifModuleExist  path = "/km/collaborate/">
				<%request.setAttribute("communicateTitle",ResourceUtil.getString("sysTaskMain.communicateTitle","sys-task"));%>
				<%--沟通与代办 --%>
				<c:import url="/km/collaborate/import/kmCollaborateMain_view.jsp" charEncoding="UTF-8">
					<c:param name="commuTitle"	value="${communicateTitle}" />
					<c:param name="formName" value="sysTaskMainForm" />
				</c:import>
				</kmss:ifModuleExist>
				<%--阅读机制 --%>
				<c:import url="/sys/readlog/import/sysReadLog_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="sysTaskMainForm" />
				</c:import>
				<%--日程机制--%>
				<c:if test="${sysTaskMainForm.syncDataToCalendarTime=='submit'}">
					<ui:content title="${ lfn:message('sys-agenda:module.sys.agenda.syn') }" >
						<table class="tb_normal" width=100%>
							<%--同步时机--%>
							<tr>
								<td class="td_normal_title" width="15%">
							 		<bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
							 	</td>
							 	<td colspan="3">
							 		<xform:radio property="syncDataToCalendarTime">
						       			<xform:enumsDataSource enumsType="sysTaskMain_syncDataToCalendarTime" />
									</xform:radio>
								</td>
							</tr>
							<%--日程(普通模式)--%>
							<tr>
								<td colspan="4" style="padding: 0px;">
								 	<c:import url="/sys/agenda/import/sysAgendaMain_general_view.jsp"	charEncoding="UTF-8">
								    	<c:param name="formName" value="sysTaskMainForm" />
								    	<c:param name="fdKey" value="reviewMainDoc" />
								    	<c:param name="fdPrefix" value="sysAgendaMain_formula_view" />
								 	</c:import>
						 		</td>
						 	</tr>
						</table>
					</ui:content>
				</c:if>
			</ui:tabpage>
		</html:form>
	</template:replace>
	
</template:include>