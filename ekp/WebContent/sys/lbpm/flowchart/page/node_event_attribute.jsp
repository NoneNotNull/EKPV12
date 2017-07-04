<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table id="TABLE_LBPM_NODE_EVENT" class="tb_normal" width=100%>
	<tr>
		<td class="td_normal_title" width="25%"><kmss:message key="FlowChartObject.Lang.Event.eventName" bundle="sys-lbpm-engine" /></td>
		<td class="td_normal_title" width="26%"><kmss:message key="FlowChartObject.Lang.Event.eventType" bundle="sys-lbpm-engine" /></td>
		<td class="td_normal_title" width="27%"><kmss:message key="FlowChartObject.Lang.Event.eventListener" bundle="sys-lbpm-engine" /></td>
		<td class="td_normal_title" width="22%">
			<a href="javascript:void(0);" onclick="AttributeObject.addNodeEvent();"><kmss:message key="FlowChartObject.Lang.Event.eventAdd" bundle="sys-lbpm-engine" /></a>
		</td>
	</tr>
	<tr KMSS_IsReferRow="1" style="display:none">
		<td>
			<input name="event_id" type="hidden" />
			<input name="event_name" class="inputsgl" style="width:95%" readonly style="border-bottom: 0px;" />
		</td>
		<td>
			<input name="event_type" type="hidden" />
			<input name="event_typeName" class="inputsgl" style="width:95%" readonly style="border-bottom: 0px;" />
			<input name="event_eventConfig" type="hidden" />
		</td>
		<td>
			<input name="event_listenerId" type="hidden" />
			<input name="event_listenerName" class="inputsgl" style="width:95%" readonly style="border-bottom: 0px;" />
			<input name="event_listenerConfig" type="hidden" />
		</td>
		<td>
			<a href="javascript:void(0);" onclick="AttributeObject.updateNodeEvent();" viewdisplay="true"><kmss:message key="FlowChartObject.Lang.Event.eventView" bundle="sys-lbpm-engine" /></a>
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();"><kmss:message key="FlowChartObject.Lang.Event.eventDelete" bundle="sys-lbpm-engine" /></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);"><kmss:message key="FlowChartObject.Lang.Event.eventUp" bundle="sys-lbpm-engine" /></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(1);"><kmss:message key="FlowChartObject.Lang.Event.eventDown" bundle="sys-lbpm-engine" /></a>
		</td>
	</tr>
</table>

