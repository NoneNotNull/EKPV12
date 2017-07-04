<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-task:module.sys.task') }"></c:out>
	</template:replace>
	<template:replace name="content">
		<list:criteria id="sysTaskMainCriteria" expand="true">		
			<%--与我相关--%>
			<list:cri-criterion title="${ lfn:message('sys-task:sysTask.sysTaskMain.my') }" key="selftask" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="2" cfg-required="true">
						<ui:source type="Static">
							[{text:'${ lfn:message('sys-task:sysTaskMain.list.perform.my') }', value: '2'},
							 {text:'${ lfn:message('sys-task:sysTaskMain.list.attention.my') }', value:'0'},
							 {text:'${ lfn:message('sys-task:sysTaskMain.list.appoint.my') }',value:'1'}]
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
							{text:'${ lfn:message('sys-task:tree.sysTaskMain.status.terminate') }', value: '4'}]
						</ui:source>
				</list:item-select></list:box-select>
			</list:cri-criterion>
		</list:criteria>
	    <div class="lui_list_operation">
				<table width="100%">
					<tr>
						<td style="width:65px;">${ lfn:message('list.orderType') }：</td>
						<td>
							<%-- 排序--%>
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="3">
								<list:sort property="docCreateTime" text="${lfn:message('sys-task:sysTaskMain.docCreateTime') }" group="sort.list"  value="down"></list:sort>
								<list:sort property="fdPlanCompleteDateTime" text="${lfn:message('sys-task:sysTaskMain.fdPlanCompleteTime') }" group="sort.list" ></list:sort>
								<list:sort property="fdProgress" text="${lfn:message('sys-task:sysTaskMain.fdProgress') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</td>
						<td align="right">
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
						</td>
					</tr>
				</table>
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
		<script>
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
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
				//删除回调函数
				window.delCallback = function(data){
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				};
		   });
	   </script>
	</template:replace>
</template:include>
