<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">Com_IncludeFile("dialog.js|optbar.js|list.js");</script>
<script type="text/javascript">
var LKSTree;
Tree_IncludeCSSFile();
//Com_Parameter.XMLDebug = true;
var confId = "${fdConfId}";

//生成树
function generateTree()
{
	LKSTree = new TreeView("LKSTree", '<c:out value="${fdConfName}" />', document.getElementById("treeDiv"));
	LKSTree.isShowCheckBox = true;
	LKSTree.isMultSel = false;
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;
	n1.isExpanded = true;
	n1.value = " ";
	n1.AppendBeanData("sysOrgRoleLineTree&confId="+confId+"&lineId=!{value}");
	LKSTree.Show();
}

//快速添加下级
function opt_quickAdd(){
	var node = getSelectedNode(true);
	if(node==null)
		return;
	if(node.nodeType==ORG_TYPE_ORG || node.nodeType==ORG_TYPE_DEPT){
		alert('<bean:message bundle="sys-organization" key="sysOrgRoleLine.msg.dept.noexist.role"/>');
		return;
	}
	Dialog_Address(true, null, null, null, ORG_TYPE_ALLORG, function(rtnData){
		if(rtnData==null || rtnData.IsEmpty())
			return;
		node.CheckFetchChildrenNode();
		var values = rtnData.GetHashMapArray();
		var ids = values[0].id;
		for(var i=1; i<values.length; i++)
			ids += ";" + values[i].id;
		runAction("quickAdd", function(result){
			for(var i=1; i<result.length; i++){
				node.AppendChild(result[i].text, null, null, result[i].value, null, result[i].nodeType);
			}
			node.isExpanded = true;
			LKSTree.Show();
		}, {parentId:node.value, orgIds:ids});
	});
}

//添加下级
function opt_add(){
	var node = getSelectedNode(true);
	if(node==null)
		return;
	if(node.nodeType==ORG_TYPE_ORG || node.nodeType==ORG_TYPE_DEPT){
		alert('<bean:message bundle="sys-organization" key="sysOrgRoleLine.msg.dept.noexist.role"/>');
		return;
	}
	node.CheckFetchChildrenNode();
	var query = "method=add&fdConfId="+confId+"&fdParentId="+node.value+"&fdParentName="+encodeURIComponent(node.text);
	var url = "sysOrgRoleLine_dialog.jsp?query="+encodeURIComponent(query);
	var rtnVal = openDialog(url);
	if(rtnVal==null)
		return;
	node.AppendChild(rtnVal.text, null, null, rtnVal.value, null, rtnVal.nodeType);
	node.isExpanded = true;
	LKSTree.Show();
}

//编辑
function opt_edit(){
	var node = getSelectedNode();
	if(node==null)
		return;
	var query = "method=edit&fdConfId="+confId+"&fdId="+node.value;
	var url = "sysOrgRoleLine_dialog.jsp?query="+encodeURIComponent(query);
	var rtnVal = openDialog(url);
	if(rtnVal==null)
		return;
	var parent = node.parent;
	node.text = rtnVal.text;
	node.value = rtnVal.value;
	node.nodeType = rtnVal.nodeType;
	Tree_SetNodeHTMLDirty(node);
	LKSTree.Show();
}

//删除节点
function opt_delete(){
	var node = getSelectedNode();
	if(node==null)
		return;
	node.CheckFetchChildrenNode();
	if(node.firstChild!=null){
		alert('<bean:message bundle="sys-organization" key="sysOrgRoleLine.msg.delete.error"/>');
		return;
	}else{
		if(!confirm('<bean:message bundle="sys-organization" key="sysOrgRoleLine.msg.delete.confirm"/>')){
			return;
		}
	}
	runAction("delete", function(result){
		node.Remove();
		LKSTree.Show();
	}, {id:node.value});
}

//移动节点
function opt_move(){
	var node = getSelectedNode();
	if(node==null)
		return;
	var dialog = new KMSSDialog(false, false);
	var root = dialog.CreateTree('<c:out value="${fdConfName}" />');
	root.value = " ";
	Data_XMLCatche = new Array();
	root.AppendBeanData("sysOrgRoleLineTree&nodept=true&confId="+confId+"&lineId=!{value}", null, null, null, node.value);
	dialog.SetAfterShow(function(rtnData){
		if(rtnData==null)
			return;
		var rtnVal = rtnData.GetHashMapArray()[0];
		var newParent = Tree_GetNodeByValue(LKSTree.treeRoot, rtnVal.id);
		if(newParent!=null){
			newParent.CheckFetchChildrenNode();
		}
		runAction("move", function(result){
			if(newParent!=null){
				newParent.AddChild(node);
			}else{
				node.Remove();
			}
			LKSTree.Show();
		}, {id:node.value, parentId:rtnVal.id});
	});
	dialog.notNull = true;
	dialog.Show();
}

//重复检查
function opt_check(){
	Com_OpenWindow('<c:url value="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do?method=checkRepeatRole&fdId=${fdConfId}"/>',"_blank");
}

//获取当前选定的节点
function getSelectedNode(includeRoot){
	var node = LKSTree.GetCheckedNode();
	if(node==null){
		alert('<bean:message bundle="sys-organization" key="sysOrgRoleLine.msg.pleaseSelect"/>');
		return null;
	}
	if(!includeRoot && node==LKSTree.treeRoot){
		alert('<bean:message bundle="sys-organization" key="sysOrgRoleLine.msg.rootForbit"/>');
		return null;
	}
	return node;
}

//打开对话框窗口
function openDialog(url){
	var winStyle = "resizable:1;scroll:1;dialogwidth:640px;dialogheight:480px;";
	return showModalDialog(url, null, winStyle);
}

//执行一个ajax请求
function runAction(method, action, parameter){
	var kmssdata = new KMSSData();
	kmssdata.AddHashMap(parameter);
	kmssdata.SendToBean("sysOrgRoleLineOption&method="+method+"&confId="+confId, function(rtnData){
		var rtnVal = rtnData.GetHashMapArray();
		if(rtnVal[0].success=="true"){
			action(rtnVal);
		}
		if(rtnVal[0].message!=null)
			alert(rtnVal[0].message);
	});
}
</script>
</head>
<body>
<div id="optBarDiv">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleLine.opt.quickCreate"/>" onclick="opt_quickAdd();">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleLine.opt.create"/>" onclick="opt_add();">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleLine.opt.move"/>" onclick="opt_move();">
	<input type="button" value="<bean:message key="button.edit"/>" onclick="opt_edit();">
	<input type="button" value="<bean:message key="button.delete"/>" onclick="opt_delete();">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleLine.opt.check"/>" onclick="opt_check();">
	<input type="button" value="<bean:message bundle="sys-organization" key="sysOrgRoleConf.simulator"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_role/sysOrgRole_simulator.jsp"/>','_blank');">
</div>
<div id=treeDiv class="treediv"></div>
<script>generateTree();</script>
</body>
</html>