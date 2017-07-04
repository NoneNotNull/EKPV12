<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>

var dialogObject = top.dialogObject;
Com_Parameter.XMLDebug = dialogObject.XMLDebug;
var Data_XMLCatche = dialogObject.XMLCatche
function generateTree(){
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-organization" key="sysOrg.address.nav2"/>", document.getElementById("treeDiv"));
	LKSTree.ClickNode = Dialog_ClickNode;
	var selectType = dialogObject.addressBookParameter.selectType;
	var n1 = LKSTree.treeRoot;
	var n2 = n1.AppendChild(
		"<bean:message bundle="sys-organization" key="sysOrg.address.myAddress"/>"
	);
	n2.isExpanded = true;
	n2.AppendBeanData(
		"organizationDialogMyAddress",
		"organizationDialogMyAddress&id=!{value}&orgType="+selectType,
		null,
		false
	);
	//常用群组，可根据selectType选择群组的成员
	n2 = n1.AppendChild(
		"<bean:message bundle="sys-organization" key="sysOrg.address.group"/>",
		"organizationDialogGroupList&groupCate=!{value}&nodeType=cate&orgType="+selectType
	);
	n2.AppendBeanData(
		"organizationDialogGroupTree&parent=!{value}",
		"organizationDialogGroupList&groupCate=!{value}&nodeType=!{nodeType}&orgType="+selectType
	);
	
	LKSTree.Show();
	//常用地址本打开时，目录树默认展开level级
	var level = '<%=ResourceUtil.getKmssConfigString("kmss.org.addrBookCommonExpandDef")%>';
	if(level != "null" && level != ""){
		expandNodes(LKSTree.treeRoot,LKSTree,level);
	}
}
/***********************************************
功能：展开树节点
参数：
	node：
		必选，当前节点
	treeObj：
		必选，TreeView对象
	level：
		必选，展开多少级
***********************************************/
function expandNodes(node,treeObj,level){
	if(node == null || treeObj == null)
		return;
	level = level == null ? 1 : level;
	level--;
	for(node=node.firstChild;node!=null;node=node.nextSibling){
		treeObj.ExpandNode(node)
		if(level>0)
			expandNodes(node,treeObj,level)
	}
}
function Dialog_ClickNode(node){
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return;
	if(node.parameter==null){
		this.ExpandNode(node);
		return;
	}
	if(node.parameter.IsKMSSData!=true)
		node.parameter = new KMSSData().AddBeanData(Com_ReplaceParameter(node.parameter, node));
	try{
		top.optFrame.setOptData(node.parameter);
	}catch(e){
		return;
	}
	this.SetCurrentNode(node);
}
<%@ include file="/resource/jsp/tree_down.jsp" %>