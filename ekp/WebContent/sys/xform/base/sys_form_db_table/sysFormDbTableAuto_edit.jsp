<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style type="text/css">
.hideLength {
	display:none;
}
</style>
<kmss:windowTitle
	subjectKey="sys-xform:table.sysFormDbColumn.create.title"
	subject="${sysFormDbTableForm.fdName}"
	moduleKey="sys-xform:table.sysFormDbTable" />
	
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
		
		<%-- 关闭 --%>
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
	
	<%-- 显示标题 --%>
	<p class="txttitle">
		<bean:message bundle="sys-xform" key="sysFormTemplate.prompt.button.autoTitle" />
	</p>

<html:form action="/sys/xform/base/sys_form_db_table/sysFormDbTable.do" >
	
	<center>
	<table class="tb_normal" width="95%" id="db_table">
	<tbody>
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdName" /></td>
			<td colspan="3"><html:text property="fdName" style="width:90%" styleClass="inputsgl" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdFormName" /></td>
			<td width=35%>
				<html:hidden property="fdFormType"/>
				<html:hidden property="fdFormId"/>
				<html:hidden property="fdTableType"/>
				<html:text property="fdFormName" style="width:90%" readonly="true" styleClass="inputsgl" />
			</td>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdTable" /></td>
			<td width=35%>
				<html:text property="fdTable" style="width:70%" styleClass="${(sysFormDbTableForm.tagerMethod=='edit')?'inputread':'inputsgl'}" readonly="${(sysFormDbTableForm.tagerMethod=='edit')?'true':'false'}" />
				<%-- 
				<a href="javascript:void(0)" onclick="SelectMainTable();"><kmss:message key="dialog.selectOther" /></a>
				 --%>
				<c:if test="${sysFormDbTableForm.tagerMethod=='edit'}">
				<a href="javascript:void(0)" onclick="ReloadMainTable(false);"><kmss:message key="sys-xform:sysFormDbTable.btn.reloadTable" /></a>
				</c:if>
			</td>
		</tr>
		<tr style="display:none;">
			<td colspan="4">
			<table id="columnTable" class="tb_normal" width="100%" style="display:none;">
				<tr class="tr_normal_title">
					<td width="20px" rowspan="2"><input type="checkbox" class="mainTableSelectAll" onclick="selectAll(this)"/></td>
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
				
				<tr class="template">
					<td>
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdIsEnable" value="!{ VAR.isEnable /}">
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdOrder" value="!{ VAR.order == null ? VAR.index : VAR.order /}">
						<input type="checkbox" class="enableBox" onclick="SetEnableRowAuto(this.parentNode.parentNode);">
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdAllowEdit" value="!{ VAR.allowEdit /}">
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdUserColumn" value="!{ VAR.userColumn /}" />
					</td>
					<td>!{ VAR.index + 1/}</td>
					<td>
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdName" value="!{ VAR.name /}">
						<select class="fdNameSelect"  isAuto="true" fdNameSelect="true" id="!{ VAR.prefix /}_!{ VAR.index /}_fdNameSelect" >
							<option value=""><kmss:message key="sys-xform:sysFormDbTable.help.pleaseSelect" /></option>
						</select> 
						<span name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdColumnName"></span>
					</td>
					<td>
						<input type="text" style="width:90%" class="!{ VAR.allowEdit ==  'false' ? 'inputread' : 'inputsgl'/}"
							columnName="true"
							allowEdit="!{ VAR.allowEdit ==  'false' ? 'readOnly' : ''/}" 
							name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdColumn" value="!{ VAR.column ? VAR.column : VAR.tableName /}"   >
					</td>
					<td> 
						<div class="!{ (VAR.maxLength ==0 || VAR.type.indexOf('com.landray.kmss.sys.')>-1) ? 'hideLength':''/}"> 
						<input type="text" style="width:90%" class="!{ VAR.dataType == 'VARCHAR' ? (VAR.allowEdit ==  'false' ? 'inputread' : 'inputsgl') : 'inputread'/}" 
							columnLength="true"
							allowEdit="!{ VAR.dataType == 'VARCHAR' ? (VAR.allowEdit ==  'false' ? 'readOnly' : 'true') : 'readOnly'/}"  
							name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdLength" value="!{ VAR.maxLength /}" >
						</div>
					</td>
					<td>
						<input type="text" style="width:100px" class="inputread" 
							name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdDataType" 
							value="!{ VAR.dataType ? VAR.dataType : '<kmss:message key="sys-xform:sysFormDbColumn.fdRelType.table" />' /}" readOnly >
					</td>
					<td>
						<input type="text" style="width:200px" class="inputread" 
							name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdType" value="!{ VAR.type /}" readOnly >
					</td>
					<td>
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdIsPk" value="!{ VAR.isPk /}" >
						
						<!-- oneToMany, manyToMany, manyToOne -->
						!{ GetDesMessage(VAR) /} <span class="_error_msg" style="color: red;">!{ GetRemark(VAR) /}</span>
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdRelation" value="!{ VAR.relation /}" >
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdTableName" value="!{ VAR.tableName /}" >
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdModelName" value="!{ VAR.modelName /}" >
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdModelText" value="!{ VAR.modelText /}" >
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdMainColumn" value="!{ VAR.mainColumn /}" >
						<input type="hidden" name="!{ VAR.prefix /}fdColumns[!{ VAR.index /}].fdElementColumn" value="!{ VAR.elementColumn /}" >
						!{GetTypeChangeHTML(VAR) /}
					</td>
				</tr>
			</table>
			</td>
		</tr>
		</tbody>
		<tbody id="subTable">
		<!-- 子表 -->
		<tr class="templateTitle">
			<td class="td_normal_title" width=15%>
				<input type="hidden" name="fdTables[!{ VAR.index /}].fdId" value="!{ VAR.id /}" >
				<input type="hidden" name="fdTables[!{ VAR.index /}].fdIsPublish" value="!{ VAR.isPublish /}"><!-- 模板没有处理这个字段 -->
				<input type="hidden" name="fdTables[!{ VAR.index /}].fdAllowEdit" value="!{ VAR.allowEdit /}"><!-- 模板没有处理这个字段 -->
				<input type="checkbox" class="tableEnableBox" onclick="return SetEnableSubTableAuto(this.parentNode.parentNode);"/>
				<kmss:message key="sys-xform:sysFormDbTable.subFormName" />
			</td>
			<td width=35%>
				<input type="hidden" name="fdTables[!{ VAR.index /}].fdName" value="!{ VAR.name /}"/>
				!{ VAR.label /}
			</td>
			<td class="td_normal_title" width=15%><kmss:message key="sys-xform:sysFormDbTable.fdTable" /></td>
			<td width=35%>
				<input type="text" name="fdTables[!{ VAR.index /}].fdTable" value="!{ VAR.fdTable /}" style="width:70%" class="inputsgl" subTable="true" />
				<!-- 
				<a href="javascript:void(0)" onclick="SelectSubTable(this, '!{ VAR.index /}');"><kmss:message key="dialog.selectOther" /></a>
				 -->
				<a name="ReloadSubTableLink" href="javascript:void(0)" onclick="ReloadSubTable(this, '!{ VAR.index /}',false);"><kmss:message key="sys-xform:sysFormDbTable.btn.reloadTable" /></a>
			</td>
		</tr>
		<tr class="templateColumns">
			<td colspan="4">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td width="20px" rowspan="2"></td>
					<td width="20px" rowspan="2"><kmss:message key="sys-xform:sysFormDbTable.No" /></td>
					<td width="20%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdName" /></td>
					<td width="20%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdColumn" /></td>
					<td width="5%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.fdLength" /></td>
					<td width="25%" colspan="2"><kmss:message key="sys-xform:sysFormDbColumn.type" /></td>
					<td width="30%" rowspan="2"><kmss:message key="sys-xform:sysFormDbColumn.info" /></td>
				</tr>
				<tr class="tr_normal_title">
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.db" /></td>
					<td width=""><kmss:message key="sys-xform:sysFormDbColumn.type.java" /></td>
				</tr>
			</table>
			</td>
		</tr>
		</tbody>
	</table>
	</center>

	<html:hidden property="fdKey"/>
	<html:hidden property="fdModelName" />
	<html:hidden property="fdTemplateModel" />
	<html:hidden property="method_GET" />
	<html:hidden property="fdId" />
