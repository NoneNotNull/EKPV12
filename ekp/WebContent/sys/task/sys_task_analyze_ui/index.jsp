<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-task:module.sys.task') }"></c:out>
	</template:replace>
	<%--导航路径--%>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" style="height:40px;line-height:40px;">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:module.sys.task') }" href="/sys/task/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskAnalyze') }" href="/sys/task/sys_task_analyze_ui/index.jsp" target="_self" >
				<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskMain') }" href="/sys/task/index.jsp" target="_self">
			   </ui:menu-item>
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<%--左侧--%>
	<template:replace name="nav">
		<%--新建按钮--%>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('sys-task:table.sysTaskAnalyze') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_SYSTASK_ANALYZE">
					{
						"text": "${lfn:message('sys-task:sysTaskAnalyze.analyze.create.title')}",
						"href": "javascript:addAnalyze('1');",
						"icon": "lui_icon_l_icon_34"
					}
					</kmss:authShow>
				]
			</ui:varParam>
		</ui:combin>
		
		<c:import url="/sys/task/import/nav.jsp" charEncoding="UTF-8">
		   <c:param name="key" value="sysTaskAnalyze"></c:param>
		    <c:param name="criteria" value="sysTaskAnalyzeCriteria"></c:param>
		</c:import>
		
	</template:replace>
	
	<%--右侧--%>
	<template:replace name="content">  
		<script type="text/javascript">
		 	seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
		 		//新建
				window.addAnalyze = function(type) {
					window.open('${LUI_ContextPath}/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=add&type='+type);
				};
				//删除
				window.delAnalyze = function(){
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
							window.delAnalyze_load = dialog.loading();
							$.post('<c:url value="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delAnalyzeCallback,'json');
						}
					});
				};
				//删除回调函数
				window.delAnalyzeCallback = function(data){
					if(window.delAnalyze_load!=null)
						window.delAnalyze_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				};
				//修改新增按钮
			 	topic.subscribe('criteria.changed',function(evt){
			 		for(var i=0;i<evt['criterions'].length;i++){
						 if(LUI('add')&&evt['criterions'][i].key=="type"&&evt['criterions'][i].value.length==1){
							 LUI('toolbar').removeButton(LUI('add'));
							var btn=toolbar.buildButton({text:'${lfn:message("sys-task:sysTaskAnalyze.analyze.create.button")}',id:'add',click:'addAnalyze("'+evt['criterions'][i].value[0]+'")',order:'2'});
							 LUI('toolbar').addButton(btn);
						}
				 	}
				});
			 });
	 	</script>	 
		<list:criteria id="sysTaskAnalyzeCriteria">		
			<%-- 搜索条件:名称--%>
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject" title="${lfn:message('sys-task:sysTaskAnalyze.docSubject') }" style="width:125px;">
			</list:cri-ref>
			<list:cri-criterion title="${lfn:message('sys-task:sysTaskAnalyze.fdAnalyzeType')}" key="type" expand="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('sys-task:tree.load') }', value:'1'},{text:'${ lfn:message('sys-task:tree.degree') }',value:'2'}, {text:'${ lfn:message('sys-task:tree.synthesized') }', value: '3'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		
		<%--操作栏--%>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
						<list:sort property="fdStartDate" text="${lfn:message('sys-task:sysTaskAnalyze.startDate') }" group="sort.list"></list:sort>
						<list:sort property="fdEndDate" text="${lfn:message('sys-task:sysTaskAnalyze.endDate') }" group="sort.list"></list:sort>
						<list:sort property="docCreateTime" text="${lfn:message('sys-task:sysTaskAnalyze.docCreateTime') }" group="sort.list" value="down"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar id="toolbar" count="2">
						<%--新建--%>
						<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=add" requestMethod="GET">
							<ui:button id="add" text="${lfn:message('sys-task:sysTaskAnalyze.analyze.create.button')}" onclick="addAnalyze('1')" order="2"></ui:button>	
						</kmss:auth>
						<%--删除--%>
						<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=deleteall" requestMethod="GET">						
							<ui:button text="${lfn:message('button.delete')}" onclick="delAnalyze()" order="4"></ui:button>
						</kmss:auth>
					</ui:toolbar>
				</div>
			</div>
		</div>		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--list视图--%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=list'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>   
		</list:listview> 
	 	<list:paging></list:paging>	 
	 	
	</template:replace>
	
</template:include>