<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.km.signature" bundle="km-signature"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	<%-- 文档印章历史库
	n2 = n1.AppendURLChild(
		"<bean:message key="table.documentHistory" bundle="km-signature" />",
		"<c:url value="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do?method=list&" />"
	);
	<%-- 文档库表
	n2 = n1.AppendURLChild(
		"<bean:message key="table.document" bundle="km-signature" />",
		"<c:url value="/km/signature/km_signature_document_main/kmSignatureDocumentMain.do?method=list" />"
	);
	<%-- 文档印章库
	n2 = n1.AppendURLChild(
		"<bean:message key="table.documentSignature" bundle="km-signature" />",
		"<c:url value="/km/signature/km_signature_document_signature/kmSignatureDocumentSignature.do?method=list" />"
	); --%>
	<%-- 印章库 --%>
	n2 = n1.AppendURLChild(
		"<bean:message key="table.signature" bundle="km-signature" />",
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list" />"
	);
	<kmss:authShow roles="ROLE_SIGNATURE_ADD">
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>",
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&docType=1" />"	
	);
	</kmss:authShow>
	<kmss:authShow roles="ROLE_SIGNATURE_COMPANY">
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>",
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&docType=2" />"
	);
	</kmss:authShow>
	//-----------------我的印章-----------
	n2=n1.AppendURLChild(
		"<bean:message key="tree.myDoc" bundle="km-signature" />",
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&mydoc=mydoc" />"
	);
	<kmss:authShow roles="ROLE_SIGNATURE_ADD">
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>",
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&mydoc=mydoc&docType=1" />"	
	);
	</kmss:authShow>
	<kmss:authShow roles="ROLE_SIGNATURE_COMPANY">
	n3 = n2.AppendURLChild(
		"<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>",
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&mydoc=mydoc&docType=2" />"
	);
	</kmss:authShow>
	//按部门
	n2=n1.AppendURLChild(
		"<bean:message key="tree.byType" bundle="km-signature" />"
	);	
	n3 = n2.AppendOrgData(
		ORG_TYPE_DEPT,
		"<c:url value="/km/signature/km_signature_main/kmSignatureMain.do?method=list&departmentId=!{value}"/>"
	);
	<%-- 印章分类设置 --%>
	<kmss:authShow roles="ROLE_SIGNATURE_CATEGORY_MAINTAINER;ROLE_SIGNATURE_ADMIN">
	 n1.AppendURLChild(
		"<bean:message key="signatureCategory.setting" bundle="km-signature" />",
		"<c:url value="/km/signature/km_signature_category/kmSignatureCategory_tree.jsp?modelName=com.landray.kmss.km.signature.model.KmSignatureCategory&actionUrl=/km/signature/km_signature_category/kmSignatureCategory.do&formName=kmSignatureCategoryForm" />"
	);
	</kmss:authShow>

	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>