</html:form>
<script>Com_IncludeFile("dialog.js|data.js|jquery.js");</script>
<script src="<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTableSelect.js" />"></script>
<script>
//设置子表是否有效
function SetEnableSubTableAuto(tr) {
	var inputs, i, input, fdTable, links;
	var checkbox = GetElement(tr, 'input', function(input) {
		return (input.className == 'tableEnableBox');
	});
	var fdIsPublish = GetElement(tr, 'input', function(input) {
		return (input.name != null && input.name.indexOf('.fdIsPublish') > -1);
	});
	var fdAllowEdit = GetElement(tr, 'input', function(input) {
		return (input.name != null && input.name.indexOf('.fdAllowEdit') > -1);
	}); 
	if(String(fdAllowEdit.value)=="false"){
		return false;
	} 
	fdIsPublish.value = checkbox.checked;
	/*
	links = tr.getElementsByTagName('a');
	for (i = 0; i < links.length; i ++) {
		links[i].style.display = checkbox.checked ? '' : 'none';
	}
	*/
	fdTable =  GetElement(tr, 'input', function(input) {
		return (input.name != null && input.name.indexOf('.fdTable') > -1);
	});
	tr = tr.nextSibling;
	//tr.style.display = (fdTable.value == '' || !checkbox.checked) ? 'none' : '';

	inputs = tr.getElementsByTagName('select');
	for (i = 0; i < inputs.length; i ++) {
			var row = GetParent(inputs[i], 'tr');
			var checkboxs = GetElement(row, 'input', function(input) {
				return (input.type == 'checkbox');
			}); 
			checkboxs.checked = checkbox.checked; 
			SetEnableRow(row);
		 
	}
}
function submitForm(method){
	Com_Submit(document.sysFormDbTableForm, method);
}


function GetRemark(_VAR){
	if(_VAR.errMsgKey!=null &&_VAR.errMsgKey != ""){
		if(_VAR.errMsgKey.indexOf(";") > -1){
			var errMsgKeys = _VAR.errMsgKey.split(";");
			var errMsgs = [];
			for(i=0;i<errMsgKeys.length;i++){
				errMsgs[i] = GetRemark.msg[errMsgKeys[i]];
			}
			return errMsgs.join(";");
		}else{
			return GetRemark.msg[_VAR.errMsgKey];
		}
	}
}
GetRemark.msg = {
		'formUserDelete' : '<kmss:message key="sys-xform:sysFormDbTable.alert.formUserDelete" />',
		'dbUserDelete' : '<kmss:message key="sys-xform:sysFormDbTable.alert.dbUserDelete" />',
		'dbUserAdd' : '<kmss:message key="sys-xform:sysFormDbTable.alert.dbUserAdd" />',
		'typeChanged' : '<kmss:message key="sys-xform:sysFormDbTable.alert.typeChanged" />'
};
// 消息
function GetDesMessage(_VAR) { 
	if (_VAR.isPk == 'true') {
		return GetRelationMessage('isPk');
	}
	if (_VAR.name == 'fdParent') {
		return GetRelationMessage('isParent');
	}
	if (_VAR.relation != null && _VAR.relation != '') {
		if (_VAR.relation == 'manyToOne') {
			if (_VAR.modelName != null && _VAR.modelName != '') {
				return GetRelationMessage('manyToOne_sys', _VAR.modelText);
			}
			return GetRelationMessage('manyToOne_table', _VAR.tableName);
		}
		if (_VAR.relation == 'manyToMany') {
			return GetRelationMessage(_VAR.relation, _VAR.modelText);
		}
		return GetRelationMessage(_VAR.relation, _VAR.tableName);
	}
	return '';
}
function GetRelationMessage(key, text) {
	if (key == null || key == '') return "";
	return GetRelationMessage.msg[key].replace('{0}' , text);
}
GetRelationMessage.msg = {
		'isPk' : '<kmss:message key="sys-xform:sysFormDbColumn.fdIsPk" />',
		'isParent' : '<kmss:message key="sys-xform:sysFormDbColumn.fdIsParent" />',
		'oneToMany' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.oneToMany" />',
		'manyToMany' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToMany" />',
		'manyToOne' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_sys" />',
		'manyToOne_sys' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_sys" />',
		'manyToOne_table' : '<kmss:message key="sys-xform:sysFormDbColumn.relation.manyToOne_table" />'
};
// 子表模板
var TableTemplate = {templateTitle:null,templateColumns:null};
// 创建子表
function BuildSubTableItems(subField) {
	 var tbody = document.getElementById('subTable'), i, templateTitle, templateColumns, cell, j, index = 0;

	 for (i = tbody.rows.length-1; i >= 0; i --) {
		row = tbody.rows[i];
		if (row.className == 'templateTitle' && TableTemplate.templateTitle == null) {
			templateTitle = [];
			for (j = 0; j < row.cells.length; j ++) {
				templateTitle[templateTitle.length] = SysFormDb_CompileTemplate(row.cells[j].innerHTML);
			}
			TableTemplate.templateTitle = templateTitle;
		}
		else
		if (row.className == 'templateColumns' && TableTemplate.templateColumns == null) {
			templateColumns = [];
			for (j = 0; j < row.cells.length; j ++) {
				templateColumns[templateColumns.length] = SysFormDb_CompileTemplate(row.cells[j].innerHTML);
			}
			TableTemplate.templateColumns = templateColumns;
		}
		tbody.deleteRow(i);
	}
	for (i = 0; i < subField.length; i ++) {
		if (subField[i].children == null) {
			continue;
		}
		var tr = tbody.insertRow(-1);
		
		for (j = 0; j < TableTemplate.templateTitle.length; j ++) {
			cell = tr.insertCell(-1);
			subField[i].index = index; 
			 
			html = SysFormDb_RunTemplate(TableTemplate.templateTitle[j], subField[i]);
			
			cell.innerHTML = html;
		}
		tr = tbody.insertRow(-1);
		tr.style.display = 'none';
		cell = tr.insertCell(-1);
		cell.colSpan = 4;
		for (j = 0; j < TableTemplate.templateColumns.length; j ++) {
			html = SysFormDb_RunTemplate(TableTemplate.templateColumns[j]);
			cell.innerHTML = html;
		}
		index ++;
		SetEnableSubTable(tr.previousSibling);
	}
}
function DeleteSubTableColumns(tr) {
	var table = tr.getElementsByTagName('table')[0];
	for (i = table.rows.length-1; i > 1; i --) {
		table.deleteRow(i);
	}
	return table;
}
/** 子表字段生成 */
function BuildSubTableColumns(values, dom) {
	var tr = GetParent(dom, 'tr'), i, html, j, row, cell;
	if (!ValHasPk(values)) {
		var fdTable =  GetElement(tr, 'input', function(input) {
			return (input.name != null && input.name.indexOf('.fdTable') > -1);
		});
		fdTable.value = '';
		DeleteSubTableColumns(tr.nextSibling);
		tr.nextSibling.style.display = 'none';
		return;
	}
	var fdName = GetElement(tr, 'input', function(input) {
		return (input.name != null && input.name.indexOf('.fdName') > -1);
	});
	var prefix = fdName.name.substring(0, fdName.name.indexOf('.'));
	var fields = [];
	for (i = 0; i < dictTree.length; i ++) {
		if (fdName.value == dictTree[i].name) {
			fields = dictTree[i].children;
		}
	}
	tr = tr.nextSibling;
	tr.style.display = '';
	var table = tr.getElementsByTagName('table')[0];
	var oldValues = GetOldValues(table);
	DeleteSubTableColumns(tr);
	for (i = 0; i < values.length; i ++) {
		tr = table.insertRow(-1);
		values[i].index = i;
		for (j = 0; j < ColumnTableTemplate.length; j ++) {
			cell = tr.insertCell(-1);
			values[i].prefix = prefix + '.';
			html = SysFormDb_RunTemplate(ColumnTableTemplate[j], values[i]);
			cell.innerHTML = html;
		}
		FillXFormOptions(tr ,fields);
		SetEnableRow(tr, values[i].isEnable);
	}
	FillOldValues(table, oldValues);
}

