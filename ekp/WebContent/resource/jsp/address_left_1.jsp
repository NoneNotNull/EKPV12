<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
var dialogObject = top.dialogObject;
Com_Parameter.XMLDebug = dialogObject.XMLDebug;
var Data_XMLCatche = dialogObject.XMLCatche;
var startWith = Com_GetUrlParameter(location.href, "startWith");
startWith = startWith==null?"":startWith;
//获取父节点信息
var kmssData = new KMSSData();
kmssData.AddBeanData("organizationUserDept&startWith="+startWith);
var parentNodes = kmssData.GetHashMapArray();
var parentNode = new Object();
parentNode["value"] = startWith;
parentNode["text"] = top.dialogObject.treeTitle==null?"<bean:message bundle="sys-organization" key="organization.moduleName" />":top.dialogObject.treeTitle;
parentNode["title"] = parentNode["text"];
parentNodes[parentNodes.length] = parentNode;
var treeOrgType = null;

//生成树
function generateTree(){
	LKSTree = new TreeView("LKSTree", null, document.getElementById("treeDiv"));
	LKSTree.ClickNode = Dialog_ClickNode;
	LKSTree.DblClickNode = Dialog_DblClickNode;
	LKSTree.DrawNodeIndentHTML = Dialog_DrawNode;
	var selectType = dialogObject.addressBookParameter.selectType;
	var para = "organizationDialogList&parent=!{value}&orgType="+selectType;
	var n1 = LKSTree.treeRoot;
	n1.parameter = para;
	treeOrgType = selectType;
	if ((treeOrgType & ORG_TYPE_ALL) != ORG_TYPE_ORG)
		treeOrgType = treeOrgType & ~ORG_TYPE_ALL | ORG_TYPE_ORGORDEPT;
	n1.AppendOrgData(treeOrgType, para, null, parentNodes[0].value);
	refreshTree();
	//我的部门地址本打开时，目录树默认展开level级
	var level = '<%=ResourceUtil.getKmssConfigString("kmss.org.addrBookMyDeptExpandDef")%>';
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
//刷新树信息
function refreshTree(){
	var n1 = LKSTree.treeRoot;
	//更新根节点
	if(parentNodes.length <= 2){
		n1.text = parentNodes[0].text;
		n1.title = parentNodes[0].title;
	}else{
		n1.text = ".../"+parentNodes[0].text;
		n1.title = parentNodes[0].title;
		for(var i=1; i<parentNodes.length-1; i++)
			n1.title = parentNodes[i].title + "/" + n1.title;
	}
	//显示树
	LKSTree.Show();
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
	var selectType = dialogObject.addressBookParameter.rightSelectType;
	if(selectType == null || selectType == ""){
		selectType = dialogObject.addressBookParameter.selectType;
	}
	var p = new KMSSData().AddBeanData(Com_ReplaceParameter("organizationDialogList&parent=!{value}&orgType="+selectType, node));
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

//获取树节点的HTML代码
function Dialog_DrawNode(node, indent_level){
	var CannotExpand = (node.FetchChildrenNode==null && node.firstChild==null);
	var Result;
	if (parentNodes.length>1 && node.id==LKSTree.treeRoot.id)
		Result = Com_Parameter.StylePath + "tree/up.gif";
	else if(node.nodeType==ORG_TYPE_ORG)
		Result = TREENODESTYLE.imgOrgNode;
	else if(node.nodeType==ORG_TYPE_DEPT)
		Result = TREENODESTYLE.imgDeptNode;
	else if(node.nodeType==ORG_TYPE_PERSON)
		Result = TREENODESTYLE.imgPersonNode;
	else 
		Result = CannotExpand?TREENODESTYLE.imgLeaf:(node.isExpanded?TREENODESTYLE.imgOpenedFolder:TREENODESTYLE.imgClosedFolder);
	Result = "<a href=\"javascript:Dialog_JumpTo("+node.id+");\"><img src=" + Result + " border=0></a>";
	if(!CannotExpand)
		Result = "<a href=\"javascript:"+this.refName+".ExpandNode("+node.id+")\">"+Result+"</a>";
	if(indent_level <= 0)
		return Result;
	if(node.nextSibling == null){	
		if(CannotExpand)
			Result = "<img src="+TREENODESTYLE.imgLastNode+">"+Result;
		else
			Result = "<a href=\"javascript:"+this.refName+".ExpandNode("+node.id+")\">"
				+(node.isExpanded?"<img src="+TREENODESTYLE.imgLastNodeMinus+" border=0>":"<img src="+TREENODESTYLE.imgLastNodePlus+" border=0>")+"</a>"+Result;
	}else{
		if(CannotExpand)
			Result = "<img src="+TREENODESTYLE.imgNode+">"+Result;
		else
			Result = "<a href=\"javascript:"+this.refName+".ExpandNode("+node.id+")\">"
				+(node.isExpanded?"<img src="+TREENODESTYLE.imgNodeMinus+" border=0>":"<img src="+TREENODESTYLE.imgNodePlus+" border=0>")+"</a>"+Result;
	}

	var now = node.parent;
	for(i=indent_level-1; i>0; i--){
		if(now == null)
			break;
		Result = "<img src="+(now.nextSibling == null?TREENODESTYLE.imgBlank:TREENODESTYLE.imgVertLine)+">"+Result;
		now = now.parent;
	}
	return Result;
}
//重新设置树的根节点
function Dialog_JumpTo(id){
	var currentNode = Tree_GetNodeByID(LKSTree.treeRoot, id);
	if(LKSTree.treeRoot.id==id){
		//点击根节点图标，上跳一级
		if(parentNodes.length==1)
			return;
		//整理所有父节点信息
		parentNodes = parentNodes.slice(1, parentNodes.length);
		//创建新的根节点
		var root = new TreeNode();
		root.treeView = currentNode.treeView;
		root.parameter = currentNode.parameter;
		root.AppendOrgData(treeOrgType, currentNode.parameter, null, parentNodes[0].value);
		root.isExpanded = true;
		//加载根的子节点
		root.CheckFetchChildrenNode();
		//将当前根节点信息嵌入到root对应的子节点中
		for(var node = root.firstChild; node!=null; node = node.nextSibling)
			if(node.value == currentNode.value){
				if(root.firstChild==node)
					root.firstChild = currentNode;
				if(root.lastChild==node)
					root.lastChild = currentNode;
				currentNode.parent = root;
				if(node.prevSibling!=null)
					node.prevSibling.nextSibling = currentNode;
				currentNode.prevSibling = node.prevSibling;
				if(node.nextSibling!=null)
					node.nextSibling.prevSibling = currentNode;
				currentNode.nextSibling = node.nextSibling;
				currentNode.nodeType = node.nodeType;
				currentNode.text = node.text;
				currentNode.title = node.title;
			}
		//重设根节点，刷新树
		LKSTree.treeRoot = root;
		refreshTree();
	} else {
		//点击子节点图标，以该子节点为根节点展现
		var root = LKSTree.treeRoot;
		if(!currentNode.isExpanded)
			LKSTree.ExpandNode(currentNode);
		//子节点为叶子节点，不处理
		if(currentNode.firstChild==null)
			return;
		//整理父节点信息
		var pNodes = new Array();
		for(var node=currentNode; node.id!=root.id; node=node.parent){
			parentNode = new Object();
			parentNode["value"] = node.value;
			parentNode["text"] = node.text;
			parentNode["title"] = node.title;
			pNodes[pNodes.length] = parentNode;
		}
		parentNodes = pNodes.concat(parentNodes);
		//将当前节点设置为根节点，刷新树
		currentNode.parent = null;
		currentNode.prevSibling = null;
		currentNode.nextSibling = null;
		LKSTree.treeRoot = currentNode;
		refreshTree();
	}
}
<%@ include file="/resource/jsp/tree_down.jsp" %>