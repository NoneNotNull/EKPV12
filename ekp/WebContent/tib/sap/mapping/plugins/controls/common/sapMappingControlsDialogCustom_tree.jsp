<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
Com_Parameter.XMLDebug = dialogArguments.XMLDebug;
var Data_XMLCatche = dialogArguments.XMLCatche;
function generateTree() {
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="tib-common" key="tibCommon.lang.formulaDefinition"/>", document.getElementById("treeDiv"));
	var n1, n2;
	n1 = LKSTree.treeRoot;
	n2 = n1.AppendChild(
		"<bean:message bundle="tib-sap" key="tibSapMapping.lang.var"/>"
	);
	n2.FetchChildrenNode = getVars;
	n1.isExpanded = true;
	LKSTree.Show();
}

function getVars(){
	var varInfo = top.dialogArguments.formulaParameter.varInfo;
	for(var i=0; i<varInfo.length; i++){
		if (varInfo[i].text != undefined) {
			var textArr = varInfo[i].text.split(".");
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
			node.value = "$"+varInfo[i].name+"$";
			node.type = "$"+varInfo[i].type+"$";
			node.label = "$"+varInfo[i].label+"$";
			node.tibEkpId = varInfo[i].tibEkpId;
		}
		
	}
}
function opFormula(){
	top.setCaret();
	parent.document.getElementById("expression").value = "";
	parent.document.getElementById("idField").value = this.tibEkpId;
	var area = top.document.getElementById("expression");
	top.insertText(area, this.label);
}
<%@ include file="/resource/jsp/tree_down.jsp" %>