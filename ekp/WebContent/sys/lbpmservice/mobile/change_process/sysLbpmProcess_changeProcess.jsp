<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>


<div id="modifyNodeAuthorizationTr" style="display:none">
	<div class="titleNode">
		<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor" />
	</div>
	<div id="modifyNodeAuthorizationDetail" class="detailNode">
		
	</div>
</div>
<script src="<c:url value="/sys/lbpmservice/mobile/change_process/sysLbpmProcess_changeProcess.js" />"></script>