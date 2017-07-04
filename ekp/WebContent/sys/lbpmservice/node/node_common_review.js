$(document).ready(function(){ 
	lbpm.globals.controlExtendRoleOptRow();
	lbpm.globals.getHandlerInfo();
});  
//取得当前处理人和已经处理人
lbpm.globals.getHandlerInfo=function(){
	var currentHandlersLabel = document.getElementById("currentHandlersLabel");
	if(currentHandlersLabel != null && lbpm.currentHandlers != null){
		var currentHandlersRow = document.getElementById("currentHandlersRow");
		if(currentHandlersRow != null) {
			lbpm.globals.hiddenObject(currentHandlersRow, false);
		}
		currentHandlersLabel.innerHTML = lbpm.currentHandlers;
	}
	var historyHandlersLabel = document.getElementById("historyHandlersLabel");
	if(historyHandlersLabel != null && lbpm.historyHandlers != null){
		var historyHandlersRow = document.getElementById("historyHandlersRow");
		if(historyHandlersRow != null) {
			lbpm.globals.hiddenObject(historyHandlersRow, false);
		}
		historyHandlersLabel.innerHTML = lbpm.historyHandlers;
	} 
}

//打开起草人或特权人处理流程的小窗口, roleType的值为drafter或者authority
lbpm.globals.openExtendRoleOptWindow=function(roleType, operationType){
	var param = {
			Window:window,
			AfterShow:function(rtnVal){
				lbpm.globals.redirectPage(rtnVal);
			}
		};
	var url = Com_Parameter.ContextPath + "sys/lbpmservice/include/sysLbpmProcess_panel_frame.jsp?roleType=" 
		+ roleType + (operationType ? "&operationType=" + operationType : "") + "&docStatus="+lbpm.constant.DOCSTATUS+"&modelName="+lbpm.modelName;
	lbpm.globals.popupWindow(url,600,400,param);
}

lbpm.globals.popupWindow=function(url,width,height,param){
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		var rtnVal=window.showModalDialog(url, param, winStyle);
		if(param.AfterShow)
			param.AfterShow(rtnVal);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = param;
		var tmpwin=window.open(url, "_blank", winStyle);
		if(tmpwin){
			tmpwin.onbeforeunload=function(){
				if(param.AfterShow)
					param.AfterShow(tmpwin.returnValue);
			}
		}		
	}
}

lbpm.globals.extendRoleOptWindowSubmit=function(submitType){
	if(!lbpm.globals.submitFormEvent()){
		return;
	}
	var kmssData = new KMSSData();
	kmssData.AddHashMapArray(lbpm.globals.buildFormToHashArray(document.forms['sysWfProcessForm']));
	kmssData.SendToUrl(Com_Parameter.ContextPath + 'sys/lbpmservice/support/lbpm_process/lbpmProcess.do?method=' + submitType, function(request) {
		var responseText = request.responseText;
	    var operationKey = Com_GetUrlParameter(responseText, "operationKey");
	    top.returnValue = operationKey;
	    top.close();
	}, true);
}

/**
* 封装数据,把form表单里面所有需要提交的数据封装
* 所有需要提交数据封装     
* formobj form对象
* return string 
*/
lbpm.globals.buildFormToHashArray=function(formObj) {
	var array = [], elementsObj, obj;
	if(formObj){
		elementsObj = formObj.elements;
		if(elementsObj) {
			for(var i=0; i<elementsObj.length; i++){
				obj = elementsObj[i];
				if(obj.name != undefined && obj.name != ""){
					var arg = {};
					arg[obj.name] = obj.value;
					array.push(arg);
				}
			}
		}
	}
	return array;
}

lbpm.globals.buildExtendRoleOptButton = function(cfg) {
	if (window.LUI){
		return $('<a class="com_btn_link" id="' + cfg.optType + 'Button"' + ' style="margin: 0 10px 0 0;" title="'+ cfg.optTypeName +'"'
			+ ' onclick="lbpm.globals.openExtendRoleOptWindow(\''+cfg.roleType+'\', \''+cfg.optType+'\');" href="javascript:void(0);">'
			+ cfg.optTypeName + '</a>');
	} else {
		return $('<input class="btnopt" type=button id="' + cfg.optType + 'Button"' + ' value="'+ cfg.optTypeName +'"'
				+ ' onclick="lbpm.globals.openExtendRoleOptWindow(\''+cfg.roleType+'\', \''+cfg.optType+'\');"/>');
	}
}

//展示进行起草人或特权人角色的操作行
lbpm.globals.controlExtendRoleOptRow=function(){
	var extendRoleOptRow = document.getElementById("extendRoleOptRow");
	var drafterOptButton = document.getElementById("drafterOptButton");
	var authorityOptButton = document.getElementById("authorityOptButton");
	var historyhandlerOpt = document.getElementById("historyhandlerOpt");
	var drafterInfoObj = lbpm.globals.getDrafterInfoObj();
	var authorityInfoObj = lbpm.globals.getAuthorityInfoObj();
	var historyhandlerInfoObj = lbpm.globals.getHistoryhandlerInfoObj();
	var index = 0;
	if(drafterInfoObj == null || drafterInfoObj.length == 0 || drafterInfoObj[0].operations == null || drafterInfoObj[0].operations.length==0){ 
		// 无操作时不显示 2009-8-19 by fuyx
		lbpm.globals.hiddenObject(drafterOptButton, true);
	}else{
		lbpm.globals.hiddenObject(drafterOptButton, false);
		index++;
	}

	if(authorityInfoObj == null || authorityInfoObj.length == 0){
		lbpm.globals.hiddenObject(authorityOptButton, true);
	}else{
		lbpm.globals.hiddenObject(authorityOptButton, false);
		index++;
	}
	
	if(historyhandlerInfoObj == null || historyhandlerInfoObj.length == 0){
		lbpm.globals.hiddenObject(historyhandlerOpt, true);
	}else{
		var optTypeTmp = [];
		var contains = function(type) {
			for (var k = 0; k < optTypeTmp.length; k++) {
				if(optTypeTmp[k] == type){
					return true;
				}
			}
			return false;
		};
		for(var i = 0; i < historyhandlerInfoObj.length; i++) {
			for(var j = 0; j < historyhandlerInfoObj[i].operations.length; j++) {
				var opt = historyhandlerInfoObj[i].operations[j];
				if(contains(opt.id+":"+opt.name)) { // 避免并发分支按钮重复
					continue;
				}
				optTypeTmp.push(opt.id+":"+opt.name);
				var btn = lbpm.globals.buildExtendRoleOptButton({optType:opt.id, optTypeName: opt.name, roleType: opt.operationHandlerType});
				$(historyhandlerOpt).prepend(btn);
			}
		}
		lbpm.globals.hiddenObject(historyhandlerOpt, false);
		index++;
	}
	
	if(extendRoleOptRow != null){
		if(index == 0){
			lbpm.globals.hiddenObject(extendRoleOptRow, true);
		}else{
			lbpm.globals.hiddenObject(extendRoleOptRow, false);
		}
	}
}

