<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<kmss:auth
	requestURL="/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=${param.cateModelName}&categoryId=${param.categoryId}&modelName=${param.modelName}"
	requestMethod="GET">
	<script type="text/javascript">
	
	function changeCateCheckSelect() {
		var values = "";
		var selected;
		var select = document.getElementsByName("List_Selected");
		for ( var i = 0; i < select.length; i++) {
			if (select[i].checked) {
				selected = true;
				break;
			}
		}
		if (selected) {
			values = values.substring(0, values.length - 1);
			var url = '/sys/sc/cateChg.do?method=cateChgEdit&cateModelName=${param.cateModelName}&modelName=${param.modelName}&categoryId=${param.categoryId}&docFkName=${param.docFkName}&extProps=${param.extProps}';
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

		} else {
			seajs.use( [ 'lui/dialog' ], function(dialog) {
				dialog.alert("${lfn:message('page.noSelect')}");
			})
		}
	}
</script>
	<ui:button
		text="${ lfn:message('sys-simplecategory:sysSimpleCategory.chg.button') }"
		onclick="changeCateCheckSelect();" order="4"></ui:button>
</kmss:auth>
