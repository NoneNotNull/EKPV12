<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-admin" key="home.nav.sysAdmin"/>", document.getElementById("treeDiv"));
	var n1, n2, n3,n4;
	n1 = LKSTree.treeRoot;
	
<kmss:authShow roles="SYSROLE_ADMIN">
	//========== 系统初始化 ==========
	n2 = n1.AppendURLChild(
		"<bean:message key="global.init.system"/>",
		"<c:url value="/sys/common/config.do?method=systemInitPage"/>"
	);
	//==========数据初始化 ===========
	n2 = n1.AppendURLChild(
		"<bean:message key="global.init.data"/>"
	);
	n3 = n2.AppendURLChild(
		"<bean:message key="global.init.data.download"/>",
		"<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=showImport&type=export"/>"
	);
	n3= n2.AppendURLChild(
	"<bean:message key="global.init.export"/>",
		"<c:url value=""/>"
	);
	n3.AppendURLChild(
	"<bean:message key="global.init.import.baseData"/>",
		"<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=showStatus&type=baseImport"/>"
	);
	n3.AppendURLChild(
	"<bean:message key="global.init.data.upload"/>",
		"<c:url value="/sys/datainit/sys_datainit_main/sysDatainit_upload.jsp" />"
	);
	n3.AppendURLChild(
	"<bean:message key="global.init.export.data"/>",
		"<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=showStatus"/>"
	);
	//==========数据库检测======
	n2 = n1.AppendURLChild("<bean:message bundle="sys-admin" key="sysAdminDbchecker.dbchecker"/>",
		"<c:url value="/sys/admin/sys_admin_dbchecker/sysAdminDbchecker.do?method=select"/>"
	);
	//==========数据迁移======
	n2 = n1.AppendURLChild("<bean:message bundle="sys-admin-transfer" key="module.sys.admin.transfer"/>",
		"<c:url value="/sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do?method=list&status=10"/>"
	);
	//==========升级向导======
	n2 = n1.AppendURLChild("<bean:message bundle="sys-admin" key="sys.admin.upgradeWizard"/>",
		"<c:url value="/sys/admin/sysAdminUpgrade_wizard.jsp"/>"
	);
	//==========请求监控========
	n2 = n1.AppendURLChild("<bean:message bundle="sys-admin" key="sys.sysAdminThreadMonitor"/>",
		"<c:url value="/sys/admin/threadmonitor.do?method=monitor"/>"
	);
	//==========常用工具集========
	n2 = n1.AppendURLChild("<bean:message bundle="sys-admin" key="sys.sysAdminCommonTools"/>",
		"<c:url value="/sys/admin/commontools.do"/>"
	);
	//==========产品许可信息======
	n2 = n1.AppendURLChild(
		"<bean:message key="global.license.info"/>",
		"<c:url value="/sys/config/SystemLicense.jsp"/>"
	);
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-log" key="sysLogOnline.NotifyConfig.set"/>",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.sys.log.model.SysLogOnlineNotifyConfig"/>"
	);
</kmss:authShow>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>