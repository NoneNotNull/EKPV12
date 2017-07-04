<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" href="${LUI_ContextPath }/kms/common/pda/core/category/style/category.css" />
<section data-lui-role="category" id="category-panel">
	<script type="text/config">
		{
			modelName : '${param.templateClass}',
			mainModelName : '${param.mainModelName}',
			href : '${param.href}'
		}
	</script>
	<section data-lui-role="component" id="category-component">
		<script type="text/config">
			{
				source : {
					url : '${LUI_ContextPath}/kms/common/kms_common_simple_category/KmsCommonSimpleCategory.do?method=list&modelName=${param.templateClass}&parentId=!{parentId}&type=1',
					type : 'ajaxJson'
				},
				render : {
					url : '${LUI_ContextPath}/kms/common/pda/core/category/tmpl/category.jsp'
				},
				lazy : true,
				parent : 'category-panel'
			}
		</script>
	</section>
</section>

<script>
	function category_click(){
		Pda.Element('category-panel').selected();
		Pda.Element('category-component').draw();
		Pda.Topic.emit('head_btnClick');
	}
</script>