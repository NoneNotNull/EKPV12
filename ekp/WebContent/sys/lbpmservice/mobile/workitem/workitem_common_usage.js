

require(["dojo/store/Memory", "dojo/ready", "dijit/registry", "dojo/request", 
         "dojox/mobile/viewRegistry", "dojo/query", "dojo/dom-style", 
         "mui/dialog/Dialog", "dojo/_base/array", "dojo/topic", "dojo/touch"], 
		function(Memory, ready, registry, request, viewRegistry, query, domStyle, Dialog, array, topic, touch) {
	//初使化常用审批语
	ready( function() {
		lbpm.globals.initialCommonUsages();
		topic.subscribe('/dojox/mobile/beforeTransitionIn', function() {
			var fdUsageContent = registry.byId('fdUsageContent');
			if (fdUsageContent) {
				fdUsageContent.resizeHeight(fdUsageContent.textareaNode);
			}
		});
	});
	
	lbpm.globals.initialCommonUsages = function() {
		var url = Com_Parameter.ContextPath + 'sys/lbpmservice/support/lbpm_usage/lbpmUsage.do?method=getUsagesInfo';
		request.get(url, {handleAs:'text'}).then(function(responseText) {
			var names = responseText ? decodeURIComponent(responseText) : null;
			var usageContents = [];
			if (names != null && names != "") {
				usageContents = names.split("\n");
			}
			lbpm.globals.initialCommonUsageObj("commonUsages",
					usageContents);
		});
	};
	
	function getUsageContents(usageContents) {
		return array.map(usageContents, function(usageContent) {
			while (usageContent.indexOf("nbsp;") != -1) {
				usageContent = usageContent.replace("&nbsp;", " ");
			}
			return {text: usageContent, value: usageContent};
		});
	}
	
	var temp = '<input type="checkbox" data-dojo-type="mui/form/CheckBox" name="_select_box_commonUsageObjName" value="!{value}" data-dojo-props="mul:false,text:\'!{text}\'">';

	function buildItemHtml(props) {
		return temp.replace(
				'!{text}', props.text).replace(
				'!{value}', props.value);
	}
	
	function buildContentHtml(usageContents) {
		var ucs = getUsageContents(usageContents);
		if (ucs.length == 0) {
			return "<p>暂时没有数据</p>";
		}
		var html = array.map(ucs, function(props) {
			return buildItemHtml(props);
		});
		return "<div class='muiFormSelectElement'>" + html.join("") + "</div>";
	}
	
	lbpm.globals.initialCommonUsageObj = function(commonUsageObjName, usageContents) {
		var dialog = null, html = buildContentHtml(usageContents);
		query("#" + commonUsageObjName).on(touch.press, function() {
			setTimeout(function(){
				dialog = Dialog.element({
					title : "常用审批意见",
					element : html,
					showClass: 'muiDialogSelect',
					callback: function() {
						dialog = null;
					}
				});
			},300);
		});
		topic.subscribe("mui/form/checkbox/change", function(box, data) {
			if (data.name != '_select_box_commonUsageObjName') {
				return;
			}
			if (dialog)
				dialog.hide();
			dialog = null;
			lbpm.globals.clearDefaultUsageContent();
			var fdUsageContent = registry.byId('fdUsageContent');
			fdUsageContent.set('value', fdUsageContent.get('value') + data.value + "\r\n");
		});
	};

	lbpm.globals.clearDefaultUsageContent = function() {
		var defalutUsage = lbpm.workitem.constant.COMMONHANDLERUSAGECONTENTDEFAULT;

		var fdUsageContent = registry.byId('fdUsageContent');
		var val = fdUsageContent.get('value');
		if (val.replace(/\s*/ig, '') == defalutUsage) {
			fdUsageContent.set('value', '');
		}
	};
	
	lbpm.globals.setDefaultUsageContent = function(usageContent, simpleUsage) {
		var defalutUsage = lbpm.workitem.constant.COMMONHANDLERUSAGECONTENTDEFAULT;
		usageContent = usageContent || document.getElementsByName("fdUsageContent")[0];
		// 审批意见为空时才设置默认审批意见
		if (usageContent && !usageContent.value.replace(/\s*/ig, '')) {
			usageContent.value = defalutUsage;
		}
	};

});