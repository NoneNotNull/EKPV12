<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-task:module.sys.task') }"></c:out>
	</template:replace>
	<template:replace name="content">
		<list:criteria id="sysTaskMainCriteria" expand="true">		
			<list:cri-criterion title="${ lfn:message(lfn:concat('sys-task:sysTaskMain.', TA)) }" key="tatask" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="2" cfg-required="true">
						<ui:source type="Static">
							[{text:'${ lfn:message(lfn:concat('sys-task:sysTaskMain.list.perform.', TA)) }', value: '2'}
							,{text:'${ lfn:message(lfn:concat('sys-task:sysTaskMain.list.attention.', TA)) }', value:'0'}
							,{text:'${ lfn:message(lfn:concat('sys-task:sysTaskMain.list.appoint.', TA)) }',value:'1'}]
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
					</tr>
				</table>
			</div>
			<ui:fixed elem=".lui_list_operation"></ui:fixed>
			<%--list视图--%>
			<list:listview id="listview">
				<ui:source type="AjaxJson">
					{url:'/sys/task/sys_task_main/sysTaskIndex.do?method=list&userid=${param.userId}'}
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
