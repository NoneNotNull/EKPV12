<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<section id="grid" data-lui-role="falls" style="position:relative;">
	<script type="text/config">
		{
			source : {
				url : '${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=${param.categoryId}&orderby=docPublishTime&ordertype=down&rowsize=15&dataType=pic&q.mydoc=create',
				type : 'ajaxJson'
			},
			render : {
				url : '${LUI_ContextPath}/kms/knowledge/pda/list/tmpl/grid.jsp'
			},
			lazy : true
		}
	</script>
</section>	