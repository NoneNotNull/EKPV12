<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.relation.util.SysRelationExtendPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	Object cateModelName = request
			.getAttribute(SysRelationExtendPluginUtil.PARAM_CATE_MODEL_NAME);
	// 实现了关联机制自定义属性扩展点，分类改变需要
	String type = condition.getProperty().getType();
	if (cateModelName != null && StringUtil.isNotNull(type)) {
		if (cateModelName.equals(type)) {
%>
<script>
	window.isInited = false;
	function onCatePropertychange() {
		if (window.frameElement != null
				&& window.frameElement.tagName == "IFRAME" && isInited == true) {
			setTimeout(
					function() {
						var idV = $('input[name="fdParameter1_${entryIndex}"]')
								.val();
						var textV = $('input[name="t0_${entryIndex}"]').val();
						if (idV == parent.tempId)
							return;
						parent.tempId = idV;
						parent.tempText = textV;
						window.frameElement.src = Com_Parameter.ContextPath
								+ "sys/relation/relation.do?method=selectCondition&forward=conditionUi&fdType=2&fdModuleName=${param.fdModuleName}&fdModuleModelName=${fdModuleModelName}&cateId="
								+ idV;
					}, 1);
		}
	};

	Com_AddEventListener(
			window,
			"load",
			function() {
				var modelName = $('#rela_module', parent.document).val();
				if (!modelName || parent.modelName != modelName) {
					parent.tempId = '';
					parent.tempText = '';
					parent.modelName = modelName;
				}
				var idV = parent.tempId;
				var textV = parent.tempText;
				var $inputText = $('input[name="t0_${entryIndex}'), $inputValue = $('input[name="fdParameter1_${entryIndex}"]');
				$inputText.on({
					'input' : onCatePropertychange,
					'propertychange' : onCatePropertychange,
					'focus' : onCatePropertychange
				});
				if (idV && textV) {
					$inputValue.val(idV);
					$inputText.val(textV);
				} else {
					parent.tempId = '';
					parent.tempText = '';
				}
				window.isInited = true;
			});
</script>
<%
	}
	}
%>



