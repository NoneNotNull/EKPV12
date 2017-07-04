var data_xmlDom = null;

var multiple_table = 0;

$
		.extend( {
			cover : {
				show : function() {
					$.cover.hide();
					var str = "<div id='cover' style='position:absolute;background-color: #666;"
					str += "width:" + $(document).width() + "px;";
					str += "height:" + $(document).height() + "px;";
					str += "opacity:0.5;filter:alpha(opacity=50);";
					str += "top:0;left:0;z-index=10'> <div style='position:relative; width:100%;*position:absolute; *top:15%; *left:50%;'>";
					str += "<img src=" + Com_Parameter.ContextPath
							+ "resource/style/common/images/loading.gif"
							+ "></img></div> </div>";
					$(document.body).append(str);
				},
				hide : function() {
					$("#cover").remove();
				}
			}
		});
/**
 * xml 的field解析对象
 */
function XmlField() {
	this.name = '';
	this.title = '';
	this.ctype = '';
	this.maxlength = 0;
	this.decimals = '';
	this.isoptional = false;
	this.ekpid = '';
	this.ekpname = '';
	this.ekpmaxlength = '';
	this.dbiskey = false;
	this.text = '';

	this.initData = function(currNode) {
		this.name = XML_GetAttribute(currNode, 'name', '');
		this.title = XML_GetAttribute(currNode, 'title', '');
		this.ctype = XML_GetAttribute(currNode, 'ctype', '');
		this.maxlength = XML_GetAttribute(currNode, 'maxlength', 0);
		this.decimals = XML_GetAttribute(currNode, 'decimals', '');
		this.isoptional = XML_GetAttribute(currNode, 'isoptional', false);
		this.ekpid = XML_GetAttribute(currNode, 'ekpid', '');
		this.ekpname = XML_GetAttribute(currNode, 'ekpname', '');
		this.ekpmaxlength = XML_GetAttribute(currNode, 'ekpmaxlength', 0);
		this.dbiskey = XML_GetAttribute(currNode, 'dbiskey', false);
		this.text = currNode.firstChild!=null ? currNode.firstChild.nodeValue:"";//currNode.textContent;//currNode.text;
	}
}
/**
 * 解析xml 的Structure
 */
function XmlStructure() {
	this.name = '';
	this.fieldNodes = null;

	this.initData = function(structure) {
		this.name = XML_GetAttribute(structure, 'name', '');
		this.fieldNodes = XML_GetNodesByPath(structure, 'field');
	}

}

/**
 * 解析xml table
 */
function XmlTable() {
	this.name = '';
	this.clocal = '';
	this.isin = '';
	this.timestamp_ekp = '';
	this.recordsList = null;
	this.initData = function(table) {
		this.isin = XML_GetAttribute(table, 'isin', '');
		this.name = XML_GetAttribute(table, 'name', '');
		this.clocal = XML_GetAttribute(table, 'clocal', '');
		this.timestamp_ekp = XML_GetAttribute(table, 'timestamp_ekp', '');
		this.recordsList = XML_GetNodesByPath(table, 'records');
	}

}

function Records() {
	this.row = '';
	this.fieldNodes = null;

	this.initData = function(records) {
		this.row = XML_GetAttribute(records, 'row', '');
		this.fieldNodes = XML_GetNodesByPath(records, 'field');
	}
}


//扩展selectNodes方法
if(!(navigator.userAgent.indexOf("MSIE")>0)){
	 // prototying the XMLDocument 
	XMLDocument.prototype.selectNodes = function(cXPathString, xNode) {
	 	if( !xNode ) { 
	      xNode = this; 
		} 
		var oNSResolver = this.createNSResolver(this.documentElement); 
		var aItems = this.evaluate(cXPathString, xNode, oNSResolver,XPathResult.ORDERED_NODE_SNAPSHOT_TYPE, null) ;
		var aResult = []; 
		for( var i = 0; i < aItems.snapshotLength; i++) { 
		     aResult[i] = aItems.snapshotItem(i); 
		   } 
		   return aResult; 
	} 
	
	// prototying the Element 
	Element.prototype.selectNodes = function(cXPathString) { 
	    if(this.ownerDocument.selectNodes) { 
	         return this.ownerDocument.selectNodes(cXPathString, this); 
	    } else{
	         throw "For XML Elements Only";
	    } 
	 } 
}

//获取节点列表
function XML_GetNodes(xmlContent, xPath) {

	var nodeValue="";
	//对不是ie的浏览器，进行扩展selectNodes方法
	if(navigator.userAgent.indexOf("MSIE")>0){
		nodeValue=xmlContent.documentElement.selectNodes(xPath);
	}else{
		nodeValue=xmlContent.selectNodes(xPath);
	}
	return nodeValue;
}


$(document).ready( function() {
	getXml();

});

// 得到函数对应xml格式数据信息
function getXml() {
	var data = $("#fdData_xml").val();
	//alert(XML2String(data));
	resetTable(data);
}

