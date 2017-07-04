<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List,com.landray.kmss.sys.mobile.util.MobileConfigPlugin" %>
<%@page import="com.landray.kmss.third.pda.util.LicenseUtil"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.third.pda" bundle="third-pda"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;

	
	<%-- 移动组件配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="module.third.tree.setting" bundle="third-pda"/>",
		"<c:url value="/third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=list" />"
	);
	n2 = n1.AppendURLChild(
		"模块分类",
		"<c:url value="/third/pda/pda_module_cate/pdaModuleCate.do?method=list" />"
	);
	
	<%-- iPad配置 --%>
	n2= n1.AppendURLChild("<bean:message key="module.third.tree.home.ipad" bundle="third-pda"/>");
	<%-- 窗口配置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.pdaHomeCustomPortlet" bundle="third-pda"/>",
		"<c:url value="/third/pda/pda_custon_page_portlet/pdaHomeCustomPortlet.do?method=list" />"
	);
	<%-- 主页配置 --%>
	n3 = n2.AppendURLChild(
		"<bean:message key="table.pdaHomePageConfig" bundle="third-pda"/>",
		"<c:url value="/third/pda/pda_home_page_cfg/pdaHomePageConfig.do?method=list" />"
	);
	
	<%-- 功能区配置 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="module.third.tree.tabview.setting" bundle="third-pda"/>",
		"<c:url value="/third/pda/pda_tabview_config_main/pdaTabViewConfigMain.do?method=list" />"
	);
	
	<kmss:authShow roles="ROLE_THIRDPDA_ADMIN">
		<%-- 参数配置 --%>
		n2 = n1.AppendURLChild(
			"<bean:message key="module.third.tree.setting.other" bundle="third-pda"/>",
			"<c:url value="/third/pda/pda_rows_per_page_config/pdaRowsPerPageConfig.do?method=edit" />"
		);
	</kmss:authShow>
	
	<%-- 功能区配置 --%>
	<kmss:authShow roles="ROLE_SYSMOBILE_ADMIN">
	n2 = n1.AppendURLChild(
		"模块配置"
	);
	<%
	List modules = MobileConfigPlugin.findModuleConfigs();
	for (int i = 0; i < modules.size(); i ++) {
		MobileConfigPlugin.MobileConfigInfo cfgPage = (MobileConfigPlugin.MobileConfigInfo) modules.get(i);
	%>
		n3 = n2.AppendURLChild(
			"<c:out value="<%=cfgPage.getName() %>" />",
			"<c:url value="/sys/mobile/sys_mobile_module_category_config/sysMobileModuleCategoryConfig.do">
				<c:param name="fdModelName" value="<%=cfgPage.getModelName() %>" />
				<c:param name="method" value="edit" />
			</c:url>"
		);
	<%
	}
	%>
	n2 = n1.AppendURLChild(
		"压缩合并配置",
		"<c:url value="/sys/mobile/sys_mobile_compress/sysMobileCompress.do?method=listAll" />"
	);
	</kmss:authShow>
	
	n2 = n1.AppendURLChild(
		"扩展配置",
		"<c:url value="/third/pda/pda_data_extend_config/pdaDataExtendConfig.do?method=view" />"
	);
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>