<script>
var dialogObject=window.dialogArguments?window.dialogArguments:opener.Com_Parameter.Dialog; 
// 添加动态表格
DocList_Info.push("TABLE_LBPM_NODE_EVENT");
// 初始化
AttributeObject.Init.AllModeFuns.push(function() {
	var nodeData = AttributeObject.NodeData;
	if(nodeData && nodeData.events) {
		for (var i = 0, n = nodeData.events.length; i < n; i++) {
			var event = nodeData.events[i];
			if(!event.id || !event.type || !event.listenerId) {
				continue;
			}
			// 解析显示名称
			var typeObj = AttributeObject.getNodeEventType(AttributeObject.NodeObject.Type, event.type);
			if(!typeObj) continue;
			var listenerObj = AttributeObject.getNodeEventListener(typeObj, event.listenerId);
			if(!listenerObj) continue;
			AttributeObject._addNodeEvent({id: event.id, name: event.name, type: event.type, typeName: typeObj.typeName, eventConfig: event.eventConfig,
				listenerId: event.listenerId, listenerName: listenerObj.listenerName, listenerConfig: event.listenerConfig});
		}
	}
});
// 初始化事件数据
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
// 根据类型获取事件类型
AttributeObject.getNodeEventType = function(nodeType, type) {
	var nodeEvent = AttributeObject.loadNodeEvents(nodeType);
	if(nodeEvent) {
		for (var i = 0, n = nodeEvent.length; i < n; i++) {
			var event = nodeEvent[i];
			if(event.type == type) {
				return event;
			}
		}
	}
	return null;
};
// 获取事件类型下的侦听器
AttributeObject.getNodeEventListener = function(type, listenerId) {
	if(type) {
		for (var i = 0, n = type.listeners.length; i < n; i++) {
			var listener = type.listeners[i];
			if(listener.listenerId == listenerId) {
				return listener;
			}
		}
	}
	return null;
};
// 添加动态行
AttributeObject._addNodeEvent = function(event) {
	var fieldValues = new Object();
	fieldValues["event_id"] = event.id;
	fieldValues["event_name"] = (event.name ? event.name : "");
	fieldValues["event_type"] = event.type;
	fieldValues["event_typeName"] = event.typeName;
	fieldValues["event_eventConfig"] = event.eventConfig;
	fieldValues["event_listenerId"] = event.listenerId;
	fieldValues["event_listenerName"] = event.listenerName;
	fieldValues["event_listenerConfig"] = event.listenerConfig;
	DocList_AddRow("TABLE_LBPM_NODE_EVENT", null, fieldValues);
};
// 添加
AttributeObject.addNodeEvent = function() {
	dialogObject.CurrEventType = null;
	dialogObject.DocumentOnNode = window.document;
	dialogObject.AfterShow=function(rtn){
		if(rtn!=null){
			AttributeObject._addNodeEvent(rtn);
		}
	}
	AttributeObject.Utils.PopupWindow(Com_Parameter.ContextPath + "sys/lbpm/flowchart/page/node_event_select.jsp", 640, 530,
			dialogObject);
}
// 查看、更新
AttributeObject.updateNodeEvent = function() {
	var tr = DocListFunc_GetParentByTagName("TR");
	var id = $(tr).find("input[name='event_id']").val();
	var eventName = $(tr).find("input[name='event_name']").val();
	var eventType = $(tr).find("input[name='event_type']").val();
	var eventConfig = $(tr).find("input[name='event_eventConfig']").val();
	var listenerId = $(tr).find("input[name='event_listenerId']").val();
	var listenerConfig = $(tr).find("input[name='event_listenerConfig']").val();

	dialogObject.CurrEventType = {id: id, name: eventName, type: eventType, eventConfig: eventConfig, listenerId: listenerId, listenerConfig: listenerConfig};
	dialogObject.DocumentOnNode = window.document;
	dialogObject.AfterShow=function(rtn){
		if(rtn!=null){
			// 更新当前行数据
			$(tr).find("input[name='event_id']").attr("value", rtn.id);
			$(tr).find("input[name='event_name']").attr("value", rtn.name);
			$(tr).find("input[name='event_type']").attr("value", rtn.type);
			$(tr).find("input[name='event_typeName']").attr("value", rtn.typeName);
			$(tr).find("input[name='event_eventConfig']").attr("value", rtn.eventConfig);
			$(tr).find("input[name='event_listenerId']").attr("value", rtn.listenerId);
			$(tr).find("input[name='event_listenerName']").attr("value", rtn.listenerName);
			$(tr).find("input[name='event_listenerConfig']").attr("value", rtn.listenerConfig);
		}
	}
	AttributeObject.Utils.PopupWindow(Com_Parameter.ContextPath + "sys/lbpm/flowchart/page/node_event_select.jsp", 640, 530,
			dialogObject);
}
// 提交数据
AttributeObject.AppendDataFuns.push(function(nodeData) {
	nodeData.events = null;
	$("input[name='event_id']").each(function(i){
		if(i == 0) {
			nodeData.events = new Array();
		}
		var id = $(this).val();
		var name = $("input[name='event_name']").get(i).value;
		var type = $("input[name='event_type']").get(i).value;
		var eventConfig = $("input[name='event_eventConfig']").get(i).value;
		var listenerId = $("input[name='event_listenerId']").get(i).value;
		var listenerConfig = $("input[name='event_listenerConfig']").get(i).value;
		nodeData.events.push({XMLNODENAME: "event", id: id, name: name, type: type, eventConfig: eventConfig, listenerId: listenerId, listenerConfig: listenerConfig});
 	});
});
</script>