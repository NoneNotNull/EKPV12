/**********************************************************
功能：明细表
使用：
	
作者：傅游翔
创建时间：2010-04-12
**********************************************************/
// ======== 明细表 (开始)===========
Designer_Config.controls.detailsTable = {
	type : "detailsTable",
	inherit    : 'table',
	relatedWay : 'up',
	onDraw : _Designer_Control_DetailsTable_OnDraw,
	setColumnsWidth : _Designer_Control_DetailsTable_SetColumnsWidth,
	onDrawEnd : _Designer_Control_DetailsTable_OnDrawEnd,
	columnCellDraw: _Designer_Control_DetailsTable_Column_Cell_Draw,
	drawXML : _Designer_Control_DetailsTable_DrawXML,
	attrs : {
		label : Designer_Config.attrs.label,
		showIndex : {
			text : Designer_Lang.controlDetailsTable_attr_showIndex,
			value: "true",
			type: 'checkbox',
			checked: true,
			show: true
		},
		showRow : {
			text : Designer_Lang.controlDetailsTable_attr_showRow,
			value: "1",
			type: 'text',
			show: true
		},
		showStatisticRow : {
			text : Designer_Lang.controlDetailsTable_attr_showStatisticRow,
			value: "true",
			type: 'checkbox',
			checked: true,
			show: true
		},
		width : {
			text: Designer_Lang.controlAttrWidth,
			value: "",
			type: 'text',
			show: true,
			validator: Designer_Control_Attr_Width_Validator,
			checkout: Designer_Control_Attr_Width_Checkout
		}
	},
	domAttrs : {
		td : {
			align: {
				text: Designer_Lang.controlStandardTableDomAttrTdAlign,
				value: "left",
				type: 'radio',
				opts: [
					{text:Designer_Lang.controlStandardTableDomAttrTdAlignLeft,value:"left"}, // left
					{text:Designer_Lang.controlStandardTableDomAttrTdAlignCenter,value:"center"},
					{text:Designer_Lang.controlStandardTableDomAttrTdAlignRight,value:"right"}
				]
			},
			vAlign: {
				text: Designer_Lang.controlStandardTableDomAttrTdVAlign,
				value: "middle",
				type: 'radio',
				opts: [
					{text:Designer_Lang.controlStandardTableDomAttrTdVAlignTop,value:"top"},
					{text:Designer_Lang.controlStandardTableDomAttrTdVAlignMiddle,value:"middle"}, // middle
					{text:Designer_Lang.controlStandardTableDomAttrTdVAlignBottom,value:"bottom"}
				]
			},
			width: {
				text: Designer_Lang.controlAttrWidth,
				value: "auto",
				type: 'text'
			}
		}
	},
	info : {
		name: Designer_Lang.controlDetailsTable_info_name,
		td: Designer_Lang.controlDetailsTable_info_td
	},
	resizeMode : 'no',
	insertRow: _Designer_Control_DetailsTable_noSuppotAlert,
	deleteRow: _Designer_Control_DetailsTable_noSuppotAlert,
	appendRow: _Designer_Control_DetailsTable_noSuppotAlert,
	merge: _Designer_Control_DetailsTable_noSuppotAlert,
	split: _Designer_Control_DetailsTable_noSuppotAlert,
	setColWidth: null,
	onColumnStart: null,
	onColumnDoing: null,
	onColumnEnd: null,
	onRowStart: _Designer_Control_DetailsTable_noSuppotAlert,
	onRowDoing: _Designer_Control_DetailsTable_noSuppotAlert,
	onRowEnd: _Designer_Control_DetailsTable_noSuppotAlert,
	onMouseOver: _Designer_Control_DetailsTable_DoMouseOver,
	onSelect: _Designer_Control_DetailsTable_OnSelect,
	insertColumn : _Designer_Control_DetailsTable_InsertColumn,
	_insertColumn : _Designer_Control_Table_InsertColumn,
	deleteColumn : _Designer_Control_DetailsTable_DeleteColumn,
	_deleteColumn : _Designer_Control_Table_DeleteColumn,
	insertValidate: _Designer_Control_DetailsTable_InsertValidate,
	onInitialize : _Designer_Control_DetailsTable_OnInitialize,
	_appendColumn  : _Designer_Control_Table_AppendColumn,
	appendColumn  : _Designer_Control_DetailsTable_AppendColumn,
	getRelateWay  : _Designer_Control_DetailsTable_GetRelateWay
};

