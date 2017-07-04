<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="<c:url value="/kms/common/resource/js/lib/jquery.js" />"
	type="text/javascript"></script>
<script>
	Com_IncludeFile("doclist.js|dialog.js");
	window.onload = function() {
		DocList_Info = new Array("knowledge_mapping_doclist");
		$('input[name="fdName"]')
				.focusout(
						function() {
							var fdTopName = $('input[name="fdTopName"]'), fdName = $('input[name="fdName"]');
							(fdTopName.val()) ? '' : fdTopName
									.val(fdName.val());
						});
	};

	function selectModel() {
		var dialog = new KMSSDialog(false, true);
		dialog.winTitle = "选择模块";
		dialog.AddDefaultOptionBeanData("kmsModuleDataBean");
		dialog.BindingField("fdModelId", "fdModelName", ";", false);
		dialog.notNull = false;
		dialog.Show();
		return false;
	}

	function selectPortal() {
		var dialog = new KMSSDialog(false, true);
		dialog.winTitle = "选择门户";
		dialog.AddDefaultOptionBeanData("kmsPortalDataBean");
		dialog.BindingField("fdPortalId", "fdPortalName", ";", false);
		dialog.notNull = false;
		dialog.Show();
		return false;
	}
</script>