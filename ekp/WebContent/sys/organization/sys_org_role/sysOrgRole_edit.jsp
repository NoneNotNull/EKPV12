<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<c:if test="${sysOrgRoleForm.fdConfId==null}">
	<%@ include file="/sys/organization/sys_org_role/sysOrgRole_edit_common.jsp"%>
</c:if>
<c:if test="${sysOrgRoleForm.fdConfId!=null}">
	<%@ include file="/sys/organization/sys_org_role/sysOrgRole_edit_line.jsp"%>
</c:if>
<%@ include file="/resource/jsp/edit_down.jsp"%>