<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>

//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.kms.common" bundle="kms-common"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 推荐知识 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.kmsHomeKnowledgeIntro" bundle="kms-common" />",
		"<c:url value="/kms/common/kms_home_knowledge_intro/kmsHomeKnowledgeIntro.do?method=list" />"
	);
	<%--高级搜索设置 --%>
	n2 = n1.AppendURLChild(
		"高级搜索设置",
		"<c:url value="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=list" />"
	);
 
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%--
<%@page import="com.landray.kmss.web.SysTreeWriter"%>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message key="kms.common.sys" bundle="kms-common"/>", document.getElementById("treeDiv"));
	var nodes = new Array();
	nodes[0] = LKSTree.treeRoot;
	nodes[0].AppendURLChild("模块信息", "<c:url value="/kms/common/kms_common_main/kmsCommonMain.do?method=list" />");
	
	<%--个人中心--%><%-- %>
	nodes[1] = nodes[0].AppendURLChild(
		"<bean:message bundle="kms-common" key="table.kmsPersonInfo"/>"
	);	
	nodes[2] = nodes[1].AppendOrgData(
		"organizationTree&fdId=!{value}",
		"<c:url value="/kms/common/kms_person_info/kmsPersonInfo.do?method=list&parentId=!{value}" />");
	
	<%-- 无模版筛选 --%><%--
	nodes[1] = nodes[0].AppendURLChild(
		"<bean:message key="table.sysPropertyFilterMain" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_filter_main/sysPropertyFilterMain.do?method=list&amp;orderby=fdOrder" />"
	);	
		
	<%-- 模板库 --%><%--
	nodes[1] = nodes[0].AppendURLChild("模板库");
	<%-- 属性模板定义 --%><%--
	nodes[2] = nodes[1].AppendURLChild("<bean:message key="table.sysPropertyTemplate" bundle="sys-property" />");
	nodes[2].AppendBeanData(
		"sysPropertyModelListService",
		"<c:url value="/sys/property/sys_property_template/sysPropertyTemplate.do">
			<c:param name="method" value="list" />
		</c:url>&fdModelName=!{value}",
		null, false
	);
	<%-- 筛选项设置 --%><%--
	nodes[2] = nodes[1].AppendURLChild(
		"<bean:message key="table.sysPropertyFilterSetting" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=list" />"
	);
	
	<%-- 属性库 --%><%--
	nodes[1] = nodes[0].AppendURLChild(
		"属性库"
	);
	<%-- 属性定义 --%><%--
	nodes[2] = nodes[1].AppendURLChild(
		"<bean:message key="table.sysPropertyDefine" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list" />"
	);
	
	<%-- 属性导入--%><%--
	nodes[1].AppendURLChild(
		"属性导入",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.property.model.SysPropertyDefine"/>"
	);
		
	<%-- 高级选项 --%><%--
	nodes[2] = nodes[1].AppendURLChild(
		"高级选项"
	);
	<%-- 主数据定义 --%><%--
	nodes[3] = nodes[2].AppendURLChild(
		"<bean:message key="table.sysPropertyTree" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do?method=list&isRoot=true" />"
	);
	<%-- 主数据录入 --%><%--
	nodes[3] = nodes[2].AppendURLChild(
		"<bean:message key="table.sysPropertyTree.in" bundle="sys-property" />"
	);
	nodes[3].AppendBeanData(
		"sysPropertyTreeListService",
		"<c:url value="/sys/property/sys_property_tree/sysPropertyTree_tree.jsp" />?fdId=!{value}&fdName=!{text}",
		null, false
	);
	nodes[2].AppendURLChild(
		"主数据导入",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.property.model.SysPropertyTree"/>"
	);
	<%-- 知识标签 --%><%--
	nodes[1] = nodes[0].AppendURLChild(
		"知识标签"
	);
	<%-- 所有标签 --%><%--
	nodes[1].AppendURLChild(
		"<bean:message key="sysTag.tree.all" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_tags/sysTagTags.do?method=list" />"
	);
	<%-- 分类设置 --%><%--
	nodes[2] = nodes[1].AppendURLChild(
		"<bean:message key="sysTag.tree.system.category" bundle="sys-tag" />",
		"<c:url value="/sys/tag/sys_tag_category/sysTagCategory.do?method=list" />"
	);
	nodes[1].AppendURLChild(
		"标签类别导入",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.tag.model.SysTagCategory"/>"
	);
	nodes[1].AppendURLChild(
		"标签导入",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.tag.model.SysTagTags"/>"
	);
	
	nodes[1] = nodes[0].AppendURLChild(
		"高级搜索设置"
	);
	nodes[2] = nodes[1].AppendURLChild(
		"搜索范围设置",
		"<c:url value="/kms/common/kms_ftsearch_config/kmsFtsearchConfig.do?method=list" />"
	);
	<%= SysTreeWriter.getTreeNodesJS("kms", request) %>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}--%>
<%@ include file="/resource/jsp/tree_down.jsp" %> 