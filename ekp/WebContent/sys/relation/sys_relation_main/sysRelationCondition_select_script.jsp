<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
Com_IncludeFile("common.js|calendar.js|dialog.js|validator.jsp|jquery.js", null, "js");
function createRelationEntry(){
	// fdModuleName 为模块中文名称，fdModuleModelName 为业务模型名称
	return {fdId:"<%=com.landray.kmss.util.IDGenerator.generateID()%>",fdType:"${fdType}",
		fdModuleModelName:"${fdModuleModelName}",fdModuleName:"${fdModuleName}",fdOrderBy:"",
		fdOrderByName:"",fdPageSize:"10",fdRelationProperty:"",fdParameter:"",relationConditions:{}};
}

var relationEntry = {};
//初始化relationEntry
if(top.dialogObject == null || top.dialogObject.relationEntry==null
		|| parent.parent.SysRelation_IsChangeType || parent.SysRelation_IsChangeModule){
	// 新建，修改类型，修改模块
	relationEntry = createRelationEntry();
} else {
	// 编辑
	relationEntry = top.dialogObject.relationEntry;
}

Com_AddEventListener(window, "load", function(){
	fullRelationEntry();
	try {
		// 初始化扩展数据
		window.frames["sysRelationExtendCondition"].config_iniThirdRelationConfig(unescape(relationEntry.fdParameter));
	} catch(e) {
	}
});

function createRelationCondition(){
	return {fdId:"",fdItemName:"",fdParameter1:"",fdParameter2:"",fdParameter3:"",fdBlurSearch:"",fdVarName:""};
}

// 清空
function clearRelationCondition(condition){
	for(var property in condition){
		if(property=="fdId" || property=="fdItemName")
			continue;
		condition[property]="";
	}
}

function doOK(){
	var tbObj = document.getElementById("TB_Condition");
	var relationConditions = relationEntry.relationConditions;
	if(typeof relationConditions =="undefined")relationConditions={};
	var count = 0;
	for(var i=0; i<tbObj.rows.length; i++){
		var fdItemName = document.getElementsByName("fdItemName_"+i)[0].value;		
		var relationCondition = relationConditions[fdItemName];
		if(typeof relationCondition =="undefined")relationCondition=createRelationCondition();
		relationCondition.fdItemName = fdItemName;
		clearRelationCondition(relationCondition);
		//模糊搜索
		var fdBlurSearch_ = document.getElementsByName("fdBlurSearch_"+i)[0];
		if(fdBlurSearch_!=null && fdBlurSearch_.checked){
			relationCondition.fdBlurSearch=fdBlurSearch_.value;
		}
		//关联搜索
		var fdVarName_ = document.getElementsByName("fdVarName_"+i)[0];
		if(fdVarName_!=null && fdVarName_.checked){
			relationCondition.fdVarName=fdVarName_.value;
		}
		var type = tbObj.rows[i].getAttribute("kmss_type");
		var fdParameters = document.getElementsByName("fdParameter1_"+i);
		var fdParameter1_ = fdParameters[0];
		//增加为空值判断 by chenyy
		if ((type=="string" || type=="number") && fdParameter1_.type == 'checkbox') {
			var isHasValue = false;
			//当条件实体为枚举复选框，如果没有没有选择返回
			for(var j=0; j<fdParameters.length; j++){
				if(fdParameters[j].checked)
					isHasValue = true;
			}
			if(!isHasValue){
				//没有值，则返回
				continue;
			}
		}else{
			if(fdParameter1_==null)continue;
		}
		
		var fdParameter2_ = document.getElementsByName("fdParameter2_"+i)[0];
		var fdParameter3_ = document.getElementsByName("fdParameter3_"+i)[0];
		switch(type){
		case "string":
			relationCondition.fdBlurSearch=1;	//string类型默认为模糊查询，不需要通过页面设置
			//扩展属性 by chenyy
			if (fdParameters[0].type == 'checkbox') {
				var value = "";
				for(var j=0; j<fdParameters.length; j++){
					if(fdParameters[j].checked)
						value += ";"+fdParameters[j].value;
				}
				if(value!="")relationCondition.fdParameter1 = value.substring(1);
			}else{
				relationCondition.fdParameter1 = fdParameter1_.value;//string类型的值
			}
			
		break;
		case "date":
		case "number":
			//扩展属性 by chenyy
			if (type=="number" && fdParameters[0].type == 'checkbox') {
				var value = "";
				for(var j=0; j<fdParameters.length; j++){
					if(fdParameters[j].checked)
						value += ";"+fdParameters[j].value;
				}
				if(value!="")relationCondition.fdParameter1 = value.substring(1);
			}else{
				if(type=="date"){
					var validateFun = isDate;
				}else{
					var validateFun = isNumber;
				}
				var logicStr = fdParameter1_.options[fdParameter1_.selectedIndex].value;
				if(logicStr=="bt"){
					if(fdParameter2_.value=="" && fdParameter3_.value=="")continue;
					if(fdParameter2_.value == "" && fdParameter3_.value != "" 
						|| fdParameter2_.value != "" && fdParameter3_.value == ""){
						alert('<kmss:message key="errors.required" />'.replace("{0}", tbObj.rows[i].cells[0].innerText));
						return;
					}
					if((!validateFun(fdParameter3_, tbObj.rows[i].cells[0].innerText))||(!validateFun(fdParameter3_, tbObj.rows[i].cells[0].textContent)))return;
				}else{
					if(fdParameter2_.value=="")continue;
				}
				if((!validateFun(fdParameter2_, tbObj.rows[i].cells[0].innerText))||(!validateFun(fdParameter2_, tbObj.rows[i].cells[0].textContent)))return;
				relationCondition.fdParameter1 = fdParameter1_.value;//date、number类型逻辑比较值
				relationCondition.fdParameter2 = fdParameter2_.value;
				if(logicStr=="bt"){
					relationCondition.fdParameter3 = fdParameter3_.value;
				}
			}
		break;
		case "foreign":
			if(fdItemName=="docKeyword"){
				relationCondition.fdParameter2 = fdParameter2_.value;
			}else{
				if(fdBlurSearch_!=null && fdBlurSearch_.checked){//是否模糊查询
					relationCondition.fdParameter2 = fdParameter2_.value;
				}else{
					var includeChild = document.getElementsByName("t1_"+i)[0];
					if(includeChild!=null && includeChild.checked){//是否包含子节点
						if(fdParameter1_.value!=""){
							relationCondition.fdParameter3 = fdParameter1_.value;
							var t0 = document.getElementsByName("t0_"+i)[0];
							relationCondition.fdVarName = t0.value ;//借用fdVarName保存名称值
						}
					}
					else if(fdParameter1_.value!=""){//一般查询
						relationCondition.fdParameter1 = fdParameter1_.value;
						var t0 = document.getElementsByName("t0_"+i)[0];
						relationCondition.fdParameter2 = t0.value ;//借用fdParameter2保存名称值
					}
				}
			}
		break;
		case "enum":
			var value = "";
			var enums = document.getElementsByName("fdParameter1_"+i);
			for(var j=0; j<enums.length; j++){
				if(enums[j].checked)
					value += ";"+enums[j].value;
			}
			if(value!="")relationCondition.fdParameter1 = value.substring(1);
		break;
		}
		relationConditions[relationCondition.fdItemName] = relationCondition;		
	}
	relationEntry.relationConditions = relationConditions;
	try {
		// 提交扩展数据
		var data = window.frames["sysRelationExtendCondition"].config_getThirdRelationConfig();
		if (data != null && data != "") {
			relationEntry.fdParameter = escape(data);
		}
	} catch(e) {
	}
	top.Com_DialogReturn(relationEntry);
}

