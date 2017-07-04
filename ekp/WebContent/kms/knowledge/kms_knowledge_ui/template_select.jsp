<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/knowledge/resource/style/template_select.css" />
	<template:replace name="content">
		<div style="width: 473px; margin: 0 5;" id="categoryCtx">
			<div class="lui_template_frame_item">
				<ul class="lui_template_content" >
				</ul>
			</div>
		</div>
	</template:replace>
</template:include>
<script type="text/javascript">
function serializeParams(params) {
	var array = [];
	for ( var kk in params) {
		array.push('qq.' + encodeURIComponent(kk) + '='
				+ encodeURIComponent(params[kk]));
	}
	var str = array.join('&');
	return str;
}

var interval = setInterval(loadTemplate, 50);
function loadTemplate() {
	if (!window['$dialog'])
		return;
	seajs.use([ 'lui/jquery','lui/data/source','lui/util/env'],
				function($,source,env) {
					var url = "/kms/knowledge/kms_knowledge_category/kmsKnowledgeCategory.do?method=findTemplate";
					if (window['$dialog'].___params){
						url += ("&" + serializeParams(window['$dialog'].___params));
					}
					$.ajax({
						url : env.fn.formatUrl(url),
						dataType : 'json',
						success : function(rtnData, textStatus) {
							var len = rtnData.length;
							var value,text;
							for(var i=0;i<len;i++){
								value = rtnData[i].value;
								text = rtnData[i].text;
								$(".lui_template_content").append("<li><a id='"+value+"'"+ 
										"class='lui_template_itemLink_single  lui_template_itemLink_on' onclick='selected(this)' href='javascript:;'>"+
										"<label title='"+text+"'>"+text+"</label></a></li>");
							}
							if(len==1){
								selectId = value;
								$(".lui_template_content li").addClass("lui_template_li_on");
							}
						}
					});
				});
	clearInterval(interval);
};

var selectId = null;

function selected(e){
	seajs.use([ 'lui/jquery'],
			function($){
				$(".lui_template_li_on").removeClass();
				e.parentNode.className="lui_template_li_on";
				selectId = e.id; 
			})
}
</script>
<style>
body {
	background-color: white !important;
}
</style>