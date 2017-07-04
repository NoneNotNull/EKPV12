<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style type="text/css">
.oldValue , .newValue {
	width: 100%;
}
.tb_noborder .tb_normal td {
padding: 8px;
border: 1px #e8e8e8 solid;
}
</style>
<script type="text/javascript">
Com_IncludeFile("treeview.js|jquery.js");
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
<script type="text/javascript">
var LKSTree;
window.onload=function (){
	generateTree();
};
function generateTree(){
	LKSTree = new TreeView("LKSTree", '<bean:message bundle="sys-datainit" key="sysDatainitMain.import.title"/>', document.getElementById("treeDiv"));
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
function submitForm(obj){
	if(!verification_val()){
		return false;
	}
	var form = document.getElementsByName('configForm')[0];
	if(List_CheckSelect()){
		form.submit();
	}
	$(form).hide();
	$('#loading').show();
	$(obj).attr('disabled','disabled');
}
function verification_val(){
	if($("#isRel").is(":checked")){
		var inputs = $("#rel_body").find("input");
		for(var i=0;i<inputs.length;i++){ 
			if($(inputs[i]).val()==""){
				alert('<bean:message bundle="sys-datainit" key="sysDatainitMain.import.verification"/>');
				return false;
			}
		}
	}
	return true;
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

function selectValue(){
	var row = $("<tr></tr>");
	
	var xtd1 = $("<td></td>"); 
	xtd1.append('<input class="oldValue" type="text" name="oldValue" value="">'); 
	row.append(xtd1);				
	
	var xtd2 = $("<td></td>");				
	xtd2.append('<input class="newValue" type="text" name="newValue" value="" />');  
	row.append(xtd2);
	
	var xtd3 = $("<td align='center'></td>");
	xtd3.append('<img src="../../../resource/style/default/icons/delete.gif" alt="del" onclick="deleteValue(this);" style="cursor:pointer">&nbsp;&nbsp;');
	//xtd3.append('<img src="../../../resource/style/default/icons/up.gif" alt="up" onclick="pages_moveUp(this);" style="cursor:pointer">&nbsp;&nbsp;');
	//xtd3.append('<img src="../../../resource/style/default/icons/down.gif" alt="down" onclick="pages_moveDown(this);" style="cursor:pointer">');
	row.append(xtd3);
	
	$("#rel_body").append(row);
}
function deleteValue(obj){
	var xtr = $(obj).closest("tr");
	xtr.remove();
}
function relClick(obj){
	if(obj.checked){
		$("#rel_tr").show();
	}else{
		$("#rel_tr").hide();	
	}		
}
</script>
<form action="<c:url value="/sys/datainit/sys_datainit_main/sysDatainitMain.do?method=startImport" />" name="configForm" method="POST">
	
	<div id="optBarDiv">
		<input type=button value="<bean:message bundle="sys-datainit" key="sysDatainitMain.import" />"
			onclick="submitForm(this);">
		
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
	
	<table class="tb_noborder">
		<tr>
			<td width="10pt"></td>
			<td>
				<label><input type="checkbox" name="isImportRequired" value="true" /><bean:message bundle="sys-datainit" key="sysDatainitMain.import.isImportRequired" /></label>
				<bean:message bundle="sys-datainit" key="sysDatainitMain.import.isImportRequired.info" />
			</td>
		</tr>
		<tr>
			<td width="10pt"></td>
			<td>
				<label><input type="checkbox" name="isUpdate" value="true" checked="checked" /><bean:message bundle="sys-datainit" key="sysDatainitMain.import.isUpdate" /></label>
				<bean:message bundle="sys-datainit" key="sysDatainitMain.import.isUpdate.info" />
			</td>
		</tr>
		
		<tr>
			<td width="10pt"></td>
			<td colspan="3"><label><input type="checkbox" id="isRel" name="isRel" value="true" onclick="relClick(this)" /><bean:message bundle="sys-datainit" key="sysDatainitMain.import.isReplace" /></label></td>
		</tr>
		<tr id="rel_tr" style="display: none;">
			<td width="10pt"></td>
			<td>
			
				<table id="TABLE_DocList" class="tb_normal" width=100%>
					<tbody>
						<tr>
							<td align="center" class="td_normal_title"><bean:message bundle="sys-datainit" key="sysDatainitMain.import.oldValue" /></td>
							<td align="center" class="td_normal_title"><bean:message bundle="sys-datainit" key="sysDatainitMain.import.newValue" /></td>
							<td width="15%" align="center" class="td_normal_title">
								<img src="../../../resource/style/default/icons/add.gif" alt="add" onclick="selectValue();" style="cursor:pointer">
							</td>
						</tr>
					</tbody>
					<tbody id="rel_body">
					</tbody>
				</table>  
			
			</td>
		</tr>
	</table>
</form>
<div align="center" style="display: none;" id="loading">
	<img src="../../../resource/style/common/images/loading.gif" border="0" /><bean:message bundle="sys-datainit" key="sysDatainitMain.import.loading"/>
</div>
<%@ include file="/resource/jsp/edit_down.jsp"%>
