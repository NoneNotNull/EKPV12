<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.authorization.constant.ISysAuthConstant"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
function selectProperty(){
	var url = "sysPropertyFilterSetting.do?method=dialog";
	var args = {
		filterBean:$("input[name='fdFilterBean']").val(),
		defineId:$("input[name='fdDefineId']").val(),
		defineName:$("input[name='fdDefineName']").val(),
		modeName:$("input[name='fdModelName']").val(),
		dataType:$("input[name='fdDataType']").val(),
		propertyName:$("input[name='fdPropertyName']").val()
	}
	var content = window.showModalDialog(url,args,"dialogwidth:560px;dialogheight:564px;resizable:1","scroll:0");
	if(content && content.isTrue){
		$("input[name='fdDataType']").attr("value", content.dataType);
		$("input[name='fdModelName']").attr("value", content.modelName);
		$("input[name='fdFilterBean']").attr("value",  content.filterBean);
		$("input[name='fdDefineId']").attr("value",  content.fdDefineId);
		$("input[name='fdDefineName']").attr("value", content.fdDefineName);
		$("input[name='fdPropertyName']").attr("value", content.propertyName);
		//更新设置内容
		updateUI();
	}
}
function updateUI(){
	if(getIsLongFilter()){
		$("#scopeSetting").css("display","");
	}else{
		$("#scopeSetting").css("display","none");
	}
}
Com_IncludeFile("dialog.js|jquery.js");
function sysPropFilterBeanChange(val) {
	if(val != null){
		var url = '<c:url value="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do" />?method=add';
		var fdName = document.getElementsByName("fdName")[0].value;
		url = Com_SetUrlParameter(url, "name", fdName);
		location.href = Com_SetUrlParameter(url, "filterBean", val);
	}
}
function sysPropDefineChange() {
	var fdFilterBean = document.getElementsByName("fdFilterBean")[0].value;
	if(fdFilterBean == "") {
		alert('<bean:message bundle="sys-property" key="sysPropertyFilterSetting.selectFilterType"/>');
		return;
	}
	var fdDataType = document.getElementsByName("fdDataType")[0].value;
	if(fdDataType == "") {
		alert('<bean:message bundle="sys-property" key="sysPropertyFilterSetting.dataTypeNotNull"/>');
		return;
	}
	var fdModelName = document.getElementsByName("fdModelName")[0].value;
	Dialog_Tree(false, 'fdDefineId', 'fdDefineName', ',', 'sysPropertyPropListService&fdParentId=!{value}&fdDataType='+fdDataType+'&fdModelName='+fdModelName+'&fdFilterBean='+fdFilterBean, 
			'<bean:message  bundle="sys-property" key="table.sysPropertyDefine"/>', null, null, null, null, null, 
			'<bean:message  bundle="sys-property" key="table.sysPropertyDefine"/>');
}



function checkFilterName(){

	referFilterScope();
	
//提交前，校验类别名称唯一性
	var fdName=document.getElementsByName("fdName")[0].value ; 
	var fdId='${sysPropertyFilterSettingForm.fdId}';
	if(fdName != "" && fdName != null){
		fdName=encodeURI(fdName) ; //中文两次转码
		fdName=encodeURI(fdName)  ;
		var url="sysPorpertyFilterSettingCheckService&type=1&fdName="+fdName+"&fdId="+fdId ;
		var data = new KMSSData(); 
		var rtnVal =data.AddBeanData(url).GetHashMapArray()[0];
		var flag=rtnVal["flag"];
			   	if(flag=='true'){
			   		return true;
			   	}else{
			   		 alert("筛选名称已存在，请更换筛选名称。");
			   		return false;
			   	}
	}else{
		 alert("筛选名称不能为空。");
		 return false;
	}

}

/**
 * 提交范围对象值
 */
function referFilterScope(){

	if(getIsLongFilter()){
		var filterScopes = $("tbody#filterScope tr");
		filterScopes.each(function(i,domEle){
			filterSetting.scope[i].fdId = i;
			filterSetting.scope[i].fdMin = $(domEle).children().eq(2).children().val();
			filterSetting.scope[i].fdMax =  $(domEle).children().eq(3).children().val();
		})
		var json = toJson(filterSetting);
		$("input[name='fdParams']").val(json);
	}else{
		$("input[name='fdParams']").val("");
	}
}


/**
 * 对象转JSON
 */
