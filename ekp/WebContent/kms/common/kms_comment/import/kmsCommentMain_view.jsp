<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
	seajs.use(['${KMSS_Parameter_ContextPath}kms/common/kms_comment/import/resource/comment.css']);
	Com_IncludeFile("comment.js","${KMSS_Parameter_ContextPath}kms/common/kms_comment/import/resource/","js",true);
	
	var commentAlert = {
			'comment_reply':'<bean:message key="kmsCommentMain.reply" bundle="kms-common" />',
			'comment_delete':'<bean:message key="button.delete"/>',
			'comment_publish':'<bean:message key="kmsCommentMain.publish" bundle="kms-common" />',
			'comment_r_s':'<bean:message key="kmsCommentMain.reply.success" bundle="kms-common" />',
			'comment_d_s':'<bean:message key="kmsCommentMain.delete.success" bundle="kms-common" />',
			'comment_c_write':'<bean:message key="kmsCommentMain.canwrite" bundle="kms-common" />',
			'comment_many':'<bean:message key="kmsCommentMain.toomany" bundle="kms-common" />',
			'comment_del_title': '<bean:message key="page.comfirmDelete"/>'
	};
</script>
<script>
	LUI.ready(function(){
		var positionId = '${param.positionId}';
		$("#"+positionId).on('click', function(){
			var __list = $("#comment_${param.fdModelId}");
			setTimeout(function(){
				if(__list.is(":hidden")){
					$(".kms_comment").hide();
					__list.slideDown('slow');
				}else{
					__list.slideUp("slow");
				}
			}, 300);
		});
		window["comment_${param.fdModelId}"].__init__();
	});
	if(window["comment_${param.fdModelId}"] == null)
		window["comment_${param.fdModelId}"] = new Comment_opt("comment_${param.fdModelId}", "${param.countId}", "${param.fdModelId}");
</script>
	<kmss:authShow roles="SYSROLE_ADMIN">
		<c:set var="commentAuth" value="true" />
	</kmss:authShow>
	<c:if test="${param.defaultShow ne true}">
		<c:set var="defaultShow" value="display:none;"/>
	</c:if>
<div class="kms_comment" id="comment_${param.fdModelId}" style="${defaultShow}">
	<div class="trig_box"><span class="trig"></span></div>
	<list:listview channel="comment_channel_${param.fdModelId}">
		<ui:source type="AjaxJson">
			{url:'/kms/common/kms_comment_main/kmsCommentMain.do?method=data&orderby=docCreateTime&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&rowsize=${param.rowsize}'}
		</ui:source>
		<list:rowTable isDefault="true" target="_blank" cfg-norecodeLayout="none">
			<ui:layout type="Template">
				{$<div class="comment_records" data-lui-mark='table.content.inside'>
				</div>$}
			</ui:layout>
			<list:row-template>
				<c:import url="/kms/common/kms_comment/import/kmsCommentMain_view_tmpl.jsp" charEncoding="UTF-8">
					<c:param name="commentAuth" value="${commentAuth=='true'}" />
				</c:import>
			</list:row-template>
		</list:rowTable>	
		<ui:event topic="comment.opt.success" args="vt">
			window["comment_${param.fdModelId}"].refreshCount(vt);
		</ui:event>	
	</list:listview>
	<list:paging channel="comment_channel_${param.fdModelId}" layout="sys.ui.paging.simple"></list:paging>
	<c:import url="/kms/common/kms_comment/import/kmsCommentMain_view_include.jsp" charEncoding="UTF-8">
		<c:param name="fdModelName" value="${param.fdModelName }"></c:param>
		<c:param name="fdModelId" value="${param.fdModelId }"></c:param>
	</c:import>
</div>