<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<div class="bookmarkDiv" id="bookmarkDiv">
	<!-- 默认未收藏 -->
	<input type="hidden" id="isMarked" value="false"></input>
	<input type="hidden" id="mark_docSubject" value="${param.docSubject}"></input>
	<a id="BMBtn_${param.fdModelId}" href="javascript:void(0)" title="${lfn:message('kms-common:kmsBookMarkMain.todo')}" onclick="changeBM('${param.fdModelId}','${param.fdModelName}');">
	   	<span class="bml0" id="starItem"></span>
	</a>
	<span class="bmc" id="bmIcon" >
	   	${param.bookMarkCount} 
	</span>
	<span class="bmr"></span>
</div>