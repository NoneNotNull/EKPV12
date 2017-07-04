<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<p><input type="button" value="添加" class="btnopt" id="addRow"
	onclick="DocList_AddRow( 'TABLE_DocList');"
/> <input type="button"
	value="上移" class="btnopt" id="upRow" onclick="move_Row(-1)"/> <input
	type="button" value="下移" class="btnopt" id="downRow"
	onclick=move_Row(1);; /> <input type="button" value="删除"
	class="btnopt" id="deleteRow" onclick="delete_Row()" /></p>
<center>
<table class="tb_normal" width=100% id="TABLE_DocList">
	<tr>
		<td class="td_normal_title" width="5%"><input type="checkbox"
			id="fdCatelogList_seclectAll" onclick="changeSelectAll(this);"/></td>
		<td class="td_normal_title" width="10%">排序号</td>
		<td class="td_normal_title" width="30%">目录名</td>
		<td class="td_normal_title" width="55%">默认可编辑者</td>
	</tr>
	<%--基准行--%>
	<tr KMSS_IsReferRow="1" style="display: none;">
		<td><input type="checkbox" name="fdCatelogList_seclect"
			onclick=changeSelect(this);; /></td>
		<td KMSS_IsRowIndex="1"></td>
		<td><input type='text' name='fdCatelogList[!{index}].fdName'
			style="width: 90%" class="inputsgl" /> <input type='hidden'
			name='fdCatelogList[!{index}].fdTemplateId'
			value='${kmsWikiTemplateForm.fdId}' /> <input type='hidden'
			name='fdCatelogList[!{index}].fdId' /> <input type='hidden'
			name='fdCatelogList[!{index}].fdOrder' /></td>
		<td><input type='hidden'
			name="fdCatelogList[!{index}].authTmpEditorIds" /> <textarea
			name="fdCatelogList[!{index}].authTmpEditorNames" style="width: 90%"
			rows="4" readonly="true" styleClass="inputsgl"></textarea> <a
			href="#" onclick=selectEditors(this);;><bean:message
			key="dialog.selectOrg" /></a></td>
	</tr>
	<%---内容行--%>
	<c:forEach items="${kmsWikiTemplateForm.fdCatelogList}"
		var="kmsWikiCatelogTemplateForm" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td><input type="checkbox" name="fdCatelogList_seclect"
				onclick=changeSelect(this);; /></td>
			<td>${vstatus.index+1}</td>
			<td><input type='text'
				name='fdCatelogList[${vstatus.index}].fdName' style="width: 90%"
				class="inputsgl" value='${kmsWikiCatelogTemplateForm.fdName}' /> <input
				type='hidden' name='fdCatelogList[${vstatus.index}].fdTemplateId'
				value='${kmsWikiTemplateForm.fdId}' /> <input type='hidden'
				name='fdCatelogList[${vstatus.index}].fdId'
				value='${kmsWikiCatelogTemplateForm.fdId}' /> <input type='hidden'
				name='fdCatelogList[${vstatus.index}].fdOrder'
				value='${kmsWikiCatelogTemplateForm.fdOrder}' /></td>
			<td><input type='hidden'
				name="fdCatelogList[${vstatus.index}].authTmpEditorIds"
				value="${kmsWikiCatelogTemplateForm.authTmpEditorIds}" /> <html:textarea
				property="fdCatelogList[${vstatus.index}].authTmpEditorNames"
				style="width:90%;height:90px" styleClass="inputmul" readonly="true" />
			<a href="#" onclick=selectEditors(this);;><bean:message
				key="dialog.selectOrg" /></a></td>
		</tr>
	</c:forEach>
</table>
</center>
<script>
	//上移
	function move_Row(val) {
		var selectObj = GetEl("fdCatelogList_seclect");
		var n = 0;
		for ( var i = 0; i < selectObj.length; i++) {
			if (selectObj[i].checked == true) {
				n++;//计算选中的个数。
				if (n > 1) {
					alert("只能选择一行");
					return false;
				}
			}
		}
		if (n == 0) {
			alert("请选择行");
			return false;
		}
		for ( var i = 0; i < selectObj.length; i++) {
			if (selectObj[i].checked == true) {
				DocList_MoveRow(val, selectObj[i].parentNode.parentNode);
				break;
			}
		}
	}


	//删除
	
	function delete_Row() {
		var selectObj = $('input[name="fdCatelogList_seclect"]:checked');
		if (!(selectObj.length)) {
			alert("请选择行");
			return;
		}
		if (confirm('<bean:message key="page.comfirmDelete"/>')) {
			selectObj.each( function() {
				DocList_DeleteRow(this.parentNode.parentNode);
			});
		}
	}

	//选择可编辑者
	function selectEditors(thisObj) {
		var idObj = thisObj.parentNode.childNodes[0];
		var nameObj = thisObj.parentNode.childNodes[1].nextSibling;
		Dialog_Address(true, idObj.name, nameObj.name, ';', 'ORG_TYPE_ALL');
	}

	//全选
	function changeSelectAll(thisObj) {
		var selectObj = GetEl("fdCatelogList_seclect");
		if (thisObj.checked == true) {
			//全选
			if (selectObj != null) {
				for ( var i = 0; i < selectObj.length; i++) {
					selectObj[i].checked = true;
				}
			}
		} else {
			//取消全选
			for ( var i = 0; i < selectObj.length; i++) {
				selectObj[i].checked = false;
			}
		}
	}

	//选择行
	function changeSelect(thisObj) {
		var selectAllObj = GetID("fdCatelogList_seclectAll");
		if (thisObj.checked == true) {
			var isAll = true;
			var selectObj = GetEl("fdCatelogList_seclect");
			for ( var i = 0; i < selectObj.length; i++) {
				if (selectObj[i].checked == false) {
					isAll = false;
					break;
				}
			}
			selectAllObj.checked = isAll;
		} else {
			selectAllObj.checked = false;
		}
	}

	//提交前将order重新赋值
	Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = function() {
		var index = GetID('TABLE_DocList').rows.length;//获取行数
		for ( var i = 1; i < index; i++) {			
			GetEl("fdCatelogList[" + (i - 1) + "].fdOrder")[0].value = i;
		}
		return true;
	}

	function GetEl(element) {
		return document.getElementsByName(element);
	}

	function GetID(element) {
		return document.getElementById(element);
	}
</script>
