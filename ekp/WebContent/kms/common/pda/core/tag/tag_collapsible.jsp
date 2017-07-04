<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<section data-lui-role="collapsible">
		<script type="text/config">
				{
					title : '知识标签',
					expand : ${empty param.expand ? false : param.expand},
					group : '${empty param.group ? "" : param.group}',
				    multi : ${empty param.multi ? true : param.multi}
				}
		</script>
		<table class="tb_normal" data-lui-role="component" style="display: none;">
			<script type="text/config">
					{
						lazy : true
					}
			</script>
			<c:import url="/sys/tag/import/sysTagMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="${param.formName }" />
				<c:param name="useTab" value="true"></c:param>
			</c:import>
		</table>
</section>