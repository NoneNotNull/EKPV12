<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>
FlowChartObject.Lang.Include('sys-lbpmservice');
FlowChartObject.Lang.Include('sys-lbpmservice-node-robotnode');
</script>

<table width="750px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
		<table width="100%" class="tb_normal">
			<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
			<tr>
				<td width="15%"><kmss:message key="FlowChartObject.Lang.Node.robotType" bundle="sys-lbpmservice-node-robotnode" /></td>
				<td>
					<select id="category" onchange="changeCategory(this);">
						<option><kmss:message key="FlowChartObject.Lang.pleaseSelect" bundle="sys-lbpm-engine" /></option>
					</select>
					<select id="type" onchange="changeType(this);">
						<option><kmss:message key="FlowChartObject.Lang.pleaseSelect" bundle="sys-lbpm-engine" /></option>
					</select>
				</td>
			</tr>
			<tr>
				<td colspan="2" height="300px">
					<iframe id="IF_Parameter" src="" frameborder="0" scrolling="yes" width="100%" height="100%"></iframe>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Event" bundle="sys-lbpm-engine" />">
		<td>
		<c:import url="/sys/lbpm/flowchart/page/node_event_attribute.jsp" charEncoding="UTF-8" />
		</td>
	</tr>
</table>

<script>
// 格式化特殊字符
function formatJson(value) {
	return value.replace(/"/ig,'\\"').replace(/\r\n/ig,'\\r\\n');
}
// 类型选项
RobotCategories = new Array();
// 分类对象
function RobotCategory(name) {
	this.name = name || '';
	this.subCategories = new Array();
};
// 子分类对象
function RobotSubCategory(name, url, unid) {
	this.name = name || '';
	this.url = url || '';
	this.unid = unid || '';
};
// 获得分类对象，根据name
function getCategoryByName(name) {
	if (name) {
		for (var i = 0, length = RobotCategories.length; i < length; i++)
			if (RobotCategories[i].name == name)
				return RobotCategories[i];
	}
	return null;
};

AttributeObject.Init.AllModeFuns.push(function() {
	initType();
	//window.dialogHeight = "450px";
	window.dialogWidth = "800px";
});

var NodeData = AttributeObject.NodeData;
var NodeContent = NodeData.content;

function initType() {
	var nodesValue = new KMSSData().AddBeanData("robotNodeConfigService&modelName=" + FlowChartObject.ModelName).GetHashMapArray();
	var objCategory = document.getElementById("category");
	// 由于更改为扩展模式，为了向下兼容...
	var _nUnid = NodeData.unid || null, delimiters = "@Robot@";
	if (_nUnid != null && _nUnid.lastIndexOf(delimiters) == -1) {
		_nUnid = "*" + delimiters + _nUnid;
	}
	// 输出主分类和子分类的选项
	var selectCategory = null, typeSelectIndex = -1;
	for (var i = 0, length = nodesValue.length; i < length; i++) {
		var _node = nodesValue[i];
		var _category = _node["category"];
		if (_category) {
			var type = _node["type"] || "";
			var url = _node["url"] || "";
			var unid = _node["unid"] || "";
			// 获得分类对象
			var oCategory = getCategoryByName(_category);
			if (!oCategory) {
				oCategory = new RobotCategory(_category);
				RobotCategories.push(oCategory);
				// 添加选项
				objCategory.options[objCategory.options.length] = new Option(_category);
			}
			// 记录子分类对象
			oCategory.subCategories.push(new RobotSubCategory(type, Com_Parameter.ContextPath + cleanPath(url), unid));
			//若没有初始化配置，则_nUnid为null，此时默认为第一个选项。
			if (_nUnid == null) _nUnid = unid;
			// 记录当前选中
			if (unid == _nUnid) {
				selectCategory = oCategory;
				typeSelectIndex = oCategory.subCategories.length;
			}
		}
	}
	if (selectCategory == null) return;
	// 初始化选中状态
	for (var i = 0, length = RobotCategories.length; i < length; i++) {
		if (RobotCategories[i] == selectCategory) {
			objCategory.selectedIndex = (i + 1);
			break;
		}
	}
	// 当前分类对象的子分类集
	var objType = document.getElementById("type");
	var currSubRobotCategory = selectCategory.subCategories;
	for (var i = 0, length = currSubRobotCategory.length; i < length; i++) {
		objType.options[objType.options.length] = new Option(currSubRobotCategory[i].name, currSubRobotCategory[i].unid);
	}
	objType.selectedIndex = typeSelectIndex;
	// 调用相应机器人
	var iframe = document.getElementById("IF_Parameter");
	Com_AddEventListener(iframe, "load", iframeOnload);
	// 调用相应机器人的配置页面
	iframe.src = currSubRobotCategory[typeSelectIndex - 1].url;
};

function cleanPath(url) {
	return (url.indexOf("/") == 0) ? url.substr(1) : url;
}

function iframeOnload() {
	if (!AttributeObject.isNodeCanBeEdit) {
		AttributeObject.Utils.disabledOperation(window.frames["IF_Parameter"].document);
	}
};

function changeCategory(owner) {
	var objType = document.getElementById("type");
	objType.options.length = 0;
	objType.options[objType.options.length] = new Option(FlowChartObject.Lang.pleaseSelect);
	// 请选择时...
	var index = owner.selectedIndex;
	if (owner.options[index].text == FlowChartObject.Lang.pleaseSelect) return;
	// 当前分类对象的子分类集
	var currSubRobotCategory = RobotCategories[index - 1].subCategories;
	for (var i = 0, length = currSubRobotCategory.length; i < length; i++) {
		objType.options[objType.options.length] = new Option(currSubRobotCategory[i].name, currSubRobotCategory[i].unid);
	}
};

function changeType(owner) {
	// 请选择时...
	var index = owner.selectedIndex;
	if (owner.options[index].text == FlowChartObject.Lang.pleaseSelect) return;
	// 当前子分类
	var objCategory = document.getElementById("category");
	var currSubRobotCategory = RobotCategories[objCategory.selectedIndex - 1].subCategories;
	document.getElementById("IF_Parameter").src = currSubRobotCategory[index - 1].url;
};

AttributeObject.CheckDataFuns.push(function(data) {
	var robotType = document.getElementById("type");
	var robotTypeOption = robotType.options[robotType.selectedIndex];
	if (robotTypeOption.text == FlowChartObject.Lang.pleaseSelect) {
		alert(FlowChartObject.Lang.Node.robot_CheckType);
		return false;
	}

	var contentDoc = document.getElementById("IF_Parameter");
	var json = contentDoc.contentWindow.returnValue();
	if (json == null) return false;

	data.unid = robotTypeOption.value;
	data.content = json;
	
	return true;
});
</script>