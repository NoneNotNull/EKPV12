<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>


<tr id="modifyNodeAuthorizationTr" style="display:none">
	<td class="td_title">
		<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor" />
	</td>
	<td id="modifyNodeAuthorizationDetail" colspan="3">
		
	</td>
</tr>
<script src="<c:url value="/sys/lbpmservice/pda/OptHandler.js" />"></script>
<script src="<c:url value="/sys/lbpmservice/pda/sysLbpmProcess_changeProcess.js" />"></script>