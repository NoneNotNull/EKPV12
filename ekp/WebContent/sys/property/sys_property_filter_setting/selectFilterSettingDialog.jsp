<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<link rel=stylesheet href="dialog.css">
<script>
Com_IncludeFile("jquery.js|treeview.js");
</script>
<html:form action="/sys/property/sys_property_filter_setting/sysPropertyFilterSetting.do">

<p class="txttitle"><bean:message bundle="sys-property" key="table.sysPropertyFilterSetting2"/></p>
<center>
<div id="filterSettingMain">
	<div id="selectList">
		<span class="header"><bean:message bundle="sys-property" key="sysPropertyFilterSetting.customProperty"/></span>
		<span id="customProperty"></span>
		<span class="header"><bean:message bundle="sys-property" key="sysPropertyFilterSetting.regularFilter"/></span>
		<span id="regularFilter"></span>
	</div>
	<div id="property">
		<span class="header"><bean:message bundle="sys-property" key="sysPropertyFilterSetting.fdDefine"/></span>
		<span id="propertyTree"></span>
	</div>
</div>
<div class="filterSettingMainBottom">
	<input type="button" class="btndialog" onclick="ok();"  value="<bean:message key="button.ok"/>" style="width:50px"></input>
	<input type="button" class="btndialog" onclick="filterSetting.isTrue=false;window.close();" value="<bean:message key="button.cancel"/>" style="width:50px"></input>
</div>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<html:hidden property="pluginFilterSettings" value="${sysPropertyFilterSettingForm.pluginFilterSettings}"/>
<script>
var args;
var LKSTree
Tree_IncludeCSSFile();
var filterSetting = {
	dataType:"",
	modelName:"",
	filterBean:"",
	filterTitle:"",
	propertyId:"",
	propertyName:"",
	isTrue:false
};
var isfixedProperty = false;
/**
 * 初始化筛选列表
 */
(function(){
	args = window.dialogArguments;
	var pluginFilterSettings = document.getElementsByName("pluginFilterSettings")[0].value;
	var filters = pluginFilterSettings.split(";");
	$(filters).each( function() {
		var filter = this.split(",");
		var c = $('<a id='+filter[0]+' className="UnSelect" href="#" onclick="SelectNode(this)" modelName='+filter[2]+' dataType='+filter[3]+' title='+filter[1]+'><div>'+filter[1]+'</div></a>');
		if(filter[2]=="*"){
			$("#selectList #customProperty").append(c);
		}else{
			$("#selectList #regularFilter").append(c);
		}
	});
	loadTreeView(args.dataType,args.modeName,args.filterBean,args.defineId,args.propertyName);
	setCurrentNode(document.getElementById(args.filterBean));
})()

function setFilterSetting(dataType,modelName,filterBean,filterTitle,value,name){
	if(dataType){
		filterSetting.dataType = dataType;
		filterSetting.modelName = modelName;
		filterSetting.filterBean = filterBean;
		filterSetting.filterTitle = filterTitle;
		filterSetting.isTrue = false;
	}
	if(value && name){
		if(isfixedProperty){
			filterSetting.propertyName = value;
			filterSetting.fdDefineId = "";
		}else{
			filterSetting.propertyName = "";
			filterSetting.fdDefineId = value;
		}
		filterSetting.fdDefineName = name;
		filterSetting.isTrue = true;
	}
}
var currentNode;
function SelectNode(e){
	setCurrentNode(e);
	loadTreeView(e.getAttribute('dataType'),e.getAttribute('modelName'),e.getAttribute('id'));
}
function setCurrentNode(e){
	if(!e)return;
	e.className = "Selected";
	isfixedProperty = $(e).attr("modelName")=="*"?false:true;
	if(currentNode){
		currentNode.className = "UnSelect";
	}
	currentNode = e;
}
/**
 * 属性树
 */
function loadTreeView(dataType,modelName,filterBean,defineId,propertyName){
	LKSTree = new TreeView("LKSTree","属性",document.getElementById("propertyTree"));
	var n1, n2;
	n1 = LKSTree.treeRoot;
	//========== 属性列表 ==========
	n2 = n1.AppendBeanData('sysPropertyPropListService&fdParentId=!{value}&fdDataType='+dataType+'&fdModelName='+modelName+'&fdFilterBean='+filterBean, null,null, null, null);
	LKSTree.isShowCheckBox = true;
	LKSTree.isAutoSelectChildren = null;
	LKSTree.isMultSel = false;
	LKSTree.Show();
	if(defineId){
		var defaultDom = $("input[value='"+(propertyName||defineId)+"']");
		var nodeId = defaultDom.parent().attr("lks_nodeid");;
		LKSTree.SetNodeChecked(nodeId*1,true);
	}

	//set筛选参数
	setFilterSetting(dataType,modelName,filterBean,"");
}


function Com_DialogReturnValue(){
	
	if(!LKSTree){
		alert("<bean:message bundle='sys-property' key='sysPropertyFilter.selectPropertiesList'/>");
		return false;
	};
	var selectNodes = LKSTree.GetCheckedNode();
	var value,name;
	if(selectNodes!=null){
		selectNodes = new Array(selectNodes);
		if(selectNodes.length==1){
			value = selectNodes[0].value;
			name = (selectNodes[0].text!=null && selectNodes[0].text!="")?selectNodes[0].text:selectNodes[0].title;
			setFilterSetting(null,null,null,null,value,name);
		}
	}
	if(!value && !name){
		alert("<bean:message bundle='sys-property' key='sysPropertyFilter.selectProperties'/>");
		return false;
	}
	return true;
}

function ok(){
	//window.dialogArguments
	if(!Com_DialogReturnValue())return;
	window.returnValue = filterSetting ;
	window.close();
}

	//$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>