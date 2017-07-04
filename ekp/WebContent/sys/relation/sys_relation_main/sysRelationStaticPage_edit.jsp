<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp" %>
<style type="text/css"> 
ul, li{list-style-type: none;} 
ul{padding:1px;margin:0px 0px 0px 0px;height: 100px;width: 100%;}
li { float:left;width: 50%;}
.clear {clear:both; height: 0px;}
</style>
<center>
<table class="tb_normal" width="100%" id="tab_static_setting">
<input type="hidden" name="fdOtherUrl">
	<tr align="center">	
		<td class="td_normal_title"><bean:message bundle="sys-relation" key="sysRelationMain.relatedInformation" /></td>
	</tr>
	<tr>	
		<td>
			<ul id="staticPageContent">
				<li><bean:message bundle="sys-relation" key="sysRelationMain.noDocumentation" /></li>
			</ul>
			<div class="clear"></div>
		</td>
	</tr>
	<tr>	
		<td>
			<input type="button" class="btnopt" value="<bean:message key="button.add"/>" onclick="sysRelationStaticPage_add();"/>
			<input type="button" id="deleteButton" class="btnopt" value="<bean:message key="button.delete"/>" onclick="sysRelationStaticPage_delete();"/>
			<input type="button" id="editButton" class="btnopt" value="<bean:message key="button.edit"/>" onclick="sysRelationStaticPage_edit();"/>
			<input type="button" class="btnopt" value="<bean:message key="button.search"/>" onclick="sysRelationStaticPage_search();"/>
		</td>
	</tr>
</table>
<br /><br />
<input type="button" class="btnopt" value="<bean:message key="button.ok"/>" onclick="doOK();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" class="btnopt" value="<bean:message key="button.close" />" onclick="Com_CloseWindow();" />
</center>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("jquery.js|dialog.js");
</script>
<script>
var relationEntry = {};
//初始化relationEntry
if(top.dialogObject == null || top.dialogObject.relationEntry==null
		|| parent.SysRelation_IsChangeType){
	var fdOtherUrl = parent.document.getElementsByName("fdOtherUrl")[0].value;
	// 新建，修改类型
	relationEntry = createRelationEntry(fdOtherUrl);
} else {
	// 编辑
	relationEntry = top.dialogObject.relationEntry;
}
function createRelationEntry(fdOtherUrl){
	return {fdId:"<%=com.landray.kmss.util.IDGenerator.generateID()%>",fdType:"4",fdModuleName:"<bean:message bundle='sys-relation' key='sysRelationMain.fdOtherUrl' />",fdParameter:"",fdOtherUrl:fdOtherUrl};
}
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById("tab_static_setting");
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 80) + "px";
			parent.resizeWindowHeight();
		}
	} catch(e) {
	}
}
function doOK() {
	var staticContent = $('#staticPageContent').children();
	var staticInfos = new Array();
	for(var n=0;n<staticContent.length;n++){
		var liContent = staticContent[n];
		var liContChild = liContent.children;
		var staticInfo = {};
		for(var m=0;m<liContChild.length;m++){
			var propLi = liContChild[m];
			if($(propLi).attr("type") == "hidden"){
				var name = $(propLi).attr("name");
				var value = $(propLi).attr("value");
				staticInfo[name] = value;
			}
		}
		staticInfos[n] = staticInfo;
	}
	relationEntry.staticInfos = staticInfos;
	
	top.Com_DialogReturn(relationEntry);
}
var contentIndex = 0;
Com_AddEventListener(window, "load", function(){

	var staticInfos = relationEntry.staticInfos;
	if(staticInfos && staticInfos!=null){
		$('#staticPageContent').html("");
		for(var i=0;i<staticInfos.length;i++){
			var fdRelatedName = staticInfos[i]["fdRelatedName"];
			var fdRelatedUrl = staticInfos[i]["fdRelatedUrl"];
			var docName = staticInfos[i]["fdRelatedName"];
			if(docName.length>20)
				docName = docName.substring(0,20)+"..";
			
			var appendStaticHTML = '';
			contentIndex++;
			appendStaticHTML += '<li title="'+fdRelatedName+'" id="contentId'+contentIndex+'">';
			appendStaticHTML += '<input id="" type="checkbox" onclick="setSelectValue(this)"  value="'+fdRelatedName + '|' +fdRelatedUrl+'|'+'contentId'+contentIndex+'" \>';
			for(var staticProperty in staticInfos[i]){
				appendStaticHTML+="<input type=\"hidden\" name=\""+staticProperty+"\" value=\""+staticInfos[i][staticProperty]+"\">";
			}
			
			appendStaticHTML += docName;
			appendStaticHTML += '</li>';
			$('#staticPageContent').append(appendStaticHTML);
		}
	}
	
	dyniFrameSize();
	setButtionStatus();
});
//添加
function sysRelationStaticPage_add(){
	var dialog = new KMSSDialog();
	dialog.SetAfterShow(_sysRelationStaticPage_add);
	dialog.staticData = null;
	dialog.URL = '<c:url value="/sys/relation/sys_relation_main/sysRelationStaticPage_addDialog.jsp" />';
	window._static_dialog = dialog;
	dialog.Show(380, 150);
}
function _sysRelationStaticPage_add(){
	var obj = window._static_dialog.rtnStaticData;
	if(obj==null) return;
	if(obj.isSave){
		var liChildren = $('#staticPageContent').children();
		if(liChildren.length == 1 && liChildren[0].children.length <= 0){
			$('#staticPageContent').html("");
		}
		var fdRelatedUrl = obj.docUrl;
		var fdRelatedName = obj.docName;
		var docName = obj.docName;
		if(docName.length>20)
			docName = docName.substring(0,20)+"..";

		addStaticHTML(fdRelatedName,fdRelatedName,docName);
		
	}
	dyniFrameSize();
}


