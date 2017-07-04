
// 初始化加载
;
(function() {
	ims_cfg_matchCheckBox('sys_ims_config');
})();
/**
 * 正则校验值允许英文 校验默认值
 * 
 * @param {}
 *            matchTable
 */
// function matchCheckBox(matchTable){
// //匹配分号隔开整个字符
// var regStr="\\b!{replace}(;)?\\b";
// //configGroup="1" sys_ims_config
// var configName="value(kmss.ims.config)";
// var configElem=document.getElementsByName(configName)[0];
// var tarTable= document.getElementById(matchTable);
// if(tarTable&&configElem.value){
// var inputElem=tarTable.getElementsByTagName("INPUT");
// var str=configElem.value;
// for(var i=0,len=inputElem.length;i<len;i++){
// var attr=inputElem[i].getAttribute("imsconfig");
// if(attr&&attr=='1'){
// var imsName=inputElem[i].value;
// var regChar=regStr.replace("!{replace}",imsName);
// var reg = new RegExp(regChar,'g');
// var bool=reg.test(str);
// if(bool){
// inputElem[i].checked='checked';
// }
// }
// }
// }
// }
/**
 * 校验默认值
 * 
 * @param {}
 *            matchTable
 */
function ims_cfg_matchCheckBox(matchTable) {
	// 匹配分号隔开整个字符
	var configName = "value(kmss.ims.config)";
	var configElem = document.getElementsByName(configName)[0];
	var tarTable = document.getElementById(matchTable);
	if (tarTable && configElem.value) {
		var inputElem = tarTable.getElementsByTagName("INPUT");
		var str = configElem.value;
		var cfgArry = str.split(";");
		if(cfgArry.length==0&&!str){
		cfgArry.push(str);
		}
		
		for (var i = 0, len = inputElem.length; i < len; i++) {
			var attr = inputElem[i].getAttribute("imsconfig");
			if (attr && attr == '1') {
				var imsName = inputElem[i].value;
				// var regChar=regStr.replace("!{replace}",imsName);
				// var reg = new RegExp(regChar,'g');
				var bool = ims_checkInArray(cfgArry, imsName); // reg.test(str);
				if (bool) {
					inputElem[i].checked = 'checked';
				}
			}
		}
	}
}

function ims_checkInArray(array, name) {
	if (!array || !name)
		return false;
	for (var i = 0, len = array.length; i < len; i++) {
		if (array[i] == name) {
			return true;
		}
	}
	return false;

}

function ims_removeInArray(array, name) {
	var n_array = [];
	if (!array || !name)
		return n_array;
	for (var i = 0, len = array.length; i < len; i++) {
		if (array[i] == name) {
		}
		else{
		n_array.push(array[i]);
		}
	}
	return n_array;

}

/**
 * 正则是否启动,变更配置文件 配置文件格式 imsName; ';'隔开
 * 
 * @param {}
 *            curItem
 */
// function imsConfig(curItem){
// var regStr="\\b!{replace}(;)?\\b";
// var configName="value(kmss.ims.config)";
// var configElem=document.getElementsByName(configName)[0];
// if(curItem.name!=configName){
// var str=configElem.value;
// var curVal=curItem.value;
// var regChar=regStr.replace("!{replace}",curVal);
// var reg = new RegExp(regChar,'g');
// if(curItem.checked){
// str=str.replace(reg,'');
// if(str)
// str+=";"+curVal;
// else str=curVal;
// }
// else{
// str=str.replace(reg,'');
// }
// configElem.value=str;
// }
// }
function ims_imsConfig(curItem) {
	// var regStr="\\b!{replace}(;)?\\b";
	var configName = "value(kmss.ims.config)";
	var configElem = document.getElementsByName(configName)[0];
	if (curItem.name != configName) {
		var str = configElem.value;
		var curVal = curItem.value;
		var cfgArry = str.split(";");
		if(cfgArry.length==0&&!str){
		cfgArry.push(str);
		}
		// var regChar=regStr.replace("!{replace}",curVal);
		// var reg = new RegExp(regChar,'g');
		var bool = ims_checkInArray(cfgArry, curVal);
		if (curItem.checked) {
			if (!bool) {
				str += curVal + ";";
			}
		} else {
			if (bool) {
               var n_array=ims_removeInArray(cfgArry,curVal);
               str=n_array.join(";");
			}
		}
		configElem.value = str;
	}
}

/**
 * 表格隐藏开关
 * 
 * @param {}
 *            elemId 目标表格
 * @param {}
 *            toggle 开关控制对象 {checked:true or false}
 */
function ims_tableToggle(elemId, toggle) {
	var table = document.getElementById(elemId);
	if (toggle.checked) {
		ims_showTable(1, table);
	} else {
		ims_hideTable(1, table);
	}
}

/**
 * 隐藏表格
 * 
 * @param {}
 *            index 起始隐藏行
 * @param {}
 *            tarTable 目标table
 */
function ims_hideTable(index, tarTable) {
	for (var i = index, len = tarTable.rows.length; i < len; i++) {
		var row = tarTable.rows[i];
		row.style.display = "none";
	}
}
/**
 * 显示表格
 * 
 * @param {}
 *            index 起始隐藏行
 * @param {}
 *            tarTable 目标table
 */
function ims_showTable(index, tarTable) {
	for (var i = index, len = tarTable.rows.length; i < len; i++) {
		var row = tarTable.rows[i];
		row.style.display = "";
	}
}
