<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:choose>
	<c:when
		test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
		<input type="hidden" name="fdDocNum" value="" />
		<span id="docnum"></span>
		<c:if test="${not empty kmImissiveSignMainForm.fdDocNum and kmImissiveSignMainForm.docStatus =='10'}">
		   <c:out value="${kmImissiveSignMainForm.fdDocNum}"/>
		</c:if>
	</c:when>
	<c:otherwise>
	     <c:if test="${not empty kmImissiveSignMainForm.fdDocNum}">
		   <c:out value="${kmImissiveSignMainForm.fdDocNum}"/>
		</c:if>
		 <c:if test="${empty kmImissiveSignMainForm.fdDocNum}">
		     <bean:message  bundle="km-imissive" key="kmImissiveSignMain.docNum.info"/>
		</c:if>
	</c:otherwise>
</c:choose>