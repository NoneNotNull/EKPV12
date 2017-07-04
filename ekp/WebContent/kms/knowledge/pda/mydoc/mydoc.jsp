<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<style>
	.lui-column-table h3{
		font-size: 14px;
		font-weight: normal;
		padding: 8px 0px;
		border-bottom: 1px solid #CBCBCB; 
	}
	.lui-column-table a{
		color: #000;
	}
</style>
<section id="${param.id }" data-lui-role="rowTable" class="content" style="display:none">
	<script type="text/config">
	{
							source : {
								url : '${LUI_ContextPath}/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listPerson&orderby=docPublishTime&ordertype=down&rowsize=16&userId=${fdOrgId}&personType=other&q.mydoc=myOriginal',
								type : 'ajaxJson'
							},
							render : {
								url : '${LUI_ContextPath}/kms/knowledge/pda/mydoc/tmpl/mydoc.jsp'
							},
							lazy : true
	}
	</script>
</section>

