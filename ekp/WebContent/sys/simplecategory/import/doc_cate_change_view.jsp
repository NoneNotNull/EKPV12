<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<kmss:auth
	requestURL="/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=${param.fdCateModelName}&categoryId=${param.fdCategoryId}&modelName=${param.fdMmodelName}"
	requestMethod="GET">
	<script type="text/javascript">
	function changeCateCheckSelect() {
		var url = '/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=${param.fdCateModelName}&modelName=${param.fdMmodelName}&categoryId=${param.fdCategoryId}&docFkName=${param.docFkName}&fdIds=${param.fdMmodelId}&extProps=${param.extProps}';
		seajs
				.use(
						[ 'lui/dialog' ],
						function(dialog) {
							dialog
									.iframe(
											url,
											"${ lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }",
											function() {
											}, {
												"width" : 600,
												"height" : 300
											});
						});
	}
	// -->
</script>
	<ui:button
		text="${ lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }"
		onclick="changeCateCheckSelect();" order="4"></ui:button>
</kmss:auth>
