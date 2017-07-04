//构建处理人信息loading效果
lbpm.globals.buildNextNodeHandlerLoading=function() {
	return '<div><img src="' + Com_Parameter.ContextPath + 'resource/style/common/images/loading.gif"/><kmss:message key="sys-lbpmservice:WorkFlow.Loading.Msg"/></div>';
}
//获取DOM对象在页面绝对位置
lbpm.globals.nextNodeHandlerAbsPosition=function(node, stopNode) {
	var x = y = 0;
	for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
	}
	x = x + document.body.scrollLeft;
	y = y + document.body.scrollTop;
	return {'x':x, 'y':y};
};

//解析节点处理人详细信息（组织架构配置）
lbpm.globals.parseNextNodeHandler=function(ids, analysis4View, distinct, action) {
	if (ids == '' || ids == null) {
		return [{name: lbpm.constant.COMMONNODEHANDLERORGEMPTY}];
	}
	ids = encodeURIComponent(ids);
	var other = "&modelId=" + lbpm.globals.getWfBusinessFormModelId();
	var rolesSelectObj = document.getElementsByName('rolesSelectObj');
	if (rolesSelectObj != null && rolesSelectObj.length > 0) {
		other += "&drafterId=" + rolesSelectObj[0].value;
	}
	var url = "lbpmHandlerParseService&handlerIds=" + ids + other+"&analysis4View="+analysis4View;
	if(distinct) {
		url += "&distinct=true";
	}
	var data = new KMSSData(); 
	if(action) {
		data.SendToBean(url, action);
	} else {
		return data.AddBeanData(url).GetHashMapArray();
	}
}

// 解析节点处理人详细信息（公式配置）
lbpm.globals.formulaNextNodeHandler=function(formula, analysis4View, distinct, action) {
	if (formula == '' || formula == null) {
		return [{name: '('+lbpm.constant.COMMONNODEHANDLERORGEMPTY+')'}];
	}
	formula = encodeURIComponent(formula);
	var other = "&modelId=" + lbpm.globals.getWfBusinessFormModelId() + "&modelName=" + lbpm.globals.getWfBusinessFormModelName();
	var rolesSelectObj = document.getElementsByName('rolesSelectObj');
	if (rolesSelectObj != null && rolesSelectObj.length > 0) {
		other += "&drafterId=" + rolesSelectObj[0].value;
	}
	var url = "lbpmHandlerParseService&formula=" + formula + other+"&analysis4View="+analysis4View;
	if(distinct) {
		url += "&distinct=true";
	}
	var data = new KMSSData();
	if(action) {
		data.SendToBean(url, action);
	} else {
		return data.AddBeanData(url).GetHashMapArray();
	}
}

// 构建处理人信息详细信息
lbpm.globals.buildNextNodeHandlerView=function(type, data) {
	var html = '';
	var foreache = function(name,str) {
		html += name + ':<div style="text-align: center;">'; //
		if (data.length < 1) {
			return (html += lbpm.constant.COMMONNODEHANDLERPARSEERROR);
		}
		for (var i = 0; i < data.length; i ++) {
			if (i > 0) html += str;
			html += data[i].name;
		}
	};
	if (type == lbpm.constant.PROCESSTYPE_SERIAL) { // 串行
		foreache('('+lbpm.constant.COMMONNODEHANDLERPROCESSTYPESERIAL+')', '<br/>&darr;<br/>');
	} else if (type == lbpm.constant.PROCESSTYPE_ALL) { // 会审/会签
		foreache('('+lbpm.constant.COMMONNODEHANDLERPROCESSTYPEALL+')', '<br/>+<br/>');
	} else if (type == lbpm.constant.PROCESSTYPE_SINGLE) { // 并行
		foreache('('+lbpm.constant.COMMONNODEHANDLERPROCESSTYPESINGLE+')', '/');
	} else {
		foreache('', ';');
		html = html.replace(/\//g, ';');
	}
	html += '</div>';
	return html;
}

// 构建流程图处理人信息详细信息框（loading时）
lbpm.globals.buildNextNodeHandlerNodeRefreshInfo=function(name, processType, value, isFormulaType) {
	var html = "<div>·"+lbpm.constant.COMMONNODENAME+":" + name + '</div>';
	html += "<div id='nodehandler_box'>·"+lbpm.constant.COMMONNODEHANDLER + lbpm.globals.buildNextNodeHandlerLoading() + '</div>';

	if (isFormulaType) {
		html += "<div>·"+lbpm.constant.COMMONNODEHANDLERHINT+"</div>";
	}
	return html;
}

// 构建流程图处理人信息详细信息（详细内容）
lbpm.globals.buildNextNodeHandlerNodeShowDetail=function(doc, NodeData) {
	var box = doc.getElementById('nodehandler_box');
	if (box == null || NodeData == null) {
		return;
	}
	var html = "·"+lbpm.constant.COMMONNODEHANDLER;
	var data = [];
	if (NodeData.handlerSelectType=="formula") {
		data = lbpm.globals.formulaNextNodeHandler(NodeData.handlerIds,false,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,NodeData));
	} else {
		data = lbpm.globals.parseNextNodeHandler(NodeData.handlerIds,false,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,NodeData));
	}
	html += lbpm.globals.buildNextNodeHandlerView(NodeData.processType, data);
	box.innerHTML = html;
};

