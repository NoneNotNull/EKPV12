<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<section id="column" data-lui-role="column">
	<script type="text/config">
		{
			source : {
					
				url : '${LUI_ContextPath}/kms/ask/kms_ask_index/kmsAskTopicIndex.do?method=index&categoryId=${param.categoryId}&orderby=docCreateTime&ordertype=down&rowsize=16',
				type : 'ajaxJson'
			},
			render : {
				url : '${LUI_ContextPath}/kms/ask/pda/list/tmpl/column.jsp'
			},
			scroll : 'auto'
		}
	</script>
</section>
