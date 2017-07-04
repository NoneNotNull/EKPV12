<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<section id="rowtable" data-lui-role="rowTable">
	<script type="text/config">
		{
			source : {
				url : '${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=${param.categoryId}&orderby=docPublishTime&ordertype=down&rowsize=16&dataType=pic',
				type : 'ajaxJson'
			},
			render : {
				url : '${LUI_ContextPath}/kms/knowledge/pda/list/tmpl/rowtable.jsp'
			},
			lazy : true,
			scroll : 'auto'
		}
	</script>
</section>