function fullRelationEntry(){
	var tbObj = document.getElementById("TB_Condition");
	var relationConditions = relationEntry.relationConditions;
	if(typeof relationConditions =="undefined")return;
	for(var i=0; i<tbObj.rows.length; i++){
		var fdItemName = document.getElementsByName("fdItemName_"+i)[0].value; 
		var relationCondition = relationConditions[fdItemName];		
		if(typeof relationCondition =="undefined")continue;
		//模糊搜索
		var fdBlurSearch_ = document.getElementsByName("fdBlurSearch_"+i)[0];
		if(fdBlurSearch_!=null && relationCondition.fdBlurSearch=="1"){
			fdBlurSearch_.checked=true;
		}
		//关联搜索
		var fdVarName_ = document.getElementsByName("fdVarName_"+i)[0];
		if(fdVarName_!=null && relationCondition.fdVarName!="" 
			&& relationCondition.fdVarName==fdItemName){
			fdVarName_.checked=true;
		}		
		var type = tbObj.rows[i].getAttribute("kmss_type");
		var fdParameters = document.getElementsByName("fdParameter1_"+i);
		var fdParameter1_ = fdParameters[0];
		var fdParameter2_ = document.getElementsByName("fdParameter2_"+i)[0];
		var fdParameter3_ = document.getElementsByName("fdParameter3_"+i)[0];
		var values = relationCondition.fdParameter1.split(";");
		switch(type){
		case "string":
			//判断扩展的自定义枚举
			if (fdParameter1_.type == 'checkbox') {
				for(var j=0; j<fdParameters.length; j++){
					if(Com_ArrayGetIndex(values,fdParameters[j].value)>-1){
						fdParameters[j].checked = true;
					}
				}
			}else{
				fdParameter1_.value = relationCondition.fdParameter1 ;//string类型的值
			}
		break;
		case "date":
		case "number":
			if (type=='number' && fdParameter1_.type == 'checkbox') {
				for(var j=0; j<fdParameters.length; j++){
					if(Com_ArrayGetIndex(values,fdParameters[j].value)>-1){
						fdParameters[j].checked = true;
					}
				}
			}else{
				fdParameter1_.value = relationCondition.fdParameter1;//date、number类型逻辑比较值
				fdParameter2_.value = relationCondition.fdParameter2;
				fdParameter3_.value = relationCondition.fdParameter3;
			}
			
		break;
		case "foreign":
			if(fdItemName=="docKeyword"){
				fdParameter2_.value = relationCondition.fdParameter2 ;
			}else{
				if(relationCondition.fdParameter1!=""){//一般查询
					fdParameter1_.value = relationCondition.fdParameter1;
					var t0 = document.getElementsByName("t0_"+i)[0];
					t0.value = relationCondition.fdParameter2 ;//借用fdParameter2保存名称值
					break;
				}
				if(relationCondition.fdBlurSearch=="1"){//是否模糊查询
					fdParameter2_.value = relationCondition.fdParameter2 ;
					break;
				}
				var includeChild = document.getElementsByName("t1_"+i)[0];
				if(relationCondition.fdParameter3!=""){//是否包含子节点
					includeChild.checked=true;
					fdParameter1_.value = relationCondition.fdParameter3;
					var t0 = document.getElementsByName("t0_"+i)[0];
					t0.value = relationCondition.fdVarName ;//借用fdVarName保存名称值
				}
			}
		break;
		case "enum":
			var enums = document.getElementsByName("fdParameter1_"+i);
			for(var j=0; j<enums.length; j++){
				if(Com_ArrayGetIndex(values,enums[j].value)>-1){
					enums[j].checked = true;
				}
			}
		break;
		}
	}
	resetDisplay();
}

