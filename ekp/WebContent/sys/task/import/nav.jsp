<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="key" value="${param.key}"/>
<c:set var="criteria" value="${param.criteria}"/>
<div class="lui_list_nav_frame">
	<ui:accordionpanel>
		<%--任务查询--%>
		<ui:content title="${ lfn:message('sys-task:sysTaskMain.list.search') }" expand="${param.key != 'sysTaskMain'?'false':'true' }">
			<%--0.我关注的、1.我负责的、2.我指派的、3.所有任务--%>
			<ul class='lui_list_nav_list'>
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskMain','flag','');">${ lfn:message('sys-task:sysTaskMain.list.all') }</a></li>
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskMain','flag','0');">${ lfn:message('sys-task:sysTaskMain.list.attention') }</a></li>					
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskMain','flag','1');">${ lfn:message('sys-task:sysTaskMain.list.appoint') }</a></li>
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskMain','flag','2');">${ lfn:message('sys-task:sysTaskMain.list.perform') }</a></li>
			</ul>
			<ui:operation href="javascript:openPage('${LUI_ContextPath }/sys/task/sys_task_ui/calendar.jsp')" name="${ lfn:message('sys-task:tree.task.calendar') }" target="_self" />
		</ui:content>		
		<kmss:authShow roles="ROLE_SYSTASK_ANALYZE">		 
		<%--任务分析--%>
		<ui:content title="${ lfn:message('sys-task:tree.analyze') }"  expand="${param.key != 'sysTaskAnalyze'?'false':'true' }">
			<%--0.我关注的、1.我负责的、2.我指派的、3.所有任务--%>
			<ul class='lui_list_nav_list'>
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskAnalyze','type','1');">${ lfn:message('sys-task:tree.load') }</a></li>					
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskAnalyze','type','2');">${ lfn:message('sys-task:tree.degree') }</a></li>
				<li><a href="javascript:void(0)" onclick="setUrl('sysTaskAnalyze','type','3');">${ lfn:message('sys-task:tree.synthesized') }</a></li>
			</ul>
		</ui:content>				
		</kmss:authShow>
		<%--后台管理--%>
		<ui:content title="${ lfn:message('list.otherOpt') }">
			<ul class='lui_list_nav_list'>
				<li><a href="${LUI_ContextPath }/sys/?module=sys/task" target="_blank">${ lfn:message('list.manager') }</a></li>
			</ul>
		</ui:content>
	</ui:accordionpanel>
	
	<script type="text/javascript">
		seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog'], function($, strutil, dialog){
			window.setUrl= function (key,mykey,type){
				//打开新页面
				if(key!="${key}"){
					if(key=="sysTaskMain"){
						if(type==""){
							openUrl('${LUI_ContextPath}/sys/task/index.jsp','');
						}
						else{
							openUrl('${LUI_ContextPath}/sys/task/index.jsp','cri.q='+mykey+':'+type);
						}
					}
					if(key=="sysTaskAnalyze"){
						openUrl('${LUI_ContextPath}/sys/task/sys_task_analyze_ui/index.jsp','cri.q='+mykey+':'+type);
					}
				}
				//只更新list列表
			 	else{
			 		openQuery();
			 		 LUI('${criteria}').setValue(mykey, type);
				}
			};
			window.openUrl = function(srcUrl,hash){
				if(hash!=""){
					srcUrl+="#"+hash;
			    }
				window.open(srcUrl,"_self");
			};
		});
	</script>
</div>
