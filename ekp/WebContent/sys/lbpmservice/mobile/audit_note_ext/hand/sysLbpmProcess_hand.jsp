<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<link rel="stylesheet" type="text/css" href="<%=request.getContextPath()%>/sys/lbpmservice/mobile/audit_note_ext/canvas.css"></link>
	<div id="auditNoteHandlerView" data-dojo-type="sys/lbpmservice/mobile/audit_note_ext/hand/AuditNoteHandlerView" style="display:none"
		data-dojo-props='fdKey:"${param.auditNoteFdId}_hw",
				fdAttType:"pic",
				fdModelId:"${param.modelId}",
				fdModelName:"${param.modelName}",
				buttonDiv:"#commonUsagesDiv",
				descriptionDiv: "#descriptionDiv"'>
		<c:import url="/sys/lbpmservice/mobile/audit_note_ext/canvas.jsp" charEncoding="UTF-8"> 
		</c:import>
	</div>
