<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
function generateTree()
{
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="kms-expert" key="title.kms.expert"/>", document.getElementById("treeDiv"));
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	//========== 专家网络 ==========
	// 专家分类设置 
	n2 = n1.AppendURLChild("<bean:message bundle="kms-expert" key="menu.kmsExpertTepy.config"/>",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.expert.model.KmsExpertType&actionUrl=/kms/expert/kms_expert_type/kmsExpertType.do&formName=kmsExpertTypeForm&mainModelName=com.landray.kmss.kms.expert.model.KmsExpertInfo&docFkName=kmsExpertType" />"
	);
	
	// 类别导入
	n2 = n1.AppendURLChild(
		"<bean:message bundle="kms-expert" key="kmsExpert.config.category.import"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.expert.model.KmsExpertType"/>"
	);
	//专家导入
	n2 = n1.AppendURLChild(
		"<bean:message bundle="kms-expert" key="kmsExpert.config.main.import"/>",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.expert.model.KmsExpertInfo"/>"
	);
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
