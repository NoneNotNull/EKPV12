<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script type="text/javascript">

function openUrl(url){
    window.open("${LUI_ContextPath}"+url,"_blank");
	//parent.location = "${LUI_ContextPath}"+url;
	
}
</script>
	    <div class="lui_flow_overview">
			<div class="lui_flow_viewContent">
			    <ui:dataview>
					<ui:source type="AjaxJson">
					    {"url":"/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=preview"}
					</ui:source>
					<ui:render type="Template">
						<c:import url="/km/doc/resource/tmpl/portlet.tmpl"></c:import>
					</ui:render>
				</ui:dataview>
			</div>
		</div>
	</template:replace> 
</template:include>
</ui:ajaxtext>