<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">选择分类</template:replace>
	<template:replace name="body">	
	<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
	<script>
		function selectSimpleCategory(){
			var data = {};
			var rtnVal = new Array;
			var selectNodes = LKSTree.GetCheckedNode();
			if(selectNodes!=null){
				selectNodes = new Array(selectNodes);
				if(selectNodes.length > 0){
					data.fdId = selectNodes[0].value
					data.fdName = (selectNodes[0].text!=null && selectNodes[0].text!="")?selectNodes[0].text:selectNodes[0].title;
				} 
				window.$dialog.hide(data);
			}else{
				alert("请选择");
			}
		}
	</script>
	<script>
	function generateTree(){
		var modelName = "${ param['model'] }";
		LKSTree = new TreeView(
			"LKSTree",
			"请选择",
			document.getElementById("treeDiv")
		);
		LKSTree.isShowCheckBox = true;
		LKSTree.isMultSel = false;
		LKSTree.treeRoot.AppendBeanData('sysSimpleCategoryTreeService&authType=00&modelName=' + modelName, null, null, null, null);
		LKSTree.Show();
	}
	</script>
	<table class="tb_normal" style="margin:20px auto;width:95%;height:460px;">
		<tr>
			<td valign="top" style="height: 400px;">
				<div id=treeDiv class="treediv" style="height: 400px;overflow-y: scroll;"></div>
				<script>generateTree();</script>
			</td>
		</tr>
		<tr>
			<td align="center"">
				<ui:button text=" ${ lfn:message('button.ok') } " onclick="selectSimpleCategory()"></ui:button>
				&nbsp;&nbsp;&nbsp;&nbsp;
				
				<ui:button text=" ${ lfn:message('button.cancelSelect') } " styleClass="lui_toolbar_btn_gray" onclick="window.$dialog.hide({'fdId':'','fdName':''})"></ui:button>
				&nbsp;&nbsp;&nbsp;&nbsp;
				
				<ui:button text=" ${ lfn:message('button.close') }  " styleClass="lui_toolbar_btn_gray" onclick="window.$dialog.hide(null)"></ui:button>
			</td>
		</tr>
	</table>
	</template:replace>
</template:include>