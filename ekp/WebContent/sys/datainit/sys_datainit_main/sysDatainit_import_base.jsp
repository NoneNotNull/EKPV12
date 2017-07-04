<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">Com_IncludeFile("treeview.js");</script>
<script type="text/javascript">
var LKSTree;
window.onload=function(){
	setTimeout("generateTree();", 100);
};
function generateTree(){
	LKSTree = new TreeView("LKSTree", '<bean:message bundle="sys-datainit" key="sysDatainitMain.import.baseData.title"/>', document.getElementById("treeDiv"));
	var n1, n2, n3;
	LKSTree.isShowCheckBox=false;
	n1 = LKSTree.treeRoot;
	var json=eval(${filePaths});
	var arr = [];
	for(var i=0; i<json.length; i++) {
		n2 = n1.AppendChild(json[i].text);
		n2.isExpanded = true;
		for(var j=0; j<json[i].children.length; j++) {
			n3=n2.AppendChild(json[i].children[j].text);
			n3.value=json[i].children[j].value;
			n3.isExpanded = true;
			arr.push('<input type="hidden" name="List_Selected" value="' + Com_HtmlEscape(json[i].children[j].value) + '" />');
		}
	}
	LKSTree.Show();
	document.getElementById("hiddenDiv").innerHTML = arr.join("");
}
function submitForm(){
	var form = document.getElementsByName('configForm')[0];
	form.submit();
}
</script>
<form action="<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=startImport&type=baseImport" />" name="configForm" method="POST">
	
	<div id="optBarDiv">
		<input type=button value="<bean:message bundle="sys-datainit" key="sysDatainitMain.import" />"
			onclick="submitForm();">
		
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
	
	<table class="tb_noborder">
		<tr>
			<td width="10pt"></td>
			<td>
			<div id=treeDiv class="treediv"></div>
			<div id=hiddenDiv></div>
			</td>
		</tr>
	</table>
	
</form>

<%@ include file="/resource/jsp/edit_down.jsp"%>
