<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
	<c:param name="formBeanName" value="${param.formName}" />
	<c:param name="fdKey" value="${param.auditNoteFdId}_sp" />
	<c:param name="fdViewType" value="simple" />
   	<c:param name="fdForceDisabledOpt" value="edit" />
</c:import>