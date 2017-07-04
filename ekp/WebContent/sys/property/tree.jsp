<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="sysProperty.tree.center" bundle="sys-property"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 所属分类 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.sysPropertyCategory" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.sys.property.model.SysPropertyCategory&actionUrl=/sys/property/sys_property_category/sysPropertyCategory.do&formName=sysPropertyCategoryForm" />"
	);
	
	<%-- 引用属性 --%>
	//n2 = n1.AppendURLChild(
		//"<bean:message key="table.sysPropertyReference" bundle="sys-property" />",
		//"<c:url value="/sys/property/sys_property_reference/sysPropertyReference.do?method=list" />"
	//);
	<%-- 属性库 --%>
	n4 = n1.AppendURLChild(
		"<bean:message key="sysPropertyDefine.set" bundle="sys-property" />"
	);
	
	<%-- 属性定义 --%>
	n5= n4.AppendURLChild(
		 "<bean:message key="table.sysPropertyDefine" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list" />"
	);
	<%--属性导入 --%>
	n4.AppendURLChild(
		"<bean:message key="sysProperty.tree.import" bundle="sys-property" />",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.property.model.SysPropertyDefine"/>"
	);
	<%-- 
	 n3 = n5.AppendURLChild(
		"字符串",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list&type=String" />"
	);
	n3 = n5.AppendURLChild(
		"整数",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list&type=Long" />"
	);
	n3 = n5.AppendURLChild(
		"浮点数",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list&type=Double" />"
	);
	n3 = n5.AppendURLChild(
		"日期",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list&type=DateTime" />"
	);	
	n3 = n5.AppendURLChild(
		"组织架构",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list&type=com.landray.kmss.sys.organization.model.SysOrgElement" />"
	);
	n3 = n5.AppendURLChild(
		"自定义树",
		"<c:url value="/sys/property/sys_property_define/sysPropertyDefine.do?method=list&type=com.landray.kmss.sys.property.model.SysPropertyTree" />"
	);--%>
	 
	 n3 = n4.AppendURLChild(
		"<bean:message key="sysProperty.advance" bundle="sys-property" />" 
	);
	 
	<%-- 主数据定义--%>
	n2 = n3.AppendURLChild(
		"<bean:message key="table.sysPropertyTree" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_tree/sysPropertyTree.do?method=list&isRoot=true" />"
	);
	<%-- 主数据录入 --%>
	n2 = n3.AppendURLChild(
		"<bean:message key="table.sysPropertyTree.in" bundle="sys-property" />"
	);
	n2.AppendBeanData(
		"sysPropertyTreeListService",
		"<c:url value="/sys/property/sys_property_tree/sysPropertyTree_tree.jsp" />?fdId=!{value}&fdName=!{text}",
		null, false
	);
	<%-- 主数据导入 --%>
	n3.AppendURLChild(
		"<bean:message key="sysProperty.tree.in" bundle="sys-property" />",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.sys.property.model.SysPropertyTree"/>"
	);
	
	
	<%--  模板库 --%>
	n3 = n1.AppendURLChild(
		"<bean:message key="sysPropertyTemplate.set" bundle="sys-property" />"
	);
	n4 = n3.AppendURLChild(
		"<bean:message key="table.sysPropertyTemplate" bundle="sys-property" />"
	);
	n4.AppendBeanData(
		"sysPropertyModelListService",
		"<c:url value="/sys/property/sys_property_template/sysPropertyTemplate.do">
			<c:param name="method" value="list" />
		</c:url>&fdModelName=!{value}",
		null, false
	); 
	
	<%-- 筛选项设置 --%>
	n2 = n3.AppendURLChild(
		"<bean:message key="table.sysPropertyFilterSetting" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=list" />"
	);
	<%--
	n2 = n3.AppendURLChild(
		"<bean:message key="table.sysPropertyFilterSetting2" bundle="sys-property" />",
		"<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=list" />"
	); 
	n2.AppendBeanData(
		"sysPropertyFilterListForMenuService" ,
		"<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do?method=list" />&filterBean=!{value}",
		null, false 
	); --%>
	 
	 

	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>