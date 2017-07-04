<%-- 发文文号 --%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<html:hidden property="fdDocNum" />
<c:choose>
	<c:when
		test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
		<input type="hidden" name="fdDocNum" value="${kmImissiveSignMainForm.fdDocNum}" />
		<span id="docnum">
		  <c:if test="${not empty kmImissiveSignMainForm.fdDocNum}">
		   <c:out value="${kmImissiveSignMainForm.fdDocNum}"/>
		  </c:if>
		</span>
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
