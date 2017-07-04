<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/attachment/style/att.css" />
<c:set var="fdKey" value="${param.attFdKey}"/>
<c:set var="formBeanName" value="${param.formName}" />
<section data-lui-role="collapsible">
		<script type="text/config">
				{
					title : '附件信息',
					expand : ${empty param.expand ? false : param.expand},
					group : '${empty param.group ? "" : param.group}',
					multi : ${empty param.multi ? true : param.multi}
				}
		</script>
		<div  data-lui-role="component" style="display: none;">
			<script type="text/config">
					{
						lazy : true
					}
			</script>
			<c:import url="/sys/attachment/pda/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="${fdKey}" />
				<c:param name="formBeanName" value="${formBeanName}"/>
				<%-- 金格启用模式下 支持附件显示图片 begin--%>
			   <%-- <c:param name="formName" value="${pda_formName}"/>
                   <c:param name="fdModelId" value="${fdModelId}"/>--%>
                   <%-- 金格启用模式下 支持附件显示图片 end--%>
			</c:import>
		</div>
</section>