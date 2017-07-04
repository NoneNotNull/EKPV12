<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js|data.js");</script>
<script>
function submitForm(method){
	Com_Submit(document.sysFormDbTableForm, method);
}
function SelectTable() {//sysFormDbListService实际返回空
	Dialog_List(false, 'fdTable', null, null, 'sysFormDbListService', 
			LoadColumns,
			'sysFormDbSearchService&keyword=!{keyword}',
			false, true, 
			'<kmss:message key="sys-xform:sysFormDbTable.selectTable" />');
}
function LoadColumns(data) {
	if (data == null) return;
	var values = data.GetHashMapArray();
	var kmssData = new KMSSData();
	kmssData.SendToBean('sysFormDbColumnListService&table=' + values[0].id, ShowColumns);
}
function ShowColumns(data) {
	if (data == null) return;
	var values = data.GetHashMapArray();
	AddDataToColumnTable(values);
}
function ReloadColumns() {
	if (confirm('<kmss:message key="sys-xform:sysFormDbTable.alert.confirm" />')) {
		var table = document.getElementsByName('fdTable')[0];
		new KMSSData().SendToBean('sysFormDbColumnListService&table=' + table.value, ReShowColumns);
	}
}
function ReShowColumns(data) {
	if (data == null) return;
	var values = data.GetHashMapArray();
	AddDataToColumnTable(values, initValues);
}
function GetOldValueByColumnName(name, oldValues) {
	for (var i = 0; i < oldValues.length; i ++) {
		if (name == oldValues[i].column) {
			return oldValues[i];
		}
	}
	return null;
}
function SetOldValueToNew(name, value, oldValues) {
	if (oldValues && oldValues.length > 0) {
		var old = GetOldValueByColumnName(value.column, oldValues);
		if (old && old[name] && old[name] != '') {
			value[name] = old[name];
		}
	}
}
function AddDataToColumnTable(values, oldValues) {
	var table = document.getElementById('columnTable');
	for (var i = table.rows.length-1; i > 1; i --) {
		table.deleteRow(i);
	}
	for (var i = 0; i < values.length; i ++) {
		AddColumnRow(table, values[i], i, oldValues);
	}
	$KMSSValidation(document.sysFormDbTableForm);
}
function AddColumnRow(table, value, index, oldValues) {
	var tr = table.insertRow(-1);
	AddEnableCell(table, tr, value, index, oldValues);
	AddIndexCell(table, tr, value, index, oldValues);
	AddNameCell(table, tr, value, index, oldValues);
	AddColumnCell(table, tr, value, index, oldValues);
	AddLengthCell(table, tr, value, index, oldValues);
	AddDataTypeCell(table, tr, value, index, oldValues);
	AddJavaTypeCell(table, tr, value, index, oldValues);
	AddRelationCell(table, tr, value, index, oldValues);
	SetNameSelectEnable(tr);
}
function SetNameSelectEnable(tr) {
	var inputs = tr.getElementsByTagName('input');
	var isEnable = false;
	for (var i = 0; i < inputs.length; i ++) {
		var c = inputs[i];
		if (c.name == 'isEnableCheck') {
			isEnable = c.checked;
			break;
		}
	}
	for (var i = 0; i < inputs.length; i ++) {
		var input = inputs[i];
		if (input.type == 'text') {
			input.style.color = isEnable ? '' : '#999';
		}
		if (input.name != null && input.name.indexOf('.fdName') > -1) {
			validateFormFieldSelectedReminderHidden(input);
		}
	}
	var selects = tr.getElementsByTagName('select');
	for (var i = 0; i < selects.length; i ++) {
		var s = selects[i];
		if (s.getAttribute('isFeildSelect') == 'true') {
			s.disabled = !isEnable;
			break;
		}
	}
}
function AddEnableCell(table, tr, value, index, oldValues) {
	var td = tr.insertCell(-1);
	var checkbox = document.createElement('<input type="checkbox" name="isEnableCheck">');
	checkbox.setAttribute('_namePre', 'fdColumns[' + index + ']');
	checkbox.onclick = function() {
		this.nextSibling.value = this.checked;
		SetNameSelectEnable(this.parentNode.parentNode);
	};
	td.appendChild(checkbox);
	if (oldValues != null && value.isPk != 'true') {
		var oldValue = GetOldValue(value, oldValues);
		if (oldValue != null) {
			var isEnable = (oldValue.isEnable == 'true' || oldValue.isEnable == true);
			checkbox.checked = isEnable;
			var input = document.createElement('<input type="hidden" name="fdColumns['
					+index+'].fdIsEnable" value="'+isEnable+'">');
			td.appendChild(input);
			return;
		}
	}
	var isEnable = (value.isEnable == 'true' || value.isEnable == true) || value.isPk == 'true';
	checkbox.checked = isEnable;
	if (value.isPk == 'true') checkbox.disabled = true;
	var input = document.createElement('<input type="hidden" name="fdColumns['
			+index+'].fdIsEnable" value="'+isEnable+'">');
	td.appendChild(input);
}
function AddIndexCell(table, tr, value, index, oldValues) {
	var td = tr.insertCell(-1);
	td.innerHTML = index + 1 + '<input type="hidden" name="fdColumns['+index+'].fdOrder" value="' + index + '">';
}
function AddNameCell(table, tr, value, index, oldValues) {
	var td = tr.insertCell(-1);
	var hidden = document.createElement('<input type="hidden" name="fdColumns['+index+'].fdName">');
	hidden.value = (value.name ? value.name : '');
	hidden.setAttribute('isFdName','true');
	if (value.isPk == 'true') {
		td.appendChild(hidden);
		hidden.value = 'fdId';
		td.appendChild(document.createTextNode("ID"));
		return;
	}
	var select = document.createElement('select');
	FillXFormOptions(select, (value.name ? value.name : null));
	td.appendChild(select);
	td.appendChild(hidden);
	select.onchange = function() {
		var hidden = this.nextSibling;
		hidden.value = this.value;
		validateFormFieldSelectedReminderHidden(hidden);
	};
	/*
	SetOldValueToNew('name', value, oldValues);
	td.innerHTML = '<input type="text" style="width:90%" class="inputsgl" name="fdColumns['
		+index+'].fdName" value="' + (value.name ? value.name : '') 
		+ '" subject="<kmss:message key="sys-xform:sysFormDbColumn.fdName" />" validate="required maxLength(50)" >'
		+ '<span class="txtstrong">*</span>';
	*/
	if (oldValues != null && value.isPk != 'true') {
		var oldValue = GetOldValue(value, oldValues);
		if (oldValue != null) {
			if (oldValue.name != null && oldValue.name != '') {
				FillXFormOptions(select, (oldValue.name ? oldValue.name : null));
				select.onchange();
			}
		}
	}
}
function AddColumnCell(table, tr, value, index, oldValues) {
	var td = tr.insertCell(-1);
	
	td.innerHTML = '<input type="text" style="width:90%" class="inputsgl" name="fdColumns['
		+index+'].fdColumn" value="' + (value.column ? value.column : value.tableName) + '" readOnly >';
}
function AddLengthCell(table, tr, value, index) {
	var td = tr.insertCell(-1);
	var html = '';
	if (value.maxLength != null) {
		html += '<input type="text" style="width:90%" class="inputsgl" name="fdColumns['
			+index+'].fdLength" value="' + value.maxLength + '" readOnly >';
	}
	td.innerHTML = html;
}
function AddDataTypeCell(table, tr, value, index) {
	var td = tr.insertCell(-1);
	var html = '<input type="text" style="width:100px" class="inputsgl" name="fdColumns['
		+index+'].fdDataType" value="' + (value.dataType ? value.dataType : '<kmss:message key="sys-xform:sysFormDbColumn.fdRelType.table" />') + '" readOnly >';
	td.innerHTML = html;
}
function AddJavaTypeCell(table, tr, value, index) {
	var td = tr.insertCell(-1);
	var html = '';
	if (value.type != null) {
		html += '<input type="text" style="width:200px" class="inputsgl" name="fdColumns['
			+index+'].fdType" value="' + value.type + '" readOnly >';
	}
	td.innerHTML = html;
}
function AddRelationCell(table, tr, value, index) {
	var td = tr.insertCell(-1);
	var html = '';
	if (value.isPk == true || value.isPk == 'true') {
		html = '<kmss:message key="sys-xform:sysFormDbColumn.fdIsPk" /> <input type="hidden" name="fdColumns['
			+index+'].fdIsPk" value="true" >';
	}
	if (value.relation == null || value.relation == '') {
		td.innerHTML = html;
		return;
	}
	if (value.relation == 'oneToMany') {
		td.innerHTML = html + GetRelationMessage('oneToMany', value.tableName)+'<input type="hidden" name="fdColumns['
			+index+'].fdRelation" value="oneToMany" ><input type="hidden" name="fdColumns['
			+index+'].fdTableName" value="'+value.tableName+'" >';
	}
	else if (value.relation == 'manyToMany') {
		td.innerHTML = html + GetRelationMessage('manyToMany', value.modelText)+'<input type="hidden" name="fdColumns['
			+index+'].fdRelation" value="manyToMany" ><input type="hidden" name="fdColumns['
			+index+'].fdTableName" value="'+value.tableName+'" ><input type="hidden" name="fdColumns['
			+index+'].fdModelName" value="'+value.modelName+'" ><input type="hidden" name="fdColumns['
			+index+'].fdModelText" value="'+value.modelText+'" ><input type="hidden" name="fdColumns['
			+index+'].fdMainColumn" value="'+value.mainColumn+'" ><input type="hidden" name="fdColumns['
			+index+'].fdElementColumn" value="'+value.elementColumn+'" >';
	}
	else if (value.relation == 'manyToOne') {
		if (value.modelName != null) {
			td.innerHTML = html + GetRelationMessage('manyToOne_sys', value.modelText)+'<input type="hidden" name="fdColumns['
				+index+'].fdRelation" value="manyToOne" ><input type="hidden" name="fdColumns['
				+index+'].fdModelName" value="'+value.modelName+'" ><input type="hidden" name="fdColumns['
				+index+'].fdModelText" value="'+value.modelText+'" >';
		} else {
			td.innerHTML = html + GetRelationMessage('manyToOne_table', value.tableName)+'<input type="hidden" name="fdColumns['
				+index+'].fdRelation" value="manyToOne" ><input type="hidden" name="fdColumns['
				+index+'].fdTableName" value="'+value.tableName+'" >&nbsp;&nbsp;<nobr><label><input type="checkbox" name="fdColumns['
				+index+'].fdIsForm" value="true" ><kmss:message key="sys-xform:sysFormDbColumn.is.fdIsForm" /></label></nobr>';
		}
	}
}
function GetOldValue(nValue, oldValues) {
	for (var i = 0; i < oldValues.length; i ++) {
		var old = oldValues[i];
		if (old.column != '' && old.column == nValue.column) {
			return old;
		} else if (old.tableName != '' && old.tableName == nValue.tableName) {
			return old;
		}
	}
}
function GetRelationMessage(key, text) {
	return GetRelationMessage.msg[key].replace('{0}' , text);
}
GetRelationMessage.msg = {
	'oneToMany' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.oneToMany" />',
	'manyToMany' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToMany" />',
	'manyToOne_sys' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_sys" />',
	'manyToOne_table' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_table" />'
};
<c:if test="${sysFormDbTableForm.tagerMethod !='edit' && sysFormDbTableForm.tagerMethod !='add'}">
function DesableInput() {
	var inputs = document.getElementsByTagName('input');
	for (var i = 0; i < inputs.length; i ++) {
		var input = inputs[i];
		if (input.type == 'text') {
			input.readOnly = true;
			input.className = 'inputread';
		} else if (input.type == 'checkbox') {
			input.disabled = true;
		}
	}
	var spans = document.getElementsByTagName('span');
	for (var i = 0; i < spans.length; i ++) {
		var span = spans[i];
		if (span.className == 'txtstrong') {
			span.style.display = 'none';
		}
	}
	var selects = document.getElementsByTagName('select');
	for (var i = 0; i < selects.length; i ++) {
		var select = selects[i];
		select.disabled = true;
	}
}
</c:if>
Com_AddEventListener(window, 'load', function() {
	if (initValues != null && initValues.length > 0) {
		AddDataToColumnTable(initValues);
	}
	InitFormFields();
	if (typeof DesableInput != 'undefined') {
		DesableInput();
	}
});
var initValues = [];
<c:if test="${not empty sysFormDbTableForm.fdColumns}">
<c:forEach items="${sysFormDbTableForm.fdColumns}" var="column">
initValues.push({
	name:"<c:out value="${column.fdName}"/>",
	column:"<c:out value="${column.fdColumn}"/>",
	dataType:"<c:out value="${column.fdDataType}"/>",
	type:"<c:out value="${column.fdType}"/>",
	relation:"<c:out value="${column.fdRelation}"/>",
	tableName:"<c:out value="${column.fdTableName}"/>",
	modelName:"<c:out value="${column.fdModelName}"/>",
	modelText:"<c:out value="${column.fdModelText}"/>",
	mainColumn:"<c:out value="${column.fdMainColumn}"/>",
	elementColumn:"<c:out value="${column.fdElementColumn}"/>",
	maxLength:"<c:out value="${column.fdLength}"/>",
	isPk:'<c:out value="${column.fdIsPk}"/>',
	isForm:'<c:out value="${column.fdIsForm}"/>',
	isEnable:'<c:out value="${column.fdIsEnable}"/>'
});
</c:forEach>
</c:if>
var xformFields = [];
function FillXFormOptions(select, value) {
	select.options.length = 0;
	select.options.add(new Option("<kmss:message key="sys-xform:sysFormDbTable.help.pleaseSelect" />", ''));
	select.setAttribute('isFeildSelect','true');
	for (var i = 0; i < xformFields.length; i ++) {
		var opt = new Option(xformFields[i].label, xformFields[i].name);
		select.options.add(opt);
		if (value == opt.value) {
			opt.selected = true;
		}
	}
}
function ReFillXFormOptions() {
	var selects = document.getElementsByTagName('select');
	for (var i = 0; i < selects.length; i ++) {
		var select = selects[i];
		var value = select.nextSibling.value;
		if (select.getAttribute('isFeildSelect') == 'true') {
			select.options.length = 0;
			FillXFormOptions(select, value);
		}
	}
}
function SelectXForm() {
	Dialog_List(false, 'fdFormId', 'fdFormName', null, 
			'sysFormListService&fdModelName=${sysFormDbTableForm.fdTemplateModel}&fdKey=${sysFormDbTableForm.fdKey}', 
			LoadFormFields,
			null, false, true, 
			'<kmss:message key="sys-xform:sysFormDbTable.selectForm" />');
}
function LoadFormFields(data) {
	if (data == null) {
		return;
	}
	var values = data.GetHashMapArray();
	var formType = document.getElementsByName('fdFormType')[0];
	formType.value = values[0].key3;
	var array = GetFormExtDictObj(values[0].key3, values[0].id);
	xformFields = array;
	ReFillXFormOptions();
}
DialogParams = {};
function ShowXFormFields() {
	/*
	Dialog_PopupWindow('<c:url value="/resource/jsp/frame.jsp">
			<c:param name="url" value="/sys/xform/base/sys_form_db_table/sysFormDbFormFields_view.jsp" />
			</c:url>', 500, 500, {formFiels:xformFields,title:'表单详细'});
	*/
	DialogParams = {formFiels:xformFields,title:'<kmss:message key="sys-xform:sysFormDbFormFields.title" />'};
	var left = (screen.width-500)/2;
	var top = (screen.height-400)/2;
	window.open('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbFormFields_view.jsp"/>', '_blank', 'resizable=1,scrollbars=1,height=400,width=500,left='+left+',top='+top);
}
function GetFormExtDictObj(tempType, tempId) {
	return new KMSSData().AddBeanData("sysFormDictVarTree&tempType="+tempType+"&tempId="+tempId).GetHashMapArray();
}
function InitFormFields() {
	var formId = document.getElementsByName('fdFormId')[0];
	var formType = document.getElementsByName('fdFormType')[0];
	if (formId.value == '' || formType.value == '') return;
	
	var array = GetFormExtDictObj(formType.value, formId.value);
	xformFields = array;
	ReFillXFormOptions();
}