function _Designer_Control_DetailsTable_noSuppotAlert() {
	alert(Designer_Lang.controlDetailsTable_noSuppotAlert);
	return false;
}

Designer_Config.operations['detailsTable'] = {
		lab : "2",
		imgIndex : 2,
		title : Designer_Lang.controlDetailsTable_title,
		run : function (designer) {
			designer.toolBar.selectButton('detailsTable');
		},
		type : 'cmd',
		shortcut : 'R',
		select: true,
		cursorImg: 'style/cursor/detailsTable.cur',
		isAdvanced: false
	};
Designer_Config.buttons.control.push("detailsTable");
Designer_Menus.add.menu['detailsTable'] = Designer_Config.operations['detailsTable'];

// 初始化绘制
function _Designer_Control_DetailsTable_OnDraw(parentNode, childNode) {
	if(this.options.values.cell == null){
		this.options.values.cell=this.attrs.cell.value?this.attrs.cell.value:5;
	}
	var cells = {row:3, cell:this.options.values.cell}, domElement, row, cell;
	this.options.domElement = document.createElement('table');
	domElement = this.options.domElement;
	this.options.values._label_bind = 'false'; // 不需要绑定
//	this.options.values.label = _Get_Designer_Control_Label(this.options.values, this);
	this.options.values.label = this.info.name + _Designer_Index_Object.label ++;
	domElement.setAttribute('label', this.options.values.label);

	if(this.options.values.id == null)
		this.options.values.id = "fd_" + Designer.generateID();
	domElement.setAttribute('id', this.options.values.id);
	domElement.setAttribute('formDesign', 'landray');
	domElement.setAttribute('align', 'center');
	domElement.className = 'tb_normal';
	domElement.style.width = '100%';
	if (this.parent)
		domElement.setAttribute('tableName', _Get_Designer_Control_TableName(this.parent));
	parentNode.appendChild(this.options.domElement);
	for (var i = 0; i < cells.row; i ++) {
		row = domElement.insertRow(-1);
		if ( i == 0) {row.className = 'tr_normal_title'; row.type = "titleRow";}
		else if (i == 1) {row.type = "templateRow";}
		else if (i == 2) {row.type = "statisticRow";}
		for (var j = 0; j < cells.cell; j ++) {
			cell = row.insertCell(-1);
			cell.setAttribute('row', '' + i);            //记录行数(多值，以逗号分割，有严格顺序)
			cell.setAttribute('column', '' + j);         //记录列数(多值，以逗号分割，有严格顺序)
			cell.setAttribute('align', 'center');
			if (j == 0) {
				//cell.setAttribute('align', 'center');
				cell.style.width = '15px';
				if (i == 0) {
					cell.setAttribute("colType", "noTitle");
					cell.innerHTML = '<label attach="' + this.options.values.id + '">'+Designer_Lang.controlDetailsTable_seqNo+'</label>';
				}
				else if (i == 1) {
					cell.setAttribute("colType", "noTemplate");
					cell.innerHTML = '<label attach="' + this.options.values.id + '">'+i+'</label>';
				}
				else if (i == 2) {
					cell.setAttribute("colType", "noFoot");
					cell.innerHTML = '<label attach="' + this.options.values.id + '">&nbsp;</label>';
				}
			} else if (j + 1 == cells.cell) {
				//cell.setAttribute('align', 'center');
				cell.style.width = '48px';
				if (i == 0) {
					cell.setAttribute('colType', 'addTitle');
					var url = Com_Parameter.ResPath + 'style/default/icons/add.gif';
					cell.innerHTML = '<img src="' + url + '">';
				}
				else if (i == 1) {
					cell.setAttribute('colType', 'delCol');
					//cell.innerHTML = '<label attach="' + this.options.values.id + '">删除</label>';
					//cell.innerHTML = '删除<br>上移<br>下移';
					var del = Com_Parameter.ResPath + 'style/default/icons/delete.gif';
					var up = Com_Parameter.ResPath + 'style/default/icons/up.gif';
					var down = Com_Parameter.ResPath + 'style/default/icons/down.gif';
					cell.innerHTML = '<nobr><img src="' + del + '">' 
							+ '<img src="' + up + '">' 
							+ '<img src="' + down + '"></nobr>';
				}
				else if (i == 2) {
					cell.setAttribute('colType', 'emptyCell');
					cell.innerHTML = '<label attach="' + this.options.values.id + '">&nbsp;</label>';
				}
			} else {
				if (i == 2) {
					this.columnCellDraw(cell);
				}
			}
		}
	}
	this.setColumnsWidth();
}
// 设置宽度属性
function _Designer_Control_DetailsTable_SetColumnsWidth() {
	var domElement = this.options.domElement;
	var columns = domElement.rows[0].cells.length - 2;
	var width = 'auto';//100 / columns + '%';
	var columnsWidth = ['10px'];
	for (var i = 0, l = columns; i < l; i ++) {
		//domElement.rows[0].cells[i + 1].width = width;
		//columnsWidth.push(width);
	}
	//columnsWidth.push('10px');
	//domElement.columnsWidth = columnsWidth.join(';');
	domElement = null;
}

