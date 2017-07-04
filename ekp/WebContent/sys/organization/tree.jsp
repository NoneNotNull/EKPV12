<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-organization" key="organization.moduleName"/>", document.getElementById("treeDiv"));
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
	n1.isExpanded = true;
	//========== 层级架构 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.levelOrg"/>",
		"<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do?method=list"/>&parent=!{value}"
	);
	n2.AppendOrgData(
		ORG_TYPE_ORGORDEPT|ORG_FLAG_BUSINESSALL,
		"<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do?method=list"/>&parent=!{value}",
		openListView
	);
	//========== 常用群组 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.group"/>",
		"<c:url value="/sys/organization/sys_org_group/sysOrgGroup.do?method=list&parentcate="/>"
	);
	n2.AppendBeanData(
		Tree_GetBeanNameFromService('sysOrgGroupCateService', 'hbmParent', 'fdName:fdId'),
		"<c:url value="/sys/organization/sys_org_group/sysOrgGroup.do?method=list&parentCate="/>!{value}"
	);
	//========== 所有架构 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.flatOrg"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.org"/>",
		"<c:url value="/sys/organization/sys_org_org/sysOrgOrg.do?method=list&all=true"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.dept"/>",
		"<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do?method=list&all=true"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.post"/>",
		"<c:url value="/sys/organization/sys_org_post/sysOrgPost.do?method=list&all=true"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.person"/>",
		"<c:url value="/sys/organization/sys_org_person/sysOrgPerson.do?method=list&all=true"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.group"/>",
		"<c:url value="/sys/organization/sys_org_group/sysOrgGroup.do?method=list"/>"
	);
	//========== 无效架构 ==========
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.unavailable"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.org"/>",
		"<c:url value="/sys/organization/sys_org_org/sysOrgOrg.do?method=list&available=0&all=true"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.dept"/>",
		"<c:url value="/sys/organization/sys_org_dept/sysOrgDept.do?method=list&available=0&all=true"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.post"/>",
		"<c:url value="/sys/organization/sys_org_post/sysOrgPost.do?method=list&available=0&all=true"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.person"/>",
		"<c:url value="/sys/organization/sys_org_person/sysOrgPerson.do?method=list&available=0&hidetoplist=true&all=true"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.group"/>",
		"<c:url value="/sys/organization/sys_org_group/sysOrgGroup.do?method=list&available=0"/>"
	);

	//========== 角色线 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="table.sysOrgRoleLine"/>"
	);
	n3 = n2.AppendBeanData("sysOrgRoleConfTree&auth=1",
		"<c:url value="/sys/organization/sys_org_role_line/sysOrgRoleLine.do?method=roleTree&fdConfId=!{value}" />",
		null,
		false);
	

	//========== 数据查询 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrg.tree.search.query"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.org"/>",
		"<c:url value="/sys/search/tree.jsp?fdModelName=com.landray.kmss.sys.organization.model.SysOrgOrg"/>",
		2
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.dept"/>",
		"<c:url value="/sys/search/tree.jsp?fdModelName=com.landray.kmss.sys.organization.model.SysOrgDept"/>",
		2
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.post"/>",
		"<c:url value="/sys/search/tree.jsp?fdModelName=com.landray.kmss.sys.organization.model.SysOrgPost"/>",
		2
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.person"/>",
		"<c:url value="/sys/search/tree.jsp?fdModelName=com.landray.kmss.sys.organization.model.SysOrgPerson"/>",
		2
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.group"/>",
		"<c:url value="/sys/search/tree.jsp?fdModelName=com.landray.kmss.sys.organization.model.SysOrgGroup"/>",
		2
	);
	
	<kmss:auth requestURL="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgOrg">
	//========== 导入 ==========
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrg.tree.transport.in"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.org"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgOrg"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.dept"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgDept"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.post"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgPost"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.person"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgPerson"/>"
	);
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.group"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgGroup"/>"
	);
	</kmss:auth>
	<kmss:authShow roles="SYSROLE_ADMIN">
	//========== 数据升级 ==========
	n2 = n1.AppendURLChild("<bean:message bundle="sys-organization" key="sysOrgElement.dataUpdate.title"/>","<c:url value="/sys/organization/sysOrgData_update.jsp" />");
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrg.tree.config"/>"
	);
	</kmss:authShow>
	<kmss:auth requestURL="/sys/oms/orgsynchro_notify_template_empty/orgSynchroNotifyTemplateEmpty.do?method=view&fdId=0">
	//========== 通知配置 ==========
	n2.AppendURLChild(
		"<bean:message bundle="sys-oms-notify" key="orgSynchroNotify"/>",
		"<c:url value="/sys/oms/orgsynchro_notify_template_empty/orgSynchroNotifyTemplateEmpty.do?method=view&fdId=0"/>"
	);
	</kmss:auth>
	//========== 角色线配置 ==========
	<kmss:auth requestURL="/sys/organization/sys_org_role/sysOrgRole.do?method=list">
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgRole.common.config"/>",
		"<c:url value="/sys/organization/sys_org_role/sysOrgRole.do?method=list"/>"
	);
	</kmss:auth>
	<kmss:auth requestURL="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=list">
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="table.sysOrgRoleConf"/>",
		"<c:url value="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=list"/>"
	);
	</kmss:auth>
	
	<kmss:auth requestURL="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do?method=list">
	//========== 群组类别 ==========
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="table.sysOrgGroupCate"/>",
		"<c:url value="/sys/organization/sys_org_group_cate/sysOrgGroupCate.do?method=list"/>"
	);
	</kmss:auth>
	<kmss:auth requestURL="/sys/organization/sys_org_org/sysOrgOrg.do?method=updateDeptToOrg">
	//========== 将部门设置为机构 ==========
	n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgOrg.updateDeptToOrg"/>",
		"<c:url value="/sys/organization/sys_org_org/sysOrgOrg_updateDeptToOrg.jsp"/>"
	);
	</kmss:auth>
	<kmss:auth requestURL="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgOrg">
	//========== 搜索配置 ==========
	n3 = n2.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrg.tree.search.config"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.org"/>",
		"<c:url value="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgOrg"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.dept"/>",
		"<c:url value="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgDept"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.post"/>",
		"<c:url value="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgPost"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.person"/>",
		"<c:url value="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgPerson"/>"
	);
	n3.AppendURLChild(
		"<bean:message bundle="sys-organization" key="sysOrgElement.group"/>",
		"<c:url value="/sys/search/sys_search_main/sysSearchMain.do?method=list&fdModelName=com.landray.kmss.sys.organization.model.SysOrgGroup"/>"
	);
	</kmss:auth>
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
function openListView(para){
	var orgName, url;
	try{
		var win = window;
		for(var frameWin = win.parent; frameWin!=null && frameWin!=win; frameWin=win.parent){
			if(frameWin.frames["viewFrame"]!=null){
				url = frameWin.frames["viewFrame"].location.href;
				orgName = url.substring(0, url.indexOf(".do"));
				orgName = orgName.substring(0, orgName.lastIndexOf("/"));
				orgName = orgName.substring(orgName.lastIndexOf("_")+1);
				if(orgName!="org" && orgName!="dept" && orgName!="post" && orgName!="person")
					orgName = null;
				break;
			}
			win = frameWin;
		}
	}catch(e){
		orgName = null;
	}
	if(orgName==null)
		orgName = "dept";
	var url = Com_Parameter.ContextPath+"sys/organization/sys_org_"+orgName+"/sysOrg"+orgName.substring(0,1).toUpperCase()+orgName.substring(1)+".do?method=list";
	url = Com_SetUrlParameter(url, "s_path", Tree_GetNodePath(this,">>",this.treeView.treeRoot));
	Com_OpenWindow(Com_SetUrlParameter(url, "parent", this.value), 3);
}
<%@ include file="/resource/jsp/tree_down.jsp" %>