// 构建处理人信息详细信息（详细内容）
lbpm.globals.toBuildNextNodeHandler=function(node, value, isFormulaType, baseLine) {
	var div = document.getElementById('nodehandler_box');
	var data = [];
	var h = "·"+lbpm.constant.COMMONNODEHANDLER;
	if (isFormulaType) {
		data = lbpm.globals.formulaNextNodeHandler(value,false,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,node));
	} else {
		data = lbpm.globals.parseNextNodeHandler(value,false,lbpm.globals.checkNodeType(lbpm.constant.NODETYPE_SEND,node));
	}
	h += lbpm.globals.buildNextNodeHandlerView(node.processType, data);
	div.innerHTML = h;
	// 调整最后位置
	if (WorkFlow_NextNodeHandlerBox.offsetHeight + WorkFlow_NextNodeHandlerBox.offsetTop > document.body.scrollTop + document.body.clientHeight) {
		WorkFlow_NextNodeHandlerBox.style.top = (baseLine - WorkFlow_NextNodeHandlerBox.offsetHeight) + 'px';
	}
}

// 构建处理人信息详细信息框（loading时）
lbpm.globals.clickNextNodeHandlerEventListener=function(event) {
	var target = event.target;
	if (target.className.indexOf('handlerNamesLabel') > -1) {
		if (WorkFlow_NextNodeHandlerTimeout != null)
			clearTimeout(WorkFlow_NextNodeHandlerTimeout);
		event.cancelBubble = true;
		var re = new RegExp("(\\[\\d+\\])", "g");
		var handlerIds = 'handlerIds';
		var index = re.exec(target.id);
		if (index != null) {
			index = RegExp.$1;
			handlerIds += index;
		}
		var dom = $("[name='"+handlerIds + "']");
		var pos = lbpm.globals.nextNodeHandlerAbsPosition(target);
		var node = lbpm.globals.getNodeObj($(target).attr('nodeId'));
		
		var html = "<div>·"+lbpm.constant.COMMONNODENAME+":" + node.id + '.' + node.name + '</div>';
		html += "<div id='nodehandler_box'>·"+lbpm.constant.COMMONNODEHANDLER + lbpm.globals.buildNextNodeHandlerLoading() + '</div>';
		if (dom.attr('isFormula') == 'true') {
			html += "<div>·"+lbpm.constant.COMMONNODEHANDLERHINT+"</div>";
		}
		var left = (pos.x + (target.offsetWidth > 200 ? 200 : target.offsetWidth));
		WorkFlow_NextNodeHandlerBox.innerHTML = html;
		WorkFlow_NextNodeHandlerBox.style.display = '';
		WorkFlow_NextNodeHandlerBox.style.left = left + 'px';
		WorkFlow_NextNodeHandlerBox.style.top = (pos.y) + 'px';
		if (WorkFlow_NextNodeHandlerBox.offsetHeight + WorkFlow_NextNodeHandlerBox.offsetTop > document.body.scrollTop + document.body.clientHeight) {
			WorkFlow_NextNodeHandlerBox.style.top = (pos.y + target.offsetHeight - WorkFlow_NextNodeHandlerBox.offsetHeight) + 'px';
		}
		var baseLine = pos.y + target.offsetHeight;
		var script = dom.val();
		var call = function() {
			lbpm.globals.toBuildNextNodeHandler(node, script, dom.attr('isFormula') == 'true', baseLine);
		};
		WorkFlow_NextNodeHandlerTimeout = setTimeout(call, 500);
	}
};

// 初始化配置处理人信息详细信息框显示(即将流程栏的处理人信息详细描述)
lbpm.globals.initNextNodeHandlerParse=function() {
	var stopPropagation = function(e) {e.stopPropagation();};
	WorkFlow_NextNodeHandlerBox = document.createElement('div');
	WorkFlow_NextNodeHandlerBox.className = "nodeinfo_box";
	$(WorkFlow_NextNodeHandlerBox).css({'position': 'absolute', 'display': 'none'});
	document.body.appendChild(WorkFlow_NextNodeHandlerBox);
	//点击弹出悬浮提示 改为 鼠标移上去 。作者 曹映辉 #日期 2014年4月25日 
	$("#nextNodeTD").mouseover(lbpm.globals.clickNextNodeHandlerEventListener);
	$("#operationsTDContent").mouseover(lbpm.globals.clickNextNodeHandlerEventListener);
	//$("#nextNodeTD").mouseleave(stopPropagation);
	//$("#operationsTDContent").mouseleave(stopPropagation);
	$("#nextNodeTD").mouseleave(function(e){
		WorkFlow_NextNodeHandlerBox.style.display = 'none';
		e.stopPropagation();
	});
	$("#operationsTDContent").mouseleave(function(e){
		WorkFlow_NextNodeHandlerBox.style.display = 'none';
		e.stopPropagation();
	});
	$(WorkFlow_NextNodeHandlerBox).mouseleave(function(e) {
		if (WorkFlow_NextNodeHandlerTimeout != null)
			clearTimeout(WorkFlow_NextNodeHandlerTimeout);
		WorkFlow_NextNodeHandlerBox.style.display = 'none';
		e.stopPropagation();
	});
};
var WorkFlow_NextNodeHandlerBox = null; // 处理人详细框
var WorkFlow_NextNodeHandlerTimeout = null; // 延迟显示详细定时ID

$(document).ready(function(){
	lbpm.globals.initNextNodeHandlerParse();
});