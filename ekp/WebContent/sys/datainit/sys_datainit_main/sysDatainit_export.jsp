<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
	Com_IncludeFile("treeview.js");
</script>
<script type="text/javascript">
var LKSTree;
window.onload = function() {
	generateTree();
};
function generateTree(){
	LKSTree = new TreeView("LKSTree", "<bean:message bundle="sys-datainit" key="sysDatainitMain.export.title"/>", document.getElementById("treeDiv"));
	var n1, n2, n3;
	LKSTree.isShowCheckBox=true;
	LKSTree.isMultSel=true;
	LKSTree.isAutoSelectChildren = true;
	n1 = LKSTree.treeRoot;
	n1.value = " ";
	var json=eval(${filePaths});
	for(var i=0; i<json.length; i++) {
			n2 = n1.AppendChild(json[i].text);
			n2.value = " ";
			for(var j=0; j<json[i].children.length; j++) {
				n3=n2.AppendChild(json[i].children[j].text);
				n3.value=json[i].children[j].value;
			}
	}
	
	LKSTree.Show();
}
function submitForm(methodValue) {
	var form = document.getElementsByName('configForm')[0];
	form.action += '?method=' + methodValue + encodeURI('&s_path=${fn:escapeXml(param.s_path)}');
	if (List_CheckSelect()) {
		form.submit();
	}

}
function List_CheckSelect(){
	expandNode(LKSTree.treeRoot);
	var fields = document.getElementsByName("List_Selected");
	var selected = false;
	for(var i=0; i<fields.length; i++){
		var field = fields[i];
		if(field.checked && field.value!=" "){
			selected = true;
			break;
		}
	}
	if(!selected){
		alert("<bean:message key="page.noSelect"/>");
		return false;
	}
	for(var i=0; i<fields.length; i++){
		var field = fields[i];
		if(field.checked && field.value==" "){
			field.checked = false;
		}
	}
	return true;
}
function expandNode(node){
	if(!node.isExpanded){
		LKSTree.ExpandNode(node);
	}
	for(var child = node.firstChild; child!=null; child = child.nextSibling){
		expandNode(child);
	}
}
function deleteInitData(methodValue){
	if(!List_ConfirmDel())return;
	var form = document.getElementsByName('configForm')[0];
	form.action='<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do" />'+'?method='+methodValue+'&s_path=${fn:escapeXml(param.s_path)}';
	form.submit();
	
}
function List_ConfirmDel(){
	return List_CheckSelect() && confirm("<bean:message key="page.comfirmDelete"/>");
}
</script>
<form action="<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do" />" name="configForm" method="POST">
	<input type="hidden" value="" name="methodValue">
	<div id="optBarDiv">
	<input type=button name="open" value="<bean:message key="global.init.data.on"/>"
			onclick="setCookie('open')" style="display: none">
	<input type=button name="close" value="<bean:message key="global.init.data.off"/>"
			onclick="setCookie('close')" style="display: none" >
	<input type=button value="<bean:message key="global.init.data.zip.download"/>"
			onclick="submitForm('startExport');">
	<input type="button" value="<bean:message key="button.delete"/>"
			onclick="deleteInitData('deleteDataInit');">
	<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
		<table class="tb_noborder">
		<tr>
			<td width="10pt"></td>
			<td>
			<div id=treeDiv class="treediv"></div>
			</td>
		</tr>
	</table>
	
</form>

<script type="text/javascript">
function setCookie(value) {
	var Days = 30;
	var exp = new Date();
	exp.setTime(exp.getTime() + Days * 24 * 60 * 60 * 1000);
	document.cookie = "isopen=" + escape(value) + ";expires=" + exp.toGMTString() + ";path=" + Com_Parameter.ContextPath;
	cookieManager();
	window.location.reload();
}
//读取cookies   
function getCookie() {
	var arr, reg = new RegExp("(^| )isopen=([^;]*)(;|$)");
	if (arr = document.cookie.match(reg)) return unescape(arr[2]);
	else return null;
}
function cookieManager() {
	var mark = getCookie();
	if (mark == '' || mark == null) {
		setCookie('close')
		return;
	}
	if (mark == 'open') {
		document.getElementsByName("close")[0].style.display = 'block';
		document.getElementsByName("open")[0].style.display = 'none';
	}
	if (mark == 'close') {
		document.getElementsByName("open")[0].style.display = 'block';
		document.getElementsByName("close")[0].style.display = 'none';
	}
}
// 标准浏览器下onload下的cookieManager()在optbar加载完事件后面，导致按钮不初始化，故修改
cookieManager();
</script>

<%@ include file="/resource/jsp/edit_down.jsp"%>