function isUnique(fdNames, namePre) {
	var cName = document.getElementsByName(namePre+'.fdName')[0];
	for (var i = 0; i < fdNames.length; i ++) {
		if (fdNames[i].name != cName.name && fdNames[i].value == cName.value) {
			var isEnable = document.getElementsByName(fdNames[i].name.replace('.fdName', '.fdIsEnable'))[0];
			if (isEnable.value == 'true') {
				new Reminder(cName, '<kmss:message key="sys-xform:sysFormDbTable.alert.hasNotUniqueField" />').show();
				new Reminder(fdNames[i], '<kmss:message key="sys-xform:sysFormDbTable.alert.hasNotUniqueField" />').show();
				return false;
			}
		}
	}
	return true;
}
function validateFormFieldSelectedReminderHidden(dom) {
	new Reminder(dom).hide();
}
function ValidateFormFieldSelected() {
	var inputs = document.getElementsByTagName('input');
	var fdNames = [];
	for (var i = 0; i < inputs.length; i ++) {
		if (inputs[i].getAttribute('isFdName') == 'true') {
			fdNames.push(inputs[i]);
		}
	}
	
	for (var i = 0; i < inputs.length; i ++) {
		var checkbox = inputs[i];
		if (checkbox.name == 'isEnableCheck') { //isEnableCheck .indexOf('fdIsEnable')
			if (checkbox.checked == true) {
				var namePre = checkbox.getAttribute('_namePre');
				var cName = document.getElementsByName(namePre+'.fdName')[0];
				if (cName.value == '') {
					new Reminder(cName, '<kmss:message key="sys-xform:sysFormDbTable.alert.selectField" />').show();
					<%--//alert('<kmss:message key="sys-xform:sysFormDbTable.alert.selectField" />');--%>
					return false;
				}
				if (!isUnique(fdNames, namePre)) {
					<%--//alert('<kmss:message key="sys-xform:sysFormDbTable.alert.hasNotUniqueField" />');--%>
					return false;
				}
				new Reminder(cName).hide();
			}
		}
	}
	return true;
}
Com_Parameter.event["submit"].push(ValidateFormFieldSelected);
</script>

