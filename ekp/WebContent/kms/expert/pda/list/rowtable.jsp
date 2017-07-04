<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/expert/pda/list/css/rowtable.css" />
<section id="rowtable" data-lui-role="rowTable">
	<script type="text/config">
		{
			source : {
				url : '${LUI_ContextPath}/kms/expert/kms_expert_index/kmsExpertIndex.do?method=list&s_block=all&categoryId=${param.categoryId}&rowsize=16&orderby=fdCreateTime&ordertype=down',
				type : 'ajaxJson'
			},
			render : {
				url : '${LUI_ContextPath}/kms/expert/pda/list/tmpl/rowtable.jsp'
			},
			scroll : 'auto'
		}
	</script>
</section>
