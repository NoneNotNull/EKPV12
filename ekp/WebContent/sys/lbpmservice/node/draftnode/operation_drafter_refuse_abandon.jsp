<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
	lbpm.globals.includeFile("lbpmservice/operation/operation_common_passtype.js");
	( function(operations) {
		operations['drafter_refuse_abandon'] = {
			click : function() {
			},
			check : function() {
				return true;
			},
			setOperationParam : function() {
			}
		};
		$(document).ready(function() {
			var btn = '<a class="com_btn_link" id="drafterRefuseAbandonOptButton"'
				+' style="margin-top: 0px; margin-right: 10px; margin-bottom: 0px; margin-left: 0px; " '
				+ ' onclick="lbpm.globals.drafterRefuseAbandonOpt();" href="javascript:void(0);">'
				+'<bean:message key="lbpmOperations.fdOperType.draft.abandon" bundle="sys-lbpmservice-operation-drafter" />'
				+'</a>';
			$("#authorityOptButton").parent("td").prepend(btn); // 追加废弃按钮
			var group = $("#operationMethodsGroup");
			if (group.attr('view-type') == 'select') {
				// select
				var opt = group.find("option[value^='drafter_refuse_abandon']");
				group.data("drafter_refuse_abandon", opt.parent().html());
				opt.remove(); // 移除操作
			} else {
				// radio
				group.find("input[name='oprGroup'][value^='drafter_refuse_abandon']").parent("label").hide(); // 隐藏操作
			}
			$("#extendRoleOptRow").show();
		});
		lbpm.globals.drafterRefuseAbandonOpt = function() {
			if (confirm('<bean:message key="lbpmNode.validate.abandon.confirm" bundle="sys-lbpmservice" />')) {
				var group = $("#operationMethodsGroup");
				if (group.attr('view-type') == 'select') {
					// select
					var data = group.data("drafter_refuse_abandon");
					if (data) {
						group.append(data); // 还原操作并选中
						group.removeData("drafter_refuse_abandon");
					}
					group.find("option[value^='drafter_refuse_abandon']").attr('selected', true);
				} else {
					// radio
					group.find("input[name='oprGroup'][value^='drafter_refuse_abandon']").click(); // 选中操作
				}
				$("#process_review_button").click();
			}
		};
	})(lbpm.operations);
</script>