<kmss:windowTitle
	subjectKey="sys-xform:table.sysFormDbColumn.create.title"
	subject="${sysFormDbTableForm.fdName}"
	moduleKey="sys-xform:table.sysFormDbTable" />

<html:form action="/sys/xform/base/sys_form_db_table/sysFormDbTable.do" >
	
	<div id="optBarDiv">
		<c:if test="${not empty reToFormUrl}">
		<input type=button value="<kmss:message key="sys-xform:sysFormDbTable.btn.reToForm" />" onclick="Com_OpenWindow('${reToFormUrl}', '_blank');"/>
		</c:if>
		<input type=button value="<kmss:message key="sys-xform:sysFormDbTable.btn.showAllFields" />" onclick="ShowXFormFields();"/>
		<%-- 保存 --%>
		<c:if test="${sysFormDbTableForm.tagerMethod=='add'}">
			<input type=button value="<bean:message key="button.submit"/>"
				onclick="submitForm('save');">
		</c:if>
		<%-- 更新 --%>
		<c:if test="${sysFormDbTableForm.tagerMethod=='edit'}">
			<input type=button value="<bean:message key="button.submit"/>"
				onclick="submitForm('update');">
		</c:if>
		
		<c:if test="${sysFormDbTableForm.method_GET=='view'}">
			<%-- 编辑 --%>
			<input type=button value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
					<c:param name="method" value="edit"/>
					<c:param name="fdId" value="${param.fdId}"/>
				</c:url>', '_self');">
		</c:if>
		
		<%-- 关闭 --%>
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
	
	<%-- 显示标题 --%>
	<p class="txttitle">
		<bean:message bundle="sys-xform" key="table.sysFormDbTable" />
	</p>
	
	<center>
	<table class="tb_normal" width="95%">
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdName" /></td>
			<td colspan="3"><xform:text property="fdName" style="width:90%" 
				showStatus="${sysFormDbTableForm.tagerMethod == 'view' ? 'view' : 'edit'}" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdFormName" /></td>
			<td width=35%>
				<html:hidden property="fdFormType"/>
				<html:hidden property="fdFormId"/>
				<c:if test="${sysFormDbTableForm.tagerMethod != 'edit' && sysFormDbTableForm.tagerMethod !='add'}">
				<xform:text property="fdFormName" style="width:80%" htmlElementProperties="readOnly" />
				</c:if>
				<c:if test="${sysFormDbTableForm.tagerMethod == 'edit' || sysFormDbTableForm.tagerMethod == 'add'}">
				<xform:text property="fdFormName" style="width:80%" showStatus="edit" htmlElementProperties="readOnly" />
				</c:if>
				<%--input type="text" name="fdFormName" value="<c:out value="${sysFormDbTableForm.fdFormName}" />" 
					readonly class="inputsgl" style="width:80%"--%>
				<%--c:if test="${sysFormDbTableForm.method_GET!='view'}">
				<span class="txtstrong">*</span>
				<a href="javascript:void(0);" onclick="SelectXForm();">选择</a>
				</c:if--%>
			</td>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdTable" /></td>
			<td width=35%>
				<c:if test="${sysFormDbTableForm.tagerMethod != 'edit' && sysFormDbTableForm.tagerMethod !='add'}">
				<xform:text property="fdTable" style="width:80%" />
				</c:if>
				<c:if test="${sysFormDbTableForm.tagerMethod=='edit' || sysFormDbTableForm.tagerMethod=='add'}">
				<xform:text property="fdTable" style="width:80%" showStatus="edit" htmlElementProperties="readOnly" />
				<c:if test="${sysFormDbTableForm.tagerMethod=='add'}">
				<a href="javascript:void(0)" onclick="SelectTable();"><kmss:message key="dialog.selectOther" /></a>
				</c:if>
				<c:if test="${sysFormDbTableForm.tagerMethod=='edit'}">
				<a href="javascript:void(0)" onclick="ReloadColumns();"><kmss:message key="sys-xform:sysFormDbTable.btn.reloadTable" /></a>
				</c:if>
				</c:if>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.docCreator" /></td>
			<td width=35%>${sysFormDbTableForm.docCreatorName}</td>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.docCreateTime" /></td>
			<td width=35%>${sysFormDbTableForm.docCreateTime}</td>
		</tr>
		<tr>
			<td colspan="4">
			<table id="columnTable" class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td width="20px" rowspan="2"> </td>
					<td width="20px" rowspan="2"><kmss:message key="sys-xform:sysFormDbTable.No" /></td>
					<td width="150px" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdName" /></td>
					<td width="200px" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdColumn" /></td>
					<td width="50px" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdLength" /></td>
					<td width="250px" colspan="2"><kmss:message key="sys-xform:sysFormDbColumn.type" /></td>
					<td width="*" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.info" /></td>
				</tr>
				<tr class="tr_normal_title">
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.db" /></td>
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.java" /></td>
				</tr>
				<c:if test="${empty sysFormDbTableForm.fdColumns}">
				<tr>
					<td colspan="8" align="center"><kmss:message key="sys-xform:sysFormDbColumn.help.noColumn" /></td>
				</tr>
				</c:if>
			</table>
			</td>
		</tr>
	</table>
	</center>
	<html:hidden property="fdKey" />
	<html:hidden property="fdModelName" />
	<html:hidden property="fdTemplateModel" />
	<html:hidden property="tagerMethod" />
	<html:hidden property="method_GET" />
	<html:hidden property="fdId" />
</html:form>
<script>
Com_AddEventListener(window, 'load', function() {
	$KMSSValidation(document.sysFormDbTableForm);
});
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>