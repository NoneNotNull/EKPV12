<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.km.imissive.util.SignOptionUtil" %>
<%@ page import="com.landray.kmss.km.imissive.model.KmImissiveReturnOpinion" %>
<%@ include file="/resource/jsp/common.jsp"%>
<c:forEach items="${signOpinions}" var="signOpinion">
	  <div style="width:100%; height:auto;">  	
	            <% KmImissiveReturnOpinion option = (KmImissiveReturnOpinion)pageContext.getAttribute("signOpinion");
	           	   String htmlContent =SignOptionUtil.getHtmlOption(option.getDocContent(),request.getContextPath());
	           	   request.setAttribute("htmlContent",htmlContent);
	           	   out.write(htmlContent);%>
	          <c:if test="${not empty htmlContent}">
		            <p align="right"><c:out value="${signOpinion.fdUnit.fdName}"/>
		                    <kmss:showDate value="${signOpinion.docCreateTime}" type="datetime"> </kmss:showDate>
		            </p>
	          </c:if>
	  </div>
</c:forEach>

