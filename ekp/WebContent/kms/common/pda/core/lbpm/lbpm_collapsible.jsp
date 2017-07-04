<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/lbpm/style/lbpm.css" />
<c:set var="kmsMultidocKnowledgeForm" value="${requestScope[param.formName]}" />
<c:if test="${kmsMultidocKnowledgeForm.docStatus!='20' && kmsMultidocKnowledgeForm.docStatus != '11'}">
	<section data-lui-role="collapsible" >
		<script type="text/config">
				{
					title : '流程日志',
					expand : ${empty param.expand ? false : param.expand},
					group : '${empty param.group ? "" : param.group}',
					multi : ${empty param.multi ? true : param.multi}
				}
	    </script>
		<div data-lui-role="component" style="display: none;">
			<script type="text/config">
					{
						lazy : true
					}
					</script>
			<%@ include file="/sys/lbpmservice/pda/sysLbpmProcess_log.jsp" %>
		</div>
	</section>
</c:if>