function resetDisplay(){
	var tbObj = document.getElementById("TB_Condition");
	for(var i=0; i<tbObj.rows.length; i++){
		refreshRelationDisplay(i);
		refreshMatchDisplay(i);
		var type = tbObj.rows[i].getAttribute("kmss_type");
		switch(type){
		case "date":
		case "number":
			var fields = document.getElementsByName("fdParameter1_"+i);
			if(type=='number' && fields[0].type == 'checkbox'){}else{
				var fdParameter1_ = document.getElementsByName("fdParameter1_"+i)[0] ;
				refreshLogicDisplay(fdParameter1_,"span_fdParameter3_"+i);
			}
		break;
		}
	}
	dyniFrameSize();
}

function refreshMatchDisplay(index){
	var obj = document.getElementsByName("fdBlurSearch_"+index)[0];
	if(obj==null)return;
	for(var tbObj=obj; tbObj.tagName!="TR"; tbObj=tbObj.parentNode);
	var type = tbObj.getAttribute("kmss_type");
	if(type=="foreign"){
		var tmp = document.getElementsByName("fdItemName_"+index)[0] ;
		if(tmp==null || tmp.value=="docKeyword")return;
		var cells = tbObj.cells[1].getElementsByTagName('td');
		if( obj.checked){
			$(cells[0]).hide();
			$(cells[1]).show();
		}else{
			$(cells[0]).show();
			$(cells[1]).hide();
		}
	}
}

function refreshLogicDisplay(obj, id){
	var spanObj = document.getElementById(id);
	if(obj!=null && obj.options[obj.selectedIndex].value=="bt")
		spanObj.style.display = "";
	else
		spanObj.style.display = "none";
}

// 验证数字
function isNumber(field, message){
	if(field.value.split(".").length<3)
		if(!(/[^\d\.]/gi).test(field.value))
			return true;
	alert('<bean:message key="errors.number" />'.replace("{0}", message));
	field.focus();
	return false;
}
// struts验证日期
var conditionForm_DateValidations = null;
function isDate(field, message){
	conditionForm_DateValidations = function(){
		this.a0 = new Array(
			field.name,
			'<kmss:message key="errors.date" />'.replace("{0}", message),
			new Function ("varName", 'this.datePattern=\'<bean:message key="date.format.date" />\';  return this[varName];')
		);
	};
	return validateDate(document.forms["conditionForm"]);
}
function refreshRelationDisplay(index){
	var obj = document.getElementsByName("fdVarName_"+index)[0];
	if(obj==null)return;
	for(var tbObj=obj; tbObj.tagName!="TR"; tbObj=tbObj.parentNode);
	if(obj.checked){
		$(tbObj.cells[1]).hide();
		$("#tipDiv_"+index).show();
		$(tbObj.cells[2]).show();
	}else{
		$(tbObj.cells[1]).show();
		$("#tipDiv_"+index).hide();
		$(tbObj.cells[2]).hide();
	}
}
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById("div_conditionCon");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 130) + "px";
			parent.dyniFrameSize();
		}
	} catch(e) {
	}
}


//显示全部条件,当条件超过20个时，后面的条件隐藏，点击“显示全部”，可以显示所有条件。
function viewAllConditions(){
	var tbObj = document.getElementById("TB_Condition");
	var relationConditions = relationEntry.relationConditions;
	if(typeof relationConditions =="undefined")return;
	for(var i=0; i<tbObj.rows.length; i++){
		tbObj.rows[i].style.display = "";
		
	}
	document.getElementById("viewAllP").style.display = "none";
	dyniFrameSize();
	
}
</script>
