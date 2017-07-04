var KMS_PORTLET_URL = KMS.basePath
		+ "/common/kms_common_portlet/kmsCommonPortlet.do?method=execute&";
function KMS_JSON(str) {
	return eval("(" + str + ")");
}
function KMS_PORTLET(pid) {
	var portlet = $("#" + pid);
	var parameters = KMS_JSON(portlet.attr("parameters"));
	if (parameters.kms.dataType.toUpperCase() == "URL"
			|| parameters.kms.dataType.toUpperCase() == "BEAN") {
		if ("true" != portlet.attr("load")) {
			var ajaxUrl = "";
			var ajaxParm = {};
			if (parameters.kms.dataType.toUpperCase() == "URL") {
				ajaxUrl = parameters.kms.dataUrl;
			} else if (parameters.kms.dataType.toUpperCase() == "BEAN") {
				ajaxUrl = KMS_PORTLET_URL + "s_bean=" + parameters.kms.dataBean;
				ajaxParm = KMS_JSON(parameters.kms.beanParm);
			}
			$.getJSON(ajaxUrl, ajaxParm, function(data) {
						portlet.html(KmsTmpl(parameters.kms.template).render({
									"parameters" : parameters,
									"data" : data
								}));
						portlet.attr("load", true);
						if (parameters.kms.callBack) {
							eval(" " + parameters.kms.callBack + "('"
									+ parameters.kms.id + "');");
						}
					});
		}
	}
}
function KMS_TAB_PORTLET_CHANGE(tpid, pid) {
	$("div[portlet='" + tpid + "']").hide();
	var portlet = $("#" + pid);
	portlet.show();
	var parameters = KMS_JSON(portlet.attr("parameters"));
	eval(" " + parameters.kms.renderer + "('" + parameters.kms.id + "');");
	tab_portlet_onclick(tpid, pid, parameters);
}

function tab_portlet_onclick(tpid, pid, parameters) {

	$("#" + tpid + "_nav").find("li").removeClass('selectTag');
	$($("#" + tpid + "_nav").find("li").get(parameters.kms.index))
			.addClass('selectTag');
	// 外部调用方法
	typeof(firePortletEvent) == 'undefined' ? '' : firePortletEvent(pid);
}

$(document).ready(function() {
	// KMS Portlet展现
	$("div[portlet='portlet']").each(function(i, obj) {
		try {
			var portlet = $(obj);
			var parameters = KMS_JSON(portlet.attr("parameters"));
			eval(" " + parameters.kms.renderer + "('" + parameters.kms.id
					+ "');");
		} catch (error) {
			alert(error)
		}
	});

	// KMS Tab Portlet 展现
	$("div[portlet='tabportlet']").each(function(i, obj) {
		var tabportlet = $(obj);
		var parameters = KMS_JSON(tabportlet.attr("parameters"));
		var tpid = tabportlet.attr("id");
		var pid = "";
		var tabs = [];
		$("div[portlet='" + tpid + "']", tabportlet).each(function(ii, objobj) {
					var portlet = $(objobj);
					var tab = KMS_JSON(portlet.attr("parameters"));
					if (parameters.kms.selected == tab.kms.index) {
						pid = tab.kms.id;
					}
					tabs[ii] = tab;
				});
		try {
			$("#" + tpid + "_nav").html(KmsTmpl(parameters.kms.template)
					.render({
								"parameters" : parameters,
								"tabs" : tabs
							}));
			KMS_TAB_PORTLET_CHANGE(tpid, pid);
		} catch (error) {
			alert(error)
		}
	});
});