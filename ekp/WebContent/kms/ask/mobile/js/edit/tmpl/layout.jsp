<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div class="muiEditorPlugin"></div>
<div class="muiAskSubject">
	<xform:text property="docSubject" mobile="true" showStatus="edit"
		required="true" validators="required maxLength(200)" subject="标题" htmlElementProperties="placeholder='一句话描述您的疑问'"></xform:text>
</div>
<div class="muiEditorTextContainer">
	<div class="muiEditorTextarea" contenteditable="true"></div>
	<textarea class="muiEditorTextarea" style="display: none" name="{name}"></textarea>
</div>
