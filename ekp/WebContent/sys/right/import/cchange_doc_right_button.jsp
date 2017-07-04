<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<kmss:authShow roles="ROLE_SYSCATEGORY_MAINTAINER">
	<script type="text/javascript">
	
	function changeRightCheckSelect() {
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
			var url = '/sys/right/cchange_doc_right/cchange_doc_right.jsp?modelName=${param.modelName}&authReaderNoteFlag=${param.authReaderNoteFlag}';
			seajs.use( [ 'lui/dialog','lui/topic' ], function(dialog,topic) {
				dialog.iframe(url,"${lfn:message('sys-right:right.button.changeRightBatch')}", function(value) {
				}, {
					"width" : 800,
					"height" : 500
				});
			});
			return;
		} else {
			seajs
					.use(
							[ 'lui/dialog' ],
							function(dialog) {
								dialog
										.alert("${lfn:message('page.noSelect')}");
							});
		}
	}
	// -->
</script>
	<ui:button
		text="${ lfn:message('sys-right:right.button.changeRightBatch')}"
		order="4" onclick="changeRightCheckSelect()">
	</ui:button>
</kmss:authShow>
