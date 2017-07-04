Com_IncludeFile("doclist.js");
/*******************************************
 * 删除错误信息节点
 * (参数为你所要验证的字段名,可以放入多个)
 ******************************************/
function Control_RemoveValidMsg(objId) {
	var spanNode = document.getElementById(objId);
	if (spanNode != undefined)
		spanNode.parentNode.removeChild(spanNode);
}

/******************
 * 寻找为TD的父节点
 ******************/
function _getNodeTD(currentNode) {
	while (currentNode.tagName.toUpperCase() != "TD") {
		currentNode = currentNode.parentNode;
	}
	return currentNode;
}

/********************
 * 添加正在加载图片
 ********************/
function Control_AppendLoadImg(obj, objId) {
	var loadImgNode = document.createElement("img");
	loadImgNode.id = objId;
	loadImgNode.src = Com_Parameter.ResPath+"style/common/images/loading.gif";
	var currentNode = _getNodeTD(obj.parentNode);
	currentNode.appendChild(loadImgNode);
}
 
 /********************
  * 添加正在加载提示
  ********************/
 function Control_AppendLoadMsg(obj, commonId, msg) {
	var currentTR = DocListFunc_GetParentByTagName('TR');
	var index = currentTR.rowIndex - 1;
	var tempId = commonId + index;
	if (document.getElementById(tempId) == null) {
		var loadImgNode = document.createElement("span");
		loadImgNode.id = tempId;
		loadImgNode.innerHTML = "</br><font color='red'>" + msg + "</font>";
		var currentNode = _getNodeTD(obj.parentNode);
		currentNode.appendChild(loadImgNode);
	}
	
 }

/**
 * 移除正在加载图片
 * @param elementName
 */
function Control_RemoveLoadImg(objId) {
	Control_RemoveValidMsg(objId);
}
 
function Common_RemoveMsg(commonId){
	var currentTR = DocListFunc_GetParentByTagName('TR');
	if (currentTR != null) {
		var index = currentTR.rowIndex -1;
		Control_RemoveValidMsg(commonId + index);
	} 
}


// Select控件保留选择值
function SapDataBySelect_LeaveValue(thisObj, valueId, textId) {
	//alert("thisObj.id="+thisObj.id+"--valueId="+valueId+"--textId="+textId);
//	var thisObj = document.getElementsByName(thisName)[0];
	for (var i = 0; i < thisObj.options.length; i++) {
		if (thisObj.options[i].selected) {
			$("input[name='"+ valueId +"']").val(thisObj.options[i].value);
			$("input[name='"+ textId +"']").val(thisObj.options[i].text);
			//document.getElementById(valueId).value = thisObj.options[i].value;
			//document.getElementById(textId).value = thisObj.options[i].text;
		}
	}
}

function Select_RemoveMsg() {
	var sapSelectShowMsgId = document.getElementById("sapSelectShowMsgId").value;
	Common_RemoveMsg(sapSelectShowMsgId);
}

