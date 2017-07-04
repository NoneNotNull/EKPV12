//初使化常用审批语
$(document).ready( function() {
	lbpm.globals.initialCommonUsages();
});
lbpm.globals.initialCommonUsages = function() {
	var url = Com_Parameter.ContextPath + 'sys/lbpmservice/support/lbpm_usage/lbpmUsage.do?method=getUsagesInfo';
	var kmssData = new KMSSData();
	kmssData.SendToUrl(url,
			function(http_request) {
				var responseText = http_request.responseText;
				var names = responseText ? decodeURIComponent(responseText) : null;
				var usageContents;
				if (names != null && names != "") {
					usageContents = names.split("\n");
				}
				lbpm.globals.initialCommonUsageObj("commonUsages",
						usageContents);
				lbpm.globals.initialCommonUsageObj("commonSimpleUsages",
						usageContents);
				//初始化审批操作控件常用审批意见 作者 曹映辉 #日期 2015年1月7日
				$("select[name*='commonUsages_']").each(function(){
					lbpm.globals.initialCommonUsageObj($(this).attr("name"),
								usageContents);
				});
			});
};

lbpm.globals.initialCommonUsageObj = function(commonUsageObjName, usageContents) {
	var commonUsageObj = document.getElementsByName(commonUsageObjName);
	if (commonUsageObj != null && commonUsageObj.length > 0) {
		commonUsageObj = commonUsageObj[0];
		while (commonUsageObj.childNodes.length > 0) {
			commonUsageObj.removeChild(commonUsageObj.childNodes[0]);
		}
		var option = document.createElement("option");
		option.appendChild(document
				.createTextNode(window.dojo ? lbpm.workitem.constant.COMMONUSAGES : lbpm.workitem.constant.COMMONPAGEFIRSTOPTION));
		option.value = "";
		commonUsageObj.appendChild(option);
		if (usageContents != null) {
			option = null;
			for ( var i = 0; i < usageContents.length; i++) {
				option = document.createElement("option");
				var usageContent = usageContents[i];
				while (usageContent.indexOf("nbsp;") != -1) {
					usageContent = usageContent.replace("&nbsp;", " ");
				}
				var optTextLength = 30;
				var optText = usageContent.length > optTextLength ? usageContent
						.substr(0, optTextLength) + '...'
						: usageContent;
				option.appendChild(document.createTextNode(optText));
				option.value = usageContent;
				commonUsageObj.appendChild(option);
			}
		}
	}
};

// 自定义常用审批语
lbpm.globals.openDefiniateUsageWindow = function() {
	var url = Com_Parameter.ContextPath
			+ "sys/lbpmservice/support/lbpm_usage/lbpmUsage_mainframe.jsp";
	var param={
		AfterShow:function(rtnVal){
			lbpm.globals.initialCommonUsages();
		}
	}
	lbpm.globals.popupWindow(url,800,600,param);
};
// 设置常用审批语
lbpm.globals.setUsages = function(commonUsagesObj) {
	if (commonUsagesObj.selectedIndex > 0) {
		var fdUsageContent = document.getElementsByName("fdUsageContent")[0];
		var fdSimpleUsageContent = document
				.getElementsByName("fdSimpleUsageContent")[0];
		// 清除默认审批意见
		lbpm.globals.clearDefaultUsageContent(fdUsageContent,
				fdSimpleUsageContent);

		fdUsageContent.value += commonUsagesObj.options[commonUsagesObj.selectedIndex].value
				+ "\r\n";
		if (fdSimpleUsageContent != null) {
			fdSimpleUsageContent.value += commonUsagesObj.options[commonUsagesObj.selectedIndex].value
					+ "\r\n";
		}
	}
};

/**
 * 清除默认审批意见信息。 #作者：曹映辉 #日期：2011年12月15日
 */
lbpm.globals.clearDefaultUsageContent = function(usageContent, simpleUsage) {
	var defalutUsage = lbpm.workitem.constant.COMMONHANDLERUSAGECONTENTDEFAULT;
	usageContent = usageContent || document.getElementsByName("fdUsageContent")[0];
	if (usageContent && usageContent.value.replace(/\s*/ig, '') == defalutUsage) {
		usageContent.value = "";
	}
	simpleUsage = simpleUsage || document.getElementsByName("fdSimpleUsageContent")[0];
	if (simpleUsage && simpleUsage.value.replace(/\s*/ig, '') == defalutUsage) {
		simpleUsage.value = "";
	}
};

/**
 * 设置默认审批意见信息。 #作者：曹映辉 #日期：2011年12月15日
 */
lbpm.globals.setDefaultUsageContent = function(usageContent, simpleUsage) {
	var defalutUsage = lbpm.workitem.constant.COMMONHANDLERUSAGECONTENTDEFAULT;
	usageContent = usageContent || document.getElementsByName("fdUsageContent")[0];
	// 审批意见为空时才设置默认审批意见
	if (usageContent && !usageContent.value.replace(/\s*/ig, '')) {
		usageContent.value = defalutUsage;
	}
	simpleUsage = simpleUsage || document.getElementsByName("fdSimpleUsageContent")[0];
	if (simpleUsage && !simpleUsage.value.replace(/\s*/ig, '')) {
		simpleUsage.value = defalutUsage;
	}
};
