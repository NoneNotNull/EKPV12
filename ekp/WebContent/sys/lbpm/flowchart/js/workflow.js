/**********************************************************
功能：流程中的常用JS
使用：
	该JS并不在流程图中使用，而是在流程主界面和节点属性配置页面使用
作者：叶中奇
创建时间：2008-05-05
修改记录：
**********************************************************/

//功能：转换对象为字符串，适合XML字符数据的拼装
//参数：
//	data：数据对象
//	nodeName：根对象对应XML的节点名
function WorkFlow_BuildXMLString(data, nodeName){
	if(nodeName==null) {
		if(data["XMLNODENAME"]) {
			nodeName = data["XMLNODENAME"];
		}
	}
	var rtnStr = "<"+nodeName;
	var childStr = "";
	
	for(var p in data){
		//XMLNODENAME是为了组织XML方便使用的对象
		if(p=="XMLNODENAME")
			continue;
		var value = data[p];
		if(value==null)
			continue;
		if(typeof(value)=="function")
			continue;
		//若p是个数字，则使用XMLNODENAME作为子对象名
		if(!isNaN(p))
			p = value.XMLNODENAME;
		switch(typeof(value)){
			case "string":
				if(value=="")
					continue;
				value = Com_HtmlEscape(data[p]);
			break;
			case "object":
				childStr += "\r\n" + WorkFlow_BuildXMLString(value, p);
				continue;
		}
		rtnStr += " "+ p + "=\"" + value + "\"";
	}
	if(childStr=="")
		rtnStr += " />";
	else
		rtnStr += ">"+childStr+"\r\n</"+nodeName+">";
	return rtnStr;
}

//功能：将xml字符串转换为对象
//参数：
//	xml：xml字符串，或xml节点对象
//	isArray：是否为数组子对象，该参数仅在内部调用的时候使用，其它调用请忽略该参数
//	nodeNames：需要到得该节点内容的节点名，如果不需要取值，调用请忽略该参数
function WorkFlow_LoadXMLData(xml, isArray,nodeNames){
	var xmlObj = xml;
	if(typeof(xml) == "string"){
		if(xml == null || xml == ""){
			return;
		}
		if(window.ActiveXObject){
			xmlObj = new ActiveXObject("MSXML2.DOMDocument.3.0");
			xmlObj.loadXML(xml);
			xmlObj = xmlObj.firstChild;
		}else{
			var dp = new DOMParser();
		    var newDOM = dp.parseFromString(xml, "text/xml");
		    xmlObj = newDOM.documentElement;
		}
	}
	var rtnVal = new Array();

	//读取属性
	rtnVal.XMLNODENAME = xmlObj.nodeName;
	var attNodes = xmlObj.attributes;
	for(var i=0; i<attNodes.length; i++)
		rtnVal[attNodes[i].nodeName] = attNodes[i].value;
	if(rtnVal.CHILDRENISARRAY!=null){
		isArray = rtnVal.CHILDRENISARRAY=="true";
	}

	//读取节点内容
	if(nodeNames!=null){
		if(nodeNames.indexOf(xmlObj.nodeName)!=-1){
			return xmlObj.text;  
		}
	}

	//读取子对象
	for(var node=xmlObj.firstChild; node!=null; node=node.nextSibling){
		if(node.nodeType==1){
			if(isArray)
				rtnVal[rtnVal.length] = WorkFlow_LoadXMLData(node, false,nodeNames);
			else
				rtnVal[node.nodeName] = WorkFlow_LoadXMLData(node, true,nodeNames);
		}
	}
	return rtnVal;
}

function WorkFlow_SetInnerText(obj, text){
	if("textContent" in obj)
		obj.textContent = text;
	else
		obj.innerText = text;
}