function _Designer_Control_DetailsTable_OnInitialize() {
	var table = this.options.domElement, column = [];
	var rowCount = table.rows.length, colCount = 0, row, cell, cellColumn;
	//计算列总数
	row = table.rows[0], colCount = row.cells.length;
	for (var i = 0; i < colCount; i++) {
		cell = row.cells[i];
		rowCount = column.length;
		cellColumn = cell.getAttribute('column').split(',');
		for (var j = 0; j < cellColumn.length; j++)
			column.push([]);
		column[rowCount].push(cell);
	}
	//遍历单元格，放入相应列组中
	rowCount = table.rows.length;
	for (var i = 1; i < rowCount; i++) {
		row = table.rows[i];
		colCount = row.cells.length;
		for (var j = 0; j < colCount; j++) {
			cell = row.cells[j];
			cellColumn = cell.getAttribute('column').split(',');
			column[cellColumn[0]].push(cell);
		}
	}
	//记录列对象集
	this.options.column = column;
}

// 添加列
function _Designer_Control_DetailsTable_InsertColumn() {
	this._insertColumn();
	this.setColumnsWidth();
}

// 删除列
function _Designer_Control_DetailsTable_DeleteColumn() {
	this._deleteColumn();
	this.setColumnsWidth();
}

// 追加列
function _Designer_Control_DetailsTable_AppendColumn() {
	var row = this.options.domElement.rows[0], colCount = row.cells.length;
	this._insertColumn(row.cells[colCount - 1]);
	this.setColumnsWidth();
}

// 选中显示
function _Designer_Control_DetailsTable_OnSelect(event) {
	//this.options.showAttr = 'default';
	var currElement = event.srcElement || event.target;
	//若选中的不是单元格，则退出
	if (!Designer.checkTagName(currElement, 'td')) {
		this.options.values.columnIndex = null;
		return;
	}
	//this.options.values.columnIndex = currElement.cellIndex;
	//if (currElement.cellIndex == 0) return;
	if ((currElement.colType != null && currElement.colType != '')) return;
	if (this.options._selectTable) {this.onUnLock(); return;}
	//this.options.showAttr = currElement.parentNode.rowIndex == 2 ? 'all' : 'default';
	//var table = currElement.parentNode.parentNode.parentNode;
	//var dataCell = table.rows[2].cells[currElement.cellIndex];
	//var input = dataCell.getElementsByTagName('input')[0];
	//this.options.values.selectedValue = input.selectedValue;
	//this.options.values.showText = input.showText;

	this.selectedDomElement = [];
	this.chooseCell(currElement, true);
}

function _Designer_Control_DetailsTable_DoMouseOver() {

}

// 插入校验
function _Designer_Control_DetailsTable_InsertValidate(cell, control) {
	if (cell.tagName != 'TD' || (cell.colType != null && cell.colType != '')) {
		return false;
	}
	if (control.implementDetailsTable != true) {
		return false;
	}
	/*
	var rowIndex = cell.parentNode.rowIndex;
	if (rowIndex == 0 && control.type != 'textLabel') {
		return false;
	} else if (rowIndex == 1) {
		// 任由插入
	}
	else if (rowIndex == 2 && control.type != 'textLabel' && control.type != 'inputText') 
		return false;
	*/
	return true;
}

