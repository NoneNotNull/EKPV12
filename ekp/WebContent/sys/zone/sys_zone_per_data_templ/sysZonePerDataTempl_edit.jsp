<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.edit" sidebar="auto">
	<template:replace name="content">
		<c:choose>
			<c:when test="${param.person eq 'yes' }">
				<xform:rtf property="docContent" width="680" height="220"/>
			</c:when>
			<c:otherwise>
				<div style="margin-top: 20px;">
					<xform:rtf property="docContent"/>
				</div>
			</c:otherwise>
		</c:choose>
	</template:replace>
</template:include>

<script>
Com_AddEventListener(window, 'load', function(){
 seajs.use([ 'lui/jquery' ], function($){
	var propertyName = null;
	var docContent = null;
	var editor = CKEDITOR.instances.docContent;
	<c:choose>
		<c:when test="${param.person eq 'yes' }">
			propertyName = "${param.index}_person_data_content_div";
			docContent = $(window.parent.document).find("#" + propertyName).html();
			$(window.parent.document).find("#${param.index}_person_data_save").click(function() {
				$(this).hide();
				seajs.use(['lui/dialog' ], function(dialog) {
					var load = dialog.loading('保存中请等待...');
					$.ajax({
						type:"post",
						url:"${LUI_ContextPath}/sys/zone/sys_zone_person_data/sysZonePersonData.do?method=saveData",
						//json格式传递数据到后台
						data:{
								fdId:$(window.parent.document).find("input[name='${param.index}_fdId']").val(),
								fdName:$(window.parent.document).find("input[name='${param.index}_fdName']").val(),
								fdDataCateId:$(window.parent.document).find("input[name='${param.index}_fdDataCateId']").val(),
								docContent:editor.getData(),
								fdPersonId:$(window.parent.document).find("input[name='${param.index}_fdPersonId']").val(),
								fdOrder:$(window.parent.document).find("input[name='${param.index}_fdOrder']").val()
							},
						success:function() {
							load.hide();
							window.parent.loadPersonData();
						}
					});
				});
				//var load = null;
				//seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
				//	load = dialog.loading('保存中请等待...');
				//});
				/*
				$.ajax({
					type:"post",
					url:"${LUI_ContextPath}/sys/zone/sys_zone_person_data/sysZonePersonData.do?method=saveData",
					//json格式传递数据到后台
					data:{
							fdId:$(window.parent.document).find("input[name='${param.index}_fdId']").val(),
							fdName:$(window.parent.document).find("input[name='${param.index}_fdName']").val(),
							fdDataCateId:$(window.parent.document).find("input[name='${param.index}_fdDataCateId']").val(),
							docContent:editor.getData(),
							fdPersonId:$(window.parent.document).find("input[name='${param.index}_fdPersonId']").val()
						},
					success:function() {
						load.hide();
						window.parent.loadPersonData();
					}
				});*/
			});
		</c:when>
		<c:otherwise>
			propertyName = "${param.propertyName}";
			docContent = $(window.parent.document).find("textarea[name='" + propertyName + "']").text();
		</c:otherwise>
	</c:choose>
	editor.setData( docContent );
 });	
});
</script>