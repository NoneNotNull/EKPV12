<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script type="text/javascript" src="${LUI_ContextPath }/kms/common/pda/script/pda_attachment.js"></script>
<link href="${LUI_ContextPath }/kms/common/pda/core/attachment/style/att_upload.css" type="text/css" rel="stylesheet" />
<!-- 隐藏域 -->
<html:hidden property="attachmentForms.${param.fdKey}.fdModelId" />
<html:hidden property="attachmentForms.${param.fdKey}.fdModelName" value="${param.fdModelName }" />
<html:hidden property="attachmentForms.${param.fdKey}.fdKey"		 value="${param.fdKey }" />
<html:hidden property="attachmentForms.${param.fdKey}.fdAttType"	 value="pic" />
<html:hidden property="attachmentForms.${param.fdKey}.fdMulti"	 value="false" />
<html:hidden property="attachmentForms.${param.fdKey}.deletedAttachmentIds" />
<html:hidden property="attachmentForms.${param.fdKey}.attachmentIds" />
<section class="lui-attachment-upload" >
	<li class="lui-attachment-btn lui-attachment-cameraUpload" style="display: none;">
		<a data-lui-role="button">
			<script type="text/config">
							{
								currentClass : 'lui-icon-s lui-camera-icon lui-camera-icon-on',
								onclick : "$('#cameraUpload').click();"
							}
			</script>		
		</a>
	</li>
	
	<li class="lui-attachment-btn lui-attachment-imgUpload" style="display: none;">
		<a data-lui-role="button">
			<script type="text/config">
							{
								currentClass : 'lui-icon-s lui-img-icon lui-img-icon-on',
								onclick : "$('#imgUpload').click();"
							}
			</script>		
		</a>
	</li>
	
	<script>
		$(function() {
			var toolbar = '${param.toolbar}';
			var $toolbar = $('#' + toolbar);
			if (!Pda.Util.browser.isAndroid)
				$('.lui-attachment-btn').show().appendTo($toolbar);
			else
				$('.lui-attachment-imgUpload').show().appendTo($toolbar);
		});
	</script>
	
	<article>
		<a data-lui-role="attachment">
			<script type="text/config">
			{
				'thumb' : '#attachment_thumb',
				'fdKey' : '${param.fdKey}',
				'fdModelId' : '${param.fdModelId}',
				'fdModelName' : '${param.fdModelName}',
				'extParam' : "${param.extParam}"
			}
			</script>	
		</a>
		<section class="img" style="width: 100%">
			<ul id="attachment_thumb" class="clearfloat">
			</ul>
		</section>
		<section class="info">
			<dl id="attachment_info">
			</dl>
		</section>
	</article>
</section>