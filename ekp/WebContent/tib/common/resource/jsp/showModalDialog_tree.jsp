<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("treeview.js|jquery.js");
</script>
<script type="text/javascript">
var TIB_LKSTreeModal;
$(function(){
	generateTIB_LKSTreeModal();
	//var textValue = "${param.value}";
	var params = window.dialogArguments;
	$("input[name=List_Selected][value='"+ params._key +"']").prop("checked", true);
});

// 打开页面展开分类树
function generateTIB_LKSTreeModal(){
	TIB_LKSTreeModal = new TreeView(
		"TIB_LKSTreeModal",
		"函数",
		document.getElementById("modalTreeDiv")
	);
	TIB_LKSTreeModal.isShowCheckBox=true;  			<%-- 是否显示单选/复选框 --%>
	TIB_LKSTreeModal.isMultSel=false;					<%-- 是否多选 --%>
	TIB_LKSTreeModal.isAutoSelectChildren = false;	<%-- 选择父节点是否自动选中子节点 --%>
	TIB_LKSTreeModal.DblClickNode = Modal_NodeDblClick;	<%-- 节点双击事件 --%>
	var n1 = TIB_LKSTreeModal.treeRoot;					<%-- 根节点 --%>
	<%--通过JavaBean的数据方式批量添加子结点,这里的bean填写前面的bean --%>
	// 总的bean
	var url = "${param.springBean}&parentId=!{value}";
	n1.AppendBeanData(url);
	TIB_LKSTreeModal.EnableRightMenu();
	TIB_LKSTreeModal.Show();
}

function Modal_NodeDblClick(nodeId) {
	var nodeObj = Tree_GetNodeByID(TIB_LKSTreeModal.treeRoot, nodeId);
	var returnJson = '{"_key":"'+nodeObj.value+'","_keyName":"'+nodeObj.text+'"}';
	//alert("returnJson="+returnJson);
	window.returnValue = eval('('+ returnJson +')');
	window.close();
}

function Modal_OkClick () {
	var val = $("input[name=List_Selected]:checked").val();
	var nodeObj = Tree_GetNodeByValue(TIB_LKSTreeModal.treeRoot, val);
	var returnJson = '{"_key":"'+nodeObj.value+'","_keyName":"'+nodeObj.text+'"}';
	window.returnValue = eval('('+ returnJson +')');
	window.close();
}

</script>
<div style="width:100%; height:300px;">
<div id="modalTreeDiv" class="treediv"></div>
<div style="position:absolute; bottom: 10px; left: 25%;">
<input type="button" style="float:left;" class="btnopt" value="<bean:message key="button.ok"/>" 
		onclick="Modal_OkClick();" />&nbsp;
<input type="button" class="btnopt" value="<bean:message key="button.close"/>" 
		onclick="window.close();">&nbsp;
<input type="button" class="btnopt" value="<bean:message key="button.cancelSelect"/>" 
		onclick="window.returnValue = '';window.close();" />
</div>
</div>
<%@ include file="/resource/jsp/list_down.jsp"%>