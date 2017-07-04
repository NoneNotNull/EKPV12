<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
var dialogObject = top.dialogObject;
Com_Parameter.XMLDebug = dialogObject.XMLDebug;
var Data_XMLCatche = dialogObject.XMLCatche
function generateTree(){

	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-organization" key="sysOrg.addressBook" />", document.getElementById("treeDiv"));
	LKSTree.ClickNode = Dialog_ClickNode;
	LKSTree.DblClickNode = Dialog_DblClickNode;
	var selectType = dialogObject.addressBookParameter.selectType;
	var para = "organizationDialogList&parent=!{value}&orgType="+selectType;
	var n1 = LKSTree.treeRoot;
	var treeTitle = top.dialogObject.treeTitle==null?"<bean:message bundle="sys-organization" key="organization.moduleName" />":top.dialogObject.treeTitle;
	var n2 = n1.AppendChild(treeTitle, para);
	n2.isExpanded = true;
	var treeOrgType = selectType;
	if ((treeOrgType & ORG_TYPE_ALL) != ORG_TYPE_ORG)
		treeOrgType = treeOrgType & ~ORG_TYPE_ALL | ORG_TYPE_ORGORDEPT;
	n2.AppendOrgData(treeOrgType, para, null, dialogObject.addressBookParameter.startWith);
	if ((selectType & ORG_TYPE_ROLE) == ORG_TYPE_ROLE){
		var listBean = "organizationDialogRoleList&fdConfId=!{value}&orgType="+selectType;
		if(dialogObject.mulSelect)
			listBean += "&ismuti=1";
		n2 = n1.AppendChild(
			"<bean:message bundle="sys-organization" key="table.common.sysOrgRole" />", 
			listBean
		);
		n2 = n1.AppendChild("<bean:message bundle="sys-organization" key="sysOrg.address.roleLine" />");
		n2.AppendBeanData("sysOrgRoleConfTree",listBean,null,false);
	}	
	LKSTree.Show();
	//组织架构地址本打开时，目录树默认展开level级
	var level = '<%=ResourceUtil.getKmssConfigString("kmss.org.addrBookOrgExpandDef")%>';
	if(level != "null" && level != ""){
		expandNodes(LKSTree.treeRoot.firstChild,LKSTree,level);
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
//点击树节点动作
function Dialog_ClickNode(node){
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(node == null)
		return;
	if(node.parameter==null){
		this.ExpandNode(node);
		return;
	}
	var p;
	if(node.parameter.indexOf('organizationDialogRoleList')==-1){
		var selectType = dialogObject.addressBookParameter.rightSelectType;
		if(selectType == null || selectType == ""){
			selectType = dialogObject.addressBookParameter.selectType;
		}	
		p = new KMSSData().AddBeanData(Com_ReplaceParameter("organizationDialogList&parent=!{value}&orgType="+selectType, node));
	}else{
		p = new KMSSData().AddBeanData(Com_ReplaceParameter(node.parameter, node));
	}
	try{
		top.optFrame.setOptData(p);
	}catch(e){
		return;
	}
	this.SetCurrentNode(node);
}

//双击树节点动作
function Dialog_DblClickNode(node){
	var selectType = dialogObject.addressBookParameter.selectType;
	if((selectType & ORG_TYPE_DEPT) == ORG_TYPE_DEPT || (selectType & ORG_TYPE_ORG) == ORG_TYPE_ORG){
		if(typeof(node)=="number")
			node = Tree_GetNodeByID(this.treeRoot, node);
		if(node == null)
			return;
		if(node.nodeType == '1' || node.nodeType == '2'){
			var p = new KMSSData();
			p.data[0] = {id:node.value,name:node.text};
			try{
				if(dialogObject.dialogType == '1'){
					top.optFrame.selData.AddHashMap(p.data[0]);
					top.optFrame.setSelData();
				}else{
					top.optFrame.setOptData(p);
				}
			}catch(e){
				return;
			}
		}
	}
}
<%@ include file="/resource/jsp/tree_down.jsp" %>