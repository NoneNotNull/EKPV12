<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>

<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js|doclist.js");
</script>
<script src="../js/attribute.js"></script>
</head>
<body onload="AttributeObject.initDocument();">
<br>
<script>
//当前节点对象
AttributeObject.NodeObject = dialogObject.Node;
//当前节点配置信息对象
AttributeObject.NodeData = AttributeObject.NodeObject.Data;
AttributeObject.STATUS_RUNNING = dialogObject.Window.STATUS_RUNNING;
AttributeObject.isEdit = function() {
	return FlowChartObject.IsEdit && AttributeObject.NodeObject.Status != AttributeObject.STATUS_RUNNING;
};

// 当前选择事件类型
AttributeObject.CurrEventType = dialogObject.CurrEventType;

//初始化事件数据
AttributeObject.loadNodeEvents = function(nodeType) {
	if(!Data_XMLCatche.LbpmNodeEvents) {
		Data_XMLCatche.LbpmNodeEvents = [];
	}
	var nodeEvent = Data_XMLCatche.LbpmNodeEvents[nodeType];
	if(!nodeEvent) {
		$.ajaxSettings.async = false; // 同步
		$.getJSON(Com_Parameter.ContextPath + "sys/lbpm/engine/jsonp.jsp?s_name=com.landray.kmss.sys.lbpm.engine.manager.event.EventDataProvider",
			{modelName: FlowChartObject.ModelName, nodeType: nodeType, d: new Date().getTime()},
			function(json) {
				nodeEvent = Data_XMLCatche.LbpmNodeEvents[nodeType] = json;
	 	});
		$.ajaxSettings.async = true;
	}
	return nodeEvent;
};

// 初始化事件
AttributeObject.Init.AllModeFuns.push(function() {
	document.title = '<kmss:message key="FlowChartObject.Lang.Event.eventConfigTitle" bundle="sys-lbpm-engine" />';
	$("#event_name").attr("value", AttributeObject.CurrEventType ? AttributeObject.CurrEventType.name : "");
	var selectEventType = null;
	var event_type = $("#event_type");
	var nodeEvents = AttributeObject.loadNodeEvents(AttributeObject.NodeObject.Type);
	if(nodeEvents) {
		for (var i = 0, n = nodeEvents.length; i < n; i++) {
			var eventType = nodeEvents[i];
			// 添加选项
			event_type.append('<option value="' + eventType.type + '">' + eventType.typeName + '</option>');
			if(AttributeObject.CurrEventType && AttributeObject.CurrEventType.type == eventType.type) {
				selectEventType = eventType;
				// 初始化选中状态
				event_type.val(selectEventType.type);
			}
		}
	}
	if (selectEventType == null) return;
	if(selectEventType.typeJsp) {
		// 调用事件类型的配置页面
		$("#IF_EventType").attr("src", selectEventType.typeJsp).load(function() {
			var ifEventType = document.getElementById("IF_EventType");
			if(ifEventType && ifEventType.contentWindow.initValue) { // 事件类型初始化
				if(AttributeObject.CurrEventType) {
					ifEventType.contentWindow.initValue(AttributeObject.CurrEventType.eventConfig, AttributeObject.CurrEventType, AttributeObject.NodeObject);
				} else {
					ifEventType.contentWindow.initValue(null, null, AttributeObject.NodeObject);
				}
			}
		});
		$("#TR_EventType").show();
	}
	// 当前事件类型下的事件侦听器
	var selectListener = null;
	var event_listener = $("#event_listener");
	var eventListeners = selectEventType.listeners;
	for (var i = 0, n = eventListeners.length; i < n; i++) {
		event_listener.append('<option value="' + eventListeners[i].listenerId + '">' + eventListeners[i].listenerName + '</option>');
		if(AttributeObject.CurrEventType && AttributeObject.CurrEventType.listenerId == eventListeners[i].listenerId) {
			selectListener = eventListeners[i];
			// 初始化选中状态
			event_listener.val(selectListener.listenerId);
		}
	}
	if(selectListener == null) return;
	if(selectListener.listenerJsp) {
		// 调用事件侦听器的配置页面
		$("#IF_Listener").attr("src", selectListener.listenerJsp).load(function() {
			var ifListener = document.getElementById("IF_Listener");
			if(ifListener && ifListener.contentWindow.initValue) { // 事件侦听器初始化
				if(AttributeObject.CurrEventType) {
					ifListener.contentWindow.initValue(AttributeObject.CurrEventType.listenerConfig, AttributeObject.CurrEventType, AttributeObject.NodeObject);
				} else {
					ifListener.contentWindow.initValue(null, null, AttributeObject.NodeObject);
				}
			}
		});
		$("#TR_Listener").show();
	}
});
AttributeObject.Init.ViewModeFuns.push(function() {
	$("#DIV_ReadButtons").show();
	$("#IF_EventType").load(function() {
		AttributeObject.Utils.disabledOperation(window.frames["IF_EventType"].document);
	});
	$("#IF_Listener").load(function() {
		AttributeObject.Utils.disabledOperation(window.frames["IF_Listener"].document);
	});
});

