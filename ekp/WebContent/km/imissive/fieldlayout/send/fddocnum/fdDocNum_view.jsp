<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:choose>
	<c:when
		test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
		<input type="hidden" name="fdDocNum" value="" />
		<span id="docnum"></span>
		<c:if test="${not empty kmImissiveSendMainForm.fdDocNum and kmImissiveSendMainForm.docStatus =='10'}">
		   <c:out value="${kmImissiveSendMainForm.fdDocNum}"/>
		</c:if>
	</c:when>
	<c:otherwise>
	     <c:if test="${not empty kmImissiveSendMainForm.fdDocNum}">
		   <c:out value="${kmImissiveSendMainForm.fdDocNum}"/>
		</c:if>
		 <c:if test="${empty kmImissiveSendMainForm.fdDocNum}">
		   <bean:message  bundle="km-imissive" key="kmImissiveSendMain.docNum.info"/>
		</c:if>
	</c:otherwise>
</c:choose>