function toJson(object){
    if (object === null) return ''; 
    var results = []; 
    
    for (var property in object) { 
      	var value = object[property]; 
	    if(typeof value=="object")value = toJson(value);
	    if(object.length){
	     	results.push(value||''); 
		}else{
	     	results.push('"' +property + '":' + (value||'""')); 
		}
    } 
    if(object.length){
	    return '[' + results.join(',') + ']'; 
    }else{
	    return '{' + results.join(',') + '}'; 
    }
}
//定义json对象
var filterSetting = {
	scope:[]
};


function addDialog(){
	referFilterScope();
	var len = filterSetting.scope.length;
	filterSetting.scope[len] = {};  
	filterSetting.scope[len].fdId = len;
	filterSetting.scope[len].fdMin = "";
	filterSetting.scope[len].fdMax = "";
	refreshNavField();
}


function refreshNavField(){
	var navs = $("#filterScope");
	navs.html("");
	for(i=0;i<filterSetting.scope.length;i++){
		var xtr = $("<tr></tr>");
		xtr.append($("<td><input name='navIndex' type='checkbox' value='"+i+"' "+(filterSetting.scope[i].checked ? "checked" : "")+"/></td>"));
		xtr.append($("<td>"+(i+1)+"</td>"));
		xtr.append($("<td><input type='text' name='fdNavs["+i+"].fdMin' onblur='validatorNumber(this)' value='"+filterSetting.scope[i].fdMin+"' class='inputsgl' style='width:85%' /></td>"));
		xtr.append($("<td><input type='text' name='fdNavs["+i+"].fdMax' onblur='validatorNumber(this)' value='"+filterSetting.scope[i].fdMax+"' class='inputsgl' style='width:85%' /></td>")); 
		navs.append(xtr);
	}
}

/**
 * 验证数字
 */
function validatorNumber(e){
	if(!e.value) return ; 
	var strP=/^\d+(\.\d+)?$/; 
	if(!strP.test(e.value)){
		e.value = "";
		 alert("范围只能输入数字类型的值"); 
		 return;
	}
	try{ 
		if(parseFloat(e.value)!=e.value){
			e.value = "";
			alert("范围只能输入数字类型的值");
			return;
		}
	} 
	catch(ex) 
	{ 
		e.value = "";
		alert("范围只能输入数字类型的值"); 
	} 
	return true; 
}

function upNav(){ 
	$("input[name='navIndex']").each(function(i){
		if($(this).is(":checked")){
			filterSetting.scope[i].checked = true;
			moveUp(i)
		}else{
			filterSetting.scope[i].checked = false;
		}
	}); 
	refreshNavField();
}

function moveUp(row){
	if(row <= 0)
		return;
	var xval = [];
	for(i=0;i<filterSetting.scope.length;i++){
		if(row-1 == i){
			xval[xval.length] = filterSetting.scope[row];
		}else if(row == i){
			xval[xval.length] = filterSetting.scope[row-1];
		}else{
			xval[xval.length] = filterSetting.scope[i];
		}
	}
	filterSetting.scope = xval; 
}

function downNav(){ 
	var ids = [];
	$("input[name='navIndex']").each(function(i){
		if($(this).is(":checked")){
			filterSetting.scope[i].checked = true;
			ids[ids.length] = i;
		}else{
			filterSetting.scope[i].checked = false;
		}
	});  
	ids = ids.reverse();
	for(m=0;m<ids.length;m++){
		moveDown(ids[m]);
	}
	refreshNavField();
}

function moveDown(row){
	if(row >= filterSetting.scope.length-1)
		return;
	var xval = [];
	for(i=0;i<filterSetting.scope.length;i++){
		if(row+1 == i){
			xval[xval.length] = filterSetting.scope[row];
		}else if(row == i){
			xval[xval.length] = filterSetting.scope[row+1];
		}else{
			xval[xval.length] = filterSetting.scope[i];
		}
	}
	filterSetting.scope = xval;
}

function delNav(){
	var ids = [];
	if(confirm('<bean:message bundle="sys-property" key="sysPropertyFilterSetting.confirmDelete"/>')){
		$("input[name='navIndex']").each(function(i){
			if($(this).is(":checked")){
				ids[ids.length] = i;
			}
		});
		ids = ids.reverse();
		for(m=0;m<ids.length;m++){
			delRow(ids[m]);
		}
	}
	refreshNavField();
}

function delRow(row){
	var xval = [];
	for(i=0;i<filterSetting.scope.length;i++){
		 if(row != i){
			 xval[xval.length] = filterSetting.scope[i];
		 }
	}
	filterSetting.scope = xval;
}

