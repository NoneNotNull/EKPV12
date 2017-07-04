
/**
 * 基础js模块
 * base on :doclist.js
 */
function EkpCommonFormEvent() {

	this.verion = "1.0";
	this.modelName = "ekpcommon";
	this.info = "ERP基础表单事件模块对象";
//	遮罩全局控制
	this.blockFlag=true;
	
	
}

//对表单对应field 进行赋值
EkpCommonFormEvent.prototype.setFieldCellValue = function(field, index, field0) {
	var ekpid = this.getString(XML_GetAttribute(field0, "ekpid"));// 去除映射表单变量的$符号，只取第0行的定义
	if (ekpid == "")
		return;// undefined和""两种情况都转为此情况处理
	var fields = ekpid.split('.');
	if (fields.length == 1) {
		// 修正非明细表赋值策略（多值半角分号隔开） 2013-5-9
		var ekpValue = GetXFormFieldValueById(fields[0])[0];
		ekpValue = ekpValue == "" ? $(field).text() : ekpValue +";"+ $(field).text();
		SetXFormFieldValueById(fields[0], ekpValue);
	} else {
		document.getElementsByName('extendDataFormInfo.value(' + fields[0]
				+ '.' + index + '.' + fields[1] + ')')[0].value = $(field).text(); // 使用自己写的方法给明细表字段赋值
	}
};

//对表单对应field 进行赋值
EkpCommonFormEvent.prototype.setFormCellValue = function(text, index, ekpid) {
	if (ekpid == "")
		return;// undefined和""两种情况都转为此情况处理
	var fields = ekpid.split('.');
	if (fields.length == 1) {
		// 修正非明细表赋值策略（多值半角分号隔开） 2013-5-9
		var ekpValue = GetXFormFieldValueById(fields[0])[0];
		ekpValue = ekpValue == "" ? text : ekpValue +";"+ text;
		SetXFormFieldValueById(fields[0], ekpValue);
	} else {
		document.getElementsByName('extendDataFormInfo.value(' + fields[0]
			+ '.' + index + '.' + fields[1] + ')')[0].value = text; // 使用自己写的方法给明细表字段赋值
	}
};

//根据表格ID 删除全部行
EkpCommonFormEvent.prototype.deleteMxAllRows = function (mxId) {
	var table = document.getElementById(mxId);
	var rowLenth = table.rows.length;
	var tbInfo = DocList_TableInfo[mxId];
	for (var i = rowLenth - 2; i > 0; i--) {
		table.deleteRow(i);
		tbInfo.lastIndex--;
		for (var j = i; j < tbInfo.lastIndex; j++)
			DocListFunc_RefreshIndex(tbInfo, j);
	}
}

//根据表格ID 删除对应表格的条目
EkpCommonFormEvent.prototype.deleteMxRows=function (mxId) {
	var table = document.getElementById(mxId);
	var rowLenth = table.rows.length;
	var tbInfo = DocList_TableInfo[mxId];
	for (var i = rowLenth - 2; i > 0; i--) {
		// 判断是否空行
		if (this.isEmptyRow(table, i)) {
			table.deleteRow(i);
			tbInfo.lastIndex--;
			for (var j = i; j < tbInfo.lastIndex; j++)
				DocListFunc_RefreshIndex(tbInfo, j);
		}	
	}
}

/**
 * 检查是否为空行
 * @param tableObj
 * @param rowIndex
 * @return
 */
EkpCommonFormEvent.prototype.isEmptyRow = function(tableObj, rowIndex){
	// 检查是否为空
	// 找到最后一行判断数据是否为空
	var row=tableObj.rows[rowIndex];
	var flag=true;
	// 针对input值
	$(row).find("input").each(function(index,elem){
		//alert("$(elem).val()="+$(elem).val()+"-elem.type="+elem.type+"--tagname="+elem.tagName);
		// 如果有非空值,标记不能删除
		if($(elem).val() != "" && elem.type != "hidden" && elem.type != "button"){
			flag=flag && false;						
		}
	});
	// add  select
	$(row).find("select").each(function(index,elem){
		// 如果有非空值,标记不能删除
		var val=$(elem).find("option:selected").val();
		if(val != ""){
			flag=flag && false;						
		}
	});
	//add textarea
	$(row).find("textarea").each(function(index,elem){
		// 如果有非空值,标记不能删除
		var val=$(elem).text();
		if(val != "" && elem.style.display != "none;"){
			flag=flag && false;						
		}
	});
	return flag;
}

