<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-log" key="sysLog.moduleName"/>", document.getElementById("treeDiv"));
	var n1 = LKSTree.treeRoot;
	var n3;
	
<kmss:auth requestURL="/sys/log/sys_log_app/sysLogApp.do?method=list" requestMethod="GET">
	//========== 日志 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-log" key="sysLog.logList"/>"
	);
	n2.isExpanded = true;
	
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogApp"/>",
		"<c:url value="/sys/log/sys_log_app/sysLogApp.do?method=list"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message  bundle="sys-log" key="table.sysLogAppBak"/>",
		"<c:url value="/sys/log/sys_log_app/sysLogApp.do?method=list&isBak=true"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogError"/>",
		"<c:url value="/sys/log/sys_log_error/sysLogError.do?method=list"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogErrorBak"/>",
		"<c:url value="/sys/log/sys_log_error/sysLogError.do?method=list&isBak=true"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogJob"/>",
		"<c:url value="/sys/log/sys_log_job/sysLogJob.do?method=list"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogJobBak"/>",
		"<c:url value="/sys/log/sys_log_job/sysLogJob.do?method=list&isBak=true"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogLogin"/>",
		"<c:url value="/sys/log/sys_login_info/sysLogLogin.do?method=list"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogLoginBak"/>",
		"<c:url value="/sys/log/sys_login_info/sysLogLogin.do?method=list&isBak=true"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogLogout"/>",
		"<c:url value="/sys/log/sys_logout_info/sysLogLogout.do?method=list"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogLogoutBak"/>",
		"<c:url value="/sys/log/sys_logout_info/sysLogLogout.do?method=list&isBak=true"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogOrganization"/>",
		"<c:url value="/sys/log/sys_log_organization/sysLogOrganization.do?method=list"/>"
	);
	
	<%-- 在线用户 --%>
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-log" key="table.sysLogOnline"/>",
		"<c:url value="/sys/log/sys_log_online/sysLogOnline.do?method=list&type=online"/>"
	);
	n2.isExpanded = true;
</kmss:auth>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>