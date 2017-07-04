/**
 * 表单持久化
 */
function Form_DB_Init(lang, controls, configs) {
	Form_DB_InitTableName(configs.entityName, configs.tableName);
	for (var i = 0; i < controls.length; i ++) {
		Form_DB_CreateRow(
				document.getElementById("editTable"), 
				controls[i], 
				configs.fields[controls[i].name],
				lang
		);
	}
	var inputs = document.getElementById("editTable").getElementsByTagName('INPUT');
	for (var i = 0; i < inputs.length; i ++) {
		var input = inputs[i];
		if (input.getAttribute('compType') == 'enableBtn') {
			Form_DB_SetEnable(input, input.checked);
		}
	}
}

function Form_DB_InitTableName(entityName, tableName) {
	var tableId = document.getElementById("tableIdField");
	var tableField = document.getElementById("tableNameField");
	//tableField.value = tableName;
}

function Form_DB_CreateRow(table, control, field, lang) {
	var tr = table.insertRow(-1);
	Form_DB_CreateEnableCheckCell(tr, control, field, lang);
	Form_DB_CreateNameCell(tr, control, field, lang);
	Form_DB_CreateTypeCell(tr, control, field, lang);
	Form_DB_CreateFieldCell(tr, control, field, lang);
}

function Form_DB_CreateEnableCheckCell(tr, control, field, lang) {
	var td = tr.insertCell(-1);
	var checkbox = document.createElement("input");
	checkbox.type = 'checkbox';
	checkbox.value = control.name;
	checkbox.setAttribute('compType', 'enableBtn');
	checkbox.onclick = function(event) {
		Form_DB_SetEnable(this, this.checked);
	}
	td.appendChild(checkbox);
}

function Form_DB_CreateNameCell(tr, control, field, lang) {
	var td = tr.insertCell(-1);
	var text = document.createTextNode(control.label);
	td.appendChild(text);
}

function Form_DB_CreateTypeCell(tr, control, field, lang) {
	var td = tr.insertCell(-1);
	var text = document.createTextNode(lang[control.type]);
	td.appendChild(text);
}

function Form_DB_CreateFieldCell(tr, control, field, lang) {
	var td = tr.insertCell(-1);
	var input = document.createElement('<input type="hidden" name="' + control.name + '_dbcol" >');
	if (field) {
		input.value = field;
	}
	var select = document.createElement('select');
	select.name = 'select-' + control.name + '_dbcol';
	select.setAttribute('compType', 'colSelect');
	select.onchange = function() {
		var name = this.name;
		name = name.substring(7, name.length);
		var dbcol = document.getElementsByName(name)[0];
		dbcol.value = this.value;
	}

	td.appendChild(input);
	td.appendChild(select);
}

function Form_DB_SetColumnSelect(values) {
	var selects = document.getElementsByTagName('select');
	for (var i = 0; i < selects.length; i ++) {
		var select = selects[i];
		if (select.getAttribute('compType') == 'colSelect') {
			var name = select.name;
			name = name.substring(7, name.length);
			var dbcol = document.getElementsByName(name)[0];
			Form_DB_FillColumnSelect(select, values, dbcol.value);
		}
	}
}

function Form_DB_FillColumnSelect(select, values, dbcol) {
	var opt = new Option("=== 请选择 ===", "");
	select.options.add(opt);
	for (var i = 0; i < values.length; i ++) {
		var col = values[i];
		var opt = new Option(col.text, col.value);
		select.options.add(opt);
		if (col.value == dbcol) {
			opt.selected = true;
		}
	}
}

function Form_DB_SetEnable(dom, enable) {
	for(var p = dom; p.parentNode != null && dom.tagName != 'TR';) {
		dom = p.parentNode;
		p = dom;
	}
	var inputs = dom.getElementsByTagName('INPUT');
	var disabled = !enable;
	for (var i = 0; i < inputs.length; i ++) {
		var input = inputs[i];
		if (input.getAttribute('compType') != 'enableBtn') {
			input.disabled = disabled;
		}
	}
	var selects = dom.getElementsByTagName('select');
	for (var i = 0; i < selects.length; i ++) {
		var select = selects[i];
		if (select.getAttribute('compType') == 'colSelect') {
			select.disabled = disabled;
		}
	}
	var tds = dom.getElementsByTagName('TD');
	dom.className = disabled ? 'DisableText' : '';
}

function Form_DB_GetParentByTagName(dom, tagName) {
	for(var p = dom; p.parentNode != null;) {
		dom = p.parentNode;
		if (dom.tagName == tagName) {
			return dom;
		}
		p = dom;
	}
	return null;
}

function Form_DB_SelectTable() {
	Dialog_List(false, 'tableIdField', 'tableNameField', null, 
			'sysFormDbTableColumnListService&fdModelName=' + fdModelName + '&fdKey=' + fdKey, 
			Form_DB_LoadColumns,
			null,
			false, true, 
			'选表');
}
function Form_DB_LoadColumns(data) {
	if (data == null) {
		return;
	}
	Form_DB_columns = [];
	var values = data.GetHashMapArray();
	new KMSSData().SendToBean('sysFormDbTableColumnListService&tableId=' + values[0].id, Form_DB_ShowColumns);
}
function Form_DB_ShowColumns(data) {
	var values = data.GetHashMapArray();
	Form_DB_columns = values;
	Form_DB_SetColumnSelect(values);
}
var Form_DB_columns = [];
