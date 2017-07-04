<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
</head>
<script type="text/javascript">
Com_IncludeFile("treeview.js|jquery.js");
var dialogObject = parent.dialogObject;
</script>
<script type="text/javascript">
var LKSTree;
Tree_IncludeCSSFile();
function generateTree(){
	//alert("dialogObject.tree="+dialogObject.tree);
	LKSTree = dialogObject.tree;
	LKSTree.DOMElement = document.getElementById("treeDiv");
	LKSTree.ClickNode = Dialog_ClickNode;
	LKSTree.DrawNode = TreeFunc_DrawNode;
	LKSTree.DrawNodeIndentHTML = TreeFunc_DrawNodeIndentHTML;
	LKSTree.DrawNodeOuterHTML = TreeFunc_DrawNodeOuterHTML;
	LKSTree.DrawNodeInnerHTML = TreeFunc_DrawNodeInnerHTML;
	LKSTree.ExpandNode = TreeFunc_ExpandNode;
	LKSTree.GetCheckedNode = TreeFunc_GetCheckedNode;
	LKSTree.SelectNode = TreeFunc_SelectNode;
	LKSTree.SetCurrentNode = TreeFunc_SetCurrentNode;
	LKSTree.SetNodeChecked = TreeFunc_SetNodeChecked;
	LKSTree.SetTreeRoot = TreeFunc_SetTreeRoot;
	LKSTree.Show = TreeFunc_Show;
	LKSTree.Show();
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
		parent.optFrame.setOptData(node.parameter);
		// 设置隐藏域，当前ID
		$("#currentId").val(node.value);
	}catch(e){
		return;
	}
	this.SetCurrentNode(node);
}

function getCategoryId() {
	var val = $("#currentId").val();
	return val;
}
</script>
</head>
<body>
<div id=treeDiv class="treediv"></div>
<input type="hidden" id="currentId" value=""/>
<script>generateTree();</script>
</body>
</html>