function ReloadSubTable(dom, index,isOnLoad) {
	var fdTable = document.getElementsByName('fdTables[' + index + '].fdTable')[0];
	if (fdTable.value != '') {
		ReLoadColumns(fdTable.value, function(data) {
				if (data == null) return;
				var values = data.GetHashMapArray();
				//BuildSubTableColumns(values, dom);
				BuildSubTableColumn(values, dom,isOnLoad);
			}
		);
	}
}

//选择子表
function SelectSubTable(dom, index) {//sysFormDbListService实际返回空
	Dialog_List(false, 'fdTables[' + index + '].fdTable', null, null, 'sysFormDbListService', 
			function(data) {LoadColumns(data, function(data) {
				if (data == null) return;
				var fdTable = document.getElementsByName('fdTables[' + index + '].fdTable')[0];
				new Reminder(fdTable).hide();
				var values = data.GetHashMapArray();
				BuildSubTableColumns(values, dom);}
			);},
			'sysFormDbSearchService&keyword=!{keyword}',
			false, true, 
			'<kmss:message key="sys-xform:sysFormDbTable.selectTable" />');
}

// 所有添加列方法
function FillXFormOptions(tr, fields) {
	var select = GetElement(tr, 'select', function(select) {
		return (select.className == 'fdNameSelect');
	});
	var checkbox = GetElement(tr, 'input', function(input) { 
		return (input.type == 'checkbox');
	}); 
	var fdAllowEdit = GetElement(tr, 'input', function(input) { 
		return (input.name != null && input.name.indexOf('.fdAllowEdit') > -1);
	}); 
	var fdUserColumn = GetElement(tr, 'input', function(input) { 
		return (input.name != null && input.name.indexOf('.fdUserColumn') > -1);
	}); 
	var fdName = GetElement(tr, 'input', function(input) {
		return (input.name != null && input.name.indexOf('.fdName') > -1);
	});
	var fdColumnName = GetElement(tr, 'span', function(input) {
		return (input.name != null && input.name.indexOf('.fdColumnName') > -1);
	});
	if (isPkRow(tr)) {
		var p = select.parentNode;
		p.removeChild(select);
		fdName.value = 'fdId';
		p.appendChild(document.createTextNode("ID"));
		var td = checkbox.parentNode;
		checkbox.style.display = 'none';  
		var imgok = document.createElement('img');
		imgok.src=Com_Parameter.StylePath+"/answer/icn_ok.gif";
	 	td.appendChild(imgok);
		return;
	}
	 
	if (fdName.value == 'fdParent') { 
		var td = checkbox.parentNode;
		checkbox.style.display = 'none';  
		var imgok = document.createElement('img');
		imgok.src=Com_Parameter.StylePath+"/answer/icn_ok.gif";
	 	td.appendChild(imgok); 
	}
	
	for (var i = 0; i < fields.length; i ++) {
		if (fields[i].children != null) {
			continue;
		}
		var opt = new Option(fields[i].label, fields[i].name);
		select.options.add(opt);
		if (fdName.value == opt.value) {	
			opt.selected = true;
			$(fdColumnName).text(fields[i].label);
		}
	}
	// || '${sysFormDbTableForm.tagerMethod}' == 'add'
	if(String(fdUserColumn.value)=="false"){
		select.style.display = "none";
		fdColumnName.style.display = "";
	}else{
		select.style.display = "";
		fdColumnName.style.display = "none";
	}
	
	select.onchange = function() { 
		var tr = GetParent(this, 'tr');
		var fdName = GetElement(tr, 'input', function(input) {
			return (input.name != null && input.name.indexOf('.fdName') > -1);
		});
		var fdColumnName = GetElement(tr, 'span', function(input) {
			return (input.name != null && input.name.indexOf('.fdColumnName') > -1);
		});
		if (this.value != '') {
			new Reminder(this).hide();
			var selects = GetParent(this, 'table').getElementsByTagName('select');
			for (var i = 0; i < selects.length; i ++) { // 唯一性校验
				if (selects[i] !== this) {
					var xtr = GetParent(selects[i], 'tr');
					var xcheckbox = GetElement(xtr, 'input', function(input) { 
						return (input.type == 'checkbox');
					}); 
					
					if(xcheckbox.disabled){ 
						if(this.getAttribute("oldValue") == selects[i].value){ 
							xcheckbox.disabled = false; 
						}
					}
					 
					 
					if(xcheckbox.checked){			
						if(this.value == selects[i].value){		
							alert(this.options[this.selectedIndex].text + "<kmss:message key="sys-xform:sysFormDbTable.alert.hasSelectedField"/>");
							this.value  = '';
						}
					}else{
						if(this.value !="" && this.value == selects[i].value){	
							xcheckbox.disabled = true; 
						}
					} 					
				}
			}
		}else{
			var selects = GetParent(this, 'table').getElementsByTagName('select');
			for (var i = 0; i < selects.length; i ++) { // 唯一性校验
				if (selects[i] !== this) {
					var xtr = GetParent(selects[i], 'tr');
					var xcheckbox = GetElement(xtr, 'input', function(input) { 
						return (input.type == 'checkbox');
					}); 
					
					if(xcheckbox.disabled){ 
						if(this.getAttribute("oldValue") == selects[i].value){ 
							xcheckbox.disabled = false; 
						}
					}
				}
			}
		}
		fdName.value = this.value;
		$(fdColumnName).text(this.options[this.selectedIndex].text);
		if (this.value == 'fdParent') {
			var tbRow = GetParent(GetParent(tr, 'table'), 'tr');
			var tbName = GetElement(tbRow.previousSibling, 'input', function(input) {
				return (input.name != null && input.name.indexOf('.fdName') > -1);
			});
			new Reminder(tbName).hide();
		}

		this.setAttribute("oldValue",this.value);
	};
}

