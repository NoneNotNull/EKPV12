<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.sys.webservice2" bundle="sys-webservice2"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 所有服务 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysWebserviceMain" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=list" />"
	);
	
    <%-- 服务状态   --%>
	n2 = n1.AppendURLChild("<bean:message key="sysWebserviceMain.fdServiceStatus" bundle="sys-webservice2" />");
	n2.AppendURLChild(
		"<bean:message key="sysWebserviceMain.fdServiceStatus.start" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=list&status=1" />"
	);	
	n2.AppendURLChild(
		"<bean:message  key="sysWebserviceMain.fdServiceStatus.stop" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=list&status=0" />"
	);	
	n2.isExpanded=true;
	
    <%-- 启动类型   --%>
	n2 = n1.AppendURLChild("<bean:message key="sysWebserviceMain.fdStartupType" bundle="sys-webservice2" />");
	n2.AppendURLChild(
		"<bean:message key="sysWebserviceMain.fdStartupType.auto" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=list&type=0" />"
	);	
	n2.AppendURLChild(
		"<bean:message  key="sysWebserviceMain.fdStartupType.manual" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=list&type=1" />"
	);	
	n2.AppendURLChild(
		"<bean:message  key="sysWebserviceMain.fdStartupType.disable" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_main/sysWebserviceMain.do?method=list&type=2" />"
	);		
	n2.isExpanded=true;
	
	<%-- 运行记录 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysWebserviceLog" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_log/sysWebserviceLog.do?method=list" />"
	);
	
    <%-- 搜索   --%>
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-webservice2" key="sysWebserviceLog.search"/>",
		"<c:url value="/sys/search/search.do?method=condition&fdModelName=com.landray.kmss.sys.webservice2.model.SysWebserviceLog" />"
	);	
	
	<%-- 超时预警 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="sysWebserviceMain.timeout" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_log/sysWebserviceLog.do?method=timeout" />"
	);	
	
	<%-- 模块设置   --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="sys.webservice2.tree.moduleSet" bundle="sys-webservice2" />"
	);
	<%-- 用户帐号设置   --%>
	n2.AppendURLChild(
		"<bean:message key="table.sysWebserviceUser" bundle="sys-webservice2" />",
		"<c:url value="/sys/webservice2/sys_webservice_user/sysWebserviceUser.do?method=list" />"
	);	
	<%-- 日志设置   --%>	
	n2.AppendURLChild(
		"<bean:message key="module.sys.webservice2.base" bundle="sys-webservice2"/>",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.sys.webservice2.model.SysWebServiceBaseInfo"/>"
	);
	<%-- 导入注册的服务   --%>
	n2.AppendURLChild(
		"<bean:message bundle="sys-webservice2" key="sysWebservice.init"/>",
		"<c:url value="/sys/webservice2/sys_webservice_init/sysWebserviceInit.do?method=init"/>"
	);		

	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>