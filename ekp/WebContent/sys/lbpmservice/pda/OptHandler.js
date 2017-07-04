;(function() {
	
	function idNameHtml(field) {
		return "id=" + field + " name=" + field + "";
	}
	function idNameKeyHtml(field) {
		return "id=" + field + " name=" + field +" key="+field+"";
	}

	function alertText(options) {
		return options.alertText ? options.alertText : "";
	}
	
	function selectBuild(options, optHandlerIds, optHandlerSelectType, modelName, modelId) {
		var idValue = options['idValue'] || '';
		var nameValue = options['nameValue'] || '';
		var html = "<input type='hidden' alertText='" + alertText(options) + "' value='" + Com_HtmlEscape(idValue) + "' " + idNameKeyHtml(options.idField) + ">"
			+ "<input type='hidden' " + idNameKeyHtml(options.nameField) + " alertText='' value='" + Com_HtmlEscape(nameValue) + "'>";
		html += buildBtn(options, optHandlerIds, optHandlerSelectType, modelName, modelId);
		return html;
	}
	
	var buildBtn = function(options, optHandlerIds, optHandlerSelectType, modelName, modelId) {
		return "<input type='button' class='selectStyle' onclick=\"Pda_selectOptHandler('" 
			+ options.idField + "', '" + options.nameField + "', '"
			+ options.splitStr + "', '" + Com_HtmlEscape(optHandlerIds.replace(/\\"/g, '\\"').replace(/\\'/g, "\\'")) + "', '" + optHandlerSelectType 
			+ "', '" + modelName + "', '" + modelId + "'); \">";
	};
	
	var buildFull = function(options, optHandlerIds, optHandlerSelectType, modelName, modelId) {
		
		return selectBuild(options, optHandlerIds, optHandlerSelectType, modelName, modelId);
	};
	
	var handler = function(idField, nameField, splitStr, optHandlerIds, optHandlerSelectType, modelName, modelId) {
		var url = Com_Parameter.ContextPath + "sys/lbpmservice/pda/OptHandler.jsp?fdModelId=" + modelId 
							+ "&fdModelName=" + modelName 
							+ "&optHandlerSelectType=" + optHandlerSelectType 
							+ "&optHandlerIds=" + optHandlerIds;
		
		var divObj = document.getElementById("_pda_address_dialog_div");
		if (divObj == null) {
			divObj = document.createElement("div");
			document.body.insertBefore(divObj, null);
			divObj.setAttribute("id", "_pda_address_dialog_div");
			divObj.setAttribute("class", "_address_div");
			divObj.innerHTML = "<iframe width='100%' height='100%' border='0' id='addressIframe' src=''></frame>";
		}
		divObj.style.display = "block";
		var iframeObj = divObj.getElementsByTagName("iframe");
		if (iframeObj != null) {
			iframeObj[0].setAttribute("src", url);
		}
		
		if (_Address_Current_Tmp_Obj == null)
			_Address_Current_Tmp_Obj = new Object();
		_Address_Current_Tmp_Obj['idField'] = idField;
		_Address_Current_Tmp_Obj['nameField'] = nameField;
		_Address_Current_Tmp_Obj['mulSelect'] = true;
		_Address_Current_Tmp_Obj['splitStr'] = splitStr;
		_Address_Current_Tmp_Obj['selectType'] = null;
		_Address_Current_Tmp_Obj['addAction'] = lbpm.globals.temp_updateFutureHandlers;
		_Address_Current_Tmp_Obj['delAction'] = lbpm.globals.temp_updateFutureHandlers;
		_Address_Current_Tmp_Obj['scrollTop'] = document.body.scrollTop;
	};
	
	var mobileOptBtnHtml = function(options, optHandlerIds, optHandlerSelectType, modelName, modelId) {
		var cateFieldShow = '';
		if (options.cateFieldShow) {
			cateFieldShow = ', cateFieldShow:\'#_'+options.idField+'_label\'" style="float:right;width:35px;height:30px;margin:0;';
		}
		var mixin = "";
		if (options.groupBtn) {
			mixin += dojoConfig.baseUrl + "sys/lbpmservice/mobile/GroupButtonMixin.js";
		}
		
		var html = '<div data-dojo-type="'+dojoConfig.baseUrl+'sys/lbpmservice/mobile/opthandler/OptHandler.js"'
			+ ' data-dojo-mixins="' + mixin + '"'
			+ ' data-dojo-props="idField:\''+options.idField+'\','
			+ 'optHandlerIds:\'' + optHandlerIds + '\','
			+ 'optHandlerSelectType:\'' + optHandlerSelectType + '\','
			+ 'fdModelName:\'' + modelName + '\','
			+ 'fdModelId:\'' + modelId + '\','
			+ 'nameField:\''+options.nameField+'\'' + cateFieldShow
			+'"></div>';
		return html;
	};
	
	window.Pda_selectOptHandler = handler;
	window.Pda_selectOptFullHtml = window.dojo ? mobileOptBtnHtml : buildFull;
	window.Pda_selectOptBtnHtml = window.dojo ? mobileOptBtnHtml : buildBtn;
})();