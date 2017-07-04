<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<section id="column" data-lui-role="column">
	<script type="text/config">
		{
			source : {
				url : '${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=${param.categoryId}&orderby=docPublishTime&ordertype=down&rowsize=16',
				type : 'ajaxJson'
			},
			render : {
				url : '${LUI_ContextPath}/kms/knowledge/pda/list/tmpl/column.jsp'
			},
			scroll : 'auto'
		}
	</script>
</section>
