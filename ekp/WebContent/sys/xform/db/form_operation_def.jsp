<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@include file="/sys/xform/base/template_script.jsp" %>
<kmss:windowTitle
	moduleKey="sys-xform:xform.title"
	subjectKey="sys-xform:xform.db.save.def" />
<center>
<div style="text-align: left;margin-bottom: 5px;width: 95%;">
	<bean:message bundle="sys-xform" key="xform.db.def.option.mode" />
	<label>
		<input type="radio" name="xformDb" value="1" onclick="XFormDBChangeMode(this.value);" checked /><bean:message bundle="sys-xform" key="xform.db.def.option.mode.designer" />
	</label>
	<label>
		<input type="radio" name="xformDb" value="2" onclick="XFormDBChangeMode(this.value);" /><bean:message bundle="sys-xform" key="xform.db.def.option.mode.dba" />
	</label>
	&nbsp;&nbsp;&nbsp;&nbsp;
	<button class="btnopt" id="xformDbUpdateTableBtn" onclick="BuildHbmXml(this);">更新表结构</button>
	<button class="btnopt" id="xformDbValidateTableBtn" style="display:none;" onclick="BuildHbmXml(this);">校验表结构</button>
</div>
<table id="xformDbDesignerTable" class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			表
		</td>
		<td width="35%" id="xformDbDesignerTableSelect">
			<select name="dbTables">
				<option value="">请选择</option>
			</select>
		</td>
		<td class="td_normal_title" width=15%>
			表名
		</td>
		<td width=35% id="xformDbDesignerTableName">
			ekp_cf_<input type="text" class="inputsgl" name="tableName" value="" />
		</td>
	</tr>
	<tr>
		<td colspan="4" id="xformDbDesignerTableTable">
			<table class="tb_normal" width=100%>
				<tr class="tr_normal_title">
					<td width="10px">
					</td>
					<td>名称</td>
					<td>数据类型</td>
					<td>列名</td>
					<td>选项</td>
				</tr>
				<tr>
					<td><input type="checkbox" value="1"/></td>
					<td>名称</td>
					<td>
					文本
					</td>
					<td>ekp_cf_<input type="text" class="inputsgl" name="tableName" value="fd_12345678" /></td>
					<td>长度<input type="text" class="inputsgl" name="tableName" value="10" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			功能说明
		</td>
		<td colspan="3">
			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			配置说明
		</td>
		<td colspan="3">
			
		</td>
	</tr>
</table>
<%-- ================================== DBA 模式 ================================ --%>
<table id="xformDbDBATable" class="tb_normal" width=95% style="display:none">
	<tr>
		<td class="td_normal_title" width=15%>
			表
		</td>
		<td width="35%" id="xformDbDBATableSelect">
			<select name="dbTables">
				<option value="">请选择</option>
			</select>
		</td>
		<td class="td_normal_title" width=15%>
			表名
		</td>
		<td width=35% id="xformDbDBATableName">
			<input type="text" class="inputsgl" name="tableName" value="" />
		</td>
	</tr>
	<tr>
		<td colspan="4" id="xformDbDBATableTable">
			<table class="tb_normal" width=100%>
				<tr class="tr_normal_title">
					<td width="10px">
					</td>
					<td>名称</td>
					<td>数据类型</td>
					<td>列名</td>
					<td>选项</td>
				</tr>
				<tr>
					<td><input type="checkbox" value="1"/></td>
					<td>名称</td>
					<td>
					<select name="">
						<option value="">文本</option>
						<option value="">整数</option>
						<option value="">浮点数</option>
						<option value="">日期时间</option>
						<option value="">大文本</option>
						<option value="">组织架构</option>
					</select>
					</td>
					<td><input type="text" class="inputsgl" name="tableName" value="" /></td>
					<td>长度<input type="text" class="inputsgl" name="tableName" value="" /></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			功能说明
		</td>
		<td colspan="3">
			
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			配置说明
		</td>
		<td colspan="3">
			
		</td>
	</tr>
