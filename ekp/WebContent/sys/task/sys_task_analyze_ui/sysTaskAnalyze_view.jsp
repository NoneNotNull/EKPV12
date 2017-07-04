<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no">
	<%--标签页标题--%>
	<template:replace name="title">
		<c:out value="${lfn:message('sys-task:table.sysTaskAnalyze')} - ${ lfn:message('sys-task:module.sys.task') }"></c:out>	
	</template:replace>
	
	<%--操作按钮--%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<%--提交--%>
			<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}" 
					onclick="Com_OpenWindow('sysTaskAnalyze.do?method=edit&fdId=${param.fdId}','_self');">
				</ui:button>
			</kmss:auth>
			<%--删除--%>
			<kmss:auth requestURL="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.delete')}" 
					onclick="del('sysTaskAnalyze.do?method=delete&fdId=${param.fdId}');">
				</ui:button>
			</kmss:auth>
			<%--关闭--%> 
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
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
			<ui:menu-item text="${ lfn:message('sys-task:table.sysTaskAnalyze') }" href="/sys/task/sys_task_analyze_ui/" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>	
	
	<%--主内容--%>
	<template:replace name="content">
		<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog'], function($, dialog) {
				//删除确认框
				window.del=function(url){
					dialog.confirm("${lfn:message('page.comfirmDelete')}",function(isOk){
						if(isOk==true){
							Com_OpenWindow(url,'_self');
						}
					});
				};
			});
		</script>
		<html:form action="/sys/task/sys_task_analyze/sysTaskAnalyze.do">
			<html:hidden property="fdId"/>
			<div class="lui_form_content_frame" >
			<p class="lui_form_subject">
				<bean:message bundle="sys-task" key="table.sysTaskAnalyze" />
			</p>
			<table class="tb_normal" width=100%>
					<tr>
						<%--报表名称--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.docSubject"/>
						</td>
						<td width=35% colspan=3>
							<c:out value="${sysTaskAnalyzeForm.docSubject}"/>	
						</td>
					</tr>
					<tr>
						<%--对象类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.type"/>
						</td>
						<td width=35%>
							<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdAnalyzeObjType}" enumsType="sysTaskAnalyze_analyzeObj_type"></sunbor:enumsShow>	
						</td>
						<%--报表类型--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyze.type"/>
						</td>
						<td width=35%>
							<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdAnalyzeType}" enumsType="sysTaskFreedback_analyze_type"></sunbor:enumsShow>
						</td>
					</tr>
					<tr>
						<%--对象范围--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.analyzeObj.bound"/>
						</td>
						<td width=35% colspan=3>
							<c:out value="${sysTaskAnalyzeForm.fdBoundNames}"/>		
						</td>
					</tr>
					<tr>
						<%-- 是否包括所有子部门（包含个人）--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechild"/>
						</td>
						<td width=35%>
						<c:choose>
							<c:when test="${sysTaskAnalyzeForm.fdIsincludechild==NULL}">
						    	<bean:message  bundle="sys-task" key="task.yesno.no"/>
							</c:when>
							<c:otherwise>
								<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdIsincludechild}" enumsType="sysTaskAnalyze_fdIsincludechild"></sunbor:enumsShow>
							</c:otherwise>
						</c:choose>
						</td>
						<%--任务类型（是否包括子任务） --%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.fdIsincludechildTask"/>
						</td>
						<td width=35%>
						<c:choose>
							<c:when test="${sysTaskAnalyzeForm.fdIsincludechildTask==NULL}">
						    	<bean:message  bundle="sys-task" key="task.yesno.yes"/>
							</c:when>
							<c:otherwise>
								<sunbor:enumsShow value="${sysTaskAnalyzeForm.fdIsincludechildTask}" enumsType="sysTaskAnalyze_fdIsincludechildTask"></sunbor:enumsShow>		
							</c:otherwise>
						</c:choose>
						</td>
					</tr>
					<tr>
						<%-- 查询时期类型--%>
						<td colspan=4 class="td_normal_title" ><sunbor:multiSelectCheckbox formName="sysTaskAnalyzeForm"  enumsType="sysTaskAnalyze_fdDateQueryType" property="dateQueryTypeList"  htmlElementProperties = "disabled"></sunbor:multiSelectCheckbox></td>
					</tr>
					<tr>
						<%--开始日期--%>
						<td class="td_normal_title" width=15%>
							<bean:message  bundle="sys-task" key="sysTaskAnalyze.startDate"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskAnalyzeForm.fdStartDate}"/>
						</td>
						<%--结束日期--%>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="sys-task" key="sysTaskAnalyze.endDate"/>
						</td>
						<td width=35%>
							<c:out value="${sysTaskAnalyzeForm.fdEndDate}"/>
						</td>
					</tr>
				</table>
				<iframe id="iframe_id" frameborder="0" width="100%" height="100%" 
					src="${LUI_ContextPath}/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=listResult&fdId=${sysTaskAnalyzeForm.fdId}&fdStartDate=${sysTaskAnalyzeForm.fdStartDate}&fdEndDate=${sysTaskAnalyzeForm.fdEndDate}&dateQueryType=${sysTaskAnalyzeForm.dateQueryTypeList[0]}${sysTaskAnalyzeForm.dateQueryTypeList[1]}" ></iframe>
			</div>
		</html:form>
		
	</template:replace>
</template:include>