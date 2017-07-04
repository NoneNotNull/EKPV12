<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/common/kms_share/style/share_view.css" />
<%@page import="com.landray.kmss.kms.common.service.IKmsShareMainService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>

<script type="text/javascript">
	function shareAction(){
		$("body").attr("style","overFlow-y:hidden;");//父窗口禁掉滚动条
		seajs.use(['lui/dialog'],function(dialog){
			dialog.iframe('/kms/common/kms_share/kmsShareMain.do?method=listShareModules&'+
					'fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdCategoryId=${param.fdCategoryId}', 
							"${lfn:message('kms-common:kmsShareMain.share')}",
							function(){
								$("body").attr("style","overFlow-y:auto;");
							}, 
							 {	
								width:710,
								height:570
							}
			);
		});
	}
</script>
<span class="kms_share_icon" title="${lfn:message('kms-common:kmsShareMain.share')}" onclick="shareAction();" href="#">
</span>
<span class="share_count" id="share_count_${param.fdModelId}">
	<%
		IKmsShareMainService kmsShareMainService = 
				(IKmsShareMainService)SpringBeanUtil.getBean("kmsShareMainService");
		String fdModelId = (String)request.getParameter("fdModelId");
		String fdModelName = (String)request.getParameter("fdModelName");
		Long count = kmsShareMainService.getShareCount(fdModelId,fdModelName);
		out.print(count);
	%>
</span>
