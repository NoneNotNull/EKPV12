/**********************************************************
功能：属性页面通用函数
使用：
	在节点属性页面引入

作者：傅游翔
创建时间：2012-07-23
修改记录：
**********************************************************/
var dialogObject=window.dialogArguments?window.dialogArguments:opener.Com_Parameter.Dialog;
var Data_XMLCatche = dialogObject.Window.Data_XMLCatche || window.Data_XMLCatche || [];
var FlowChartObject = dialogObject.Window.FlowChartObject;

var AttributeObject = {};

AttributeObject.Utils = {};

AttributeObject.isEdit = null;

AttributeObject.Init = {};
AttributeObject.Init.ViewModeFuns = [];
AttributeObject.Init.EditModeFuns = [];
AttributeObject.Init.AllModeFuns = [];

AttributeObject.SubmitFuns = [];

AttributeObject.Utils.callFunctions = function(funs, canInterrupt) {
	canInterrupt = canInterrupt || false;
	for (var i = 0; i < funs.length; i ++) {
		var result = funs[i]();
		if (canInterrupt) {
			if (false == result) {
				return false;
			}
		}
	}
	return true;
};

AttributeObject.Utils.PopupWindow=function(url, width, height, parameter){
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	if(window.showModalDialog){
		var winStyle = "resizable:1;scroll:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;
		var rtnVal=window.showModalDialog(url, parameter, winStyle);
		if(parameter.AfterShow)
			parameter.AfterShow(rtnVal);
	}else{
		var winStyle = "resizable=1,scrollbars=1,width="+width+",height="+height+",left="+left+",top="+top+",dependent=yes,alwaysRaised=1";
		Com_Parameter.Dialog = parameter;
		var tmpwin=window.open(url, "_blank", winStyle);
		if(tmpwin){
			tmpwin.onbeforeunload=function(){
				if(parameter.AfterShow)
					parameter.AfterShow(tmpwin.returnValue);
			}
		}		
	}
}

AttributeObject.initDocument = function() {
	setTimeout(AttributeObject._initDocument, 100);
};
AttributeObject._initDocument = function() {
	var isEdit = AttributeObject.isEdit ? AttributeObject.isEdit() : FlowChartObject.IsEdit;
	AttributeObject.isNodeCanBeEdit = isEdit;
	AttributeObject.Utils.callFunctions(AttributeObject.Init.AllModeFuns, false);
	if(isEdit){
		AttributeObject.Utils.callFunctions(AttributeObject.Init.EditModeFuns, false);
	} else {
		AttributeObject.Utils.callFunctions(AttributeObject.Init.ViewModeFuns, false);
	}
};

AttributeObject.submitDocument = function() {
	var result = AttributeObject.Utils.callFunctions(AttributeObject.SubmitFuns, true);
	if (result == false) {
		return false;
	}
	return true;
};

AttributeObject.Utils.disabledOperation = function(d) {
	var _d = d || window.document;
	_d = $(_d);
	_d.find("a[viewdisplay!='true']").hide();
	_d.find("input[type!='button']").attr("disabled", "true");
	_d.find("input[type='button'][viewdisabled='true']").attr("disabled", "true");
	_d.find("select").attr("disabled", "true");
	_d.find("textarea").attr("disabled", "true");
	_d.find("button[viewdisabled='true']").attr("disabled", "true");
};
AttributeObject.Utils.disabledOperation.name = "disabledOperation";
AttributeObject.Init.ViewModeFuns.push(AttributeObject.Utils.disabledOperation);

AttributeObject.Utils.nodeDesc = function(node) {
	return FlowChartObject.Nodes.nodeDesc(node);
};
