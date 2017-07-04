/*******************************************************************************
 * pda地址本js *下为公共变量及函数,供外部调用.
 ******************************************************************************/
var ORG_TYPE_ORG = 0x1; // 机构
var ORG_TYPE_DEPT = 0x2; // 部门
var ORG_TYPE_POST = 0x4; // 岗位
var ORG_TYPE_PERSON = 0x8; // 个人
var ORG_TYPE_GROUP = 0x10; // 群组
var ORG_TYPE_ROLE = 0x20;
var ORG_TYPE_ORGORDEPT = ORG_TYPE_ORG | ORG_TYPE_DEPT; // 机构或部门
var ORG_TYPE_POSTORPERSON = ORG_TYPE_POST | ORG_TYPE_PERSON; // 岗位或个人
var ORG_TYPE_ALLORG = ORG_TYPE_ORGORDEPT | ORG_TYPE_POSTORPERSON; // 所有组织架构类型
var ORG_TYPE_ALL = ORG_TYPE_ALLORG | ORG_TYPE_GROUP; // 所有组织架构类型+群组
var ORG_FLAG_AVAILABLEYES = 0x100; // 有效标记
var ORG_FLAG_AVAILABLENO = 0x200; // 无效标记
var ORG_FLAG_AVAILABLEALL = ORG_FLAG_AVAILABLEYES | ORG_FLAG_AVAILABLENO; // 包含有效和无效标记
var ORG_FLAG_BUSINESSYES = 0x400; // 业务标记
var ORG_FLAG_BUSINESSNO = 0x800; // 非业务标记
var ORG_FLAG_BUSINESSALL = ORG_FLAG_BUSINESSYES | ORG_FLAG_BUSINESSNO; // 包含业务和非业务标记

function Pda_Address(idField, nameField, mulSelect, splitStr, selectType,
		addAction, deleteAction) {
	mulSelect = mulSelect == null ? false : mulSelect;
	splitStr = splitStr == null || splitStr == "" ? ";" : splitStr;
	selectType = selectType == null || selectType == "" ? ORG_TYPE_ALLORG
			: selectType;
	var divObj = document.getElementById("_pda_address_dialog_div");
	if (divObj == null) {
		divObj = document.createElement("div");
		document.body.insertBefore(divObj, null);
		divObj.setAttribute("id", "_pda_address_dialog_div");
		divObj.setAttribute("class", "_address_div");
		divObj.innerHTML = "<iframe width='100%' height='100%' border='0' id='addressIframe' src=''></frame>";
	}
	divObj.style.display = "block";
	var iframeObj = divObj.getElementsByTagName("iframe");
	if (iframeObj != null){
		iframeObj[0].setAttribute("src", Com_Parameter.ContextPath
				+ "sys/organization/pda/address.do?method=into&fd_orgtype=" + selectType 
				+ (Com_Parameter.IsAppFlag=="1"?"&isAppflag=1":""));
	}
	if (_Address_Current_Tmp_Obj == null)
		_Address_Current_Tmp_Obj = new Object();
	_Address_Current_Tmp_Obj['idField'] = idField;
	_Address_Current_Tmp_Obj['nameField'] = nameField;
	_Address_Current_Tmp_Obj['mulSelect'] = mulSelect;
	_Address_Current_Tmp_Obj['splitStr'] = splitStr;
	_Address_Current_Tmp_Obj['selectType'] = selectType;
	_Address_Current_Tmp_Obj['addAction'] = addAction;
	_Address_Current_Tmp_Obj['delAction'] = deleteAction;
	_Address_Current_Tmp_Obj['scrollTop'] = document.body.scrollTop;
	if (addAction != null) {
		for (var i = 0; i < _Delete_Address_dialog_Funs.length; i ++) {
			if (_Delete_Address_dialog_Funs[i] === addAction) {
				return;
			}
		}
		_Delete_Address_dialog_Funs.push(addAction);
	}
}

function Pda_init(idField, nameField, splitStr,isEdit){
	var idObj = document.getElementsByName(idField)[0];
	var nameObj = document.getElementsByName(nameField)[0];
	if(idObj==null || idObj.value=="")
		return;
	var labelName = "_" + idField + "_label";
	var disDiv = document.getElementById(labelName);
	if (disDiv == null) {
		var parentObj = nameObj.parentNode;
		disDiv = document.createElement("label");
		disDiv.setAttribute("id", labelName);
		if (parentObj != null)
			parentObj.insertBefore(disDiv, nameObj);
		else
			document.body.insertBefore(disDiv, null);
	}
		
	disDiv.innerHTML = _formatDisNames(idObj.value, nameObj.value, idField,
			nameField, splitStr,isEdit);
}

function Pda_clear(idField, nameField){
	var idObj = document.getElementsByName(idField)[0];
	var nameObj = document.getElementsByName(nameField)[0];
	if(idObj.value=="")
		return;
	var labelName = "_" + idField + "_label";
	var disDiv = document.getElementById(labelName);
	if(disDiv!=null)
		disDiv.innerHTML="";
	idObj.value="";
	nameObj.value="";
}

