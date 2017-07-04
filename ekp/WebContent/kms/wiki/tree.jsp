﻿<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
function generateTree(){
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="kms-wiki" key="module.kmsWiki"/>", document.getElementById("treeDiv"));
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
	
	//待解锁词条 
	n2 = n1.AppendURLChild(
		"<bean:message bundle="kms-wiki" key="kmsWikiMain.toUnlock"/>",
		"<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=toUnlock" />"); 
	//模板导入
	<kmss:authShow roles="ROLE_KMSWIKIMAIN_EXCEL_IMPORT" >
	n2 = n1.AppendURLChild(
		"<bean:message key="kmsWikiMain.config.template.import" bundle="kms-wiki" />",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.wiki.model.KmsWikiTemplate"/>" 
	);
	</kmss:authShow>
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