//功能：将data对象的属性填充到页面的域中
//参数：
//	data：数据对象
//	fieldFliter：数据对象属性与域的对应关系，该参数为一函数名，传入对象属性名，返回域的名字，若返回null，则不处理该属性
function WorkFlow_PutDataToField(data, fieldFilter){
	for(var o in data){
		var fieldName = o;
		if(fieldFilter!=null)
			fieldName = fieldFilter(fieldName);
		if(fieldName==null)
			continue;
		var fields = document.getElementsByName(fieldName);
		if(fields.length==0)
			continue;
		var value = data[o];
		switch(fields[0].tagName){
			case "INPUT":
				switch(fields[0].type){
					case "radio":
					case "checkbox":
						for(var i=0; i<fields.length; i++)
							fields[i].checked = fields[i].value==value;
					break;
					default:
						fields[0].value = value;
				}
			break;
			case "TEXTAREA":
				fields[0].value = value;
			break;
			case "SELECT":
				for(var i=0; i<fields[0].options.length; i++)
					fields[0].options[i].selected = fields[0].options[i].value==value;
			break;
			case "SPAN":
				WorkFlow_SetInnerText(fields[0],value);
			break;
		}
	}
}

//功能：从页面的域中读取域值，并赋给对象的某个属性中
//参数：
//	data：数据对象
//	propertyFilter：域与数据对象属性的对应关系，该参数为一函数名，传入对象域的名字，返回属性名，若返回null，则不处理该域
//	obj：搜索范围，该参数为一个DOM对象，可选，默认为整份文档
function WorkFlow_GetDataFromField(data, propertyFilter, obj){
	if(obj==null)
		obj = document;
	var fields = obj.getElementsByTagName("INPUT");
	for(var i=0; i<fields.length; i++){
		var property = getFieldProperty(fields[i]);
		if(property==null)
			continue;
		switch(fields[i].type){
			case "radio":
				if(fields[i].checked)
					data[property] = fields[i].value;
			break;
			case "checkbox":
				if(fields[i].checked){
					data[property] = fields[i].value;
				}else{
					if(fields[i].value=="true")
						data[property] = "false";
					else if(fields[i].value=="false")
						data[property] = "true";
					else
						data[property] = null;
				}
			break;
			default:
				data[property] = fields[i].value;
		}
	}
	fields = obj.getElementsByTagName("TEXTAREA");
	for(var i=0; i<fields.length; i++){
		var property = getFieldProperty(fields[i]);
		if(property==null)
			continue;
		data[property] = fields[i].value;
	}
	fields = obj.getElementsByTagName("SELECT");
	for(var i=0; i<fields.length; i++){
		var property = getFieldProperty(fields[i]);
		if(property==null)
			continue;
		data[property] = fields[i].options[fields[i].selectedIndex].value;
	}
	
	function getFieldProperty(field){
		if(field.name==null || field.name=="")
			return null;
		if(propertyFilter!=null)
			return propertyFilter(field.name);
		return field.name;
	}
}

//功能：更新页面中通知方式的显示
//参数：
//	tdId：通知方式字段所在的TD的id
//	value：通知方式的值
function WorkFlow_RefreshNotifyType(tdId, value){
	var tdObj = document.getElementById(tdId);
	if(value==null){
		var values = new Array();
	}else{
		var values = value.split(";");
	}
	var fields = tdObj.getElementsByTagName("INPUT");
	for(var i=0; i<fields.length; i++){
		if(fields[i].name.substring(0, 14)=="__notify_type_"){
			fields[i].checked = Com_ArrayGetIndex(values, fields[i].value)>-1;
		}
	}
}

