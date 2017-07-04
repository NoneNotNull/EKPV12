/*压缩类型：标准*/
/***********************************************
JS文件说明：
该文件提供了常用的动态列表的通用方法。
使用说明：
	1、请在页面中定义一个ID为"TABLE_DocList"的表格，该表格即为动态列表的表格，若不希望使用TABLE_DocList作为表格ID，请改写DocList_Info的值（ID数组）
	2、在该表格的定义一个基准行，当新增行的时候，程序会自动复制基准行的HTML代码进行创建新行。标签属性说明：
		TR标签：
			KMSS_IsReferRow="1"：必须，表示该行为基准行
		TD标签：
			KMSS_IsRowIndex="1"：可选，表示该列用于显示序号
		域name属性的替换符：
			!{index}：行索引号
	3、若表格中本来就有内容，内容的行必须紧跟在基准行的后面，内容行的TR标签必须定义KMSS_IsContentRow="1"属性。
	4、当表格中需要出现选择框的时候，可以采用DocList_GetPreField函数获取到临近的域对象。
HTML样例：
<table id="TABLE_DocList" class="tb_normal" width="90%">
	<tr>
		<td>序号</td>
		<td>文本内容</td>
		<td>输入框</td>
		<td>
			<a href="#" onclick="DocList_AddRow();">添加</a>
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1"></td>
		<td>文本内容</td>
		<td><input name="field[0][!{index}]" value="!{index}"></td>
		<td>
			<a href="#" onclick="DocList_DeleteRow();">删除</a>
			<a href="#" onclick="DocList_MoveRow(-1);">上移</a>
			<a href="#" onclick="DocList_MoveRow(1);">下移</a>
		</td>
	</tr>
	<!--内容行-->
	<tr KMSS_IsContentRow="1">
		<td>1</td>
		<td>文本内容</td>
		<td><input name="field[0][0]" value="0"></td>
		<td>
			<a href="#" onclick="DocList_DeleteRow();">删除</a>
			<a href="#" onclick="DocList_MoveRow(-1);">上移</a>
			<a href="#" onclick="DocList_MoveRow(1);">下移</a>
		</td>
	</tr>
	<tr>
		<td colspan="4">这是其他行的内容</td>
	</tr>
</table>

作者：叶中奇
版本：1.0 2006-4-3
***********************************************/

Com_RegisterFile("doclist.js");

var DocList_Info = new Array("TABLE_DocList");		//全局变量，ID列表
var DocList_TableInfo = new Array;

/***********************************************
功能：获取界面中某个对象中指定对象的字段的和
参数：
	obj：
		必选，对象
	fieldRe：
		必选，域名称或域的正则表达式
***********************************************/
function DocList_GetSum(obj, fieldRe){
	var isReg = typeof(fieldRe)!="string";
	var fields = obj.getElementsByTagName("INPUT");
	var sum = 0;
	for(var i=0; i<fields.length; i++){
		if(isReg){
			if(!fieldRe.test(fields[i].name))
				continue;
		}else{
			if(fields[i].name!=fieldRe)
				continue;
		}
		var value = parseFloat(fields[i].value);
		if(!isNaN(value))
			sum += value;
	}
	return sum;
}