/**********************************************************************************
 **下为私有变量及函数,供接口调用
 **********************************************************************************/
var _Address_Current_Tmp_Obj = null;

function _Hide_Address_dialog() {
	var divObj = document.getElementById("_pda_address_dialog_div");
	divObj.style.display = "none";
	try {
		if (_Address_Current_Tmp_Obj['addAction'])
			_Address_Current_Tmp_Obj['addAction'](_Address_Current_Tmp_Obj['idField'],_Address_Current_Tmp_Obj['nameField']);

		document.body.scrollTop = _Address_Current_Tmp_Obj['scrollTop'];
	} catch (e) {
		
	}
	_Address_Current_Tmp_Obj = null;
}

function _Add_Address_dialog_data(id, name) {
	var idStr = _Address_Current_Tmp_Obj['idField'];
	var idObj = document.getElementsByName(idStr)[0];
	var nameStr = _Address_Current_Tmp_Obj['nameField'];
	var nameObj = document.getElementsByName(nameStr)[0];
	var splitStr = _Address_Current_Tmp_Obj['splitStr'];
	if (_Address_Current_Tmp_Obj["mulSelect"] == true) {
		if (idObj.value.indexOf(id) == -1) {
			idObj.value = idObj.value == "" ? id
					: (idObj.value + splitStr + id);
			nameObj.value = nameObj.value == "" ? name : (nameObj.value
					+ splitStr + name);
		}
	} else {
		idObj.value = id;
		nameObj.value = name;
	}
	var labelName = "_" + idStr + "_label";
	var disDiv = document.getElementById(labelName);
	if (disDiv == null) {
		var parentObj = nameObj.parentNode;
		disDiv = document.createElement("label");
		disDiv.setAttribute("id", labelName);
		if (parentObj != null)
			parentObj.insertBefore(disDiv, nameObj);
		else
			document.body.insertBefore(disDiv, null);
	}
	disDiv.innerHTML = _formatDisNames(idObj.value, nameObj.value, idStr,
			nameStr, splitStr,true);
	_Hide_Address_dialog();
}

function _formatDisNames(ids, names, idStr, nameStr, splitStr, isEdit) {
	var namesArr = names.split(splitStr);
	var idArr = ids.split(splitStr);
	var htmlVar = "";
	for ( var i = 0; i < idArr.length; i++) {
		htmlVar += (htmlVar == "" ? "" : "&nbsp;" + splitStr + "&nbsp;");
		htmlVar	+= "<label";
		htmlVar +=" class='_DisNameDiv'";
		if(isEdit != false)
			htmlVar +=	" onclick=\"_Delete_Address_dialog_data('"
				+ idStr + "','" + nameStr + "','" + idArr[i] + "','"+ namesArr[i] + "','" + splitStr + "');\"";
		htmlVar+= ">" ;
		htmlVar+= namesArr[i];
		if(isEdit != false)
			htmlVar += "<img src='" + Com_Parameter.ContextPath
				+ "third/pda/resource/images/ico_delpeople.png'/>";
		htmlVar +="</label>";
	}
	return htmlVar;
}

var _Delete_Address_dialog_Funs = [];

function _Delete_Address_dialog_data(idField, nameField, id, name, splitStr) {
	var idObj = document.getElementsByName(idField)[0];
	var nameObj = document.getElementsByName(nameField)[0];
	var idArr = idObj.value.split(splitStr);
	var nameArr = nameObj.value.split(splitStr);
	var labelName = "_" + idField + "_label";
	var disDiv = document.getElementById(labelName);
	var rtnIds = new Array();
	var rtnNames = new Array();
	for ( var i = 0; i < idArr.length; i++) {
		if (id != idArr[i]) {
			rtnIds[rtnIds.length] = idArr[i];
			rtnNames[rtnNames.length] = nameArr[i];
		}
	}
	if (rtnIds != null && rtnIds.length > 0) {
		idObj.value = rtnIds.join(splitStr);
		nameObj.value = rtnNames.join(splitStr);
		disDiv.innerHTML = _formatDisNames(idObj.value, nameObj.value, idField,
				nameField, splitStr,true);
	} else {
		idObj.value = "";
		nameObj.value = "";
		disDiv.innerHTML = "";
	}
	if(_Address_Current_Tmp_Obj!=null && _Address_Current_Tmp_Obj['delAction']!=null)
		try {
			_Address_Current_Tmp_Obj['delAction'](idField,nameField,id,name,splitStr);
		} catch (e) {}
	for (var i = 0; i < _Delete_Address_dialog_Funs.length; i ++) {
		try {
			_Delete_Address_dialog_Funs[i](idField,nameField,id,name,splitStr);
		} catch (e) {}
	}
}