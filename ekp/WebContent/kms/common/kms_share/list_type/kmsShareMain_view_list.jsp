<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<span class="kms_share_icon" title="分享" share-data-modelid="${param.fdModelId}" 
			share-data-modelname="${param.fdModelName}" onclick="shareAction(this);" href="#">
</span>
<span class="share_count" id="share_count_${param.fdModelId}">
	${not empty param.docShareCount ? param.docShareCount : '0'}
</span>