/***********************************************
功能：添加行
参数：
	optTB：
		可选，表格ID或表格对象，默认取当前操作的表格
	content：
		可选，HTML代码数组，往每个单元格塞的内容，默认从基准行中取数据
			若希望只提供几个单元格的数据时，只需要将其他单元格对应数组元素设置为null
	fieldValues：
		可选，对象，格式为fieldValues[fieldName]=fieldValue，fieldName可带索引号
***********************************************/
function DocList_AddRow(optTB, content, fieldValues){
	if(optTB==null)
		optTB = DocListFunc_GetParentByTagName("TABLE");
	else if(typeof(optTB)=="string")
		optTB = document.getElementById(optTB);
	if(content==null)
		content = new Array;

	var tbInfo = DocList_TableInfo[optTB.id];
	var index = tbInfo.lastIndex - tbInfo.firstIndex;
	var htmlCode, newCell;
	var newRow = optTB.insertRow(tbInfo.lastIndex);
	tbInfo.lastIndex++;
	newRow.className = tbInfo.className;
	for(var i=0; i<tbInfo.cells.length; i++){
		newCell = newRow.insertCell(-1);
		newCell.className = tbInfo.cells[i].className;
		newCell.align = tbInfo.cells[i].align ? tbInfo.cells[i].align : '';
		newCell.vAlign = tbInfo.cells[i].vAlign ? tbInfo.cells[i].vAlign : '';
		if(tbInfo.cells[i].isIndex){
			htmlCode = DocListFunc_ReplaceIndex(content[i]==null?tbInfo.cells[i].innerHTML:content[i], index + 1);
			htmlCode =  htmlCode.replace("{1}", index + 1);//自定义表单中明细表处理
		}else
			htmlCode = DocListFunc_ReplaceIndex(content[i]==null?(formatHtml(tbInfo.cells[i])):content[i], index);
		newCell.innerHTML = htmlCode;
	}
	//DocList_ResetFieldWidth(newRow);重置宽度，会导致百分比失效，因此去掉。---modify by miaogr
	if(fieldValues!=null){
		for(var name in fieldValues){
			var value = fieldValues[name];
			name = DocListFunc_ReplaceIndex(name, index);
			var fields = document.getElementsByName(name);
			fieldLoop:
			for(var i=0; i<fields.length; i++){
				for(var pObj=fields[i].parentNode; pObj!=null; pObj=pObj.parentNode){
					if(pObj==newRow)
						break;
				}
				if(pObj!=null){
					switch(fields[i].tagName){
						case "INPUT":
							if(fields[i].type=="radio"){
								if(fields[i].value==value){
									fields[i].checked = true;
									break fieldLoop;
								}
								break;
							}
							if(fields[i].type=="checkbox"){
								fields[i].checked = (fields[i].value==value);
								break;
							}
						case "TEXTAREA":
							fields[i].value = value;
							break;
						case "SELECT":
							for(var j=0; j<fields[i].options.length; j++){
								if(fields[i].options[j].value==value)
									fields[i].options[j].selected = true;
							}
							break;
					}
				}
			}
		}
	}
	
	DocList_RemoveDeleteAllFlag(optTB);
	//增加表格操作事件 作者 曹映辉 #日期 2014年6月19日
	$(optTB).trigger($.Event("table-add",newRow));
	return newRow;
}

function DocList_ResetFieldWidth(obj){
	var fields = obj.getElementsByTagName("INPUT");
	for(var i=0; i<fields.length; i++){
		if(fields[i].offsetWidth>0)
			fields[i].style.width = fields[i].offsetWidth;
	}
	var fields = obj.getElementsByTagName("TEXTAREA");
	for(var i=0; i<fields.length; i++){
		if(fields[i].offsetWidth>0)
			fields[i].style.width = fields[i].offsetWidth;
	}
}

/***********************************************
功能：补充html中value等表单属性的值
参数：
	html：
		必填，页面html
***********************************************/
function formatHtml(html) {
	if(!html)
		return;
	var $html = $(html);
	$("input,button", $html).each(function() {
				this.setAttribute('value', this.value);
			});

	$("textarea", $html).each(function() {
				this.setAttribute('value', this.value);
				$(this).text(this.value);
			});
	$(":radio,:checkbox", $html).each(function() {
				if (this.checked)
					this.setAttribute('checked', 'checked');
				else
					this.removeAttribute('checked');
			});
	$("option", $html).each(function() {
				if (this.selected)
					this.setAttribute('selected', 'selected');
				else
					this.removeAttribute('selected');
			});
	var ___ = $html[0].innerHTML;
	
	$(":radio", $html).each(function() {
		this.setAttribute('data-name',this.getAttribute('name'));
		this.setAttribute('name','______'+this.getAttribute('name'));	
	});
	return ___;
}


function recoverName(cells){
	for(var i=0; i<cells.length; i++){
		$(":radio", $(cells[i])).each(function() {
			this.setAttribute('name',this.getAttribute('data-name'));
			this.removeAttribute('data-name');	
		});
	}
}

/*******************************************************************************
 * 功能：复制行 参数： optTR： 可选，操作行对象，默认取当前操作的当前行
 ******************************************************************************/
function DocList_CopyRow(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var content = new Array();
	for(var i=0; i<optTR.cells.length; i++){
		content[i] = formatHtml(optTR.cells[i]);
	}
	DocList_AddRow(optTB, content);
	var tbInfo = DocList_TableInfo[optTB.id];
	DocListFunc_RefreshIndex(tbInfo, tbInfo.lastIndex-1);
	recoverName(optTR.cells);
	//增加表格操作事件 作者 曹映辉 #日期 2014年6月19日
	$(optTB).trigger($.Event("table-copy",optTR));
}

