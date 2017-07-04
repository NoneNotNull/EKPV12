<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script type="text/javascript">
var LKSTree;
Tree_IncludeCSSFile();

Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js");
var LKSTreeSub;
var xformDesignObject = top.dialogObject.xformDesignObject;

function generateTree(){
	LKSTree = new TreeView("LKSTree", "<bean:message key="xform.dialog.window.title" bundle="sys-xform"/>", document.getElementById("treeDiv"));

	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel = top.dialogObject.mulSelect;

	LKSTree.isAutoSelectChildren = false;
	var n1, n2;
	n1 = LKSTree.treeRoot;
	
	if(xformDesignObject==null){
		return ;
	}
	var tables = xformDesignObject.tableTags;
	var mainTableLabel="";
	for(var i=0; i<tables.length; i++){
		var tl = tables[i]["label"];
		if(tables[i]["type"]=="main"){
			mainTableLabel = tl;
		}
		n2 = n1.AppendChild(tl);
		n3 = n2.AppendChild(tl+"ID", null, null,tables[i]["name"]+".@ID@", false);//ID
		for(var j=0;j<tables[i]["commonTags"].length;j++){
			var fl = tables[i]["commonTags"][j]["label"];
			n3 = n2.AppendChild(fl, null, null,tables[i]["name"]+"."+tables[i]["commonTags"][j]["name"], false);
		}
		if(tables[i]["type"]=="second"){
			n3 = n2.AppendChild(mainTableLabel+"ID", null, null,tables[i]["name"]+".@PARENT_ID@", false);//PARENT_ID
		}
	}

	n1.isExpanded = true;
	LKSTree.Show();

}

function Com_DialogReturnValue(){
	var rtnVal = new Array;
	var nodes = LKSTree.GetCheckedNode();
	if(nodes!=null){
		rtnVal[0] = new Array;
		rtnVal[0]["id"] = nodes.value;	
		//rtnVal[0]["name"] = nodes.value;	
		rtnVal[0]["name"] = (nodes.title==null || nodes.title=="")?nodes.text:nodes.title;	
	}

	if(rtnVal.length==0)
		alert('<bean:message key="dialog.requiredSelect" />');
	else {
		parent.Com_DialogReturn(rtnVal);
	}
}

function Com_DialogReturnEmpty(){
	var rtnVal = new Array;
	rtnVal[0] = new Array;
	rtnVal[0]["id"] = "";	
	rtnVal[0]["name"] = "";	
	parent.Com_DialogReturn(rtnVal);
}

function setNodeSelected(node,optType) {
	selectNodes = node;
	return true;
}
</script>
</head>
<body>
  <table id="Label_Tabel" width=100%  height="100%">
        <tr LKS_LabelName="<bean:message key="xform.dialog.window.title" bundle="sys-xform"/>" height="100%">
                <td valign="top">
			<div id=treeDiv></div>
		</td>
	</tr>
    </table>
<script>generateTree();</script>
</body>
</html>