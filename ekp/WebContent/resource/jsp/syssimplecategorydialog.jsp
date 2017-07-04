<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ page import="com.landray.kmss.sys.simplecategory.interfaces.SimpleCategoryUtil" %>

<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script type="text/javascript">
var LKSTree;
Tree_IncludeCSSFile();

Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js");
var LKSTreeSub;
var modelName = top.dialogObject.modelName;

<%
String modelName = request.getParameter("modelName");
if (StringUtil.isNotNull(modelName)
	&& SimpleCategoryUtil.isAdmin(modelName)) {
%>
function loadAuthNodesValue() { 

}
<%  } else {%>
function NodeFunc_FetchChildrenByXML(){
	var nodesValue = new KMSSData().AddXMLData(Com_ReplaceParameter(this.XMLDataInfo.beanURL, this)).GetHashMapArray();
	for(var i=0; i<nodesValue.length; i++){
		if(checkAuth(nodesValue[i]))
			this.FetchChildrenUseXMLNode(nodesValue[i]);
	}
}
//判断该分类下是否有子分类的权限
function checkAuth(nodeValue){
	if(nodeValue["isShowCheckBox"]!="0"){
		return true;
	}
	//若节点自身没有权限，则判断是否需要显示
	var value = nodeValue["value"];
	for(var i=0; i<categoryAuthIds.length; i++){
		if(categoryAuthIds[i]["v"]==value){
			return true;
		}
	}
	return false;
}

var categoryAuthIds;
function loadAuthNodesValue() { // 读取有权限查看的分类ID
	categoryAuthIds = new KMSSData().AddBeanData("sysSimpleCategoryAuthList&modelName="+modelName+"&authType="
			+top.dialogObject.authType).GetHashMapArray();
}
<% } %>

function generateTree(){
	LKSTree = new TreeView("LKSTree", "<bean:message key="dialog.window.title" bundle="sys-simplecategory"/>", document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel = top.dialogObject.mulSelect;

	LKSTree.isAutoSelectChildren = false;
	var n1, n2;
	n1 = LKSTree.treeRoot;
	n1.authType = top.dialogObject.authType;
	n2 = n1.AppendSimpleCategoryData(modelName);
	LKSTree.Show();
}

function Com_DialogReturnValue(){
	var rtnVal = new Array;
	
	if(top.dialogObject.mulSelect) {
		var nodes = LKSTree.GetCheckedNode();
		if(nodes!=null && nodes.length>0){
			for(var i=0;i<nodes.length;i++) {				
				rtnVal[rtnVal.length] = new Array;				
				rtnVal[rtnVal.length-1]["id"] = nodes[i].value;	
				rtnVal[rtnVal.length-1]["name"] = (nodes[i].title==null || nodes[i].title=="")?nodes[i].text:nodes[i].title;
			}
		}
	}else{
			var nodes = LKSTree.GetCheckedNode();
			if(nodes!=null){
				rtnVal[0] = new Array;
				rtnVal[0]["id"] = nodes.value;	
				rtnVal[0]["name"] = (nodes.title==null || nodes.title=="")?nodes.text:nodes.title;	
			}
	}

	if(rtnVal.length==0)
		alert('<bean:message key="dialog.requiredSelect" />');
	else {
		parent.Com_DialogReturn(rtnVal);
	}
}

function Com_DialogReturnEmpty(){
	parent.Com_DialogReturn(new Array());
}

</script>
</head>
<body>
  <table width=100%  height="100%">
        <tr height="100%">
                <td valign="top">
			<div id=treeDiv></div>
		</td>
	</tr>
    </table>
<script>loadAuthNodesValue();generateTree();</script>
</body>
</html>