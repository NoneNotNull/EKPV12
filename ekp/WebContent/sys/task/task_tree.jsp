<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="sysTask.moduleName" bundle="sys-task"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5,n6,n7,n8,n9;
	n1 = LKSTree.treeRoot;
	//========== 我的文档 ==========
	<!-- 任务日历 -->
	/*n2 = n1.AppendURLChild(
		" 任务日历",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain_calendar_list.jsp"/>"
	);*/
	<!-- 我关注的任务 -->
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.my.attention" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain_calendar_list.jsp"/>"
	);
	<!-- 我指派的任务 -->
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.my.appoint" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.inactive" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1&fdStatus=1"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.progress" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1&fdStatus=2"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.complete" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1&fdStatus=3"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.overdure" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1&fdPastDue=1"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.terminate" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=1&fdStatus=4"/>"
	);
		
	<!-- 我负责的任务 -->
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.my.perform" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2"/>"		
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.inactive" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdStatus=1"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.progress" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdStatus=2"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.complete" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdStatus=3"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.overdure" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdPastDue=1"/>"
	);
	n2.AppendURLChild(
		"<bean:message key="tree.sysTaskMain.status.terminate" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=2&fdStatus=4"/>"
	);
	
	<!-- 任务查询 -->
	n2 = n1.AppendURLChild(
		"<bean:message key="tree.query" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3"/>"
	);
	<!-- 按完成状态 -->
	 n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-task" key="tree.query.status"/>"
	 );
		n3.AppendURLChild(
			"<bean:message key="tree.sysTaskMain.status.inactive" bundle="sys-task"/>",
			"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdStatus=1"/>"
		);
		n3.AppendURLChild(
			"<bean:message key="tree.sysTaskMain.status.progress" bundle="sys-task"/>",
			"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdStatus=2"/>"
		);
		n3.AppendURLChild(
			"<bean:message key="tree.sysTaskMain.status.complete" bundle="sys-task"/>",
			"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdStatus=3"/>"
		);
		n3.AppendURLChild(
			"<bean:message key="tree.sysTaskMain.status.overdure" bundle="sys-task"/>",
			"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdPastDue=1"/>"
		);
		n3.AppendURLChild(
			"<bean:message key="tree.sysTaskMain.status.terminate" bundle="sys-task"/>",
			"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdStatus=4"/>"
		);
	 
	 <!-- 按指派人 -->
	 n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-task" key="tree.query.appoint"/>"
	 );
/*	 n4 = n3.AppendURLChild(
		"<bean:message key="tree.query.dept" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdComplete=false"/>"
	 );	*/
	 n3.AppendOrgData(
		ORG_TYPE_ORGORDEPT,
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=listByAppionDept&orgId=!{value}"/>"
	 );
	 <!-- 按接收人-->
	  n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-task" key="tree.query.perform"/>"
	  );
/*	  n4 = n3.AppendURLChild(
		"<bean:message key="tree.query.dept" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=list&flag=3&fdComplete=false"/>"
	 );	*/
	 n3.AppendOrgData(
		ORG_TYPE_ORGORDEPT,
		"<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=listByPerformDept&orgId=!{value}"/>"
	 );
	 <!-- 任务搜索查询-->
	 n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-task" key="sysTaskMain.search.title"/>",
		"<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.sys.task.model.SysTaskMain" />"
	);	
	 
	 <!-- 按部门查询 -->
	 
	<!-- 任务分析 -->
	n8 = n1.AppendURLChild(
		"<bean:message key="tree.analyze" bundle="sys-task"/>"
	);
	 n4 = n8.AppendURLChild(
		"<bean:message key="tree.load" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=list&type=1"/>"
	);
	 n5 = n8.AppendURLChild(
		"<bean:message key="tree.degree" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=list&type=2"/>"
	);	
	 n6 = n8.AppendURLChild(
		"<bean:message key="tree.synthesized" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_analyze/sysTaskAnalyze.do?method=list&type=3"/>"
	);	
	<!-- 模块配置 -->
	n9 = n1.AppendURLChild(
		"<bean:message key="tree.module.set" bundle="sys-task"/>"
	);
    n4 = n9.AppendURLChild(
		"<bean:message key="tree.task.category.set" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_category/sysTaskCategory.do?method=list"/>"
	);
	 n5 = n9.AppendURLChild(
		"<bean:message key="tree.task.degree.set" bundle="sys-task"/>",
		"<c:url value="/sys/task/sys_task_approve/sysTaskApprove.do?method=list"/>"
	);
	<kmss:ifModuleExist  path = "/sys/communicate/">
	n5 = n9.AppendURLChild(
		"<bean:message bundle="sys-task" key="sysTaskMain.communicateType"/>",
		"<c:url value="/sys/communicate/sys_communicate_type/sysCommunicateType.do?method=list"/>"
	);	
	
	n5 = n9.AppendURLChild(
		"<bean:message bundle="sys-task" key="sysTaskMain.communicateConfigTitle"/>",
		"<c:url value="/sys/communicate/sys_communicate_config/sysCommunicateConfig.do?method=edit&modelName=com.landray.kmss.sys.task.model.SysTaskMain"/>"
	);	
	</kmss:ifModuleExist>
	
 LKSTree.Show();
 }
<%@ include file="/resource/jsp/tree_down.jsp" %>