<%@ include file="/resource/jsp/common.jsp"%>

<c:forEach items="${approvalTypes}" var="approvalType" varStatus="vstatus">
<tr>
	<td class="td_normal_title">${approvalType.fdName}</td>
	<td colspan="3">
		<table border="0" width="100%">
			<c:forEach items="${auditNotes[approvalType.fdId]}" var="auditNode" varStatus="vstatus">
			<c:if test="${not empty auditNode.fdAuditNote}">
			<tr>
				<td style="border:0px"><kmss:showText value="${auditNode.fdAuditNote}"/></td>
			</tr>
			<tr>
				<td style="border:0px">&nbsp;&nbsp;&nbsp;&nbsp;${auditNode.handlerName}&nbsp;&nbsp;&nbsp;&nbsp;
					<kmss:showDate value="${auditNode.fdCreateTime}" type="datetime"/>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			</c:if>
		</c:forEach>
		</table>
	</td>
</tr>
</c:forEach>