/***********************************************
功能：删除行
参数：
	optTR：
		可选，操作行对象，默认取当前操作的当前行
***********************************************/
function DocList_DeleteRow(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	optTB.deleteRow(rowIndex);
	
	tbInfo.lastIndex--;
	for(var i = rowIndex; i<tbInfo.lastIndex; i++)
		DocListFunc_RefreshIndex(tbInfo, i);
	//增加表格操作事件 作者 曹映辉 #日期 2014年6月19日
	$(optTB).trigger($.Event("table-delete"));
}
/**
 * 增加删除到最后一行后，生成一空行的函数。
 * 解决明细表无法删除最后一函数数据问题
 * @作者：曹映辉 @日期：2012年4月28日 
 */
function DocList_DeleteRow_ClearLast(optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	optTB.deleteRow(rowIndex);
		
	tbInfo.lastIndex--;
	for(var i = rowIndex; i<tbInfo.lastIndex; i++)
		DocListFunc_RefreshIndex(tbInfo, i);
	//删除最后一行数据时生成一空行，避免导致最后一行数据无法删除
	if(tbInfo.lastIndex==1){
		DocList_AddDeleteAllFlag(optTB);
	}
}
// ====== 明细表为全部删除标识相关函数 =======
function DocList_GetDeleteAllFlagName(optTB){
	var name = null;
	var tbInfo = DocList_TableInfo[optTB.id];
	for(var i=0; i<tbInfo.cells.length; i++){
		var html = tbInfo.cells[i].innerHTML;
		if (html.indexOf("!{index}") > -1) {
			var reg = /<([b-z][^>]*)\sname\s*=\s*("[^"]+"|'[^']+'|[^\s]+)([^>]*)>/gi;
			reg.exec(html);
			var fname = RegExp.$2;
			if (fname != null && fname.length > 0) {
				name = fname.replace(/[\[\.]!\{index\}[\]\.]\S[^\)]*/ig, "__autolist__");
				break;
			}
		}
	}
	if (name != null && (name.indexOf("\"") == 0 || name.indexOf("'") == 0)) {
		name = name.substring(1, name.length - 1);
	}
	return name;
}
function DocList_AddDeleteAllFlag(optTB){
	var id = optTB.id + "__autolist__";
	var name = DocList_GetDeleteAllFlagName(optTB);
	if (name == null) {
		return;
	}
	var hidden = document.createElement("input");
	hidden.type = "hidden";
	hidden.id = id;
	hidden.name = name;
	hidden.value = "true";
	optTB.rows[0].cells[0].appendChild(hidden);
}
function DocList_RemoveDeleteAllFlag(optTB){
	var id = optTB.id + "__autolist__";
	var hidden = document.getElementById(id);
	if (hidden) {
		var parent = hidden.parentNode;
		parent.removeChild(hidden);
	}
}
/***********************************************
功能：移动行
参数：
	direct：
		必选，1：下移动，-1上移动
	optTR：
		可选，操作行对象，默认取当前操作的当前行
***********************************************/
function DocList_MoveRow(direct, optTR){
	if(optTR==null)
		optTR = DocListFunc_GetParentByTagName("TR");
	var optTB = DocListFunc_GetParentByTagName("TABLE", optTR);
	var tbInfo = DocList_TableInfo[optTB.id];
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	var tagIndex = rowIndex + direct;
	if(direct==1){
		if(tagIndex>=tbInfo.lastIndex)
			return;
		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[tagIndex], optTB.rows[rowIndex]);
	}else{
		if(tagIndex<tbInfo.firstIndex)
			return;
		optTB.rows[rowIndex].parentNode.insertBefore(optTB.rows[rowIndex], optTB.rows[tagIndex]);
	}
	DocListFunc_RefreshIndex(tbInfo, rowIndex);
	DocListFunc_RefreshIndex(tbInfo, tagIndex);
	
	//增加表格操作事件 作者 曹映辉 #日期 2014年6月19日
	$(optTB).trigger($.Event("table-move",rowIndex));
}

