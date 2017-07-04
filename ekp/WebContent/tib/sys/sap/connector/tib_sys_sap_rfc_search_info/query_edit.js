var data = '<?xml version="1.0" encoding="UTF-8" ?>'
		+ '<jco ID="12f519e50a4b32ff9c3ccab466c97911" name="ZHR_PERSONNEL_INFO" timestamp="1318839721586" version="3.0">'
		+ '<import >'
		+ '		<field isoptional="1" name="ENDDA">0000-00-00</field>'
		+'<structure name="IP_PERSON_INFO">'
			+'<field name="BEGDA">0000-00-00</field>'
			+'<field name="ENDDA">0000-00-00</field>'
			+'<field name="PERNR">00000000</field>'
			+'</structure>'
		+ '</import>' + '<export>'
		+ '		<field isoptional="1" name="ENDDA">0000-00-00</field></export>'
		+ '<tables>' + '<table name="TB_PERSON_ADDR" isin="1">'
		+ '	<records row="1">' + '		<field name="BEGDA">0000-00-00</field>'
		+ '		<field isoptional="1" name="ENDDA">0000-00-00</field>'
		+ '		<field name="PERNR">00000000</field>'
		+ '		<field name="FAMST_T"></field>' + '	</records>' + '</table>'
		+ '<table name="TB_PERSON_ADDR" isin="0">' + '	<records row="1">'
		+ '		<field name="BEGDA">0000-00-00</field>'
		+ '		<field isoptional="1" name="ENDDA">0000-00-00</field>'
		+ '		<field name="PERNR">00000000</field>'
		+ '		<field name="FAMST_T"></field>' + '	</records>' + '</table>'
		+ '</tables>' + '</jco>';

var data_xmlDom = null;

var multiple_table = 0;

