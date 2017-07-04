<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%
	request.setAttribute("userId",UserUtil.getUser(request).getFdId());
%> 
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="title.kms.ask" bundle="kms-ask"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	
	//分类设置
	n2 = n1.AppendURLChild(
		"<bean:message key="menu.kmsAsk.categoryConfig" bundle="kms-ask" />",
		"<c:url value="/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.kms.ask.model.KmsAskCategory&actionUrl=/kms/ask/kms_ask_category/kmsAskCategory.do&formName=kmsAskCategoryForm&mainModelName=com.landray.kmss.kms.ask.model.KmsAskTopic&docFkName=fdKmsAskCategory" />"
	);
	//类别导入
	n2 = n1.AppendURLChild(
		"<bean:message key="menu.kmsAsk.categoryImort" bundle="kms-ask" />",
		"<c:url value="/sys/transport/sys_transport_import/SysTransportImport.do?method=list&fdModelName=com.landray.kmss.kms.ask.model.KmsAskCategory"/>"
	);
	//问题设置
	n2 = n1.AppendURLChild("<bean:message bundle="kms-ask" key="menu.kmsAsk.config"/>",
		"<c:url value="/kms/ask/kms_ask_config/kmsAskConfig.do?method=view" />"); 
	//通知设置
	n2 = n1.AppendURLChild("<bean:message bundle="kms-ask" key="kmsAsk.notify.set"/>",
		"<c:url value="/sys/appconfig/sys_appconfig/sysAppConfig.do?method=edit&modelName=com.landray.kmss.kms.ask.model.KmsAskNotifyConfig" />");
	//知识货币管理
	n2 = n1.AppendURLChild("<bean:message bundle="kms-ask" key="kmsAskPost.knowledgeMoney.manger"/>",
		"<c:url value="/kms/ask/kms_ask_config/kmsKnowledgeMoneyMain.jsp" />");	

	n2 = n1.AppendURLChild("<bean:message bundle="kms-ask" key="kmsAskTopic.maintain"/>");
	n2.authType="01";
	<kmss:authShow roles="ROLE_KMSASKTOPIC_CATEGORY_MAINTAINER_EXTENSION">
	n2.authRole="optAll";
	</kmss:authShow>
	n2.AppendSimpleCategoryDataWithAdmin("com.landray.kmss.kms.ask.model.KmsAskCategory",
		"<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=manageList&categoryId=!{value}&status=all" />",
		"<c:url value="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=listChildren&categoryId=!{value}&orderby=docPublishTime&ordertype=down" />");
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>