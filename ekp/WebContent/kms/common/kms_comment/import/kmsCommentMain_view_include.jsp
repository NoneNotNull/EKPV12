<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div class="input_titleBox">
	<input class="inputText" value="${lfn:message('kms-common:kmsCommentMain.i_reply')}" type="text">
</div>
<div class="comment_editDiv">
	<input type="hidden" name="fdModelId" value="${param.fdModelId}"/>
	<input type="hidden" name="fdModelName" value="${param.fdModelName}"/>
	<input type="hidden" name="docParentReplyerId" value=""/>
	<input type="hidden" name="fdParentId" value=""/>
	<input type="hidden" name="hasParentReply" value="false"/>
	<div class="reply_clickbtn"><span class="p_reply"></span><span class="i_reply">
		<bean:message key="kmsCommentMain.i_reply" bundle="kms-common"/></span></div>
	<iframe name='comment_textarea' class='comment_content' id='cifr_${param.fdModelId}'
		src=''></iframe>
	<span class="comment_icons"><bean:message key="kmsCommentMain.biaoqing" bundle="kms-common"/></span>
	<div class='comment_biaoqing'></div>
	<div class="comment_button" id="_commentBtn_${param.fdModelId}">
		<%-- <bean:message key="button.submit" /> 
		<ui:button id="comment_btn_${param.fdModelId}" text="${lfn:message('kms-common:kmsCommentMain.button')}" onclick='window["comment_${param.fdModelId}"].__submitData(this);'></ui:button>
		--%>
	</div>
	<span class="comment_notice">
		<font class="notice_title"><bean:message key="kmsCommentMain.canwrite" bundle="kms-common"/></font>
		<font class="notice_count" style="font-family: Constantia, Georgia; font-size: 20px;">140</font>
		<bean:message key="kmsCommentMain.word" bundle="kms-common"/>
	</span>
</div>