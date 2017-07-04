<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.keydata.base" bundle="km-keydata-base"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<kmss:auth requestURL="/km/keydata/customer">
    
	n2 = n1.AppendChild("客户");
	<%-- 客户 
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmCustomerMain" bundle="km-keydata-customer" />",
		"<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=list&fdIsAvailable=true" />"
	);
	--%>
	//按类别
	n3 = n2.AppendURLChild(
		"所有客户",
		"<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=listChildren&fdIsAvailable=true" />"
	
	);
	n3.AppendSimpleCategoryData(
		"com.landray.kmss.km.keydata.customer.model.KmCustomerCategory",
		"<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=listChildren&fdIsAvailable=true&type=category&categoryId=!{value}" />"
	);
	
	n2.AppendURLChild(
		"无效的客户",
		"<c:url value="/km/keydata/customer/km_customer_main/kmCustomerMain.do?method=listChildren&fdIsAvailable=false" />"
	
	);
	
	<kmss:auth requestURL="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.keydata.customer.model.KmCustomerCategory">
	//类别设置
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-keydata-customer" key="table.kmCustomerCategory"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.keydata.customer.model.KmCustomerCategory&actionUrl=/km/keydata/customer/km_customer_category/kmCustomerCategory.do&formName=kmCustomerCategoryForm&mainModelName=com.landray.kmss.km.keydata.customer.model.KmCustomerMain&docFkName=kmCustomerCategory" />"
	);
	</kmss:auth>
	
	<kmss:authShow roles="ROLE_SYSNUMBER_RULEADMIN,ROLE_SYSNUMBER_ADMIN">
     n3 = n2.AppendURLChild(
          "<bean:message bundle="sys-number" key="table.sysNumberMain"/>",
          "<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.keydata.customer.model.KmCustomerMain" />"
           );
    </kmss:authShow>
    
    <kmss:auth requestURL="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.km.keydata.customer.model.KmCustomerMain">
    n3 = n2.AppendURLChild(
          "导入EXCEL数据",
          "<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.km.keydata.customer.model.KmCustomerMain" />"
           );
    </kmss:auth>
	</kmss:auth>
	
	
	<kmss:auth requestURL="/km/keydata/project">
	n2 = n1.AppendChild("项目");
	<%-- 项目 
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmProjectMain" bundle="km-keydata-project" />",
		"<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do?method=list" />"
	);
	--%>
	//按类别
	n3 = n2.AppendURLChild(
		"所有项目",
		"<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do?method=listChildren&fdIsAvailable=true" />"
	
	);
	
	n3.AppendSimpleCategoryData(
		"com.landray.kmss.km.keydata.project.model.KmProjectCategory",
		"<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do?method=listChildren&fdIsAvailable=true&type=category&categoryId=!{value}" />"
	);
	
	
	n2.AppendURLChild(
		"无效的项目",
		"<c:url value="/km/keydata/project/km_project_main/kmProjectMain.do?method=listChildren&fdIsAvailable=false" />"
	
	);
	
	<kmss:auth requestURL="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.keydata.project.model.KmProjectCategory">
	//类别设置
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-keydata-project" key="table.kmProjectCategory"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.keydata.project.model.KmProjectCategory&actionUrl=/km/keydata/project/km_project_category/kmProjectCategory.do&formName=kmProjectCategoryForm&mainModelName=com.landray.kmss.km.keydata.project.model.KmProjectMain&docFkName=kmProjectCategory" />"
	);
	</kmss:auth>
	
	<kmss:authShow roles="ROLE_SYSNUMBER_RULEADMIN,ROLE_SYSNUMBER_ADMIN">
     n3 = n2.AppendURLChild(
          "<bean:message bundle="sys-number" key="table.sysNumberMain"/>",
          "<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.keydata.project.model.KmProjectMain" />"
           );
    </kmss:authShow>
    
    <kmss:auth requestURL="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.km.keydata.project.model.KmProjectMain">
    n3 = n2.AppendURLChild(
          "导入EXCEL数据",
          "<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.km.keydata.project.model.KmProjectMain" />"
           );
	</kmss:auth>
	</kmss:auth>  
	
	
	<kmss:auth requestURL="/km/keydata/supplier">
	n2 = n1.AppendChild("供应商");
	<%-- 供应商
	n3 = n2.AppendURLChild(
		"<bean:message key="table.kmSupplierMain" bundle="km-keydata-supplier" />",
		"<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=list&fdIsAvailable=true" />"
	);
	 --%>
	//按类别
	n3 = n2.AppendURLChild(
		"所有供应商",
		"<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=listChildren&fdIsAvailable=true" />"
	
	);
	n3.AppendSimpleCategoryData(
		"com.landray.kmss.km.keydata.supplier.model.KmSupplierCategory",
		"<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=listChildren&fdIsAvailable=true&type=category&categoryId=!{value}" />"
	);
	
	n3 = n2.AppendURLChild(
		"无效的供应商",
		"<c:url value="/km/keydata/supplier/km_supplier_main/kmSupplierMain.do?method=listChildren&fdIsAvailable=false" />"
	
	);
	
	<kmss:auth requestURL="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.keydata.supplier.model.KmSupplierCategory">
	//类别设置
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-keydata-supplier" key="table.kmSupplierCategory"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.km.keydata.supplier.model.KmSupplierCategory&actionUrl=/km/keydata/supplier/km_supplier_category/kmSupplierCategory.do&formName=kmSupplierCategoryForm&mainModelName=com.landray.kmss.km.keydata.supplier.model.KmSupplierMain&docFkName=kmSupplierCategory" />"
	);
	</kmss:auth>
	
	<kmss:authShow roles="ROLE_SYSNUMBER_RULEADMIN,ROLE_SYSNUMBER_ADMIN">
     n3 = n2.AppendURLChild(
          "<bean:message bundle="sys-number" key="table.sysNumberMain"/>",
          "<c:url value="/sys/number/sys_number_main/sysNumberMain.do?method=list&modelName=com.landray.kmss.km.keydata.supplier.model.KmSupplierMain" />"
           );
    </kmss:authShow>
    
    <kmss:auth requestURL="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.km.keydata.supplier.model.KmSupplierMain">
    n3 = n2.AppendURLChild(
          "导入EXCEL数据",
          "<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.km.keydata.supplier.model.KmSupplierMain" />"
           );
     </kmss:auth>
     </kmss:auth>   
     
   <kmss:auth requestURL="/km/keydata/base/kmKeydataPluginShow.do?method=list">
    n1.AppendURLChild(
          "调用关键数据的模块",
          "<c:url value="/km/keydata/base/kmKeydataPluginShow.do?method=list" />"
          );
<%--    
   	n1.AppendURLChild(
          "导入'关键数据'使用模块",
          "<c:url value="/km/keydata/base/kmKeydataPluginShow.do?method=importPluginShowData" />"
          );
--%>    
    </kmss:auth>    
	
	
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
window.onload = function(){
		if(window.parent){
			window.parent.document.title="关键数据";
		}
		
	}
<%@ include file="/resource/jsp/tree_down.jsp" %>