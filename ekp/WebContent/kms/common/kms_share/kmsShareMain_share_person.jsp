<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/common/kms_share/style/share_person.css" />
		<%@ include file="/kms/common/kms_share/kmsShareMain_share_person_js.jsp"%>
		<template:super />
		<script>
			seajs.use(['theme!form']);
			Com_IncludeFile("validation.js|plugin.js|xform.js", null, "js");
		</script>
	</template:replace>
	<template:replace name="body">
		<div style="padding:10px 20px 15px;">
			<table id="share_person_main" class="tb_simple intr_opt_table" width="100%" border="0" 
								cellspacing="0" cellpadding="0" style="border-bottom: 1px dotted #ccc;">
				<tr group="intr_person" valign="top">
					<td valign="top">
						<div class="share_peson_opt share_bolder share_title_color">${ lfn:message('kms-common:kmsShareMain.shareTarget')}</div>
						<xform:address propertyId="goalPersonIds" style="width:89.5%" propertyName="goalPersonNames" subject="${ lfn:message('kms-common:kmsShareMain.shareTarget')}" 
							required="true" validators="repetitionValidator(goalPersonIds)" showStatus="edit" orgType="ORG_TYPE_ALL" mulSelect="true">
						</xform:address>
					</td>
				</tr>
				
				<tr valign="top">
					<td valign="top">
						<div class="share_peson_opt share_bolder share_title_color">${ lfn:message('kms-common:kmsShareMain.shareReasons')}</div>
						<div style="display: inline-block;width: 89.5%;">
							<!-- <textarea name="fdShareReason" class="share_content"></textarea> -->
							<iframe name="fdShareReason" id="mainIframe" class="share_content" 
						  		 	src="${LUI_ContextPath}/kms/common/kms_share/kmsShareToPerson_share_content.jsp">
						    </iframe>
						</div>
						
						<div class="share_down_msg">
							<span class='share_icons'>
								${lfn:message('kms-common:kmsShareMain.share.expression') }
							</span>
							<div class='share_biaoqing'></div>
							<input id="share_button" class="share_button" type="button" value="<bean:message key="button.submit"/>">
							<span class="share_prompt"></span>
						</div>
						
						<div class="lui_share_notyfy">
							<label class="intr_notify">
								<input id="fdIsNotify" name="fdIsNotify" type="checkbox" value="1" checked="checked">
								<bean:message key="kmsShareMain.share.notify.auth" bundle="kms-common" />
							</label>
							&nbsp;&nbsp;&nbsp;&nbsp;
							<label class="share_notify">
								<bean:message key="kmsShareMain.notifySetting.fdNotifyType" bundle="kms-common" />：<kmss:editNotifyType property="fdNotifyType" value="todo"/>
							</label>
						</div>
					</td>
				</tr>
				
			</table>
		</div>
		<!-- 分享记录 -->
		<c:import url="/kms/common/kms_share/share_log/kmsShareLogMain.jsp" charEncoding="UTF-8">
			<c:param name="fdModelId" value="${param.fdModelId}" />
			<c:param name="fdModelName" value="${param.fdModelName}" />
		</c:import>
	</template:replace>
</template:include>
<script>
	if(window.share_opt==null){
		window.share_opt = new ShareOpt();
	}
	share_opt.onload();
</script>