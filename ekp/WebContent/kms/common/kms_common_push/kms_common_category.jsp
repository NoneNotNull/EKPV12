<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>

function NodeFunc_AppendSimpleCategoryData(modelName,parameter,action, startWith,exceptValue, extendService){
	if(modelName==null || modelName=="") return;
	var cateUrl = 'kmsWikiCategoryTree'+(extendService!=null?';'+extendService:'')+'&authType=' + this.authType + '&categoryId=!{value}';
	cateUrl+='&modelName=' + modelName;
	if(extendService!=null){
		cateUrl += "&extendService="+encodeURIComponent(extendService);
	}
	if(typeof(parameter)=="string" && parameter.indexOf("nodeType")==-1) {
		parameter += "&nodeType=!{nodeType}";
	}
	this.AppendBeanData(cateUrl, parameter, action, true, exceptValue);
	if(startWith!=null)
		this.value = startWith;
}

//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="kmsWiki.tree.title"  bundle="kms-wiki"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3, n4, n5;
	n1 = LKSTree.treeRoot;
	<!-- 按分类 -->
	//按类别
	n2 = n1.AppendURLChild(
		"<bean:message bundle="kms-common" key="kmsCommonDataPush.tree.maindirectory"/>"
	);
	n2.AppendSimpleCategoryData( 
		"com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory", 
		"<c:url value="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=listChildren&categoryId=!{value}&orderby=docCreateTime&ordertype=down" />"
	);
	n2.isExpanded = true; 
	
	LKSTree.EnableRightMenu();
	LKSTree.isShowCheckBox = true;
	LKSTree.isMultSel = false;		
	LKSTree.OnNodeCheckedPostChange = function(checkedNode){
		var categoryId = checkedNode.value ;
	    var url = '<c:url value="/kms/common/kms_common_push/kms_common_push_wiki_content.jsp?fdModelId=${param.fdModelId}&kmsCommonPushAction=${param.kmsCommonPushAction }&categoryId=" />'+categoryId;
		window.parent.document.getElementById("viewFrameObj").src =  url;
	}
	LKSTree.Show();
}
<%@ include file="/resource/jsp/tree_down.jsp" %>
