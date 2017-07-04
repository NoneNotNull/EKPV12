<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script type="text/javascript">
	var LKSTree,dialogObject;
	Tree_IncludeCSSFile();
	var Data_XMLCatche = dialogArguments.XMLCatche;

	if(window.showModalDialog){
		dialogObject = window.dialogArguments;
	}else{
		dialogObject = opener.Com_Parameter.Dialog;
	}
	
	function generateTree() {
		LKSTree = new TreeView("LKSTree", '<bean:message bundle="sys-xform-base" key="Designer_Lang.controlChinaValue_attr_relatedControl" />', document.getElementById("treeDiv"));
		LKSTree.isShowCheckBox=true;
		LKSTree.isMultSel=false;
		var n1, n2;
		n1 = LKSTree.treeRoot;
		
		n1.FetchChildrenNode = getVars;
		n1.isExpanded = true;
		
		LKSTree.Show();
	}
	
	function getVars(){
		var varInfo = top.dialogArguments.Parameters.varInfo;

		var valueData = dialogObject.valueData.GetHashMapArray()[0];
		
		for(var i=0; i < varInfo.length; i++){
			var dataType = varInfo[i].type;
			if (dataType == 'Double' || dataType == 'Double[]' ||  dataType == 'BigDecimal' || dataType == 'BigDecimal[]') {
				var textArr = varInfo[i].label.split(".");
				var pNode = this;
				var node;
				for(var j=0; j < textArr.length; j++){
					node = Tree_GetChildByText(pNode, textArr[j]);
					if(node == null){
						node = pNode.AppendChild(textArr[j]);
					}
					pNode = node;
				}
				if(valueData.id != "" && valueData.id == varInfo[i].name){
					LKSTree.SetNodeChecked(node,true);
				}
				node.value =varInfo[i].name;
			}
		}
	}
	
	//选择关联控件
	function selectRelatedCtr(){
		var data = [];
		var selectNodes = LKSTree.GetCheckedNode();
		if(selectNodes!=null){
			data.push({"id":selectNodes.value,"name":selectNodes.text});
			dialogObject.rtnData =data;
			close();
		}else{
			alert("请选择");
		}
	}

	//添加关闭事件
	Com_AddEventListener(window, "beforeunload", function(){dialogObject.AfterShow();});
	
</script>
</head>
<body>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top" style="height: 400px;">
				<div id=treeDiv class="treediv"></div>
				<script>generateTree();</script>
			</td>
		</tr>
		<tr>
			<td align="center">
				<input type=button class="btnopt" value="<bean:message key="button.ok"/>" onclick="selectRelatedCtr();">
    			&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" class="btnopt" value="<bean:message key="button.cancel"/>" onClick="window.close();">
			</td>
		</tr>
	</table>
</body>
</html>