// 数据字段生成
function _Designer_Control_DetailsTable_DrawXML() {
	var values = this.options.values;
	var rowDom;
	var otherXml = [];
	var buf = ['<extendSubTableProperty '];
	buf.push('name="',values.id, '" ');
	buf.push('label="', values.label, '" ');
	buf.push('>\r\n');
	buf.push('<idProperty><generator type="assigned" /></idProperty>\r\n');
	if (this.children.length > 0) {
		var xmls = [];
		this.children = this.children.sort(Designer.SortControl);
		for (var i = 0, l = this.children.length; i < l; i ++) {
			var c = this.children[i];
			if (c.drawXML) {
				var xml = c.drawXML();
				if (xml != null) {
					rowDom = Designer_Control_DetailsTable_GetParentDom('tr', c.options.domElement);
					if (rowDom.type == 'templateRow') {
						xmls.push(xml, '\r\n');
					} else {
						otherXml.push(xml);
					}
				}
			}
		}
		buf.push( xmls.join('') );
	}
	buf.push('</extendSubTableProperty>\r\n');
	return buf.join('') + otherXml.join('');
}

// 绘制结束调用方法
function _Designer_Control_DetailsTable_OnDrawEnd() {
	var values = this.options.values;
	var domElement = this.options.domElement;
	domElement.label = values.label;
	domElement.setAttribute('id', values.id);
	
	this.options.values.width=this.options.values.width?this.options.values.width:'100%';
	
	domElement.width=this.options.values.width;
	domElement.style.width=this.options.values.width;
	//if (this.options.values.width || this.options.values.width.toString().indexOf('%') > -1) {
	
	//}
	//if (values.rowFormula != null) {
	//	domElement.furmula = values.rowFormula;
	//}
	if (this.parent)
		domElement.setAttribute('tableName', _Get_Designer_Control_TableName(this.parent));
	//if (this.options.values.columnIndex) {
	//	this.columnCellDraw(
	//		domElement.rows[2].cells[this.options.values.columnIndex],
	//		this.options.values.selectedValue,
	//		this.options.values.showText
	//	);
	//}
	if (values) {
		var rows = domElement.rows;
		if (values.showIndex == 'false') {
			domElement.setAttribute('showIndex', 'false');
			for (var i = 0; i < rows.length; i ++) {
				rows[i].cells[0].style.display = 'none';
			}
		} else {
			domElement.setAttribute('showIndex', 'true');
			for (var i = 0; i < rows.length; i ++) {
				rows[i].cells[0].style.display = '';
			}
		}
		if (values.showRow == null) {
			values.showRow = 1;
		}
		if (values.showRow) {
			// 初始行数
			var rowSize = parseInt(values.showRow);
			if (isNaN(rowSize) || rowSize < 0) {
				rowSize = 0;
			}
			domElement.setAttribute('showRow', '' + rowSize);
			
			// 是否显示统计行
			domElement.setAttribute('showStatisticRow', values.showStatisticRow);
		}
	}
}

// 列单元绘制
function _Designer_Control_DetailsTable_Column_Cell_Draw(cell, selectedValue, showText) {
	var html = '&nbsp;';
	//var html = '<input type="hidden" selectedValue="' + (selectedValue ? selectedValue : "none");
	//if (showText) {
	//	html += '" showText="' + showText;
	//}
	//html += '" >';
	//if (showText) {
	//	html += '<label attach="' + this.options.values.id + '">' + showText + '</label>';
	//}
	cell.innerHTML = html;
}

function Designer_Control_DetailsTable_GetParentDom(tagName, dom) {
	var parent = dom;
	while((parent = parent.parentNode) != null) {
		if (Designer.checkTagName(parent, tagName)) {
			return parent;
		}
	}
	return parent;
}

function _Designer_Control_DetailsTable_GetRelateWay(control) {
	var tr = control.options.domElement;
	tr = Designer_Control_DetailsTable_GetParentDom('tr', tr);
	if (control.isTextLabel) {
		if (tr != null && tr.type == 'titleRow') {
			return 'up';
		}
		return 'self';
	}
	if (tr != null && tr.type == 'templateRow') {
		return 'up';
	}
	return 'self';
}

// ======== 明细表 (结束)===========