/**
* XML对象转字符串 
* @param xmlObject
* @returns
*/
function XML2String(xmlObject) {
	// for IE
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
		return xmlObject.xml;
	} else {
		// for other browsers
		return (new XMLSerializer()).serializeToString(xmlObject);
	}
} 


// 使用xml信息重设参数表
function resetTable(rtnData) {

	$.cover.show();
	// 正式===
	if (rtnData == '')
		return;
	data_xmlDom = XML_CreateByContent(rtnData);
	var bapiName = XML_GetAttribute(data_xmlDom.getElementsByTagName("jco")[0],
			"name", "");
	buildImport("/jco/import", "IMPORT_TABLE");
	buildExport("/jco/export", "EXPORT_TABLE");
	buildTables("/jco/tables", "Label_Tabel");
	// ==================================

	document.getElementById("bapiName").innerHTML = bapiName;
	DocListFunc_Init();
	setTimeout( function() {
		$.cover.hide();
	}, 500);
}

var multiple_table = '<table id="TABLE_DocList_Copy" class="tb_normal" width="90%">'
		// + '<tr class="td_normal_title"><td></td></tr>'
		+ '<tr class="td_normal_title">'
		+ '<td>'+ RfcSearchInfo_lang.serialNumber +'</td>'
		+ '</tr>'
		+ '<!--基准行-->'
		+ '<tr KMSS_IsReferRow="1" style="display:none">'
		+ '<td KMSS_IsRowIndex="1"></td>' + '</tr> ' + '</table>'

// simple
// var table_copy = '<table id="TABLE_COPY" class="tb_normal" width="100%"
// style="display:none">'
// + '<tr class="td_normal_title" >'
// + '<td rowspan="1000" align="center">表参数</td>'
// + '<td colspan="7"></td>'
// + '</tr>'
// + '<tr class="td_normal_title" style="">'
// + '<td>参数类型</td>'
// + '<td>字段名称</td>'
// + '<td>字段说明</td>'
// + '<td>字段值</td>'
// + '</tr>'
// + '</table>'

/**
 * 构造table
 * 
 * @param {}
 *            xpath 地址
 * @param {}
 *            tableId 对应表id
 */
function buildTables(xpath, tableId) {
	var queryTable = document.getElementById(tableId);
	var tables = XML_GetNodes(data_xmlDom, xpath)[0];
	var tableList = XML_GetNodesByPath(tables, "table");
	// 动态表格标记
	var T_index = 0;
	for ( var i = 0; i < tableList.length; i++) {
		// 获取xml数据
		var xmlTable = new XmlTable();
		xmlTable.initData(tableList[i]);
		var xpath_table = xpath + "/table[" + i + "]";
		// 创建行
		// if (xmlTable.isin == '1') {
		var table_title = queryTable.insertRow(-1);
		table_title.className = "td_normal_title";
		var table_title_cell = table_title.insertCell(-1);
		var multiple_row = null;
		var multiple_cell = null;
		/**
		 * 新增需求，把isin等于0换成包含0，意思就是如果是传出的意思
		 */
		if (xmlTable.isin.indexOf('0') != -1) {
			multiple_row = queryTable.insertRow(-1);
			var multiple_cell = multiple_row.insertCell(-1);
			// 写入数据
			multiple_cell.innerHTML = multiple_table;
		} else {
			multiple_row = document.getElementById("IMPORT_TABLE").insertRow(-1);
			multiple_cell = multiple_row.insertCell(-1);
			// 写入数据
			multiple_cell.innerHTML = multiple_table;
			multiple_cell.colSpan = 4;
		}

		$("#TABLE_DocList_Copy").attr("xpath", xpath_table);
		$("#TABLE_DocList_Copy").attr("id", "TABLE_DocList" + T_index);
		var tabel_doc = document.getElementById("TABLE_DocList" + T_index);
		// tabel_doc.rows[0].cells[0].innerHTML = xmlTable.name;
		table_title_cell.innerHTML = xmlTable.name;
		/**
		 * 新增需求，把isin包含0，意思就是如果是传出的意思
		 */
		if (xmlTable.isin.indexOf('0') != -1) {
			$(multiple_row).attr("LKS_LabelName", xmlTable.name);
		}
		if (xmlTable.recordsList.length > 0) {
			var title_row = tabel_doc.rows[0];
			var title_recordObject = new Records();
			title_recordObject.initData(xmlTable.recordsList[0]);
			// 设置title_cell长度
			table_title_cell.colSpan = title_recordObject.fieldNodes.length + 1;
			// 写入数据到title行
			for ( var title_record_field = 0; title_record_field < title_recordObject.fieldNodes.length; title_record_field++) {
				var field_node_title = new XmlField();
				field_node_title
						.initData(title_recordObject.fieldNodes[title_record_field]);
				var titlecell = title_row.insertCell(-1);
				if (field_node_title.isoptional == true) {
					titlecell.innerHTML += '<span style="color:red">*</span>';
				}
				titlecell.innerHTML += field_node_title.name;
				titlecell.innerHTML += "(" + field_node_title.title + ")";
			}
		}

		for ( var record_index = 0; record_index < xmlTable.recordsList.length; record_index++) {
			var recordObject = new Records();
			recordObject.initData(xmlTable.recordsList[record_index]);
			var standard_row = tabel_doc.insertRow(-1);
			standard_row.insertCell(-1).innerHTML = record_index + 1;
			for ( var record_field = 0; record_field < recordObject.fieldNodes.length; record_field++) {
				var field_node = new XmlField();
				field_node.initData(recordObject.fieldNodes[record_field]);
				standard_row.insertCell(-1).innerHTML = field_node.text;
			}
		}
		T_index++;
	}

	for ( var multiple = 0; multiple < T_index; multiple++) {
		DocList_Info[multiple] = "TABLE_DocList" + multiple;// 改写DocList_Info数组，使用4个动态表格
	}
	multiple_table = T_index;
}

