/**********************************************************
功能：属性页面通用函数
使用：
	在节点属性页面引入

作者：傅游翔
创建时间：2012-07-23
修改记录：
**********************************************************/

var dialogObject=window.dialogArguments?window.dialogArguments:opener.Com_Parameter.Dialog;
AttributeObject.NodeObject = dialogObject.Node;
AttributeObject.NodeData = AttributeObject.NodeObject.Data;
AttributeObject.STATUS_RUNNING = dialogObject.Window.STATUS_RUNNING;
AttributeObject.isEdit = function() {
	return FlowChartObject.IsEdit && AttributeObject.NodeObject.Status != AttributeObject.STATUS_RUNNING;
};

//加载详细数据
AttributeObject.loadNodeDetail = function(FlowChartObject) {
	if (FlowChartObject.IsDetail) {
		return;
	}
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath + "sys/lbpm/flowchart/page/detail.jsp?processId=" + FlowChartObject.MODEL_ID + "&nodeId=" + AttributeObject.NodeData.id, function(req) {
		var xml = req.responseText;
		xml = Com_Trim(xml);
		if (xml == null || xml == '' || xml == 'null') {
			return;
		}
		var node = WorkFlow_LoadXMLData(xml);
		for(var o in node){
			if (AttributeObject.NodeData[o] == null)
				AttributeObject.NodeData[o] = node[o];
		}
	}, false);
};
AttributeObject.loadNodeDetail(FlowChartObject);

AttributeObject.CheckDataFuns = [];
AttributeObject.AppendDataFuns = [];

AttributeObject.Utils.loadNodeNameInfo = function(idField, nameField){
	idField = document.getElementsByName(idField)[0];
	if(idField.value=="")
		return;
	var originIds = idField.value.split(";");
	var ids = "";
	var names = "";
	var nodesObject = FlowChartObject.Nodes;
	for(var i=0; i<originIds.length; i++){
		var node = nodesObject.GetNodeById(originIds[i]);
		if(node==null)
			continue;
		ids += ";" + originIds[i];
		names += ";" + originIds[i] + "." + node.Data.name;
	}
	nameField = document.getElementsByName(nameField)[0];
	idField.value = ids.substring(1);
	nameField.value = names.substring(1);
};

AttributeObject.Utils.writeNodeData = function(){
	var data = new Object(), i;
	WorkFlow_GetDataFromField(data, function(fieldName){
		if(fieldName.substring(0,3)=="wf_")
			return fieldName.substring(3);
		return null;
	});
	
	var extData = new Object(), extAttributes = [];
	extAttributes.XMLNODENAME = "extAttributes";
	WorkFlow_GetDataFromField(extData, function(fieldName){
		if(fieldName.substring(0,4)=="ext_")
			return fieldName.substring(4);
		return null;
	});
	for (var ext in extData) {
		extAttributes.push({
			name:ext, 
			value:extData[ext], 
			XMLNODENAME:"attribute"
		});
	}
	if (extAttributes.length > 0) {
		data.extAttributes = extAttributes;
	}
	
	var checkDataFuns = AttributeObject.CheckDataFuns;
	for (i = 0; i < checkDataFuns.length; i ++) {
		var result = checkDataFuns[i](data);
		if (result == false) {
			return false;
		}
	}
	var appendDataFuns = AttributeObject.AppendDataFuns;
	for (i = 0; i < appendDataFuns.length; i ++) {
		appendDataFuns[i](data);
	}
	
	for(var o in data){
		AttributeObject.NodeData[o] = data[o];
		if('description' == o && data[o]){
			//替换UBB URL 为html [url] 变位<a> @作者：曹映辉 @日期：2011年8月31日 
			re=/\[url=([^\]]+)\]([^\[]*)\[\/url\]/ig;
			AttributeObject.NodeData[o] = data[o].replace(re,function($0,$1,$2){
					if($2){
						return '<span><a href='+$1+' target=_blank>'+$2+'</a></span>';
					}
					else{
						//没有输入链接描述时 链接地址即为描述
					  return '<span><a href='+$1+' target=_blank>'+$1+'</a></span>';
					}
				});
			AttributeObject.NodeData[o]="<pre>"+AttributeObject.NodeData[o]+"</pre>";
			AttributeObject.NodeData[o]=AttributeObject.NodeData[o].replace(/\r\n/ig,"<br/>").replace(/\n/ig,"<br/>");
			//NodeData[o] = data[o].replace(re,'<a href="$1" target="_blank">'+'$2'+'</a>');
		}
	}
	returnValue = true;
	return true;
};

