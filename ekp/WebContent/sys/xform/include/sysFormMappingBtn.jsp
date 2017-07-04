<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%-- 通用模板被引用时不需要表单数据映射按钮 通用模板的映射在通用模板本身里面 。作者 曹映辉 #日期 2013年9月10日 --%>
<c:if test="${param.fdModeType!=2}">
<kmss:auth
	requestURL="/sys/xform/base/sys_form_db_table/sysFormDbTable.do?method=config&fdModelName=${param.fdModelName}&fdTemplateModel=${param.fdTemplateModel}&fdFormType=${param.fdFormType}&fdModelId=${param.fdModelId}"
	requestMethod="GET">
<div id="_SysXformDbConfigBtn" style="display:none;">
<input type=button value="<kmss:message key="sys-xform:table.sysFormDbTable.btn" />"
	onclick="Com_OpenWindow('<c:url value="/sys/xform/base/sys_form_db_table/sysFormDbTable.do">
		<c:param name="method" value="config"/>
		<c:param name="fdFormId" value="${param.fdTemplateId}"/>
		<c:param name="fdKey" value="${param.fdKey}"/>
		<c:param name="fdModelName" value="${param.fdModelName}"/>
		<c:param name="fdTemplateModel" value="${param.fdTemplateModel}"/>
		<c:param name="fdFormType" value="${param.fdFormType}"/>
		<c:param name="fdModelId" value="${param.fdModelId}"/>
	</c:url>', '_blank');">
</div>

<script language="JavaScript">

	OptBar_AddOptBar("_SysXformDbConfigBtn");


</script>
</kmss:auth>
</c:if>