// 因为在明细表的字段映射中可能存在非明细表字段，需要此方法找到明细表的id，另外如果是只有一行数据的采用structure的方式
// 截取其中一个field的ekpid中格式为$a.b$中的a部分，基于如果是配置明细表的，那么明细表的id是一致的，不能跨明细表
EkpCommonFormEvent.prototype.getMxId= function (record) {
	var fields = $(record).children();
	for (var i = 0; i < fields.length; i++) {
		var field = fields[i];
		var ekpid = this.getString(XML_GetAttribute(field, "ekpid"));
		var index = ekpid.indexOf('.');
		if (index > -1) {
			return "TABLE_DL_" + ekpid.substring(0, index);// 返回明细表id
		}
	}
}

EkpCommonFormEvent.prototype.getString= function(s) {
	if (s == undefined)
		return "";
	return s.replace(/\$/g, "");
	//return s.substring(s.indexOf('$') + 1, s.lastIndexOf('$'));
}

/**
 * 显示遮罩
 */
EkpCommonFormEvent.prototype.blockShow=function(){
	if(!this.blockFlag){
 	  return ;
 	}
 	
 	var load= Com_Parameter.ContextPath+"resource/style/red/icons/loading.gif";
 	
//可能没有jquery,或者blockui
		try{
		   $.blockUI({ css: { 
            border: 'none', 
            padding: '15px', 
            backgroundColor: '#000', 
            '-webkit-border-radius': '10px', 
            '-moz-border-radius': '10px', 
            opacity: .5, 
            color: '#fff'
        },
         message:"<h3>正在努力加载数据</h3><img src="+load+"></img>"
        }); 
		}catch(e){
		}
}

/**
 * 关闭遮罩
 */
EkpCommonFormEvent.prototype.blockhide=function(){
	if(!this.blockFlag){
 	  return ;
 	}
	//可能没有jquery,或者blockui
	try{
		$.unblockUI();
	}catch(e){
	}
}

/**
 * 初始化遮罩
 * @return {Boolean}
 */
EkpCommonFormEvent.prototype.blockInit=function(){
	
 	if(!this.blockFlag){
 	  return false;
 	}
	if(jQuery){
		if(!$.blockUI){
		var path="tib/common/resource/js/jquery.blockUI.js";
		jQuery.ajax({
				type : "GET",
				url : Com_Parameter.ContextPath + path,// "third/erp/ekp/resource/erp_ekp_lang.jsp",
				dataType : "script",
				// 设置同步,待加载完成以后才往下执行
				async : false
			});
			return true;
		}
		return true;
	}
	return false;

}


EkpCommonFormEvent.prototype.getFieldValue = function (fields) {
	var fieldValue = {};
	var flag = false;// 用于标记是否得到表格长度标记
	for (var i = 0; i < fields.length; i++) {
		var fieldNode = fields[i];
		var ekpid = this.getString(XML_GetAttribute(fieldNode, "ekpid"));// 去除映射表单变量的$符号
		if (ekpid == "")
			continue;
		var index = ekpid.indexOf('.');
		if (index > -1) {
			var fieldObjects = GetXFormFieldById(ekpid.substring(index + 1,
							ekpid.length), true);// 如果是明细表类型的，得到的是同一列的对象
			var values = new Array(fieldObjects.length);
			var ekpLen = 0;
			for (var j = 0; j < fieldObjects.length; j++) {
				if (fieldObjects[j].type == "radio" || fieldObjects[j].type == "checkbox") {
					if (fieldObjects[j].checked) {
						values[ekpLen] = fieldObjects[j].value;
						ekpLen ++;
					} 
				} else {
					values[ekpLen] = fieldObjects[j].value;
					ekpLen ++;
				}
			}
			if (flag == false) {
				fieldValue["importRecodsLength"] = fieldObjects.length;// 保存行数
				flag = true;
			}
			fieldValue[XML_GetAttribute(fieldNode, "name")] = values;
		} else {
			if (flag == false) {
				fieldValue["importRecodsLength"] = 1;// 保存行数
				flag = true;
			}
			// 此列都等于非明细表的字段值
			var ekpValueObjs = GetXFormFieldById(ekpid, true);
			var ekpLen = ekpValueObjs.length;
			// 处理单选或多选情况
			if (ekpLen > 1) {
				for (var j = 0; j < ekpLen; j++) {
					if (ekpValueObjs[j].checked) {
						fieldValue[XML_GetAttribute(fieldNode, "name")] = ekpValueObjs[j].value;
					}
				}
			} else {
				fieldValue[XML_GetAttribute(fieldNode, "name")] = ekpValueObjs[0].value;
			}
			//fieldValue[XML_GetAttribute(fieldNode, "name")] = GetXFormFieldValueById(ekpid, true)[0];
		}
	}
	return fieldValue;
}

/**
* XML对象转字符串 
* @param xmlObject
* @returns
*/
EkpCommonFormEvent.prototype.XML2String = function(xmlObject) {
	// for IE，兼容ie11
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
		return xmlObject.xml;
	} else {
		// for other browsers
		return (new XMLSerializer()).serializeToString(xmlObject);
	}
} 
