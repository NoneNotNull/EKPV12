<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
Com_Parameter.XMLDebug = dialogArguments.XMLDebug;
var Data_XMLCatche = dialogArguments.XMLCatche;
function generateTree() {
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="tib-jdbc" key="tree.root"/>", document.getElementById("treeDiv"));
	var n1, n2;
	n1 = LKSTree.treeRoot;
	n2 = n1.AppendChild(
		"<bean:message bundle="tib-jdbc" key="tree.var"/>"
	);
	n2.FetchChildrenNode = getVars;
	n2 = n1.AppendChild(
		"<bean:message bundle="tib-jdbc" key="tree.func"/>"
	);
	n2.FetchChildrenNode = getFunctions;
	
	n1.isExpanded = true;
	LKSTree.Show();
	
}

function getVars(){
	var varInfo = top.dialogArguments.formulaParameter.varInfo;
	for(var i=0; i<varInfo.length; i++){
		var textArr = varInfo[i].label.split(".");
		var pNode = this;
		var node;
		for(var j=0; j<textArr.length; j++){
			node = Tree_GetChildByText(pNode, textArr[j]);
			if(node==null){
				node = pNode.AppendChild(textArr[j]);
			}
			pNode = node;
		}
		node.action = opFormula;
		//node.value = "$"+varInfo[i].label+"$";
		node.value = varInfo[i].label;
	}
}

function getFunctions(){
	var funcInfo = top.dialogArguments.formulaParameter.funcInfo;
	funcInfo.sort(function(o1, o2){return o1.text==o2.text?0:(o1.text>o2.text?1:-1);});
	for(var i=0; i<funcInfo.length; i++){
		var textArr = funcInfo[i].text.split(".");
		var pNode = this;
		var node;
		for(var j=0; j<textArr.length; j++){
			node = Tree_GetChildByText(pNode, textArr[j]);
			if(node==null){
				node = pNode.AppendChild(textArr[j]);
			}
			pNode = node;
		}
		node.action = opFormula;
		node.value = funcInfo[i].value;
		node.title = funcInfo[i].title;
	}
}

function opFormula(){
	top.setCaret();
	var area = top.document.getElementById("expression");
	top.insertText(area, this.value);
}
<%@ include file="/resource/jsp/tree_down.jsp" %>