function checkAll(obj){
	$("input[name='navIndex']").attr("checked",obj.checked);
}
</script>
<html:form action="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do">
<div id="optBarDiv">
	<c:if test="${sysPropertyFilterSettingForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="if( checkFilterName()) Com_Submit(document.sysPropertyFilterSettingForm, 'save', 'name:filterBean');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="if( checkFilterName()) Com_Submit(document.sysPropertyFilterSettingForm, 'saveadd', 'name:filterBean');">
	</c:if>
	<c:if test="${sysPropertyFilterSettingForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="referFilterScope(); Com_Submit(document.sysPropertyFilterSettingForm, 'update');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyFilterSetting2"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdName"/>
		</td><td width="35%">
			<xform:text property="fdName" style="width:85%;"/>
		</td>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdIsEnabled"/>
		</td><td>
			<xform:radio property="fdIsEnabled">
				<xform:enumsDataSource enumsType="common_yesno_property" />
			</xform:radio>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			 <bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine"/>
		</td><td width="85%" colspan="3">
			<html:hidden property="fdDefineId" />
			<html:hidden property="fdPropertyName" />
			<html:hidden property="fdFilterBean" />
			<input name="fdDefineName" value="<c:out value='${sysPropertyFilterSettingForm.fdDefineName}' />" validate="required" title='<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine"/>' subject='<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine"/>' readonly="true" class="inputsgl" style="width: 85%" />
			<span class="txtstrong">*</span>
			 <a href="javascript:void(0)" onclick="selectProperty();"><bean:message key="dialog.selectOther" /></a>
			<xform:text property="fdDataType" showStatus="noShow" />
			<xform:text property="fdModelName" showStatus="noShow" />
		</td>
	</tr>
	<c:if test="${not empty configFile}">
		<c:import url="${configFile}" charEncoding="UTF-8" />
	</c:if>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdTemplateNames"/>
		</td><td colspan="3" width="85%">
			<c:out value="${sysPropertyFilterSettingForm.fdTemplateNames}" />
		</td>
	</tr>
	 
	<tr id="scopeSetting" style="display:none;">
		<td class="td_normal_title" width="15%">
			范围设置
			<html:hidden property="fdParams" value="${sysPropertyFilterSettingForm.fdParams}"/>
		</td>
		<td colspan="3">
			<table class="tb_normal" width=99%>
				<tr>
					<td colspan="4" align="right">
						<a href="javascript:void(0)"
							onclick="addDialog();"><img style="cursor: pointer"
							border="0" class="optStyle"
							src='<c:url value="/resource/style/default/icons/add.gif"/>' /></a>
						<a href="javascript:void(0)" onclick="delNav();"><img
							style="cursor: pointer" border="0" class="optStyle"
							src='<c:url value="/resource/style/default/icons/delete.gif"/>' /></a>
						<a href="javascript:void(0)" onclick="upNav();"><img
							style="cursor: pointer" border="0" class="optStyle"
							src='<c:url value="/resource/style/default/icons/up.gif"/>' /></a>
						<a href="javascript:void(0)" onclick="downNav();"><img
							style="cursor: pointer" border="0" class="optStyle"
							src='<c:url value="/resource/style/default/icons/down.gif"/>' /></a>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="15%">
						<input type="checkBox" onclick="checkAll(this);" name="allCheck">
					</td>
					<td  class="td_normal_title" width="25%">
						序号
					</td>
					<td  class="td_normal_title" width="30%">
						最小边界
					</td>
					<td  class="td_normal_title" width="30%">
						最大边界
					</td>
				</tr>
				<tbody id="filterScope">

				</tbody>
			</table>
		</td>
	</tr>
	<%-- 所属场所 --%>
	<% if(ISysAuthConstant.IS_AREA_ENABLED) { %> 
			<input type="hidden" name="authAreaId" value="${sysPropertyFilterSettingForm.authAreaId}"> 
	<% } %>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
function getIsLongFilter(){
	return $("input[name='fdFilterBean']").val()=="sysPropertyLongTextFilter" || $("input[name='fdFilterBean']").val()=="sysPropertyDoubleTextFilter";
}
$(document).ready(function(){
	if(getIsLongFilter()){
		$("#scopeSetting").css("display","");
		var json = $("input[name='fdParams']").val();
		if(!json)return;
		var items = eval('('+json+')').scope;
		for(i in items){
			filterSetting.scope[i] = {
				"fdId":items[i].fdId||'',
				"fdMin":items[i].fdMin||'',
				"fdMax":items[i].fdMax||''
			};
		}
		//
		refreshNavField();
	}
})
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>