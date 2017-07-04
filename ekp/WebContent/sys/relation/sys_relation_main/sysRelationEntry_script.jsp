<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
// 默认全文检索
var SysRelation_Type = "4";
// 是否更改类型
var SysRelation_IsChangeType = false;
var dialogRtnValue = null;
var dialogObject = null;
if(window.showModalDialog){
	dialogObject = window.dialogArguments;
}else{
	dialogObject = opener._rela_dialog;
}
Com_AddEventListener(window, "beforeunload", beforeClose);

function Com_DialogReturn(value){
	window.dialogRtnValue = value;
	window.close();
}

function beforeClose(){
	dialogObject.rtnRelaData = dialogRtnValue;
	dialogObject.AfterShow();
}

function changeRelationType(value) {
	if (value == null) {
		value = SysRelation_Type;
	}
	if (SysRelation_Type != value) {
		// 更改类型
		SysRelation_IsChangeType = true;
	}
	var url = Com_Parameter.ContextPath+"sys/relation/relation.do?method=changeRelationType&fdType=" + value + "&currModelName=${param.currModelName}&frameName=sysRelationEntry";
	var iframe = document.getElementById("sysRelationEntry");
	// 加载相应搜索类型的页面
	iframe.setAttribute("src",encodeURI(url));
}
function resizeWindowHeight(){
	var table = document.getElementById("relationEntry");
	window.innerHeight = (table.offsetHeight + 50) + "px";
}
Com_AddEventListener(window, "load", function(){
	if (dialogObject != null && dialogObject.relationEntry!=null && dialogObject.relationEntry.fdType!=null && dialogObject.relationEntry.fdType!='') {
		SysRelation_Type = dialogObject.relationEntry.fdType;
		document.getElementsByName("fdOtherUrl")[0].value = dialogObject.relationEntry.fdOtherUrl;
	}
	var _fdType = document.getElementsByName("fdType");
	for (var i = 0, len = _fdType.length; i < len; i++) {
		if (_fdType[i].value == SysRelation_Type) {
			_fdType[i].checked = true;
			break;
		}
	}
	setTimeout("changeRelationType()", 100);
});
</script>