function collect_import(tableID) {
	var inputList = $("#IMPORT_TABLE input.inputsgl");
	inputList
			.each( function(index, item) {
				var xpath = $(item).attr("xpath");
				var attr = $(item).attr("attrName");
				var value = $(item).val();
				XML_GetSingleNode(data_xmlDom, xpath.replace(/[,'"]/g, "")).text = value;
			});

}

// 获取单个节点
function XML_GetSingleNode(xmlContent, xPath) {
	return xmlContent.documentElement.selectSingleNode(xPath.replace(/[,'"]/g,
			""));
}

/**
 * 构造传入表格
 * 
 * @param {}
 *            xpath xml上对应位置
 * @param {}
 *            tableId 目标构造的表格id
 */
function buildImport(xpath, tableId) {

	var import_table = document.getElementById(tableId);
	var importNode = XML_GetNodes(data_xmlDom, xpath)[0];

	var fields = XML_GetNodesByPath(importNode, 'field');
	var structNodes = XML_GetNodesByPath(importNode, 'structure');

	cellAdd(xpath, import_table, fields, 1, RfcSearchInfo_lang.field);
	buildStruct(import_table, structNodes, import_table.rows.length, 1, xpath);

}

/**
 * 构造传入表格
 * 
 * @param {}
 *            xpath xml上对应位置
 * @param {}
 *            tableId 目标构造的表格id
 */
function buildExport(xpath, tableId) {

	var import_table = document.getElementById(tableId);
	var importNode = XML_GetNodes(data_xmlDom, xpath)[0];

	var fields = XML_GetNodesByPath(importNode, 'field');
	var structNodes = XML_GetNodesByPath(importNode, 'structure');
	cellAdd(xpath, import_table, fields, 2, RfcSearchInfo_lang.field);
	buildStruct(import_table, structNodes, import_table.rows.length, 2, xpath);

}

function cellAdd(xpath, tableObject, fields, type, typeName) {
	for ( var index = 0, i = tableObject.rows.length; index < fields.length; index++, i++) {
		var currNode = fields[index];
		var tableRow = tableObject.insertRow(-1);
		var fieldObject = new XmlField();
		fieldObject.initData(currNode);
		tableRow.id = xpath + "/field[" + index + "]";
		if (typeName != '') {
			tableRow.insertCell(-1).innerHTML = typeName;
		}
		var titleCell = tableRow.insertCell(-1);
		// isoptional
		if (fieldObject.isoptional == true) {
			titleCell.innerHTML += "<span style='color:red'>*</span>";
		}
		titleCell.innerHTML += fieldObject.name;
		// ctype ,length
		var type_length = '';
		if (fieldObject.ctype != '') {
			type_length += "type:" + fieldObject.ctype + ";";
		}
		if (fieldObject.maxlength != '') {
			type_length += "maxlength:" + fieldObject.maxlength + ";";
		}
		if (type_length != '') {
			titleCell.innerHTML += "(" + type_length + ")";
		}
		// =================
		tableRow.insertCell(-1).innerHTML = fieldObject.title;

		var textValue="";
		var tempValue=fieldObject.text;
		if(!(tempValue==null ||tempValue =='' ||tempValue== 'undefined')){
			textValue=tempValue;
		}
		
		tableRow.insertCell(-1).innerHTML = textValue;//fieldObject.text;

	}
}

function buildStruct(tableObject, structNodes, handlerNumber, type, xpath) {
	var i = handlerNumber;

	if (structNodes) {
		for ( var index = 0, i = handlerNumber; index < structNodes.length; index++, i++) {
			var j = 0;
			var currNode = structNodes[index];
			var tableRow = tableObject.insertRow(-1);
			tableRow.id = xpath + "/structure[" + index + "]";
			var structNode = new XmlStructure();
			structNode.initData(currNode);
			var f = tableRow.insertCell(-1);
			f.innerHTML = RfcSearchInfo_lang.formation + structNode.name;
			var fieldList = structNode.fieldNodes;
			f.rowSpan = fieldList.length + 1;
			cellAdd(tableRow.id, tableObject, fieldList, type, '','struct');
		}
	}
}

function SaveByExcel() {
	Com_Submit(document.tibSysSapRfcSearchInfoForm, 'saveByExcel');
}