AttributeObject.Utils.putDataToField = function() {
	WorkFlow_PutDataToField(AttributeObject.NodeData, function(propertyName){
		return "wf_"+propertyName;
	});
	var exts = AttributeObject.NodeData.extAttributes;
	if (exts) {
		var extData = new Object();
		for (var i = 0; i < exts.length; i ++) {
			extData[exts[i].name] = (exts[i].value?exts[i].value:"");
		}
		WorkFlow_PutDataToField(extData, function(propertyName){
			return "ext_"+propertyName;
		});
	}
	//节点帮助 html 转 UBB @作者：曹映辉 @日期：2011年8月31日
	if(AttributeObject.NodeData["description"]){ 
		re =/<span><a[^>]*href=[\'\"\s]*([^\s\'\"]*)[^>]*>(.+?)<\/a><\/span>/ig;
		var desc = AttributeObject.NodeData["description"].replace(re,function ($0,$1,$2){
			if($1==$2){
				return '[url='+$1+'][/url]';
			}
			else{
				return '[url='+$1+']'+$2+'[/url]';
			}
		});
		desc=desc.replace(/(<pre>)|(<\/pre>)/ig,"").replace(/<br\/>/ig,"\r\n");
		var wf_description = document.getElementsByName("wf_description")[0];
		if(wf_description) {
			wf_description.value=desc;
		}
	}
};

AttributeObject.Utils.refreshLineOut = function() {
	var LineOut = AttributeObject.NodeObject.LineOut;
	if(LineOut!=null && LineOut.length>0){
		for(var i=0;i<LineOut.length;i++){
			LineOut[i].Refresh();
		}
	}
};

AttributeObject.Utils.appendOrgAttr = function(data) {
	var inputs = document.getElementsByTagName('input');
	var orgAttrs = [];
	for (var i = 0; i < inputs.length; i ++) {
		var input = inputs[i];
		var orgAttr = input.getAttribute('orgattr');
		if (orgAttr != null && orgAttr != '') {
			orgAttrs.push(orgAttr);
		}
	}
	if (orgAttrs.length > 0) {
		data['orgAttributes'] = orgAttrs.join(";");
	}
};
AttributeObject.Utils.appendOrgAttr.name = "appendOrgAttr";
AttributeObject.AppendDataFuns.push(AttributeObject.Utils.appendOrgAttr);

AttributeObject.Utils.switchOrgAttributes = function(input, type) {
	if (type == null) {
		type = 'org';
	}
	var orgAttr = input.getAttribute('orgattr');
	var _orgAttr = input.getAttribute('_orgattr');
	if (type == 'org') {
		if (orgAttr == null || orgAttr == '') {
			input.setAttribute('orgattr', _orgAttr);
		}
	}
	else {
		if (orgAttr != null && orgAttr != '') {
			input.setAttribute('_orgattr', orgAttr);
		}
		input.setAttribute('orgattr', "");
	}
};


AttributeObject.Utils.putDataToField.name = "putDataToField";
AttributeObject.Utils.writeNodeData.name = "writeNodeData";

AttributeObject.SubmitFuns.push(AttributeObject.Utils.writeNodeData);
AttributeObject.Init.AllModeFuns.push(function() {
	document.title = FlowChartObject.Lang.Operation.Text.ChangeMode[AttributeObject.NodeObject.Type];
	if(AttributeObject.NodeObject.Type) {
		var typeObj = FlowChartObject.Nodes.Types[AttributeObject.NodeObject.Type];
		if(typeObj) {
			$("#nodeType").html("("+typeObj.Name+")");
		}
	}
});
AttributeObject.Init.AllModeFuns.push(AttributeObject.Utils.putDataToField);

AttributeObject.Init.ViewModeFuns.push(function() {
	var DIV_EditButtons = document.getElementById("DIV_EditButtons");
	if (DIV_EditButtons != null)
		DIV_EditButtons.style.display = "none";
});
AttributeObject.Init.EditModeFuns.push(function() {
	var DIV_ReadButtons = document.getElementById("DIV_ReadButtons");
	if (DIV_ReadButtons != null)
		DIV_ReadButtons.style.display = "none";
});


function writeMessage(key){
	document.write(FlowChartObject.Lang.Node[key]);
}
function writeLineMessage(key){
	document.write(FlowChartObject.Lang.Line[key]);
}
function writeOperationMessage(key){
	document.write(FlowChartObject.Lang.Operation[key]);
}