</table>
</center>
<script type="text/javascript">
<!--
var controls = window.dialogArguments.controls;
var entityName = window.dialogArguments.entityName;
var entityNameObj = window.dialogArguments.entityNameObj;

Com_AddEventListener(window, 'load', function() {
	XFormDBInit();
});
function XFormDBInit() {
	var tables = GetFormTable(controls);

	var dests = document.getElementById("xformDbDesignerTableSelect");
	dests.innerHTML = GetTableSelectHTML('1' , tables);
	var dbats = document.getElementById("xformDbDBATableSelect");
	dbats.innerHTML = GetTableSelectHTML('2' , tables);
	
	document.getElementById("xformDbDesignerTableName").innerHTML = GetTableNameHTML('1' , tables);
	document.getElementById("xformDbDBATableName").innerHTML = GetTableNameHTML('2' , tables);
	
	var designerTable = document.getElementById("xformDbDesignerTableTable");
	designerTable.innerHTML = '';
	var dbaTable = document.getElementById("xformDbDBATableTable");
	dbaTable.innerHTML = '';
	
	for (var i = tables.length - 1; i >= 0; i --) {
		var div = document.createElement('div');
		div.innerHTML = XFormDBTableRows("1", tables[i].name, controls);
		designerTable.appendChild(div);
		
		var div2 = document.createElement('div');
		div2.innerHTML = XFormDBTableRows("2", tables[i].name, controls);
		dbaTable.appendChild(div2);
	}
	ShowTableName('1' , dests.getElementsByTagName('select')[0].value);
	ShowTableName('2' , dbats.getElementsByTagName('select')[0].value);
}
function GetTableSelectHTML(mode, tables) {
	var buf = [];
	buf.push('<select name="dbTables" mode="', mode, '" onchange="OnChangeTable(this);ShowTableName(this.mode, this.value);">');
	for (var i = tables.length - 1; i >= 0; i --) {
		var c = tables[i];
		buf.push('<option value="', c.name, '">');
		buf.push(c.label, '</option>');
	}
	buf.push('</select>');
	return buf.join('');
}
function GetTableNameHTML(mode, tables) {
	var buf = [];
	for (var i = tables.length - 1; i >= 0; i --) {
		if (mode == '1')
			buf.push('ekp_cf_');
		buf.push('<input type="text" class="inputsgl" id="tableName_', mode, '_', tables[i].name, 
			'" value="', tables[i].name, '" style="display:none;">');
	}
	return buf.join('');
}
function ShowTableName(mode, tableId) {
	var inputs = document.getElementById(mode == '1' ? 'xformDbDesignerTableName' : 'xformDbDBATableName').getElementsByTagName('input');
	var input = document.getElementById('tableName_' + mode + '_' + tableId);
	for (var i = inputs.length - 1; i >= 0 ; i --) {
		inputs[i].style.display = 'none';
	}
	input.style.display = '';
}
function GetFormTable(controls, tabs) {
	var tables = tabs || [];

	for (var i = controls.length - 1; i >= 0; i --) {
		if (controls[i].isTable) {
			tables.push(controls[i]);
		}
		GetFormTable(controls[i].children, tables);
	}
	return tables;
}
function XFormDBChangeMode(mode) {
	if (mode == '1') { // 设计模式
		document.getElementById("xformDbUpdateTableBtn").style.display = '';
		document.getElementById("xformDbValidateTableBtn").style.display = 'none';
		
		document.getElementById("xformDbDesignerTable").style.display = '';
		document.getElementById("xformDbDBATable").style.display = 'none';
	}
	else if (mode == '2') { // DBA模式
		document.getElementById("xformDbUpdateTableBtn").style.display = 'none';
		document.getElementById("xformDbValidateTableBtn").style.display = '';
		
		document.getElementById("xformDbDesignerTable").style.display = 'none';
		document.getElementById("xformDbDBATable").style.display = '';
	}
}
function XFormDBTableRows(mode, tableId, objs) {
	var cs = null;
	for (var i = objs.length - 1; i >= 0; i --) {
		if (objs[i].name == tableId) {
			cs = GetTableControls(objs[i].children);
			break;
		}
	}
	var tableHTML = [];
	tableHTML.push('<table id="', mode, '_' , tableId , '" class="tb_normal" width="100%"><tr class="tr_normal_title">',
					'<td width="15px"></td>',
					'<td>名称</td>',
					'<td>数据类型</td>',
					'<td>列名</td>',
					'<td>选项</td>',
				'</tr>');
	for (var i = cs.length - 1; i >= 0; i --) {
		tableHTML.push(XFormDBTableRow(mode, cs[i]));
	}
	tableHTML.push('</table>');
	return tableHTML.join('');
}
function XFormDBTableRow(mode, control) {
	var row = [];
	row.push('<tr><td>');
	row.push(BuildTableCheckboxCell(mode, control));
	row.push('</td><td>');
	row.push(BuildTableNameCell(mode, control));
	row.push('</td><td>');
	row.push(BuildTableDataTypeCell(mode, control));
	row.push('</td><td>');
	row.push(BuildTableColNameCell(mode, control));
	row.push('</td><td>');
	row.push(BuildTableOptionCell(mode, control));
	row.push('</td></tr>');

	return row.join('');
}
function GetTableControls(objs) {
	var cs = [];
	for (var i = objs.length - 1; i >= 0; i --) {
		if (!objs[i].isTable) {
			cs.push(objs[i]);
		}
	}
	return cs;
}
function BuildTableCheckboxCell(mode, obj) {
	return '<input type="checkbox" value="1" onclick="OnEnableChecked(this);" />';
}
function BuildTableNameCell(mode, obj) {
	return obj.label + '<input type="hidden" value="' + obj.name + '">';
}
function BuildTableDataTypeCell(mode, obj) {
	if (mode == '1') { // 设计模式
		if (obj.type == 'String') {return '文本<input type="hidden" value="String">';}
		if (obj.type == 'Long') {return '整数<input type="hidden" value="Long">';}
		if (obj.type == 'Double') {return '浮点数<input type="hidden" value="Double">';}
		if (obj.type == 'Date') {return '日期时间<input type="hidden" value="Date">';}
		if (obj.type == 'RTF') {return '大文本<input type="hidden" value="rtf">';}
		if (obj.type == 'com.landray.kmss.sys.organization.model.SysOrgElement') {return '组织架构<input type="hidden" value="com.landray.kmss.sys.organization.model.SysOrgElement">';}
		return GetDataTypeSelect(mode, obj);
	}
	else if (mode == '2') { // DBA模式
		var html = GetDataTypeSelect(mode, obj);
		return html;
	}
}
function GetDataTypeSelect(mode, obj) {
	var types = [];
	types.push('<select name="dataType" onchange="OnDataTypeSelected(\'' + mode + '\', this);" disabled>');
	types.push('<option value="String"', (obj.type == 'String') ? ' selected' : '', '>文本</option>');
	types.push('<option value="Long"', (obj.type == 'Long') ? ' selected' : '', '>整数</option>');
	types.push('<option value="Double"', (obj.type == 'Double') ? ' selected' : '', '>浮点数</option>');
	types.push('<option value="Date"', (obj.type == 'Date') ? ' selected' : '', '>日期时间</option>');
	types.push('<option value="RTF"', (obj.type == 'RTF') ? ' selected' : '', '>大文本</option>');
	types.push('<option value="com.landray.kmss.sys.organization.model.SysOrgElement"', (obj.type == 'com.landray.kmss.sys.organization.model.SysOrgElement') ? ' selected' : '', '>组织架构</option>');
	types.push('</select>');
	return types.join('');
}
function BuildTableColNameCell(mode, obj) {
	var buf = [];
	buf.push('<div forType="com.landray.kmss.sys.organization.model.SysOrgElement"', (obj.type == 'com.landray.kmss.sys.organization.model.SysOrgElement' ? '' : ' style="display:none;"'), '>');
	buf.push('<label><input type="radio" name="orgDBType_',mode,obj.name,'" value="m" checked disabled>中间表 </label>');
	buf.push('<label><input type="radio" name="orgDBType_',mode,obj.name,'" value="c" disabled>列 </label>');
	buf.push(((mode == '1') ? ' ekp_cf_' : ''));
	buf.push('<input type="text" name="column" class="inputsgl" size="17" value="' + obj.name + '" disabled>');
	buf.push('</div>');
	buf.push('<div forType="common"', (obj.type != 'com.landray.kmss.sys.organization.model.SysOrgElement' ? '' : ' style="display:none;"'), '>');
	buf.push(((mode == '1') ? ' ekp_cf_' : ''));
	buf.push('<input type="text" name="columnName" class="inputsgl" value="' + obj.name + '" disabled>');
	buf.push('</div>');
	return buf.join('');
}
function BuildTableOptionCell(mode, obj) {
	var buf = [];
	buf.push('<div forType="String"', (obj.type == 'String' || obj.type == null ? '' : ' style="display:none;"'), '>');
	buf.push('长度<input type="text" name="maxlength" size="10" class="inputsgl"');
	if (obj.maxlength != null && obj.maxlength != '')
		buf.push(((mode == '1') ? 'readonly' :''), ' value="' + obj.control.maxlength + '"');
	else
		buf.push(' value="200"');
	buf.push(' disabled></div>');
	buf.push('<div forType="Double"', (obj.type == 'Double' ? '' : ' style="display:none;"'), '>');
	buf.push('保留<input type="text" name="decimal" size="3" class="inputsgl"');
	if (obj.decimal != null && obj.decimal != '') {
		buf.push(((mode == '1') ? 'readonly' :''), ' value="' + obj.control.decimal + '"');
	} else 
		buf.push(' value="0"');
	buf.push(' disabled></div>');
	
	return buf.join('');
}
// ------------- 操作方法 ---------------
function LoopTrCells(tr, fn) {
	for (var i = tr.cells.length - 1; i > 0 ; i --) {
		var cell = tr.cells[i];
		LoopToTrCells(cell.childNodes, function(node) {
			return (node.tagName == 'INPUT' || node.tagName == 'SELECT');
		}, fn);
	}
}
function LoopToTrCells(childNodes, conditon, fn) {
	if (childNodes == null) return;
	for (var j = childNodes.length - 1; j >= 0; j --) {
		var node = childNodes[j];
		if (conditon(node)) {
			fn(node);
		}
		LoopToTrCells(node.childNodes, conditon, fn);
	}
}
function isDivTagCondition(node) {
	return (node.tagName == 'DIV');
}
function OnEnableChecked(dom) {
	var tr = dom.parentNode.parentNode;
	if (dom.checked) {
		LoopTrCells(tr, function(node) {node.disabled = false;});
	} else {
		LoopTrCells(tr, function(node) {node.disabled = true;});
	}
}
function OnDataTypeSelected(mode, dom) {
	var tr = dom.parentNode.parentNode;
	var l = tr.cells.length;
	var optionTd = tr.cells[l - 1];
	if (dom.value == 'String') {
		LoopToTrCells(optionTd.childNodes, isDivTagCondition, function(node) {
			if (node.forType == 'String') node.style.display = '';
			else node.style.display = 'none';
		});
	}
	else if (dom.value == 'Long' || dom.value == 'Date' || dom.value == 'RTF' || dom.value == 'com.landray.kmss.sys.organization.model.SysOrgElement') {
		LoopToTrCells(optionTd.childNodes, isDivTagCondition, function(node) {
			node.style.display = 'none';
		});
	}
	else if (dom.value == 'Double') {
		LoopToTrCells(optionTd.childNodes, isDivTagCondition, function(node) {
			if (node.forType == 'Double') node.style.display = '';
			else node.style.display = 'none';
		});
	}
	var colNameTd = tr.cells[l - 2];
	if (dom.value == 'com.landray.kmss.sys.organization.model.SysOrgElement') {
		LoopToTrCells(colNameTd.childNodes, isDivTagCondition, function(node) {
			if (node.forType == 'com.landray.kmss.sys.organization.model.SysOrgElement') node.style.display = '';
			else node.style.display = 'none';
		});
	} else {
		LoopToTrCells(colNameTd.childNodes, isDivTagCondition, function(node) {
			if (node.forType == 'com.landray.kmss.sys.organization.model.SysOrgElement') node.style.display = 'none';
			else node.style.display = '';
		});
	}
}
function isTableTagCondition(node) {
	return node.tagName == 'TABLE'
}
function OnChangeTable(dom) {
	var tableId = dom.value;
	var mode = dom.mode;
	if (mode == '1') {
		var designerTable = document.getElementById("xformDbDesignerTableTable");
		LoopToTrCells(designerTable.childNodes, isTableTagCondition, function(node) {
			node.style.display = 'none';
		});
	} else {
		var dbaTable = document.getElementById("xformDbDBATableTable");
		LoopToTrCells(dbaTable.childNodes, isTableTagCondition, function(node) {
			node.style.display = 'none';
		});
	}
	var table = document.getElementById(mode + '_' + tableId);
	if (table != null) table.style.display = '';
}
// ----------- hbm.xml 生成 ------------------
function GetTableControlById(tableId, objs) {
	var obj = null;
	for (var i = 0; i < objs.length; i ++) {
		if (objs[i].name == tableId) {
			obj = objs[i];
			break;
		}
		obj = GetTableControlById(tableId, objs[i].children);
		if (obj != null) {
			return obj;
		}
	}
	return obj;
}
function BuildHbmXml(dom) {
	dom.disabled = true;
	XForm_loading_Text.innerHTML = "数据处理中...";
	XForm_Loading_Show();
	
	var mode = null;
	var xformDb = document.getElementsByName('xformDb');
	for (var i = xformDb.length - 1; i >= 0; i--) {
		if (xformDb[i].checked) mode = xformDb[i].value;
	}
	var designerTable = document.getElementById(mode == '1' ? "xformDbDesignerTable" : "xformDbDBATable") ;
	var tableSelect = document.getElementById(mode == '1' ? "xformDbDesignerTableSelect" : "xformDbDBATableSelect");
	var tables = tableSelect.getElementsByTagName('select')[0];
	var colTable = document.getElementById(mode + "_" + tables.value);
	var rows = colTable.rows;
	var cols = [];
	var xml = [];
	var _entityName = entityName;
	xml.push('<hibernate-mapping>\r\n');
	xml.push('<class entity-name="', _entityName, '" ');
	entityNameObj.value = _entityName;
	
	xml.push('table="', (mode == '1' ? 'ekp_cf_' : ''), document.getElementById('tableName_' + mode + '_' + tables.value).value , '">\r\n');
	for (var i = 1; i < rows.length; i ++) {
		var row = rows[i];
		GetFormHbmObj(mode, row, cols);
	}
	xml.push('\t<id name="fdId" column="ekp_cf_id" type="java.lang.String" length="36">\r\n');
	xml.push('\t\t<generator class="assigned"/>\r\n\t</id>\r\n');
	for (var i = 0; i < cols.length; i ++) {
		if (cols[i].dataType != 'SysOrgElement') {
			xml.push('\t<property name="', cols[i].name);
			xml.push('" column="', cols[i].colName);
			var type = cols[i].dataType;
			var length = cols[i].length;
			if (type == 'String') {
				xml.push('" type="', 'java.lang.String');
				if (length == null || length == '')
					xml.push('" length="', 4000);
				else
					xml.push('" length="', length);
			}
			else if (type == 'Long') {
				xml.push('" type="', 'java.lang.Long');
				xml.push('" length="', 10);
			}
			else if (type == 'Double') {
				xml.push('" type="', 'java.lang.Double');
				xml.push('" length="', 10);
			}
			else if (type == 'RTF') {
				xml.push('" type="', 'com.landray.kmss.common.dao.ClobStringType');
				xml.push('" length="', 10000);
			}
			else if (type == 'Date') {
				xml.push('" type="', 'java.util.Date');
			}
			xml.push('" />\r\n');
		}
		else {
			if (cols[i].orgDBType == 'm') {
				xml.push('\t<bag name="', cols[i].name);
				xml.push('" table="', cols[i].colName);
				xml.push('">\r\n\t\t<key column="fd_main_id" />\r\n');
				xml.push('\t\t<many-to-many ');
				xml.push('class="com.landray.kmss.sys.organization.model.SysOrgElement" ');
				xml.push('column="fd_parent_id" />\r\n\t</bag>\r\n');
			} else {
				xml.push('\t<many-to-one name="', cols[i].name);
				xml.push('" column="', cols[i].colName);
				xml.push('" class="com.landray.kmss.sys.organization.model.SysOrgElement" />\r\n');
			}
		}
	}
	xml.push('</class>\r\n</hibernate-mapping>');
	//alert(xml.join(''));return;
	Ajax({
		url:Com_Parameter.ContextPath+'sys/xform.do?method=updateTable', 
		params:'&entityName=' + _entityName + '&hbm=' + escape(xml.join('')),
		method:'POST',
		success:function(req) {
			var result = req.responseText;
			alert(result);
			dom.disabled = false;
			XForm_Loading_Hide();
		},
		error:function(req) {
			dom.disabled = false;
			XForm_Loading_Hide();
		}
	});
}
function GetFormHbmObj(mode, row, cols) {
	var cells = row.cells;
	var check = cells[0].getElementsByTagName('input')[0];
	if (!check.checked) {
		return;
	}
	var obj = {};
	// 数据字段name
	var names = cells[1].getElementsByTagName('input');
	obj.name = names[0].value;
	// 数据类型
	var selects = cells[2].getElementsByTagName('select');
	var inputs = cells[2].getElementsByTagName('input');
	if (selects.length == 1)
		obj.dataType = selects[0].value;
	else {
		obj.dataType = inputs[0].value;
	}
	// 数据库字段名
	var colNameInputs = cells[3].getElementsByTagName('input');
	for (var i = colNameInputs.length - 1; i >= 0; i --) {
		var input = colNameInputs[i];
		if (obj.dataType == 'SysOrgElement') {
			if (input.name == 'column') {
				obj.colName = input.value;
				if (mode == '1')
					obj.colName = 'ekp_cf_' + obj.colName;
			}
			if (input.name.indexOf('orgDBType') > -1 && input.checked) {
				obj.orgDBType = input.value;
			}
		} else {
			if (input.name == 'columnName') {
				obj.colName = input.value;
				if (mode == '1')
					obj.colName = 'ekp_cf_' + obj.colName;
				break;
			}
		}
	}
	// 数据参数
	var optionInputs = cells[4].getElementsByTagName('input');
	for (var i = optionInputs.length - 1; i >= 0; i --) {
		var input = optionInputs[i];
		if (obj.dataType == 'text') {
			if (input.name == 'maxlength') {
				obj.length = input.value;
			}
		}
		else if (obj.dataType == 'double') {
			if (input.name == 'decimal') {
				obj.decimal = input.value;
			}
		}
	}
	cols.push(obj);
}
function Ajax(options) {
	var request = Ajax.GetRequest();
	var url = options.url;
	var method = options.method == 'POST' || options.method == 'post' ? 'POST' : 'GET';
	var params = options.params ? options.params : null;
	var success = options.success;
	var error = options.error;
	if (!request || url == null) return;
	request.onreadystatechange = function() {
		if (request.readyState == 4) {
			 if (request.status == 200) {
				if (success != null) {
					success(request);
				}
			} else {
				if (error != null) {
					error(request);
				}
			}
		}
	}
	request.open(method, url, true);
	request.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	request.send(params);
}
Ajax.GetRequest = function() {
	if (window.ActiveXObject) { // IE   
    	try {
			return new ActiveXObject("Msxml2.XMLHTTP");
		} catch (othermicrosoft) {
			try {
				return new ActiveXObject("Microsoft.XMLHTTP");
			} catch (failed) {
				return false;
			}
		}
	}
	return new XMLHttpRequest();
}
//-->
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>