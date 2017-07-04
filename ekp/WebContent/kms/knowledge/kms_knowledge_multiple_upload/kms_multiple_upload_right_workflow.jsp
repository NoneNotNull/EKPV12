<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%-- 权限 --%>
<div class="lui_multidoc_catelog">
	<div class="lui_multidoc_title">
		<bean:message bundle="kms-knowledge" key="kmsKnowledgeBaseDoc.right"/>
	</div>
</div>
<div class="lui_multidoc_content">
	<table class="tb_normal" width=100%>
		<%@ include file="/sys/right/right_edit.jsp"%>
	</table>
</div>
