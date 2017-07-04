<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_navi_selector.js"></script>
<script>Com_Parameter.IsAutoTransferPara = true;</script>
<script language="JavaScript">
	  Com_IncludeFile("dialog.js");
</script>
<%--doc list button show bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
	charEncoding="UTF-8">
	<c:param name="fdTitleProName" value="docSubject" />
	<c:param name="fdModelName"
		value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
</c:import>
<c:import
	url="/resource/jsp/search_bar.jsp"
	charEncoding="UTF-8">
	<c:param
		name="fdModelName"
		value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
</c:import>
<c:import
	url="/sys/right/doc_right_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
</c:import>


<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
	<c:param
		name="docFkName"
		value="docCategory" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
	<c:param
		name="extProps"
		value="fdTemplateType:1;fdTemplateType:3" />
</c:import>

<script type="text/javascript">
var operatorName="" ;
var jsonUrl = '${kmsResourcePath}/jsp/get_json_feed.jsp';
var dialogUrl = '${kmsBasePath}/common/jsp/dialog.html';
var addoptions = {
	lock : false,
	noFn : function() {},
	height : '400px',
	width : '500px',
	background: '#fff', // 背景色
    opacity: 0,	// 透明度
	yesFn : function(naviSelector) {
		var selectedCache = naviSelector.selectedCache;
		// 未选择分类~
		if (selectedCache.length == 0) {
			showAlert('请选择分类') ;
			return false;
		}
		if(selectedCache.last()._data["isShowCheckBox"]=="0"){
			art.artDialog.alert("您没有当前目录使用权限！");
			return;
		}
		var fdCategoryId = selectedCache.last()._data["value"];
		if(operatorName=="addDoc")
		   window.open('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do"/>?method=add&fdTemplateId=' + fdCategoryId);
		if(operatorName=="changeTemplate"){
			var select = document.getElementsByName("List_Selected");
			var values="" ;
			for(var i=0;i<select.length;i++) {
				if(select[i].checked){
					values+=select[i].value;
					values+=",";
				}
			}
			updateExtendFilePath(values,fdCategoryId) ;
		}
  	}
};
// 分类组件
var navOptions = {
	dataSource : {
		url : jsonUrl,
		modelName:'com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate',
		authType:'02',
		extendFilter:"fdExternalId is null"
	}
};

function updateExtendFilePath(fdIds,templateId){
    //ajax 
	var url="kmsMultidocKnowledgeXMLService&type=4&docIds="+fdIds+"&templateId="+templateId ;
	var data = new KMSSData(); 
	data.SendToBean(url,function (rtnData){ 
		 var obj = rtnData.GetHashMapArray()[0]; 
 		 var count=obj['count'];
 		 if(count==0){
 	 		 alert('操作成功') ;
 	 	 }else{
 	 		alert('操作失败') ;
         }
	});	  
}
	
function checkSelect() {
	var values="";
	var selected;
	var select = document.getElementsByName("List_Selected");
	for(var i=0;i<select.length;i++) {
		if(select[i].checked){
			values+=select[i].value;
			values+=",";
			selected=true;
		}
	}
	if(selected) {
		values = values.substring(0,values.length-1);
		if(selected) {
			Com_OpenWindow(Com_Parameter.ContextPath+'kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge_change_template.jsp?method=changeTemplate&values='+values,'_blank','height=300, width=450, toolbar=no, menubar=no, scrollbars=no, resizable=no,location=no, status=no');
			return;
		}
	}
	alert("<bean:message bundle="kms-multidoc" key="message.trans_doc_select" />");
	return false;
}

function selectTemplate(doSomething){
	  operatorName=doSomething;
	  artDialog.navSelector('选择分类', addoptions, navOptions);
  }
	
//function selectAfter(rtnData){
//		if(rtnData.GetHashMapArray().length >= 1){  
//		   	var obj = rtnData.GetHashMapArray()[0];
//			var id=obj["id"];
//	  Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId='+id);   
//	    }
//}
</script>
<div id="optBarDiv">
<c:if test="${param.pink!='true'}">
	
	<c:if test="${empty param.categoryId}">
		<kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.add"/>"  onclick="selectTemplate('addDoc')"  >
		<!--  	onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate','<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}'); -->
		</kmss:auth>
	</c:if>
	<c:if test="${not empty param.categoryId}">
		<kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=${param.categoryId}"
		requestMethod="GET">
			<c:set var="flg" value="no"/>
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId=${param.categoryId}');">
			<c:set var="flg" value="yes"/>
			<c:if test="${flg eq 'no'}">
			<input type="button" value="<bean:message key="button.add"/>"  onclick="selectTemplate('addDoc')"  >
			<!--	onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate','<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}');-->
			</c:if>
		</kmss:auth>
	</c:if>

	<kmss:auth
		requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
		requestMethod="GET">
		<input
			type="button"
			value="<bean:message key="button.delete"/>"
			onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsMultidocKnowledgeForm, 'deleteall');">
	</kmss:auth>
	<%---modify by zhouchao --%>
	<%--<c:if test="${param.status == '30' or empty param.status or param.status == 'all'}">
		<c:if test="${empty param.mydoc and empty param.myflow and empty param.departmentId}">
			<kmss:auth
				requestURL="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=changeTemplate&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
				requestMethod="GET">
				<input
					type="button"
					value="<bean:message key="button.chengeTemplate" bundle="kms-multidoc"/>"
					onclick="checkSelect();">
			</kmss:auth>
		</c:if>
	</c:if>
	--%>
</c:if> 
<c:if test="${param.pink=='true'}">
	<c:import
		url="/sys/introduce/include/sysIntroduceMain_cancelbtn.jsp"
		charEncoding="UTF-8">
		<c:param
			name="fdModelName"
			value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
	</c:import>
</c:if> 
<input
	type="button"
	value="<bean:message key="button.search"/>"
	onclick="Search_Show();">
 
 </div>