/***********************************************
功能：获取obj前面以fieldName命名的第一个HTML元素
参数：
	obj：
		必选，参考对象
	fieldName：
		必选，HTML元素名
	isWholeWord：
		可选，是否全字匹配，默认为false
返回：HTML元素，找不到则返回null
***********************************************/
function DocList_GetPreField(obj, fieldName, isWholeWord){
	if(obj==null)
		return null;
	if(obj.name!=null){
		if(isWholeWord){
			if(obj.name==fieldName)
				return obj;
		}else{
			if(obj.name.indexOf(fieldName)>-1)
				return obj;
		}
	}
	var tmpObj = obj.previousSibling;
	if(tmpObj!=null){
		for(;tmpObj.lastChild!=null;)
			tmpObj = tmpObj.lastChild;
		return DocList_GetPreField(tmpObj, fieldName, isWholeWord);
	}
	return DocList_GetPreField(obj.parentNode, fieldName, isWholeWord);
}
/***********************************************
功能：获取obj后面以fieldName命名的第一个HTML元素
参数：
	obj：
		必选，参考对象
	fieldName：
		必选，HTML元素名
	isWholeWord：
		可选，是否全字匹配，默认为false
返回：HTML元素，找不到则返回null
***********************************************/
function DocList_GetSufField(obj, fieldName, isWholeWord){
	if(obj==null)
		return null;
	if(obj.name!=null){
		if(isWholeWord){
			if(obj.name==fieldName)
				return obj;
		}else{
			if(obj.name.indexOf(fieldName)>-1)
				return obj;
		}
	}
	var tmpObj = obj.nextSibling;
	if(tmpObj!=null){
		for(;tmpObj.firstChild!=null;)
			tmpObj = tmpObj.firstChild;
		return DocList_GetSufField(tmpObj, fieldName, isWholeWord);
	}
	return DocList_GetSufField(obj.parentNode, fieldName, isWholeWord);
}

/***********************************************
功能：获取指定name在当前行的对象，但如果不存在，通过index修正
参数：
	obj：
		必选，参考对象
	fieldName：
		必选，HTML元素名
返回：HTML元素，找不到则返回null
***********************************************/
function DocList_GetRowField(obj, fieldName) {
	var rtn = DocList_GetRowFields(obj, fieldName);
	return rtn == null ? null : rtn[0];
}

function DocList_GetRowFields(obj, fieldName) {
	// 测试是否是明细表内容
	if (!(/\[\d+\]/g.test(fieldName)) && !(/\.\d+\./g.test(fieldName))) {
		return document.getElementsByName(fieldName);
	}
	var optTR = $(obj).closest('tr')[0];
	var fields = $(optTR).find('[name="'+fieldName+'"]');
	if (fields.length > 0) {
		var r = [];
		fields.each(function() {r.push(this);});
		return r;
	}
	var optTB = $(optTR).closest('table')[0];
	var tbInfo = DocList_TableInfo[optTB.id];
	if (tbInfo == null) {
		return document.getElementsByName(fieldName);
	}
	var rowIndex = Com_ArrayGetIndex(optTB.rows, optTR);
	// 找到正确的对象
	var fn = fieldName.replace(/\[\d+\]/g, "[!{index}]").replace(/\.\d+\./g, ".!{index}.");
	fn = fn.replace(/!\{index\}/g, rowIndex - tbInfo.firstIndex);
	fields = $(optTR).find('[name="'+fn+'"]');
	if (fields.length > 0) {
		var r = [];
		fields.each(function() {r.push(this);});
		return r;
	}
	return null;
}

//=============================以下函数为内部函数，普通模块请勿调用==============================
/***********************************************
功能：获取父级对象中的指定tagName的对象
参数：
	tagName：必选，页面对象的tagName属性
	obj：可选，默认取当前事件触发的对象
返回：找到的对象
***********************************************/
function DocListFunc_GetParentByTagName(tagName, obj){
	if(obj==null){
		if(Com_Parameter.IE)
			obj = event.srcElement;
		else
			obj = Com_GetEventObject().target;
	}
	for(; obj!=null; obj = obj.parentNode)
		if(obj.tagName == tagName)
			return obj;
}

function DocListFunc_ReplaceIndex(htmlCode, index){
	if(htmlCode==null)
		return "";
	return htmlCode.replace(/!\{index\}/g, index);
}

