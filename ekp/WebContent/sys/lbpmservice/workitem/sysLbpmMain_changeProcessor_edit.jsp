<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
<template:replace name="content">
<%@ page import="com.landray.kmss.sys.lbpmservice.constant.LbpmConstants" %>
<script src="<c:url value="/sys/lbpm/flowchart/js/workflow.js"/>"></script>
<script type="text/javascript"> 
var lbpm = new Object();
lbpm.globals = new Object();
Com_Parameter.CloseInfo=null;
Com_IncludeFile("jquery.js|dialog.js|formula.js");
//Com_IncludeFile("workflow.js", "workflow/js/");

// 类似sysWfProcess_script.jsp中的同名函数
lbpm.globals.setHandlerFormulaDialog_=function(idField, nameField, modelName, action) {
	Formula_Dialog(idField,
			nameField,
			FormFieldList, 
			"com.landray.kmss.sys.organization.model.SysOrgElement[]",
			action,
			"com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction",
			modelName);
}
	
// 是公式的情况下，为不让在对话框中出现公式，清除公式信息;不是公式的情况下，为不让在公式对话框中出现组织架构，清除组织架构信息
function WorkFlow_ClearValueForFurtureHandler(id,isFormula) {
	_now_nodeId = id;
	var handlerIdsObj = document.getElementsByName("handlerIds_" + id)[0];
	var handlerNamesObj = document.getElementsByName("handlerNames_" + id)[0];
	if (handlerIdsObj.getAttribute("isFormula") != isFormula) {
		handlerIdsObj.value = '';
		handlerNamesObj.value = '';
	}
}

// 刷新当前值 limh 2011年3月31日
lbpm.globals.setFurtureHandlerInfoes=function(rtv,isFormula){
	var id = _now_nodeId;
	var handlerIdsObj = document.getElementsByName("handlerIds_" + id)[0];
	var handlerNamesObj = document.getElementsByName("handlerNames_" + id)[0];
	if(rtv){
		if(rtv.GetHashMapArray()){
		  handlerIdsObj.setAttribute("isFormula",isFormula);
		  var ids="";
		  var names="";
		  for(var i=0;i<rtv.GetHashMapArray().length;i++){
			  ids+=rtv.GetHashMapArray()[i].id;
			  names+=rtv.GetHashMapArray()[i].name;
			  if(i!=rtv.GetHashMapArray().length-1){
				  ids+=";";
				  names+=";";
			  }
		  }
		  handlerIdsObj.value = ids;
		  handlerNamesObj.value = names;
		}
	}
	else{
		handlerIdsObj.value = handlerIdsObj.defaultValue;
		handlerNamesObj.value = handlerNamesObj.defaultValue;
	}
	_now_nodeId = null;
}

function WorkFlow_ChangeProcessorSubmitForm(){
	var rtnNodesMapJSON= new Array();
	var inputObjs = document.getElementsByTagName("input");
	for(var i = 0; i < inputObjs.length; i++){
		var input = inputObjs[i];
		var _name = input.getAttribute("name");
		if(_name && _name.indexOf("handlerIds_") == 0) {
			var temp = _name.split("_");
			$.each(parent.lbpm.nodes, function(index, nodeData) {
				if(temp[1] == nodeData.id){
					if(temp[0]=="handlerIds"){
						var nameFieldValue = document.getElementsByName("handlerNames_"+temp[1])[0].value;
						rtnNodesMapJSON.push({
							id:temp[1],
							handlerSelectType:input.getAttribute("isFormula")=="true"?"<%=LbpmConstants.HANDLER_SELECT_TYPE_FORMULA%>":"<%=LbpmConstants.HANDLER_SELECT_TYPE_ORG%>",
							handlerIds:input.value,
							handlerNames:nameFieldValue
						});
					}
				}
			});
		}
	};
	var param={};
	param.nodeInfos=rtnNodesMapJSON;
	top.returnValue =param;top.close();
}
</script>
<form>
	<ui:toolbar layout="sys.ui.toolbar.float">
		<ui:button text="${ lfn:message('button.ok') }" styleClass="lui_toolbar_btn_gray" onclick="WorkFlow_ChangeProcessorSubmitForm();">
		</ui:button>
		<ui:button text="${ lfn:message('button.cancel') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();">
		</ui:button>
	</ui:toolbar>
	<p class="txttitle">
		<bean:message  bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.title"/>
	</p>
	<input type="hidden" name="nodeId" />
	<input type="hidden" name="handlerIdentity" />
	<center>
		<table class="tb_normal" width=95%>
			<tbody id="workflowNodeTB">   
				<tr class="tr_normal_title">
					<td width="25%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.nodeIndex" />
					</td>
					<td width="50%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.handlerIds" />
					</td>
					<td width="25%">
						<bean:message bundle="sys-lbpmservice" key="lbpmNode.processingNode.changeProcessor.nodeHelpInfo" />
					</td>
				</tr>
			</tbody>
		</table>
	</center>
</form>
</template:replace>
</template:include>
