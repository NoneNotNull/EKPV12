<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-task:module.sys.task') }"></c:out>
	</template:replace>
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" >
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" href="/sys/task/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }" href="/sys/task/index.jsp" target="_self" >
				<kmss:authShow roles="ROLE_SYSTASK_ANALYZE">		 
					<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskAnalyze') }" href="/sys/task/sys_task_analyze_ui/index.jsp" target="_self">
				   </ui:menu-item>
			   </kmss:authShow>
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<%--左侧--%>
	<template:replace name="nav">
		<%--新建按钮--%>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('sys-task:module.sys.task') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_SYSTASK_CREATE">
					{
						"text": "${ lfn:message('sys-task:table.sysTaskMain') }",
						"href": "javascript:addDoc();",
						"icon": "lui_icon_l_icon_19"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		
		<c:import url="/sys/task/import/nav.jsp" charEncoding="UTF-8">
		   <c:param name="key" value="sysTaskMain"></c:param>
		    <c:param name="criteria" value="sysTaskMainCriteria"></c:param>
		</c:import>
		
	</template:replace>
	
	<%--右侧--%>
	<template:replace name="content"> 
		<script>
			var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.sys.task.model.SysTaskMain";
		   seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
		 		//新建
				window.addDoc = function() {
					window.open('${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=add');
				};
				//删除
				window.delDoc = function(){
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							window.del_load = dialog.loading();
							$.post('<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delsuccess,'json')
									.error(delfail);
						}
					});
				};
				//删除成功回调函数
				window.delsuccess = function(data){
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				};
				
				window.delfail=function(data){
					//存在子任务，提示无法删除
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.responseJSON){
						data=data.responseJSON;
						var message=data.message;
						if(message && message.length>0 && message[message.length-1].msg){
							dialog.failure(message[message.length-1].msg);
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
					}
				};
			
				
				
		   });
	   </script>
	
		<list:criteria id="sysTaskMainCriteria">		
			<%-- 主题、任务状态、任务接收人、任务指派人、接收人部门、指派人部门、要求完成时间--%>
			<%-- 搜索条件:任务名称--%>
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject" title="${lfn:message('sys-task:sysTaskMain.docSubject') }" style="width:110px;">
			</list:cri-ref>
			
			<%--与我相关--%>
			<list:cri-criterion title="${ lfn:message('sys-task:sysTask.sysTaskMain.my') }" key="flag" multi="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('sys-task:sysTaskMain.list.attention') }', value:'0'},{text:'${ lfn:message('sys-task:sysTaskMain.list.appoint') }',value:'1'}, {text:'${ lfn:message('sys-task:sysTaskMain.list.perform') }', value: '2'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			
			<%--任务状态--%>
			<list:cri-criterion title="${ lfn:message('sys-task:sysTaskMain.fdStatus') }" key="taskStatus" >
				<list:box-select><list:item-select>
					<ui:source type="Static">
							[{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.inactive') }', value:'1'},
							{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.progress') }',value:'2'}, 
							{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.complete') }', value: '3'},
							{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.overdure') }', value: '11'},
							{text:'${ lfn:message('sys-task:sysTaskMain.status.overrule') }', value: '5'},
							{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.terminate') }', value: '4'},
							{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.close') }', value: '6'}]
						</ui:source>
				</list:item-select></list:box-select>
			</list:cri-criterion>
			
			<%--任务类型--%>
			<list:cri-criterion title="${ lfn:message('sys-task:sysTaskMain.fdCategoryId') }" key="taskCategory" >
				<list:box-select><list:item-select>
					<ui:source type="AjaxJson">
						{url:'/sys/task/sys_task_category/sysTaskCategory.do?method=getTaskCategory'}
					</ui:source>
				</list:item-select></list:box-select>
			</list:cri-criterion>
			
			<%--任务评价--%>
			<list:cri-criterion title="${ lfn:message('sys-task:table.sysTaskEvaluate') }" key="taskApproves" >
				<list:box-select><list:item-select>
					<ui:source type="AjaxJson">
						{url:'/sys/task/sys_task_approve/sysTaskApprove.do?method=getTaskApprove'}
					</ui:source>
				</list:item-select></list:box-select>
			</list:cri-criterion>
					
			<list:cri-ref ref="criterion.sys.person"   key="perform.personId"  title="${ lfn:message('sys-task:sysTaskMain.fdPerform') }"></list:cri-ref>
			<list:cri-auto modelName="com.landray.kmss.sys.task.model.SysTaskMain" property="fdAppoint" />
			<list:cri-auto modelName="com.landray.kmss.sys.task.model.SysTaskMain"  property="fdPlanCompleteDateTime" />
			
		</list:criteria>
		
		<%--操作栏--%>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="3">
						<list:sort property="docCreateTime" text="${lfn:message('sys-task:sysTaskMain.docCreateTime') }" group="sort.list"  value="down"></list:sort>
						<list:sort property="fdPlanCompleteDateTime" text="${lfn:message('sys-task:sysTaskMain.fdPlanCompleteTime') }" group="sort.list" ></list:sort>
						<list:sort property="fdProgress" text="${lfn:message('sys-task:sysTaskMain.fdProgress') }" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3">
							<%--新建--%>
							<kmss:authShow roles="ROLE_SYSTASK_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
							<%--删除--%>
							<kmss:auth
								requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
								requestMethod="GET">								
								<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="4"></ui:button>
							</kmss:auth>
						</ui:toolbar>
				</div>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--list视图--%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/task/sys_task_main/sysTaskIndex.do?method=list'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>   
		</list:listview> 
	 	<list:paging></list:paging>	 
	   
	</template:replace>
	
</template:include>