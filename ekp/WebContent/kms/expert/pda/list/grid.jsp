<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/expert/pda/list/css/grid.css" />
<section id="grid" data-lui-role="expertGrid" class="lui-expert-grid-container">
	<script type="text/config">
		{
			source : {
				url : '${LUI_ContextPath}/kms/expert/kms_expert_index/kmsExpertIndex.do?method=list&getCount=true&s_block=all&categoryId=${param.categoryId}&rowsize=2&orderby=fdCreateTime&ordertype=down',
				type : 'ajaxJson'
			},
			render : {
				url : '${LUI_ContextPath}/kms/expert/pda/list/tmpl/grid.jsp'
			},
			lazy : true
		}
	</script>
</section>	