//功能：解释流程流转状态数据
//参数：
//	xml：状态信息XML
function WorkFlow_GetStatusObjectByXML(xml){
	var unknownNode = [];
	var statusData = WorkFlow_LoadXMLData(xml);
	var i, j, nodeInfo, routePath;
	if(statusData.runningNodes==null)
		statusData.runningNodes = new Array();
	statusData.historyNodes[0].routePath = "";
	for(i=0; i<statusData.historyNodes.length; i++){
		var nodeInfo = statusData.historyNodes[i];
		switch(nodeInfo.routeType){
			case "BACK":
				routePath = WorkFlow_GetStatusInfoByModelId(statusData, nodeInfo.targetId).routePath;
			break;
			case "RESUME":
				for(var j=i-1; j>=0; j--){
					if(statusData.historyNodes[j].id==nodeInfo.targetId){
						routePath = statusData.historyNodes[j].routePath;
						break;
					}
				}
			break;
			default:
				routePath = ((nodeInfo.routePath == null || nodeInfo.routePath=="")?"":nodeInfo.routePath+";")+nodeInfo.id + ":" + nodeInfo.modelId;
		}
		if(nodeInfo.targetId=="")
			continue;
		var targetIds = nodeInfo.targetId.split(";");
		for(var j=0; j<targetIds.length; j++){
			var statusInfo = WorkFlow_GetStatusInfoById(statusData, targetIds[j], i);
			if(statusInfo!=null) {
				//statusInfo.routePath = routePath;
				WorkFlow_MergeStatusRoutePath(statusInfo, routePath);
			} else {
				unknownNode.push({nodeId:targetIds[j], routePath:routePath});
			}
		}
	}
	// 流程路由丢失出错后容错    by fuyx
	if (statusData.historyNodes.length > 0 && unknownNode.length > 0) {
		var usedIndex = 0;
		for (i = 0; i < statusData.runningNodes.length; i++) {
			var rNode = statusData.runningNodes[i];
			if (rNode.routePath == null || rNode.routePath == '') {
				if (usedIndex >= unknownNode.length) {
					usedIndex = 0;
				}
				rNode.routePath = unknownNode[usedIndex].routePath;
				usedIndex ++;
			}
		}
		// 进一步修正，历史节点错位问题    by fuyx
		for (i = 0; i < statusData.historyNodes.length; i ++) {
			var hNode = statusData.historyNodes[i];
			if (hNode.routePath == null || hNode.routePath == '') {
				for (j = 0; j < unknownNode.length; j++) {
					if (hNode.id == unknownNode[j].nodeId) {
						hNode.routePath = unknownNode[j].routePath;
						var targetIds = hNode.targetId.split(";");
						for(var k=0; k<targetIds.length; k++){
							var statusInfo = WorkFlow_GetStatusInfoById(statusData, targetIds[k], statusData.historyNodes.length);
							if (statusInfo != null) {
								statusInfo.routePath = hNode.routePath + ";" + hNode.id + ":" + hNode.modelId;
							}
						}
						break;
					}
				}
			}
		}
	}
	return statusData;
}

function WorkFlow_MergeStatusRoutePath(statusInfo, routePath) {
	if (routePath == null || routePath == '') {
		return;
	}
	if (statusInfo.routePath == null || statusInfo.routePath == '') {
		statusInfo.routePath = routePath;
		return;
	}
	var oR = statusInfo.routePath.split(';');
	var nR = routePath.split(';');
	var isIn = function(rp, key) {
		for (var i = 0; i < rp.length; i++) {
			if (rp[i] == key) {
				return true;
			}
		}
		return false;
	};
	for (var k = 0; k < nR.length; k ++) {
		if (!isIn(oR, nR[k])) {
			oR[oR.length] = nR[k];
		}
	}
	statusInfo.routePath = oR.join(';');
}

function WorkFlow_GetStatusInfoByModelId(statusData, modelId){
	for(var i=0; i<statusData.historyNodes.length; i++)
		//if(statusData.historyNodes[i].modelId==modelId)
		if(statusData.historyNodes[i].id==modelId)
			return statusData.historyNodes[i];
}

function WorkFlow_GetStatusInfoById(statusData, id, index){
	for(var i=index+1; i<statusData.historyNodes.length; i++)
		if(statusData.historyNodes[i].id==id)
			return statusData.historyNodes[i];
	for(var i=0; i<statusData.runningNodes.length; i++)
		if(statusData.runningNodes[i].id==id)
			return statusData.runningNodes[i];
}