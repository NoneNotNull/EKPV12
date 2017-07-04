<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<c:set var="_fdKey" value="${param.fdKey}"/>
<c:set var="_fdAttType" value="${param.fdAttType}"/>
<c:set var="_fdItemMixin" value="${param.fdItemMixin}"/>
<c:set var="_fdExtendClass" value="${param.fdExtendClass}"/>

<c:if test="${param.formName!=null && param.formName!=''}">
 	<c:set var="_formBean" value="${requestScope[param.formName]}"/>
 	<c:set var="attForms" value="${_formBean.attachmentForms[_fdKey]}" />
 </c:if>
<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
	<link rel="stylesheet" type="text/css" 
		href="<%=request.getContextPath()%>/sys/lbpmservice/mobile/audit_note_ext/log/log_style.css"></link>
	<div class="muiAuditLog ${_fdExtendClass}">
		<c:if test="${_fdAttType!='pic' }">
			<ul class="muiAuditList">
				<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
					<c:set var="downLoadUrl" value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
					<li data-dojo-type='sys/lbpmservice/mobile/audit_note_ext/log/AuditLogItem' 
						<c:if test="${ _fdItemMixin!='' }"> data-dojo-mixins='${ _fdItemMixin}' </c:if>
						data-dojo-props='fdId:"${sysAttMain.fdId}",label:"${sysAttMain.fdFileName}",href:"${downLoadUrl}"'>
					</li>
				</c:forEach>
			</ul>
		</c:if>
		<c:if test="${_fdAttType=='pic' }">
			<c:forEach var="sysAttMain" items="${attForms.attachments}" varStatus="vsStatus">
				 <c:set var="downLoadUrl" value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
				 <img class="muiAuditImg" border="0" width="100" height="75" src='<c:url value="${downLoadUrl}"/>'/>
			</c:forEach>
		</c:if>
	</div>
</c:if>
