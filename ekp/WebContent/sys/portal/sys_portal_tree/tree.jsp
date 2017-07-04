<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%> 
<%@ include file="/sys/ui/jsp/common.jsp"%>
var LKSTree;		//树对象
var currentOpt;		//当前的操作
var currentNode;	//当前操作的节点
var displayType;
Tree_IncludeCSSFile();
//更新导航类型的显示
function refreshType(){
	refreshDisplay();
}
//更新数据展现方式的显示
function refreshDisplay(){
	var fields = document.getElementsByName("fdDisplay");
	if(fields[0].checked){
		document.getElementById("designMode").style.display = "";
		document.getElementById("sourceMode").style.display = "none";
		//trArr[5].style.display = "";
		//trArr[6].style.display = "none";
		if(displayType!="Tree")
			generateTree();
		displayType = "Tree";
	}else{
		if(!checkChange()){
			fields[0].checked = true;
			return;
		}
		//trArr[5].style.display = "none";
		//trArr[6].style.display = "";
		currentNode = null;
		currentOpt = null;
		if(displayType!="Data")
			generateData();
		document.getElementById("designMode").style.display = "none";
		document.getElementById("sourceMode").style.display = "";
		displayType = "Data"
	}
}
//刷新操作栏的视图
function refreshOptView(){
	var divObj = document.getElementById("DIV_AllControl");
	if(currentNode==null){
		divObj.style.display = "none";
		return;
	}
	divObj.style.display = "";
	var elements = divObj.getElementsByTagName("span");
	var nodeType = currentNode.XMLDataInfo==null?"Node":"Data";
	for(var i=0; i<elements.length; i++){
		var lks_info = elements[i].getAttribute("lks_info");
		if(lks_info==null)
			continue;
		elements[i].style.display = (lks_info.indexOf(currentOpt)>-1 && lks_info.indexOf(nodeType)>-1)?"":"none";
	} 
	var selectObj = document.getElementsByName("tmpTarget")[0];
	selectObj.selectedIndex = 1; 
	document.getElementsByName("tmpNodeName")[0].value = "";
	document.getElementsByName("tmpURL")[0].value = "";
	if(currentOpt=="Edit"){
		document.getElementsByName("tmpNodeName")[0].value = currentNode.text;
		if(currentNode.parameter!=null){
			if(currentNode.parameter[0]!=null)
				document.getElementsByName("tmpURL")[0].value = currentNode.parameter[0];
			if(currentNode.parameter[1]!=null){
				for(var i=0; i<selectObj.options.length; i++)
					if(selectObj.options[i].value==currentNode.parameter[1]+""){
						selectObj.selectedIndex = i;
						break;
					}
			}
		}
	}
}
//修改树显示的大小
function resizeTreeDiv(x){
	x = x*100;
	var h = parseInt(document.getElementById("DIV_Tree").style.height);
	h += x;
	if(h<100)
		return;
	document.getElementById("DIV_Tree").style.height = h+"px";
}
//新建节点
function optAddNode(){
	if(checkChange()){
		currentOpt = "New";
		refreshOptView();
	}
}
//检查数据是否有修改
function checkChange(){
	if(currentNode==null)
		return true;
	var nodeName = document.getElementsByName("tmpNodeName")[0].value;
	var url = document.getElementsByName("tmpURL")[0].value;
	var target = document.getElementsByName("tmpTarget")[0];
	target = target.options[target.selectedIndex].value;
	if(currentOpt=="New"){
		if(nodeName!="" || url!=""){
			if(confirm("<bean:message  bundle="sys-portal" key="sysHomeNav.msg.confirm.create"/>"))
				return confirmNewNode();
		}
	}else{
		if(nodeName!=currentNode.text || (currentNode.parameter==null && url!="") || (currentNode.parameter!=null && currentNode.parameter[0]!=url)){
			if(confirm("<bean:message  bundle="sys-portal" key="sysHomeNav.msg.confirm.update"/>"))
				return confirmEditNode();
		}
	}
	return true;
}
//新建节点的确定操作
function confirmNewNode(){
	var field = document.getElementsByName("tmpNodeName")[0];
	if(field.value==""){
		alert("<bean:message  bundle="sys-portal" key="sysHomeNav.msg.error.nameNotNull"/>");
		return false;
	}
	var text = field.value;
	var parameter = null;
	field = document.getElementsByName("tmpURL")[0];
	if(field.value!=""){
		parameter = new Array();
		parameter[0] = field.value;
		field = document.getElementsByName("tmpTarget")[0];
		parameter[1] = field.options[field.selectedIndex].value;
	}
	var node = new TreeNode(text, parameter)
	currentNode.isExpanded = true;
	currentNode.AddChild(node);
	LKSTree.Show();
	currentOpt = "Edit";
	refreshOptView();
	return true;
}
//取消
function optCancel(){
	currentOpt = "Edit";
	refreshOptView();
}
//编辑节点的确定操作
function confirmEditNode(){
	var field = document.getElementsByName("tmpNodeName")[0];
	if(field.value==""){
		alert("<bean:message  bundle="sys-portal" key="sysHomeNav.msg.error.nameNotNull"/>");
		return false;
	}
	currentNode.text = field.value;
	field = document.getElementsByName("tmpURL")[0];
	if(field.value!=""){
		currentNode.parameter = new Array();
		currentNode.parameter[0] = field.value;
		field = document.getElementsByName("tmpTarget")[0];
		currentNode.parameter[1] = field.options[field.selectedIndex].value;
	}else{
		currentNode.parameter = null;
	}
	LKSTree.Show();
	return true;
}
//上移节点
function optMoveUp(node){
	if(node==null)
		return;
	var pNode = node.parent;
	if(pNode==null)
		return;
	var preNode = node.prevSibling;
	if(preNode==null)
		return;
	pNode.AddChild(node, preNode);
	LKSTree.Show();
}
//左移节点
function optMoveLeft(){
	var pNode = currentNode.parent;
	if(pNode==null)
		return;
	var fNode = pNode.parent;
	if(fNode==null)
		return;
	fNode.AddChild(currentNode, pNode.nextSibling);
	LKSTree.Show();
}
//右移节点
function optMoveRight(){
	var nNode = currentNode.prevSibling;
	if(nNode==null)
		return;
	if(nNode.firstChild!=null && nNode.firstChild.XMLDataInfo!=null)
		return;
	nNode.AddChild(currentNode);
	nNode.isExpanded = true;
	LKSTree.Show();
}
//删除节点
function optDeleteNode(){
	if(currentNode.parent==null){
		alert("<bean:message  bundle="sys-portal" key="sysHomeNav.msg.error.rootCanNotDel"/>");
		return;
	}
	if(!confirm("<bean:message  bundle="sys-portal" key="sysHomeNav.msg.confirm.delete"/>"))
		return;
	currentNode.Remove();
	currentNode = null;
	currentOpt = null;
	refreshOptView();
	LKSTree.Show();
}
//生成树
function generateTree(){
	var xmlTxt, treeData, nodeArr, i, lv;
	xmlTxt = document.getElementsByName("fdContent")[0].value;
	if(xmlTxt=="")
		treeData = [];
	else
		treeData = domain.toJSON(xmlTxt);
	if(LKSTree){
		document.getElementById("DIV_Tree").innerHTML = "";
		delete LKSTree;
	}
	LKSTree = new TreeView("LKSTree", '<bean:message  bundle="sys-portal" key="sysHomeNav.msg.node.root"/>', document.getElementById("DIV_Tree"));
	generateChildrenTree(LKSTree.treeRoot,treeData);
	LKSTree.ClickNode = onTreeNodeClick;
	LKSTree.Show();
	currentNode = null;
	currentOpt = null;
	refreshOptView();
}
function generateChildrenTree(root,data){
	for(var i =0;i<data.length;i++){
		var node = new TreeNode();
		node.text = data[i].text;
		node.isExpanded = true;
		node.nodeType = "node"; 
		if(data[i].href!=null){
			node.parameter = new Array();
			node.parameter[0] = data[i].href;
			if(data[i].target!=null){
				node.parameter[1] = data[i].target;
			}
		}
		root.AddChild(node);
		if(data[i].children!=null&&data[i].children.length >0){
			generateChildrenTree(node,data[i].children);
		}
	} 
} 
//从树生成XML
function generateData(){ 
	if($("#designMode").is(":visible")){
		document.getElementsByName("fdContent")[0].value = domain.stringify(getChildrenXML(LKSTree.treeRoot));
	}
	//document.getElementsByName("fdContent")[0].value = getChildrenXML(LKSTree.treeRoot);
}
function getChildrenXML(node){
	var children = [];
	for(var child = node.firstChild; child!=null; child = child.nextSibling){
		var no = {};
		no.text = child.text;
		if(child.parameter!=null){
			no.href = child.parameter[0];
			//no.target = child.parameter[1];
		}
		if(child.firstChild != null){
			no.children = getChildrenXML(child);
		}
		children.push(no);
	}
	return children;
} 
//树的节点点击事件
function onTreeNodeClick(node){
	//debugger;
	if(typeof(node)=="number")
		node = Tree_GetNodeByID(this.treeRoot, node);
	if(!checkChange())
		return;
	this.SetCurrentNode(node);
	currentNode = node;
	currentOpt = "Edit";
	refreshOptView();
}
//选择模块
function selectAppModule(){
	//Dialog_List(false, "tmpURL", "tmpNodeName", null, "sysHomeModuleDialog",null,null,null,null,"<bean:message  bundle="sys-portal" key="sysHomeNav.button.selectNode"/>");
	SysLinksDialog("tmpURL", "tmpNodeName");
}
//重载window的onload事件
Com_AddEventListener(window,'load', function (){
	refreshType();
});
function submitForm(method){
	generateData();
	Com_Submit(document.sysPortalTreeForm, method);
}