<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
//默认模块
var SysRelation_module = "";
// 是否更改模块
var SysRelation_IsChangeModule = false;
//初始化选择要关联的模块下拉框
function initDocument(){	
	var moduleObj = document.getElementById("module");
	var selectOption = "${param.currModelName}";
	if (top.dialogObject != null && top.dialogObject.relationEntry!=null
			&& top.dialogObject.relationEntry.fdModuleModelName != null
			&& top.dialogObject.relationEntry.fdModuleModelName != "") {
		selectOption = top.dialogObject.relationEntry.fdModuleModelName;
	}
	<c:forEach items="${relationEntries}" varStatus="vstatus" var="entry">
		//if(Com_ArrayGetIndex(moduleKeys,'${entry.sysCfgRelation.modelName }')==-1){//把已经关联的模块不放入下拉框中
			//moduleObj.add(new Option('${entry.title }','${entry.sysCfgRelation.modelName }'));
		//}
		moduleObj.options[moduleObj.options.length] = new Option('${entry.title}', '${entry.sysCfgRelation.modelName}');
	</c:forEach>

	//增加外部关联模块
	<c:forEach items="${foreignEntrys}" varStatus="vstatus"	var="foreignEntry">
		moduleObj.options[moduleObj.options.length] = new Option('${foreignEntry.fdModuleName}', '${foreignEntry.fdId}');
	</c:forEach>
	
	if(moduleObj.options.length == 0){
		moduleObj.options[moduleObj.options.length] = new Option('<bean:message key="page.firstOption" />', "");
		return ;
	}
	//默认选中当前模块
	for (var j=0; j<moduleObj.options.length; j++) {
		if(selectOption == moduleObj.options[j].value){
			moduleObj.options[j].selected = true;
			break;
		}
	}
	SysRelation_module = moduleObj.options[moduleObj.selectedIndex].value;
	changeModule(moduleObj);
}

//选择模块后，更新下面查询条件内容
function changeModule(owner){
	var fdModuleName = owner.options[owner.selectedIndex].text;
	var fdModuleModelName = owner.options[owner.selectedIndex].value;
	if (fdModuleModelName != SysRelation_module) {
		// 修改模块
		SysRelation_IsChangeModule = true;
	}
	if (fdModuleModelName != null && fdModuleModelName != "") {
		var url = Com_Parameter.ContextPath+"sys/relation/relation.do?method=selectCondition&fdType=${param.fdType}&fdModuleName="+fdModuleName+"&fdModuleModelName="+fdModuleModelName+"&currModelName=${param.currModelName}";
		var iframe = document.getElementById("sysRelationModule");
		// 调用相应查询条件页面
		iframe.setAttribute("src",encodeURI(url));
	}
}

//根据iframe里面内容高度，自动调整iframe窗口高度以及整个弹出窗口的高度
function dyniFrameSize(iframe, parentFrame) {
	try {
		// 调整高度
		var arguObj = document.getElementById("moduleSelect");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 30) + "px";
			parent.resizeWindowHeight();
		}
	} catch(e) {
	}
}
</script>
