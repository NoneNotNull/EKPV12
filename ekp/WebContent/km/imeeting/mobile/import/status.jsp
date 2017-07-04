<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="_status" value="${param.status}" scope="page" />
<c:set var="isBegin" value="${param.isBegin}"/>
<c:set var="isEnd" value="${param.isEnd}"/>
<%--废弃 --%>
<c:if test="${_status =='00' }">
	<div class="muiMeetingStatusTag muiMeetingDiscard">
		<bean:message key="status.discard"/>
	</div>
</c:if>
<%--草稿 --%>
<c:if test="${_status =='10' }">
	<div class="muiMeetingStatusTag muiMeetingDraft">
		<bean:message key="status.draft"/>
	</div>
</c:if>
<%--驳回 --%>
<c:if test="${_status =='11' }">
	<div class="muiMeetingStatusTag muiMeetingRefuse">
		<bean:message key="status.refuse"/>
	</div>
</c:if>
<%--待审 --%>
<c:if test="${_status =='20' }">
	<div class="muiMeetingStatusTag muiMeetingExamine">
		<bean:message key="status.examine"/>
	</div>
</c:if>
<%--未召开--%>
<c:if test="${_status=='30' && isBegin==false }">
	<div class="muiMeetingStatusTag muiMeetingUnhold">
		<bean:message bundle="km-imeeting" key="kmImeeting.status.publish.unHold"/>
	</div>
</c:if>
<%--正在召开--%>
<c:if test="${_status=='30' && isBegin==true && isEnd==false }">
	<div class="muiMeetingStatusTag muiMeetingHolding">
		进行中
	</div>
</c:if>
<%--已召开--%>
<c:if test="${_status=='30' && isEnd==true }">
	<div class="muiMeetingStatusTag muiMeetingHold">
		<bean:message bundle="km-imeeting" key="kmImeeting.status.publish.hold"/>
	</div>
</c:if>
<%--已取消--%>
<c:if test="${_status=='41' }">
	<div class="muiMeetingStatusTag muiMeetingCancel">
		已取消
	</div>
</c:if>