function DeleteMainTableColumns(table) {
	for (var i = table.rows.length-1; i > 1; i --) {
		table.deleteRow(i);
	}
}
/** 创建表格 */
function BuildMainTableDataToColumnTable(values) {
	var table = document.getElementById('columnTable'), i, html, j, row, cell;
	if (!ValHasPk(values)) {
		document.getElementsByName('fdTable')[0].value = '';
		DeleteMainTableColumns(table);
		table.style.display = 'none';
		table.parentNode.parentNode.style.display = 'none';
		return;
	}
	table.style.display = '';
	table.parentNode.parentNode.style.display = '';
	var oldValues = GetOldValues(table);
	
	DeleteMainTableColumns(table);
	for (i = 0; i < values.length; i ++) {
		var tr = table.insertRow(-1);
		values[i].index = i;
		for (j = 0; j < ColumnTableTemplate.length; j ++) {
			cell = tr.insertCell(-1);
			html = SysFormDb_RunTemplate(ColumnTableTemplate[j], values[i]);
			cell.innerHTML = html;
		}
		FillXFormOptions(tr ,dictTree);
		SetEnableRow(tr, values[i].isEnable);
	}
	FillOldValues(table, oldValues);
	
}

function ReLoadColumns(table, callback) {
	var kmssData = new KMSSData();
	kmssData.SendToBean('sysFormDbColumnListService&table=' + table, callback);
}