function DocListFunc_RefreshIndex(tbInfo, index){
	for (var n = 0; n < tbInfo.cells.length; n ++) {
		if (tbInfo.cells[n].isIndex) {
			var htmlCode = tbInfo.cells[n].innerHTML;
			htmlCode = DocListFunc_ReplaceIndex(htmlCode, index);
			htmlCode =  htmlCode.replace("{1}", index );//自定义表单明细表序号
			tbInfo.DOMElement.rows[index].cells[n].innerHTML = htmlCode;
		}
	}
	DocListFunc_RefreshFieldIndex(tbInfo, index, "INPUT");
	DocListFunc_RefreshFieldIndex(tbInfo, index, "TEXTAREA");
	DocListFunc_RefreshFieldIndex(tbInfo, index, "SELECT");
}

function DocListFunc_RefreshFieldIndex(tbInfo, index, tagName){
	var optTR = tbInfo.DOMElement.rows[index];
	var fields = optTR.getElementsByTagName(tagName);
	for(var i=0; i<fields.length; i++){
		var fieldName = fields[i].name.replace(/\[\d+\]/g, "[!{index}]");
		fieldName = fieldName.replace(/\.\d+\./g, ".!{index}.");
		var j = Com_ArrayGetIndex(tbInfo.fieldFormatNames, fieldName);
		if(j>-1){
			fieldName = tbInfo.fieldNames[j].replace(/!\{index\}/g, index-tbInfo.firstIndex);
			if(document.documentMode !=null && document.documentMode <= 7)
				fields[i].outerHTML = fields[i].outerHTML.replace("name=" + fields[i].name, "name="+fieldName);
			else
				fields[i].name = fieldName;
		}
	}
}

function DocListFunc_Init(){
	var i, j, k, tbObj, trObj, tbInfo, att, fields;
	//表格循环
	for(i=0; i<DocList_Info.length; i++){
		tbObj = document.getElementById(DocList_Info[i]);
		if(tbObj==null || DocList_TableInfo[tbObj.id] != null)//表格不存在,或者表格以初始化后不执行
			continue;
		tbInfo = new Object;
		tbInfo.DOMElement = tbObj;
		tbInfo.fieldNames = new Array;
		tbInfo.fieldFormatNames = new Array;
		tbInfo.cells = new Array;

		//表格行循环
		for(j=0; j<tbObj.rows.length; j++){
			trObj = tbObj.rows[j];
			att = trObj.getAttribute("KMSS_IsReferRow");
			if(att=="1" || att=="true"){
				tbInfo.firstIndex = j;
				tbInfo.lastIndex = j;
				tbInfo.className = trObj.className;
				for(k=0; k<trObj.cells.length; k++){
					tbInfo.cells[k] = new Object;
					tbInfo.cells[k].innerHTML = trObj.cells[k].innerHTML;
					tbInfo.cells[k].className = trObj.cells[k].className;
					tbInfo.cells[k].align = trObj.cells[k].align;
					tbInfo.cells[k].vAlign = trObj.cells[k].vAlign;
					att = trObj.cells[k].getAttribute("KMSS_IsRowIndex");
					tbInfo.cells[k].isIndex = (att=="1" || att=="true");
				}
				DocListFunc_AddReferFields(tbInfo, trObj, "INPUT");
				DocListFunc_AddReferFields(tbInfo, trObj, "TEXTAREA");
				DocListFunc_AddReferFields(tbInfo, trObj, "SELECT");
				tbObj.deleteRow(j);
				Com_SetOuterHTML(trObj, "");
				break;
			}
		}
		for(; j<tbObj.rows.length; j++){
			att = tbObj.rows[j].getAttribute("KMSS_IsContentRow");
			if(att!="1" && att!="true")
				break;
			tbInfo.lastIndex++;
			//DocList_ResetFieldWidth(tbObj.rows[j]);重置宽度，会导致百分比失效，因此去掉。---modify by miaogr
		}
		DocList_TableInfo[tbObj.id] = tbInfo;
	}
}

function DocListFunc_AddReferFields(tbInfo, trObj, tagName){
	var fields = trObj.getElementsByTagName(tagName);
	for(var i=0; i<fields.length; i++){
		if(fields[i].name==null || fields[i].name=="")
			continue;
		tbInfo.fieldNames[tbInfo.fieldNames.length] = fields[i].name;
		var formatName = fields[i].name.replace(/\[\d+\]/g, "[!{index}]");
		formatName = formatName.replace(/\.\d+\./g, ".!{index}.");
		tbInfo.fieldFormatNames[tbInfo.fieldFormatNames.length] = formatName;
	}
}

Com_AddEventListener(window, "load", DocListFunc_Init);

//=============================以上函数为内部函数，普通模块请勿调用==============================