AttributeObject.Init.EditModeFuns.push(function() {
	$("#DIV_EditButtons").show();
});
// 选择事件类型
AttributeObject.changeEventType = function(owner) {
	var _owner = $(owner);
	if (!_owner.val()) return;
	var index = _owner.get(0).selectedIndex;
	var event_listener = $("#event_listener");
	event_listener.empty();
	event_listener.append('<option value="">' + '<kmss:message key="page.firstOption" />' + '</option>');
	// 当前事件类型下的事件侦听
	var selectEventType = AttributeObject.loadNodeEvents(AttributeObject.NodeObject.Type)[index - 1];
	var eventListeners = selectEventType.listeners;
	for (var i = 0, n = eventListeners.length; i < n; i++) {
		event_listener.append('<option value="' + eventListeners[i].listenerId + '">' + eventListeners[i].listenerName + '</option>');
	}
	if(selectEventType.typeJsp) {
		// 调用事件类型的配置页面
		var ifEventType = $("#IF_EventType").attr("src", selectEventType.typeJsp);
		$("#TR_EventType").show();
	} else {
		$("#IF_EventType").attr("src", "");
		$("#TR_EventType").hide();
	}
	// 调用事件侦听器的配置页面
	$("#IF_Listener").attr("src", "");
	$("#TR_Listener").hide();
}
// 选择事件侦听器
AttributeObject.changeListener = function(owner) {
	var _owner = $(owner);
	if (!_owner.val()) return;
	var index = _owner.get(0).selectedIndex;
	var event_type = $("#event_type"); // 当前事件类型
	var eventListeners = AttributeObject.loadNodeEvents(AttributeObject.NodeObject.Type)[event_type.get(0).selectedIndex - 1].listeners;
	var selectListener = eventListeners[index - 1];
	if(selectListener.listenerJsp) {
		// 调用事件侦听器的配置页面
		var ifListener = $("#IF_Listener").attr("src", selectListener.listenerJsp);
		$("#TR_Listener").show();
	} else {
		$("#IF_Listener").attr("src", "");
		$("#TR_Listener").hide();
	}
};
// 提交数据
AttributeObject.SubmitFuns.push(function() {
	var event_name = $("#event_name");
	if (!event_name.val()) {
		alert('<kmss:message bundle="sys-lbpm-engine" key="lbpm.eventName.notNull" />');
		return false;
	}
	var event_type = $("#event_type");
	if (!event_type.val()) {
		alert('<kmss:message bundle="sys-lbpm-engine" key="lbpm.eventType.select" />');
		return false;
	}
	var event_listener = $("#event_listener");
	if (!event_listener.val()) {
		alert('<kmss:message bundle="sys-lbpm-engine" key="lbpm.listenerType.select" />');
		return false;
	}
	var name = null, type = null, typeName = null, listenerId = null, listenerName = null;
	name = event_name.val();
	type = event_type.val();
	typeName = event_type.find("option:selected").text();

	listenerId = event_listener.val();
	listenerName = event_listener.find("option:selected").text();

	var eventConfig = "", listenerConfig = "";
	var ifEventType = document.getElementById("IF_EventType");
	if(ifEventType) {
		if(ifEventType.contentWindow.checkValue) { // 事件类型配置校验
			if(!ifEventType.contentWindow.checkValue()) {
				return false;
			}
		}
		if(ifEventType.contentWindow.returnValue) { // 事件类型配置返回值
			eventConfig = ifEventType.contentWindow.returnValue();
		}
	}

	var ifListenerType = document.getElementById("IF_Listener");
	if(ifListenerType) {
		if(ifListenerType.contentWindow.checkValue) { // 事件侦听器配置校验
			if(!ifListenerType.contentWindow.checkValue()) {
				return false;
			}
		}
		if(ifListenerType.contentWindow.returnValue) { // 事件侦听器配置返回值
			listenerConfig = ifListenerType.contentWindow.returnValue();
		}
	}
	var id = AttributeObject.CurrEventType ? AttributeObject.CurrEventType.id : AttributeObject.Utils.generateID();
	returnValue = {id: id, name: name, type: type, typeName: typeName, eventConfig: eventConfig, listenerId: listenerId, listenerName: listenerName, listenerConfig: listenerConfig};
	window.close();
});
// 生成Id
AttributeObject.Utils.generateID = function() {
	return parseInt(((new Date().getTime()+Math.random())*10000)).toString(16);
};
</script>
<p class="txttitle"><bean:message bundle="sys-lbpm-engine" key="lbpm.eventConfig"/></p>
<center>
	<table class="tb_normal" width="95%">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-lbpm-engine" key="lbpm.eventName"/>
			</td>
			<td width=35%>
				<input id="event_name" name="event_name" class="inputsgl" style="width:95%" />
				<span class="txtstrong">*</span>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-lbpm-engine" key="lbpm.eventType"/>
			</td>
			<td width=35%>
				<select id="event_type" onchange="AttributeObject.changeEventType(this);">
					<option value=""><bean:message key="page.firstOption" /></option>
				</select>
				<span class="txtstrong">*</span>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="sys-lbpm-engine" key="lbpm.listenerType"/>
			</td>
			<td width=35%>
				<select id="event_listener" onchange="AttributeObject.changeListener(this);">
					<option value=""><bean:message key="page.firstOption" /></option>
				</select>
				<span class="txtstrong">*</span>
			</td>
		</tr>
		<tr id="TR_EventType" style="display:none">
			<td colspan="2" height="300px">
				<iframe id="IF_EventType" src="" frameborder="0" scrolling="yes" width="100%" height="100%"></iframe>
			</td>
		</tr>
		<tr id="TR_Listener" style="display:none">
			<td colspan="2" height="300px">
				<iframe id="IF_Listener" src="" frameborder="0" scrolling="yes" width="100%" height="100%"></iframe>
			</td>
		</tr>
	</table>
	<br />
	<div id="DIV_EditButtons" style="display:none">
		<input name="btnOK" type="button" class="btnopt" onclick="if(AttributeObject.submitDocument())window.close();" value="<kmss:message key="FlowChartObject.Lang.OK" bundle="sys-lbpm-engine" />" />
		&nbsp;&nbsp;&nbsp;&nbsp;
		<input name="btnCancel" type="button" class="btnopt" onclick="window.close();" value="<kmss:message key="FlowChartObject.Lang.Cancel" bundle="sys-lbpm-engine" />" />
	</div>
	<div id="DIV_ReadButtons" style="display:none">
		<input name="btnClose" type="button" class="btnopt" onclick="window.close();" value="<kmss:message key="FlowChartObject.Lang.Close" bundle="sys-lbpm-engine" />" />
	</div>
</center>
</body>
</html>