//搜索
function sysRelationStaticPage_search(){
	var currModelName = "${param.currModelName}";
	var dialog = new KMSSDialog();
	dialog.SetAfterShow(_sysRelationStaticPage_search);
	dialog.URL = Com_Parameter.ContextPath+"sys/relation/otherurl/ftsearch/searchBuilder.do?method=staticPageSearch&currModelName=${param.currModelName}";
	window._static_dialog = dialog;
	dialog.Show(600, 500);
}
function _sysRelationStaticPage_search(){
	var obj = window._static_dialog.rtnStaticData;
	if(obj==null) return;
	if(!obj.elements || obj.elements.length == 0)
		return ;
	var liChildren = $('#staticPageContent').children();
	if(liChildren.length == 1 && liChildren[0].children.length <= 0){
		$('#staticPageContent').html("");
	}
	
	for(var i=0;i<obj.elements.length;i++){
		//去掉内容里面的<strong class="lksHit"></strong>标签
		var addValue = $('<strong class="lksHit"></strong>').append(obj.elements[i].value).text();
		var values = new Array();
		values =  addValue.split("|");
		var fdRelatedName = values[0];
		var fdRelatedUrl = values[1];
		//截取字符串
		var docName = values[0];
		if(docName.length>20)
			docName = docName.substring(0,20)+"..";
		addStaticHTML(fdRelatedName,fdRelatedUrl,docName);
	}
	dyniFrameSize();
}
function addStaticHTML(fdRelatedName,fdRelatedUrl,docName){
	var appendHTML = '';
	contentIndex++;
	appendHTML += '<li title="'+fdRelatedName+'" id="contentId'+contentIndex+'">';
	appendHTML += '<input id="" type="checkbox" onclick="setSelectValue(this)"  value="'+fdRelatedName + '|' +fdRelatedUrl+'|'+'contentId'+contentIndex+'" \>';
	appendHTML += '<input type="hidden" name="fdRelatedName" value=' + fdRelatedName + '> ';
	appendHTML += '<input type="hidden" name="fdRelatedUrl" value=' + fdRelatedUrl + '> ';
	appendHTML += '<input type="hidden" name="fdSourceDocSubject" value=" "> ';
	appendHTML += docName;
	appendHTML += '</li>';
	$('#staticPageContent').append(appendHTML);
}
function addDocHTML(title,value,docName,checked){
	var appendHTML = '';
	appendHTML += '<li title="'+title+'">';
	appendHTML += '<input id="" type="checkbox" onclick="setSelectValue(this)"  value="'+value+'" '+checked+' \>';
	appendHTML += docName;
	appendHTML += '</li>';
	$('#staticPageContent').append(appendHTML);
}
var selected = new Array();
function setSelectValue(_this){
	if(_this.checked){
		selected[selected.length] = _this.value;
	}else{
		for(var i=0;i<selected.length;i++){
			if(_this.value == selected[i]){
				selected.splice(i,1);
				break;
			}
		}
	}
	setButtionStatus();
}
//设置按钮状态
function setButtionStatus(){
	if(selected.length == 1)
		$("#editButton").removeAttr("disabled");
	else
		$("#editButton").attr("disabled","disabled");
	if(selected.length > 0)
		$("#deleteButton").removeAttr("disabled");
	else
		$("#deleteButton").attr("disabled","disabled");
}

//编辑
function sysRelationStaticPage_edit(){
	var obj = new Object();
	var values = selected[0].split("|");
	obj.docName = values[0];
	obj.docUrl = values[1];
	obj.contentId = values[2];
	var dialog = new KMSSDialog();
	dialog.SetAfterShow(_sysRelationStaticPage_edit);
	dialog.staticData = obj;
	dialog.URL = '<c:url value="/sys/relation/sys_relation_main/sysRelationStaticPage_addDialog.jsp" />';
	window._static_dialog = dialog;
	dialog.Show(380, 150);
}
function _sysRelationStaticPage_edit(){
	var obj = window._static_dialog.rtnStaticData;
	var docName = obj.docName;
	var docUrl = obj.docUrl;
	var contentId = obj.contentId;
	var fdRelatedName = $("#"+contentId).find("input[name='fdRelatedName']").val();
	var fdRelatedUrl = $("#"+contentId).find("input[name='fdRelatedUrl']").val();
	//如果修改后的值没变，则不做任何操作
	if(fdRelatedName == docName && fdRelatedUrl == docUrl)
		return;
	$("#"+contentId).empty();

	var relaDocName = obj.docName;
	if(relaDocName.length>20)
		relaDocName = relaDocName.substring(0,20)+"..";
	$("#"+contentId).attr("title",docName);
	var appendHTML = '';
	appendHTML += '<input id="" type="checkbox" onclick="setSelectValue(this)"  value="'+relaDocName + '|' +docUrl+'|'+contentId+'" \>';
	appendHTML += '<input type="hidden" name="fdRelatedName" value=' + relaDocName + '> ';
	appendHTML += '<input type="hidden" name="fdRelatedUrl" value=' + docUrl + '> ';
	appendHTML += '<input type="hidden" name="fdSourceDocSubject" value=" "> ';
	appendHTML += relaDocName;
	appendHTML += '</li>';
	$("#"+contentId).append(appendHTML);
	
	dyniFrameSize();
}
//删除
function sysRelationStaticPage_delete(){
	$("input[type='checkbox']:checked").each(function(){
		$(this).parent().remove();
	});
	
	dyniFrameSize();
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp" %>