function ReloadMainTable(isOnLoad) {
	var fdTable = document.getElementsByName('fdTable')[0];
	if (fdTable.value == '') {
		return;
	}
	ReLoadColumns(fdTable.value, function(data) {
		if (data == null) return;
		var values = data.GetHashMapArray();
		ReloadMainTableColumn(values,isOnLoad);
		//BuildMainTableDataToColumnTable(values);
	});
}
function BuildMainColumns(data) {
	if (data == null) return;
	var values = data.GetHashMapArray();
	BuildMainTableDataToColumnTable(values);
}
/** 加载表字段 */
function LoadColumns(data, callback) {
	if (data == null) return;
	var fdTable = document.getElementsByName('fdTable')[0];
	new Reminder(fdTable).hide();
	
	var values = data.GetHashMapArray();
	var kmssData = new KMSSData();
	kmssData.SendToBean('sysFormDbColumnListService&table=' + values[0].id, callback);
}
/** 选择主表 */
function SelectMainTable() {//sysFormDbListService实际返回空
	Dialog_List(false, 'fdTable', null, null, 'sysFormDbListService', 
			function(data) {LoadColumns(data, BuildMainColumns);},
			'sysFormDbSearchService&keyword=!{keyword}',
			false, true, 
			'<kmss:message key="sys-xform:sysFormDbTable.selectTable" />');
}
// 原配置数据
var initValues = new Object();
<c:if test="${not empty sysFormDbTableForm.fdColumns}">
initValues.columns = [];
<c:forEach items="${sysFormDbTableForm.fdColumns}" var="column">
initValues.columns.push({
	id:"${column.fdId}",
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
	isEnable:'<c:out value="${column.fdIsEnable}"/>',
	order : '${column.fdOrder}',
	allowEdit : '<c:out value="${column.fdAllowEdit}"/>',
	userColumn : '<c:out value="${column.fdUserColumn}"/>',
	errMsgKey : '<c:out value="${column.fdErrMsgKey}"/>',
	propJavaType : '<c:out value="${column.fdPropertyJavaType}"/>',
	propDataType : '<c:out value="${column.fdPropertyDataType}"/>'
});
</c:forEach>
</c:if>
<c:if test="${not empty sysFormDbTableForm.fdTables}">
initValues.tables = {};
<c:forEach items="${sysFormDbTableForm.fdTables}" var="table">
initValues.tables['${table.fdName}'] = {};
initValues.tables['${table.fdName}'].id = "${table.fdId}";
initValues.tables['${table.fdName}'].isPublish = "${table.fdIsPublish}";
initValues.tables['${table.fdName}'].table = "${table.fdTable}";
initValues.tables['${table.fdName}'].allowEdit = "${table.fdAllowEdit}";
initValues.tables['${table.fdName}'].columns = [];
<c:forEach items="${table.fdColumns}" var="column">
initValues.tables['${table.fdName}'].columns.push({
	id:"${column.fdId}",
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
	isEnable:'<c:out value="${column.fdIsEnable}"/>',
	order : '${column.fdOrder}',
	allowEdit : '<c:out value="${column.fdAllowEdit}"/>',
	userColumn : '<c:out value="${column.fdUserColumn}"/>',
	errMsgKey : '<c:out value="${column.fdErrMsgKey}"/>',
	propJavaType : '<c:out value="${column.fdPropertyJavaType}"/>',
	propDataType : '<c:out value="${column.fdPropertyDataType}"/>'
});
</c:forEach>
</c:forEach>
</c:if>
// ======== 表单属性
var dictTree = [];
var xformFields = [];
function GetFormExtDictObj(tempType, tempId) {
	return new KMSSData().AddBeanData("sysFormDictVarTree&tempType="+tempType+"&tempId="+tempId).GetHashMapArray();
}
function ShowXFormFields() {
	DialogParams = {formFiels:xformFields,title:'<kmss:message key="sys-xform:sysFormDbFormFields.title" />'};
	var left = (screen.width-500)/2;
	var top = (screen.height-400)/2;
	window.open('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbFormFields_view.jsp"/>', '_blank', 'resizable=1,scrollbars=1,height=400,width=500,left='+left+',top='+top);
}
function var_dump(data, addwhitespace, safety, level)
{
    var rtrn = '';
    var dt, it, spaces = '';

    if (!level) {
        level = 1;
    }

    for (var i=0; i<level; i++) {
        spaces += '   ';
    } //end for i<level

    if (typeof(data) != 'object') {
        dt = data;

        if (typeof(data) == 'string') {
            if (addwhitespace == 'html') {
                dt = dt.replace(/&/g,'&amp;');
                dt = dt.replace(/>/g,'&gt;');
                dt = dt.replace(/</g,'&lt;');
            } //end if addwhitespace == html
            dt = dt.replace(/\"/g,'\"');
            dt = '"' + dt + '"';
        } //end if typeof == string

        if (typeof(data) == 'function' && addwhitespace) {
            dt = new String(dt).replace(/\n/g,"\n"+spaces);
            if (addwhitespace == 'html') {
                dt = dt.replace(/&/g,'&amp;');
                dt = dt.replace(/>/g,'&gt;');
                dt = dt.replace(/</g,'&lt;');
            } //end if addwhitespace == html
        } //end if typeof == function

        if (typeof(data) == 'undefined') {
            dt = 'undefined';
        } //end if typeof == undefined

        if (addwhitespace == 'html') {
            if (typeof(dt) != 'string') {
                dt = new String(dt);
            } //end typeof != string
            dt = dt.replace(/ /g,"&nbsp;").replace(/\n/g,"<br>");
        } //end if addwhitespace == html
        return dt;
    } //end if typeof != object && != array

    for (var x in data) {
        if (safety && (level > safety)) {
            dt = '*RECURSION*';
        } else {
            try {
                dt = var_dump(data[x],addwhitespace,safety,level+1);
            } catch (e) {
                continue;
            }
        } //end if-else level > safety
        it = var_dump(x,addwhitespace,safety,level+1);
        rtrn += it + ':' + dt + ',';
        if (addwhitespace) {
            rtrn += '\n'+spaces;
        } //end if addwhitespace
    } //end for...in

    if (addwhitespace) {
        rtrn = '{\n' + spaces + rtrn.substr(0,rtrn.length-(2+(level*3))) + '\n' + spaces.substr(0,spaces.length-3) + '}';
    } else {
        rtrn = '{' + rtrn.substr(0,rtrn.length-1) + '}';
    } //end if-else addwhitespace

    if (addwhitespace == 'html') {
        rtrn = rtrn.replace(/ /g,"&nbsp;").replace(/\n/g,"<br>");
    } //end if addwhitespace == html

    return rtrn;
} //end function var_dump
// 表单属性初始化
function InitXFormFields() {
	var formId = document.getElementsByName('fdFormId')[0];
	var formType = document.getElementsByName('fdFormType')[0];
	if (formId.value == '' || formType.value == '') return;
	
	var array = GetFormExtDictObj(formType.value, formId.value);
	xformFields = array; 
	for (var i = 0; i < xformFields.length; i ++) {
		var field = xformFields[i];
		var name = field.name;
		if (name.indexOf('.') > 0) {
			var label = field.label;
			var type = field.type;
			var len = field.len;
			var preName = name.substring(0, name.indexOf('.'));
			var subName = name.substring(name.indexOf('.') + 1, name.length);
			var subLabel = label.substring(label.indexOf('.') + 1, label.length);
			var subType = type.substring(0, type.length - 2); 
			var subLength = len.substring(len.indexOf('.') + 1, len.length);
			for (var j = 0; j < xformFields.length; j ++) {
				if (preName == xformFields[j].name) {
					if (xformFields[j].children == null) {
						xformFields[j].children = [];
						xformFields[j].children.push({name:"fdParent", label:"<kmss:message key="sys-xform:sysFormDbColumn.fdParent.parent"/>"});
					}
					xformFields[j].children.push({name:subName, label:subLabel, type: subType,len:subLength});
				}
			}
		} else {
			dictTree.push(field);
		}
	} 
}
Com_AddEventListener(window, 'load', function() {
	InitXFormFields(); // 首先初始化表单属性
	InitMainTableColumnTable(); // 初始化模板
	var kmssData = new KMSSData();
	BuildSubTableItems(dictTree); // 初始化可选择直接配置子表


	if (initValues.columns != null)
		BuildMainTableDataToColumnTable(initValues.columns);
	
	if (initValues.tables != null) {
		var inputs = document.getElementsByTagName('input');
		for (var i = 0; i < inputs.length; i ++) {
			var input = inputs[i];
			if (input.type == 'hidden' && input.name != null){
				var name = input.name;
				if (name.indexOf('fdTables') > -1 && name.indexOf('.fdName') > -1) { 
					if (initValues.tables[input.value] != null) {
						var tableValue = initValues.tables[input.value];
						var tr = GetParent(input, 'tr');
						var fdIsPublish = GetElement(tr, 'input', function(put) {return (put.name.indexOf('.fdIsPublish') > -1)});
						fdIsPublish.value = tableValue.isPublish;
						var fdAllowEdit = GetElement(tr, 'input', function(put) {return (put.name.indexOf('.fdAllowEdit') > -1)});
						fdAllowEdit.value = tableValue.allowEdit;
						var subTable = GetElement(tr, 'input', function(put) {return (put.getAttribute("subTable")!=null && put.getAttribute("subTable")=="true")});
						subTable.readOnly = String(fdAllowEdit.value)=="false"; 
						subTable.className = (String(fdAllowEdit.value)=="false") ? "inputread" : "inputsgl"; 
						<c:if test="${sysFormDbTableForm.tagerMethod=='edit'}">
							var ReloadSubTableLink = GetElement(tr, 'a', function(put) {return (put.name!=null && put.name=="ReloadSubTableLink")});
							ReloadSubTableLink.style.display = (String(fdAllowEdit.value)=="false") ? '' : 'none';
						</c:if>
						
						var checkbox = GetElement(tr, 'input', function(put) {return (put.className.indexOf('tableEnableBox') > -1)});
						checkbox.checked = tableValue.isPublish == 'true';
						checkbox.disabled = String(tableValue.allowEdit) == "false";

						if(String(tableValue.allowEdit) == "false"){
							checkbox.style.display = "none";
							var imgok = document.createElement('img');
							imgok.src=Com_Parameter.StylePath+"/answer/icn_ok.gif";
							checkbox.parentNode.insertBefore(imgok,checkbox);
						}
						
						var tableName = GetElement(tr, 'input', function(put) {return (put.name.indexOf('.fdTable') > -1)});
						tableName.value = tableValue.table;
						var fdId = GetElement(tr, 'input', function(put) {return (put.name.indexOf('.fdId') > -1)});
						fdId.value = tableValue.id;
						SetEnableSubTable(tr);
						if (tableValue.columns.length > 0)
							BuildSubTableColumns(tableValue.columns, input);
					}
				}
			}
		}
	}
	<c:if test="${sysFormDbTableForm.tagerMethod=='edit'}">
	ReloadMainTable();	
	var tabs = document.getElementsByTagName('input');
	var subTableIndex = 0;
	for(i=0;i<tabs.length;i++){
		if(tabs[i].getAttribute("subTable") != null && tabs[i].getAttribute("subTable")=="true"){
			 
			var fdTable = document.getElementsByName('fdTables[' + subTableIndex + '].fdTable')[0];

			var allowEdit = document.getElementsByName('fdTables[' + subTableIndex + '].fdAllowEdit')[0];

			
			if (fdTable.value != ''&& String(allowEdit.value)=="false") {
				ReloadSubTable(fdTable,subTableIndex,true);
			}

			subTableIndex ++;
		}
	}
	</c:if>
	Com_Parameter.event["submit"].push(ValidateForm);
});
//liyong
function SetEnableRowAuto(tr){
	var select = GetElement(tr, 'select', function(select) {
		return (select.fdNameSelect == 'true');
	});
	if(select.value != "" && select.style.display != "none"){ 
		 
		var fdName = GetElement(tr, 'input', function(input) {
			return (input.name != null && input.name.indexOf('.fdName') > -1);
		});
		var fdColumnName = GetElement(tr, 'span', function(input) {
			return (input.name != null && input.name.indexOf('.fdColumnName') > -1);
		});
		  
		var selects = GetParent(tr, 'table').getElementsByTagName('select');
		for (var i = 0; i < selects.length; i ++) { // 唯一性校验
			if (selects[i] !== select) {
				var xtr = GetParent(selects[i], 'tr');
				var xcheckbox = GetElement(xtr, 'input', function(input) { 
					return (input.type == 'checkbox');
				});  
				 
				if(xcheckbox.disabled){ 		 
					if(select.value == selects[i].value){	
						xcheckbox.disabled = false; 
					}
				} 					
			}
		}
		select. selectedIndex = 0;
		fdName.value = '';
		$(fdColumnName).text('');
		select.setAttribute("oldValue",'');
 
	}
	SetEnableRow(tr);  
}
function ReloadMainTableColumn(columns,isOnLoad){ 
	var table = document.getElementById('columnTable');
	for (var i = table.rows.length-1; i > 1; i --) {
		var fdUserColumn = GetElement(table.rows[i], 'input', function(input) {
			return (input.name != null && input.name.indexOf('.fdUserColumn') > -1);
		}); 
		if(String(fdUserColumn.value)=="true"){			
			table.deleteRow(i);
		}
	}
	/*
	for(j=2;j<table.rows.length;j++){
		var fdColumn = GetElement(table.rows[j], 'input', function(input) {
			return (input.name != null && input.name.indexOf('.fdColumn') > -1);
		}); 
		if(fdColumn.value == columns[i].column){
			columnNoDisplay = true;
			break;
		}
	}
	*/
	for(i=0;i<columns.length;i++){
		var columnNoDisplay = false;
		for(j=2;j<table.rows.length;j++){
			var fdColumn = GetElement(table.rows[j], 'input', function(input) {
				return (input.name != null && input.name.indexOf('.fdColumn') > -1);
			}); 
			if(columns[i].column){
				if(fdColumn.value.toUpperCase() == columns[i].column.toUpperCase()){
					columnNoDisplay = true;
					break;
				}
			}else{
				if(fdColumn.value.toUpperCase() == columns[i].tableName.toUpperCase()){
					columnNoDisplay = true;
					break;
				}
			}
		}
		if(!columnNoDisplay){
			var tr = table.insertRow(-1);
			columns[i].index = table.rows.length-3;
			columns[i].allowEdit = "false";
			columns[i].userColumn = "true";
			columns[i].errMsgKey = "dbUserAdd";
			for (m = 0; m < ColumnTableTemplate.length; m ++) {
				cell = tr.insertCell(-1);
				html = SysFormDb_RunTemplate(ColumnTableTemplate[m], columns[i]);
				cell.innerHTML = html;
			}
			FillXFormOptions(tr ,dictTree);
			SetEnableRow(tr, columns[i].isEnable);

			 
			var select = GetElement(tr, 'select', function(select) {
				return (select.className == 'fdNameSelect');
			});
			select.style.display = '';
			var fdColumnName = GetElement(tr, 'span', function(input) {
				return (input.name != null && input.name.indexOf('.fdColumnName') > -1);
			});
			fdColumnName.style.display = "none";
			 
		}
	}
	if(isOnLoad == false){
		alert('<kmss:message key="sys-xform:sysFormDbTable.alert.reloadComplete"/>');
	}
}
function BuildSubTableColumn(columns,dom,isOnLoad){
	var tr = GetParent(dom,'tr');
	var fdName = GetElement(tr, 'input', function(input) {
		return (input.name != null && input.name.indexOf('.fdName') > -1);
	});
	var table = dom.parentNode.parentNode.nextSibling.cells[0].children[0];;
	for(i=0;i<columns.length;i++){
		var columnNoDisplay = false;
		for(j=2;j<table.rows.length;j++){
			var fdColumn = GetElement(table.rows[j], 'input', function(input) {
				return (input.getAttribute("columnName") != null && input.getAttribute("columnName")=="true");
			}); 
			if(fdColumn.value.toString().toUpperCase() == columns[i].column.toUpperCase()){
				columnNoDisplay = true;
				break;
			}
		}
		if(!columnNoDisplay){
			var prefix = fdName.name.substring(0, fdName.name.indexOf('.'));
			var tr = table.insertRow(-1);
			columns[i].index = table.rows.length-3;
			columns[i].allowEdit = "false";
			columns[i].userColumn = "true";
			columns[i].errMsgKey = "dbUserAdd";
			for (m = 0; m < ColumnTableTemplate.length; m ++) {
				cell = tr.insertCell(-1);
				columns[i].prefix = prefix + '.';
				html = SysFormDb_RunTemplate(ColumnTableTemplate[m], columns[i]);
				cell.innerHTML = html;
			} 
			 
			
			var fields = [];
			for (n = 0; n < dictTree.length; n ++) {
				if (fdName.value == dictTree[n].name) {
					fields = dictTree[n].children;
				}
			} 
			FillXFormOptions(tr ,fields);
			SetEnableRow(tr, columns[i].isEnable);

			 
			var select = GetElement(tr, 'select', function(select) {
				return (select.className == 'fdNameSelect');
			});
			if (select)
				select.style.display = '';
			var fdColumnName = GetElement(tr, 'span', function(input) {
				return (input.name != null && input.name.indexOf('.fdColumnName') > -1);
			});
			fdColumnName.style.display = "none";
			 
			 
		}
	}
	if(isOnLoad == false){
		alert('<kmss:message key="sys-xform:sysFormDbTable.alert.reloadComplete"/>');
	}
}
function selectAll(obj){ 
	var tr = GetParent(obj, 'table');	 
	inputs = tr.getElementsByTagName('select');
	for (i = 0; i < inputs.length; i ++) {
			var row = GetParent(inputs[i], 'tr');
			var checkboxs = GetElement(row, 'input', function(input) {
				return (input.type == 'checkbox');
			}); 
			checkboxs.checked = obj.checked; 
			SetEnableRow(row);		 
	}
}
//获取数据库所有表名
var dbTables = null;
function getDbTables(){
	if(dbTables==null){
		dbTables = new KMSSData().AddBeanData("sysFormDbSearchService&keyword=").GetHashMapArray();
	}
	return dbTables;
}
var namePattern = /^([a-zA-Z]([a-zA-Z0-9]|(_))*)$/;
//验证表名是否合法，是否重复，是否存已存在。
function ValidateTableName(){	
	var tableNames = [];
	var fdTable = document.getElementsByName('fdTable')[0];
	tableNames.push(fdTable.value);
	<c:if test="${sysFormDbTableForm.tagerMethod=='add'}">
	//表名是否合法   
	if (!namePattern.test(fdTable.value) || fdTable.value.length > 30 || fdTable.value.length <= 4 || fdTable.value.substr(0,4).toLowerCase() != "ekp_"){
		var reminder = new Reminder(fdTable, '<kmss:message key="sys-xform:sysFormDbTable.alert.nameTableRule"/>');
		reminder.show();
		fdTable.onkeypress = function(){
			reminder.hide();
		}		 
		return false;
	}  
	//主表是否存在
	var dbs = getDbTables();
	for(j=0;j<dbs.length;j++){
		if(dbs[j].key0 == fdTable.value){  
			var reminder = new Reminder(fdTable, '<kmss:message key="sys-xform:sysFormDbTable.alert.tableExist"/>');
			reminder.show();
			fdTable.onkeypress = function(){
				reminder.hide();
			}					
			return false;
		}
	}
	</c:if>
	var tabs = document.getElementsByTagName('input');
	for(i=0;i<tabs.length;i++){
		if(tabs[i].getAttribute("subTable") != null && tabs[i].getAttribute("subTable")=="true"){
			var tr = GetParent(tabs[i], 'tr');
			var fdIsPublish = GetElement(tr, 'input', function(put) {return (put.name.indexOf('.fdIsPublish') > -1)});
			if(String(fdIsPublish.value) == "false"){
				continue;
			} 
			var fdAllowEdit = GetElement(tr, 'input', function(put) {return (put.name.indexOf('.fdAllowEdit') > -1)});
			
			//表名是否合法 
			if (!namePattern.test(tabs[i].value) || tabs[i].value.length > 30 || tabs[i].value.length <= 4 || tabs[i].value.substr(0,4).toLowerCase() != "ekp_"){
				var reminder = new Reminder(tabs[i], '<kmss:message key="sys-xform:sysFormDbTable.alert.nameTableRule"/>');
				reminder.show();
				tabs[i].onkeypress = function(){
					reminder.hide();
				}		
				return false;
			}  
			//判断表名是否重复  
			for(j=0;j<tableNames.length;j++){			
				if(tableNames[j] == tabs[i].value){ 
					var reminder = new Reminder(tabs[i], '<kmss:message key="sys-xform:sysFormDbTable.alert.nameRepeat"/>');
					reminder.show();
					tabs[i].onkeypress = function(){
						reminder.hide();
					}					
					return false;
				}
			}
			tableNames.push(tabs[i].value);
			 
			
			//新增的表需要判断子表是否已存在于数据库
			if(String(fdAllowEdit.value)=="true"){				
				//子表是否存在
				var dbs = getDbTables();
				for(j=0;j<dbs.length;j++){
					if(dbs[j].key0 == tabs[i].value){  
						var reminder = new Reminder(tabs[i], '<kmss:message key="sys-xform:sysFormDbTable.alert.tableExist"/>');
						reminder.show();
						tabs[i].onkeypress = function(){
							reminder.hide();
						}					
						return false;
					}
				}
			}			
		}
	}
	return true;
}
//同一表内字段段名不能重复,字段名规则，字段长度必须是数字
function ValidateField(dbTalbe,tableId){
	var columnNames = [];
	var rows = dbTalbe.rows;  
	for(i=0;i<rows.length;i++){
		if(rows[i].className == "tr_normal_title"){
			continue;
		}
		var colName = GetElement(rows[i], 'input', function(input) { 
			return (input.getAttribute("columnName") != null && input.getAttribute("columnName") =='true');
		}); 
		var colLength = GetElement(rows[i], 'input', function(input) { 
			return (input.getAttribute("columnLength") != null && input.getAttribute("columnLength") =='true');
		}); 
		var checkbox = GetElement(rows[i], 'input', function(input) { 
			return (input.type == 'checkbox');
		});  
		var select = GetElement(rows[i], 'select', function(input) { 
			return (input.className == 'fdNameSelect');
		}); 
		var fdUserColumn = GetElement(rows[i], 'input', function(input) { 
			return (input.name.indexOf('.fdUserColumn') > -1);
		}); 
		var fdDataType = GetElement(rows[i], 'input', function(input) { 
			return (input.name.indexOf('.fdDataType') > -1);
		}); 
		var fdRelation = GetElement(rows[i], 'input', function(input) { 
			return (input.name.indexOf('.fdRelation') > -1);
		}); 
		//选中的字段才会做验证
		if(checkbox.checked){
			if(!colName.readOnly){
				if(fdDataType.value == "表"){
					//名称必须符合规则 
					if (!namePattern.test(colName.value) || colName.value.length > 30 || colName.value.length <=7 || colName.value.substr(0,7).toLowerCase() != "ekporg_"){
						var reminder = new Reminder(colName, '<kmss:message key="sys-xform:sysFormDbTable.alert.nameTableRule2"/>');
						reminder.show();
						colName.onkeypress = function(){
							reminder.hide();
						}		
						return false;
					}
					//如果多对多字段必须验证表是否存在					 
					var dbs = getDbTables();
					for(j=0;j<dbs.length;j++){
						if(dbs[j].key0 == colName.value){  
							var reminder = new Reminder(colName, '<kmss:message key="sys-xform:sysFormDbTable.alert.tableExist"/>');
							reminder.show();
							colName.onkeypress = function(){
								reminder.hide();
							}					
							return false;
						}
					}
					 
				}else{
					//名称必须符合规则 
					if (!namePattern.test(colName.value) || colName.value.length > 30 || colName.value.length <=3 || colName.value.substr(0,3).toLowerCase() != "fd_"){
						var reminder = new Reminder(colName, '<kmss:message key="sys-xform:sysFormDbTable.alert.nameColumnRule"/>');
						reminder.show();
						colName.onkeypress = function(){
							reminder.hide();
						}		
						return false;
					}
				
					//字段长度必须是数字
					var re = /^\d+(\d+)?$/;
					if (!re.test(Com_Trim(colLength.value)) || (parseInt(colLength.value) > 4000&&parseInt(colLength.value)!=1000000)){ 
						var reminder = new Reminder(colLength, '<kmss:message key="sys-xform:sysFormDbTable.alert.lengthRule"/>');
						reminder.show();
						colLength.onkeypress = function(){
							reminder.hide();
						}		
						return false;
					}
				}
			}
			//同一表字段名是否重复 
			for(j=0;j<columnNames.length;j++){			
				if(columnNames[j] == colName.value){ 
					var reminder = new Reminder(colName, '<kmss:message key="sys-xform:sysFormDbTable.alert.nameRepeat"/>');
					reminder.show();
					colName.onkeypress = function(){
						reminder.hide();
					}					
					return false;
				}
			}
			columnNames.push(colName.value);
		}
		//选择的字段数据类型验证
		if(checkbox.checked && String(fdUserColumn.value) == "true"){ 
			var fields
			if(tableId == "mainTable"){
				fields = dictTree;				
			}else{
				for (n = 0; n < dictTree.length; n ++) {
					if (tableId == dictTree[n].name) {
						fields = dictTree[n].children;
					}
				} 
			}
			for(m=0;m<fields.length;m++){
				if (select.value == fields[m].name) { 
					var fieldType = fields[m].type;
					var fdType = fdDataType.value;
					if(fdType.toLowerCase() == "date" || fdType.toLowerCase() == "datetime" || fdType.toLowerCase() == "timestamp"){
						fdType = "date";
					}
					if(fieldType.toLowerCase() == "string"){
						fieldType = "varchar";
					} else if (fieldType.toLowerCase() == "time"){
						fieldType = "date";
					}
					if(fdType.toLowerCase() != fieldType.toLowerCase()){
						var reminder = new Reminder(select, '<kmss:message key="sys-xform:sysFormDbTable.alert.dataTypeMismatch"/>');
						reminder.show();	
						return false;
					}
					if(fdType.toLowerCase() == "varchar"){
						if(parseInt(colLength.value) < parseInt(fields[m].len)){
							var reminder = new Reminder(select, '<kmss:message key="sys-xform:sysFormDbTable.alert.dataLength"/>');
							reminder.show();	
							return false;
						}
					}
				}
			}
		}
	}
	return true;
}
function ValidateForm() {
	var isOk = true;
	var fdName = document.getElementsByName('fdName')[0];
	if (Com_Trim(fdName.value) == '') {
		new Reminder(fdName, '<kmss:message key="sys-xform:sysFormDbTable.alert.nameNotNull"/>').show();
		Com_AddEventListener(fdName, 'blur', ValFdName);
		isOk = false;
	} else {
		Com_RemoveEventListener(fdName, 'blur', ValFdName);
	}
	// 校验所有有效行，是否已经选择
	var selects = document.getElementsByTagName('select');
	var i = 0;
	for (i = 0; i < selects.length; i ++ ){
		var select = selects[i];
		if (select.getAttribute('fdNameSelect') == 'true') {
			if (!select.disabled && select.value == '') {
				new Reminder(select, '<kmss:message key="sys-xform:sysFormDbTable.alert.selectField"/>').show();
				isOk = false;
			}
		}
	}
	if(isOk == false){
		return isOk;
	}
	// 子表有效情况下，是否选择表
	var subTable = document.getElementById('subTable');
	var inputs = subTable.getElementsByTagName('input');
	var hasSubTable = false;
	for (i = 0; i < inputs.length; i ++ ){
		var input = inputs[i];
		if (input.type == 'checkbox' && input.className == 'tableEnableBox') {
			if (input.checked) {
				hasSubTable = true;
				var row = GetParent(input, 'tr');
				var tableName = GetElement(row, 'input', function(input) {
					return (input.name != null && input.name.indexOf('.fdTable') > -1);
				});
				if (tableName.value == '') {
					new Reminder(tableName, '<kmss:message key="sys-xform:sysFormDbTable.alert.tableNotNull"/>').show();
					isOk = false;
					continue;
				}
				var tRow = row.nextSibling;
				// 校验是否有选择fdParent
				var subSelects = tRow.getElementsByTagName('select');
				var hasFdParent = false;
				for (var n = 0; n < subSelects.length; n ++) {
					var ss = subSelects[n];
					if (ss.value == 'fdParent') {
						hasFdParent = true;
						break;
					}
				}
				if (!hasFdParent) {
					var fdName = GetElement(row, 'input', function(input) {
						return (input.name != null && input.name.indexOf('.fdName') > -1);
					});
					new Reminder(fdName, '<kmss:message key="sys-xform:sysFormDbTable.alert.pleaseSelectParent"/>').show();
					isOk = false;
				}
			}
		}
	}
	///liyong
	isOk = ValidateField(document.getElementById("columnTable"),'mainTable');
	if(isOk == false){
		return isOk;
	}
	subTables = subTable.getElementsByTagName("table");
	for(i=0;i<subTables.length;i++){
		if(subTables[i].className == "tb_normal"){
			var xtr = GetParent(subTables[i],'tr');
			var tableId = GetElement(xtr.previousSibling, 'input', function(input) { 
				return (input.name.indexOf(".fdName") > -1);
			}); 
			isOk = ValidateField(subTables[i],tableId.value);
			if(isOk == false){
				return isOk;
			}
		}
	}
	isOk = ValidateTableName();	
	if(isOk == false){
		return isOk;
	}
	// 主表映射配置，如果无子表情况下，是必填
	//if (!hasSubTable) {
		var fdTable = document.getElementsByName('fdTable')[0];
		if (Com_Trim(fdTable.value) == '') {
			new Reminder(fdTable, '<kmss:message key="sys-xform:sysFormDbTable.alert.tableNotNull"/>').show();
			isOk = false;
		}
	//}
 
	return true;
}
function ValFdName() {
	var fdName = document.getElementsByName('fdName')[0];
	if (Com_Trim(fdName.value) != '') {
		new Reminder(fdName).hide();
	}
}
function ValHasPk(columns) {
	var has = false;
	for (var i = 0; i < columns.length; i ++) {
		if (columns[i].isPk == 'true') {
			has = true;
			break;
		}
	}
	if (!has) {
		alert('<kmss:message key="sys-xform:sysFormDbTable.alert.idNotNull"/>');
	}
	return has;
}


function GetTypeChangeHTML(VAR) {
	if (VAR.errMsgKey=='typeChanged') {
		return ("<label><input type='checkbox' name='_use_new_type' "
				+"javaType='"+VAR.propJavaType+"' "
				+"dataType='"+VAR.propDataType+"' "
				+"onclick='UseDataNewType(this);'>使用新类型</label>");	
	}
	return "";
}
function UseDataNewType(dom) {
	var tr = dom.parentNode.parentNode.parentNode;
	var td = dom.parentNode.parentNode;
	var inputs = tr.getElementsByTagName('input');
	var spans = td.getElementsByTagName('span');

	for (var i = 0; i < spans.length; i ++) {
		var span = spans[i];
		if (span.className == '_error_msg') {
			span.style.display = dom.checked ? 'none' : '';
		}
	}
	if (dom.checked) {
		for (var i = 0; i < inputs.length; i ++) {
			var input = inputs[i];
			if (input.name.indexOf('.fdDataType') > -1) {
				if (input.oldValue == null || input.oldValue == '') {
					input.oldValue = input.value;
				}
				input.value = dom.dataType;
			}
			else if (input.name.indexOf('.fdType') > -1) {
				if (input.oldValue == null || input.oldValue == '') {
					input.oldValue = input.value;
				}
				input.value = dom.javaType;
			}
		}
	} else {
		for (var i = 0; i < inputs.length; i ++) {
			var input = inputs[i];
			if (input.name.indexOf('.fdDataType') > -1 || input.name.indexOf('.fdType') > -1) {
				if (input.oldValue != null && input.oldValue != '') {
					input.value = input.oldValue;
				}
			}
		}
	}
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%> 