$.extend({
	cover : {
		show : function() {
			$.cover.hide();
			var str = "<div id='cover' style='position:absolute;background-color: #666;"
			str += "width:" + $(document).width() + "px;";
			str += "height:" + $(document).height() + "px;";
			str += "opacity:0.5;filter:alpha(opacity=50);";
			str += "top:0;left:0;z-index=10'> <div style='position:relative; width:100%;*position:absolute; *top:15%; *left:50%;'>";
			str += "<img src="+Com_Parameter.ContextPath+"resource/style/common/images/loading.gif"+"></img></div> </div>";
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
		this.text = currNode.firstChild!=null ? currNode.firstChild.nodeValue:""; //currNode.text;
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
	

	// prototying the XMLDocument 
	XMLDocument.prototype.selectSingleNode = function(cXPathString, xNode) {
		if( !xNode ) { 
		   xNode = this; 
		} 
		
		var xItems = this.selectNodes(cXPathString, xNode); 
	   if( xItems.length > 0 ) { 
		  return xItems[0]; 
	   } else { 
	    return null; 
	   } 
	} 
	
	// prototying the Element 
	Element.prototype.selectSingleNode = function(cXPathString) { 
	   if(this.ownerDocument.selectSingleNode) { 
	      return this.ownerDocument.selectSingleNode(cXPathString, this); 
	   } else{
	      throw "For XML Elements Only";} 
	   } 
}


// 获取节点列表
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




$(document).ready(function() {
			getXml();

		});

// 得到函数对应xml格式数据信息
function getXml() {
	
	$.cover.show();
	if ($("#xml_data").val()) {
		resetTableBydata($("#xml_data").val());
	} else {
		var fdRfcSettingId = $("#fdRfcSettingId").val();
		if (fdRfcSettingId == null || fdRfcSettingId == "")
			return;
		var data = new KMSSData();
		data.SendToBean(
				"tibSapMappingFuncXmlService&fdRfcSettingId=" + fdRfcSettingId,
				resetTable);
	}
	// resetTable(data);

}

// 使用xml信息重设参数表
function resetTable(rtnData) {
	
	// 正式=======================
	if (rtnData.GetHashMapArray().length == 0)
		return;
	var fdRfcXml = rtnData.GetHashMapArray()[0]["funcXml"];
	var msg=rtnData.GetHashMapArray()[1]["MSG"];
	if(!fdRfcXml) {
	setTimeout(function() {
				$.cover.hide();
			}, 500);
			return ;
	}
	if(msg!="SUCCESS"){
		alert(msg);
		setTimeout(function() {
				$.cover.hide();
			}, 500);
			return ;
	}
	
	data_xmlDom = XML_CreateByContent(fdRfcXml);
	//========================
	// alert(fdRfcXml);
	// 测试======
//	 data_xmlDom = XML_CreateByContent(data);
	// 写xml================================
	// alert(fdRfcXml);
	var bapiName = XML_GetAttribute(data_xmlDom.getElementsByTagName("jco")[0],
			"name", "");
	buildImport("/jco/import", "IMPORT_TABLE");
	// buildExport("/jco/export","EXPORT_TABLE");
	buildTables("/jco/tables", "query_Table_append");
	// ==================================
	document.getElementById("bapiName").innerHTML = bapiName;
	DocListFunc_Init();
	setTimeout(function() {
				$.cover.hide();
			}, 500);
}

// 使用xml信息重设参数表
function resetTableBydata(data) {
	var fdRfcXml = data;// rtnData.GetHashMapArray()[0]["funcXml"];
	// alert(fdRfcXml);
	// $("#debug").text(fdRfcXml);
	data_xmlDom = XML_CreateByContent(fdRfcXml);
	//
	// alert(fdRfcXml);
	// 测试======
	// data_xmlDom = XML_CreateByContent(data);
	// 写xml================================
	// alert(fdRfcXml);
	var bapiName = XML_GetAttribute(data_xmlDom.getElementsByTagName("jco")[0],
			"name", "");
	buildImport("/jco/import", "IMPORT_TABLE");
	// buildExport("/jco/export","EXPORT_TABLE");
	buildTables("/jco/tables", "query_Table_append");
	// ==================================
	document.getElementById("bapiName").innerHTML = bapiName;
	setTimeout(function() {
				$.cover.hide();
			}, 500);
}

var multiple_table = '<table id="TABLE_DocList_Copy" class="tb_normal" width="1024">'
		// + '<tr class="td_normal_title"><td></td></tr>'
		+ '<tr class="td_normal_title">'
		+ '<td>'+ RfcSearchInfo_lang.serialNumber +'</td>'
		+ '</tr>'
		+ '<!--基准行-->'
		+ '<tr KMSS_IsReferRow="1" style="display:none">'
		+ '<td KMSS_IsRowIndex="1"></td>' + '</tr> ' + '</table>'

// simple
//var table_copy = '<table id="TABLE_COPY" class="tb_normal" width="80%"  style="display:none">'
//		+ '<tr class="td_normal_title" >'
//		+ '<td rowspan="1000" align="center">表参数</td>'
//		+ '<td colspan="7"></td>'
//		+ '</tr>'
//		+ '<tr class="td_normal_title"  style="">'
//		+ '<td width="10%">参数类aa型</td>'
//		+ '<td width="10%">字fdsaf段名称</td>'
//		+ '<td width="10%">字段说明</td>'
//		+ '<td width="10%">字段值</td>'
//		+ '</tr>'
//		+ '</table>'

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

	for (var i = 0; i < tableList.length; i++) {
		// 获取xml数据
		var xmlTable = new XmlTable();
		xmlTable.initData(tableList[i]);
		var xpath_table = xpath + "/table[" + i + "]";
		// 创建行，判断传出表格，包括（传入并且传出0;1）类型的
		if (xmlTable.isin.indexOf('1') != -1) {

			var table_title = queryTable.insertRow(-1);
			table_title.className = "td_normal_title";
			var table_title_cell = table_title.insertCell(-1);

			var multiple_row = queryTable.insertRow(-1);
			var multiple_cell = multiple_row.insertCell(-1);
			// 写入数据
			multiple_cell.innerHTML = multiple_table;

			$("#TABLE_DocList_Copy").attr("xpath", xpath_table);
			$("#TABLE_DocList_Copy").attr("id", "TABLE_DocList" + T_index);
			var tabel_doc = document.getElementById("TABLE_DocList" + T_index);
			// tabel_doc.rows[0].cells[0].innerHTML = xmlTable.name;
			table_title_cell.innerHTML = xmlTable.name;
			for (var record_index = 0; record_index < xmlTable.recordsList.length
					&& record_index < 1; record_index++) {
				var recordObject = new Records();
				recordObject.initData(xmlTable.recordsList[record_index]);
				var xpath_table_record = xpath_table + "/records[!{index}]";
				// 标题行
				var title_row = tabel_doc.rows[0];
				// 基准行
				var standard_row = tabel_doc.rows[1];
				standard_row.id = xpath_table_record;
				// 设置title长度
				table_title_cell.colSpan = recordObject.fieldNodes.length + 2;
				// 只取第一行获取title
				for (var record_field = 0; record_field < recordObject.fieldNodes.length; record_field++) {
					var xpath_field = xpath_table_record + "/field["
							+ record_field + "]";
					var field_node = new XmlField();
					field_node.initData(recordObject.fieldNodes[record_field]);
					var titlecell = title_row.insertCell(-1);
						if (field_node.isoptional == true) {
						titlecell.innerHTML += '<span style="color:red">*</span>'
					};
					titlecell.innerHTML += field_node.name;
					titlecell.innerHTML +="("+field_node.title+")";
					standard_row.insertCell(-1).innerHTML = '<input class="inputsgl" name="\''
							+ xpath_field
							+ '\'" value="'
							+ field_node.text
							+ '" type="text" xpath="\'' + xpath_field + '\'" >';
				}
				standard_row.insertCell(-1).innerHTML = '<img src="'
						+ Com_Parameter.StylePath
						+ 'icons/delete.gif" alt="del" onclick="DocList_DeleteRow();" style="cursor: hand">';
				title_row.insertCell(-1).innerHTML = '<img src="'
						+ Com_Parameter.StylePath
						+ 'icons/add.gif" alt="add" onclick="DocList_AddRow();" style="cursor: hand">';
			}
			// 填写内容行
			for (var content_index = 0; content_index < xmlTable.recordsList.length; content_index++) {
				var record_content = new Records();
				record_content.initData(xmlTable.recordsList[content_index]);
				var content_row = tabel_doc.insertRow(-1);
				$(content_row).attr("KMSS_IsContentRow", "1");
				content_row.insertCell(-1).innerHTML = content_index + 1;
				var xpath_table_record_content = xpath_table + "/records["
						+ content_index + "]";
//						alert(xpath_table_record_content+"-content");
				for (var content_field = 0; content_field < record_content.fieldNodes.length; content_field++) {
					var xpath_content_field = xpath_table_record_content
							+ "/field[" + content_field + "]";
//							alert(xpath_content_field+"-field");
					var field_node_content = new XmlField();
					field_node_content
							.initData(record_content.fieldNodes[content_field]);
					content_row.insertCell(-1).innerHTML = '<input class="inputsgl" name="\''
							+ xpath_content_field
							+ '\'" value="'
							+ field_node_content.text
							+ '" type="text" xpath="\''
							+ xpath_content_field
							+ '\'" >';
				}
				content_row.insertCell(-1).innerHTML = '<img src="'
						+ Com_Parameter.StylePath
						+ 'icons/delete.gif" alt="del" onclick="DocList_DeleteRow();" style="cursor: hand">';
			}
			T_index++;
		}
	}

	for (var multiple = 0; multiple < T_index; multiple++) {
		DocList_Info[multiple] = "TABLE_DocList" + multiple;// 改写DocList_Info数组，使用4个动态表格
	}
	
	multiple_table = T_index;
}

/**
 * 组装页面上填写的东西,汇总成xml
 */
function collectResutlXml() {
	collect_import('IMPORT_TABLE');
	collect_table('TABLE_DocList');

   //为了兼容各种浏览器，需转换成string 
	$("#xml_data").attr("value", XML2String(data_xmlDom));//$("#xml_data").attr("value", data_xmlDom.xml);
	// $("form[name=rfcSearchInfoForm]").submit();
	Com_Submit(document.tibSysSapRfcSearchInfoForm, 'getXmlResult');
}

function checkNull(elemId,elem_divId){
    var docElem =document.getElementsByName("docSubject")[0];
	var docDiv=document.getElementById("docSubject_div");
	docDiv.style.display="none";
	if(docElem && docDiv){
	   // 检查空值
	   if(!docElem.value) { 
	      docDiv.style.display="block";
	      docDiv.innerHTML = RfcSearchInfo_lang.queryTitleNotEmpty;
	      return false;
	   }
	}
	return true;
}

function formSave() {
	collect_import('IMPORT_TABLE');
	collect_table('TABLE_DocList');
	$("#xml_data").attr("value", XML2String(data_xmlDom));
	if(!checkNull("docSubject","docSubject_div")) {
		return false;
	}
	Com_Submit(document.tibSysSapRfcSearchInfoForm, 'saveByData');
	return true;
}

function collect_table(tableId) {
	for (var i = 0; i < multiple_table; i++) {
		var xpath = $("#TABLE_DocList" + i).attr("xpath");
		var table_doc = document.getElementById("TABLE_DocList" + i);
		tableNode = getCurrentNode(data_xmlDom, xpath.replace(/[,'"]/g,""))[0];
		if (tableNode) {
			var records = tableNode.childNodes;
			if (records.length > 0) {
				var copy_records_source = records[0].cloneNode(true);
				// 删除原来records
				for (; records.length > 0;) {
					tableNode.removeChild(tableNode.firstChild);
				}
				// 获取动态表格数据 忽略第一行的数据
				for (var t_num = 1; t_num < table_doc.rows.length; t_num++) {
					var row = table_doc.rows[t_num];
					var copy_records = copy_records_source.cloneNode(true);
					copy_records.setAttribute("row", t_num - 1);

					for (var c_num = 1, xml_num = 0; c_num < row.cells.length
							- 1; c_num++, xml_num++) {
						var input = row.cells[c_num]
								.getElementsByTagName("input")[0];
						copy_records.childNodes[xml_num].text = $(input).val();
					}
					tableNode.appendChild(copy_records);
				}
				// 修改rows
				tableNode.setAttribute("rows",table_doc.rows.length-1);

			}
		}

	}

}

function collect_import(tableID) {
	var inputList = $("#IMPORT_TABLE input.inputsgl");
	inputList.each(function(index, item) {
		var xpath = $(item).attr("xpath");
		var attr = $(item).attr("attrName");
		var value = $(item).val();
		//XML_GetSingleNode(data_xmlDom, xpath.replace(/[,'"]/g, "")).text = value;

		var currentNodes = getCurrentNode(data_xmlDom, xpath.replace(/[,'"]/g, ""));
		if(currentNodes != null && currentNodes.length>0 ){
		    var oldTextNode = currentNodes[0].firstChild;
		    if (oldTextNode != undefined && oldTextNode.nodeType == "3") {
		    	currentNodes[0].removeChild(oldTextNode);
		    }
		    var textNode= currentNodes[0].ownerDocument.createTextNode(value);
		    currentNodes[0].appendChild(textNode);
	    }
	});

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

/**
 * 构建入表格
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
	for (var index = 0, i = tableObject.rows.length; index < fields.length; index++, i++) {
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
         
		var fieldValue =  fieldObject.text;

		if(typeof(fieldValue)=='undefined'){
			fieldValue="";
		}
		if (type == 1) {

			tableRow.insertCell(-1).innerHTML = '<input type="text" xpath="'
					+ tableRow.id
					+ '" attrName="ekptxt" class="inputsgl" value="'
					+ fieldValue + '"/>';
		} else if (type == 2) {

			tableRow.insertCell(-1).innerHTML = '<input type="text" xpath="'
					+ tableRow.id
					+ '" attrName="ekptxt" readOnly class="inputread" value="'
					+ fieldValue + '"/>';
		}
	}
}

function buildStruct(tableObject, structNodes, handlerNumber, type, xpath) {
	var i = handlerNumber;

	if (structNodes) {
		for (var index = 0, i = handlerNumber; index < structNodes.length; index++, i++) {
			var j = 0;
			var currNode = structNodes[index];
			var tableRow = tableObject.insertRow(-1);
			tableRow.id = xpath + "/structure[" + index + "]";
			var structNode = new XmlStructure();
			structNode.initData(currNode);
			var f = tableRow.insertCell(-1);
			f.innerHTML = RfcSearchInfo_lang.formation + structNode.name;
			var fieldList = structNode.fieldNodes;
			f.rowSpan = fieldList.length+1;
			cellAdd(tableRow.id, tableObject, fieldList, type, '');
		}
	}
}

function Custom_selectNodes(xmlDoc, elementPath) {
    if(!!window.ActiveXObject || "ActiveXObject" in window) {
    	xmlDoc.setProperty("SelectionLanguage","XPath");
        return xmlDoc.selectNodes(elementPath);
    } else {
        var xpe = new XPathEvaluator();
        var nsResolver = xpe.createNSResolver( xmlDoc.ownerDocument == null ? xmlDoc.documentElement : xmlDoc.ownerDocument.documentElement);
        var result = xpe.evaluate(elementPath, xmlDoc, nsResolver, 0, null);
        var found = [];
        var res;
        while (res = result.iterateNext())
             found.push(res);
        return found;
     }
}

function getCurrentNode(xmlData,xpath){
	var reg = /\[(\d+)\]/g;;
	var _xpath =reg.exec(xpath);
	if (_xpath != null) {
//		var num = new Number(_xpath[1]);
		xpath = xpath.replace(reg,function($0, $1, $2){
			return "["+ (++$1) +"]";
		});
	}
	var currentNodes= Custom_selectNodes(xmlData,xpath);
	return currentNodes;
}
