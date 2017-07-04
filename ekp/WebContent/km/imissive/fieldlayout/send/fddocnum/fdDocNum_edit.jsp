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
		test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
		<input type="hidden" name="fdDocNum" value="${kmImissiveSendMainForm.fdDocNum}" />
		<span id="docnum"> 
		  <c:if test="${not empty kmImissiveSendMainForm.fdDocNum}">
		   <c:out value="${kmImissiveSendMainForm.fdDocNum}"/>
		  </c:if>
		</span>
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
<c:if test="${sysNumberFlag eq 'unlimited' or not empty kmImissiveSendMainForm.fdNumberMainId}">
   <c:import url="/sys/number/include/sysNumberMain_edit.jsp" charEncoding="UTF-8">
		<c:param name="modelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
	</c:import>
</c:if>
