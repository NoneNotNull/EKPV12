<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script type="text/javascript">
var fdId = "";
//记录节点类型（模板和分类）
var fdNodeType = "";
var hideDiv = null;
function showCreateDiv(id,nodeType,obj) {
	var url = "${LUI_ContextPath}/km/review/km_review_main/kmReviewMain.do?method=checkAuth&fdTempid="+id;
	if("TEMPLATE"==nodeType){
		//如果是模板则判断权限
	$.ajax({     
	     type:"post",    
	     url:url,     
	     async:true,     
	     success:function(data){
	     var a = LUI.toJSON(data);
	     if(a["value"] == "true"){
	    	 showQuickIcon(id,nodeType,obj);
	     }
	   }
     });
	}else{
		//如果是分类则显示快速新建图标
		showQuickIcon(id,nodeType,obj);
	}
 }

function showQuickIcon(id,nodeType,obj){
	fdId = id;
	fdNodeType = nodeType;
	var newDiv = document.getElementById("newDiv");
	var p = LUI.$(obj).position();
	LUI.$(newDiv).css('display','block');
	LUI.$(newDiv).css('left',p.left+LUI.$(obj).width());
	LUI.$(newDiv).css('top', p.top);
	LUI.$(newDiv).css('z-index', 1000);
	if(hideDiv){
		clearTimeout(hideDiv);
	}
}
function quickCreate(){
	seajs.use(['lui/dialog'], function(dialog) {
		if("TEMPLATE"==fdNodeType){
			window.open("${LUI_ContextPath}/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId="+fdId, '_blank');
		}else{
		dialog.categoryForNewFile(
				'com.landray.kmss.km.review.model.KmReviewTemplate',
				'/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{id}',false,null,null,fdId,null,null,true);
		}
	});
}
function openUrl(id,nodeType){

	top.location.href = "${LUI_ContextPath}/km/review/index.jsp?categoryId="+id+"&nodeType="+nodeType+"#cri.q=fdTemplate:"+id;
}

function hideCreateDiv(){
	hideDiv =  setTimeout(function(){
		  document.getElementById("newDiv").style.display="none";
	 },2000);
}
</script>
<div id="newDiv" style="display:none;position:absolute;">
<a href="javascript:;" onclick="quickCreate();"><img  src="../resource/style/images/tips.png">
</a>
</div>
	    <div class="lui_flow_overview">
			<div class="lui_flow_viewContent">
				<h1><bean:message bundle="km-review" key="kmReview.tree.preview" /></h1>
			    <ui:dataview>
					<ui:source type="AjaxJson">
					    {"url":"/km/review/km_review_main/kmReviewMain.do?method=preview"}
					</ui:source>
					<ui:render type="Template">
						<c:import url="/km/review/resource/tmpl/treemenu2.tmpl"></c:import>
					</ui:render>
				</ui:dataview>
			</div>
		</div>
	</template:replace> 
</template:include>
