<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
			<table width="100%" class="tb_normal">
				<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.handlerNames" bundle="sys-lbpmservice" /></td>
					<td>
						<label><input type="radio" name="wf_handlerSelectType" value="org" onclick="switchHandlerSelectType(value);" checked><kmss:message key="FlowChartObject.Lang.Node.selectAddress" bundle="sys-lbpmservice" /></label>
						<label><input type="radio" name="wf_handlerSelectType" value="formula" onclick="switchHandlerSelectType(value);"><kmss:message key="FlowChartObject.Lang.Node.selectFormList" bundle="sys-lbpmservice" /></label>
						<input name="wf_handlerNames" class="inputsgl" style="width:400px" readonly>
						<input name="wf_handlerIds" type="hidden" orgattr="handlerIds:handlerNames">
						<span id="SPAN_SelectType1">
						<a href="#" onclick="Dialog_Address(true, 'wf_handlerIds', 'wf_handlerNames', null, ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE);"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<span id="SPAN_SelectType2" style="display:none ">
						<a href="#" onclick="selectByFormula('wf_handlerIds', 'wf_handlerNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<br>
						<label>
							<input type="checkbox" name="wf_ignoreOnHandlerEmpty" value="true">
							<kmss:message key="FlowChartObject.Lang.Node.ignoreOnHandlerEmpty" bundle="sys-lbpmservice" />
						</label>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.processType" bundle="sys-lbpmservice" /></td>
					<td>
						<label>
							<input name="wf_processType" type="radio" value="0" checked>
							<kmss:message key="FlowChartObject.Lang.Node.processType_0" bundle="sys-lbpmservice" />
						</label><label>
							<input name="wf_processType" type="radio" value="1">
							<kmss:message key="FlowChartObject.Lang.Node.processType_1" bundle="sys-lbpmservice" />
						</label><label>
							<input name="wf_processType" type="radio" value="2">
							<kmss:message key="FlowChartObject.Lang.Node.processType_21" bundle="sys-lbpmservice" />
						</label>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.onHandlerSame" bundle="sys-lbpmservice"/></td>
					<td>
						<input name="wf_ignoreOnHandlerSame" type="hidden" value="true" />
						<input name="wf_onAdjoinHandlerSame" type="hidden" value="true"/>
						<select name="handlerSameSelect" onchange="switchHandlerSameSelect(this);">
							<option value="1" selected="selected">
								<kmss:message key="FlowChartObject.Lang.Node.onAdjoinHandlerSame" bundle="sys-lbpmservice" /></option>
							<option value="2">
								<kmss:message key="FlowChartObject.Lang.Node.onSkipHandlerSame" bundle="sys-lbpmservice" /></option>
							<option value="0">
								<kmss:message key="FlowChartObject.Lang.Node.ignoreOnHandlerSame" bundle="sys-lbpmservice" /></option>
						</select>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.popedom" bundle="sys-lbpmservice" /></td>
					<td>
						<label>
							<input name="wf_canModifyMainDoc" type="checkbox" value="true">
							<kmss:message key="FlowChartObject.Lang.Node.canModifyMainDoc" bundle="sys-lbpmservice" />
						</label>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.description" bundle="sys-lbpm-engine" /></td>
					<td>
						<textarea name="wf_description" style="width:100%"></textarea>
						<kmss:message key="FlowChartObject.Lang.Node.imgLink" bundle="sys-lbpm-engine" />
					</td>
				</tr>
				
				<c:import url="/sys/lbpm/flowchart/page/node_ext_attribute.jsp" charEncoding="UTF-8">
					<c:param name="position" value="base" />
					<c:param name="nodeType" value="${param.nodeType}" />
					<c:param name="modelName" value="${param.modelName}" />
				</c:import>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Operation" bundle="sys-lbpm-engine" />">
		<td>
			<c:import url="/sys/lbpmservice/node/common/node_operation_attribute.jsp" charEncoding="UTF-8">
				<c:param name="nodeType" value="${param.nodeType}" />
				<c:param name="modelName" value="${param.modelName}" />
				<c:param name="passOperationType"><kmss:message key="lbpm.operation.handler_sign" bundle="sys-lbpmservice" /></c:param>
			</c:import>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Advance" bundle="sys-lbpm-engine" />">
		<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.optHandlerNames" bundle="sys-lbpmservice" /></td>
					<td>
						<label><input type="radio" name="wf_optHandlerSelectType" value="org" onclick="switchOptHandlerSelectType(value);" checked><kmss:message key="FlowChartObject.Lang.Node.selectAddress" bundle="sys-lbpmservice" /></label>
						<label><input type="radio" name="wf_optHandlerSelectType" value="formula" onclick="switchOptHandlerSelectType(value);"><kmss:message key="FlowChartObject.Lang.Node.selectFormList" bundle="sys-lbpmservice" /></label>
						<input name="wf_optHandlerIds" type="hidden" orgattr="optHandlerIds:optHandlerNames">
						<input name="wf_optHandlerNames" class="inputsgl" style="width:400px" readonly>
						<span id="SPAN_OptSelectType1">
						<a href="#" onclick="Dialog_Address(true, 'wf_optHandlerIds', 'wf_optHandlerNames', null, ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE);"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<span id="SPAN_OptSelectType2" style="display:none ">
						<a href="#" onclick="selectByFormula('wf_optHandlerIds', 'wf_optHandlerNames');"><kmss:message key="FlowChartObject.Lang.select" bundle="sys-lbpm-engine" /></a>
						</span>
						<br><div id="DIV_OptHandlerCalType"><kmss:message key="FlowChartObject.Lang.Node.optHandlerCalType" bundle="sys-lbpmservice" />: 
						<label>
							<input name="wf_optHandlerCalType" type="radio" value="1">
							<kmss:message key="FlowChartObject.Lang.Node.handler" bundle="sys-lbpm-engine" />
						</label><label>
							<input name="wf_optHandlerCalType" type="radio" value="2" checked>
							<kmss:message key="FlowChartObject.Lang.Node.creator" bundle="sys-lbpm-engine" />
						</label><br></div><label>
							<input name="wf_useOptHandlerOnly" type="checkbox" value="true">
							<kmss:message key="FlowChartObject.Lang.Node.useOptHandlerOnly" bundle="sys-lbpmservice" />
						</label>
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.dayOfHandle" bundle="sys-lbpmservice" /></td>
					<td>
						<kmss:message key="FlowChartObject.Lang.Node.dayOfNotify1" bundle="sys-lbpmservice" />
						<input name="wf_dayOfNotify" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
						<input name="wf_hourOfNotify" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
						<input name="wf_minuteOfNotify" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><kmss:message key="FlowChartObject.Lang.Node.dayOfNotify2" bundle="sys-lbpmservice" /><br>
						
						<kmss:message key="FlowChartObject.Lang.Node.dayOfNotify1" bundle="sys-lbpmservice" />
					  <input name="wf_tranNotifyDraft" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
					  <input name="wf_hourOfTranNotifyDraft" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
					  <input name="wf_minuteOfTranNotifyDraft" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><kmss:message key="FlowChartObject.Lang.Node.tranNotifyDraft1" bundle="sys-lbpmservice" /><br>
						
						<kmss:message key="FlowChartObject.Lang.Node.dayOfNotify1" bundle="sys-lbpmservice" />
						<input name="wf_tranNotifyPrivate" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
						<input name="wf_hourOfTranNotifyPrivate" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
						<input name="wf_minuteOfTranNotifyPrivate" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><kmss:message key="FlowChartObject.Lang.Node.tranNotifyPrivileger1" bundle="sys-lbpmservice" /><br>
						
						<kmss:message key="FlowChartObject.Lang.Node.dayOfPass1" bundle="sys-lbpmservice" />
						<input name="wf_dayOfPass" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
						<input name="wf_hourOfPass" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
						<input name="wf_minuteOfPass" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><kmss:message key="FlowChartObject.Lang.Node.dayOfPass2" bundle="sys-lbpmservice" /><br>
						<kmss:message key="FlowChartObject.Lang.Node.dayOfHandleHelp" bundle="sys-lbpmservice" />
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.nodeOptions" bundle="sys-lbpmservice" /></td>
					<td>
						<label>					
						<input name="wf_recalculateHandler" type="checkbox" value="true" >
						<kmss:message key="FlowChartObject.Lang.Node.isRecalculate" bundle="sys-lbpmservice" />
						</label>
					</td>
				</tr>
				<c:import url="/sys/lbpm/flowchart/page/node_ext_attribute.jsp" charEncoding="UTF-8">
					<c:param name="position" value="advance" />
					<c:param name="nodeType" value="${param.nodeType}" />
					<c:param name="modelName" value="${param.modelName }" />
				</c:import>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Popedom" bundle="sys-lbpmservice" />">
		<td>
		<c:import url="/sys/lbpmservice/node/common/node_right_attribute.jsp" charEncoding="UTF-8" />
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Event" bundle="sys-lbpm-engine" />">
		<td>
		<c:import url="/sys/lbpm/flowchart/page/node_event_attribute.jsp" charEncoding="UTF-8" />
		</td>
	</tr>
	<c:import url="/sys/lbpm/flowchart/page/node_ext_attribute.jsp" charEncoding="UTF-8">
		<c:param name="position" value="newtag" />
		<c:param name="nodeType" value="${param.nodeType}" />
		<c:param name="modelName" value="${param.modelName }" />
	</c:import>
	<c:import url="/sys/lbpm/flowchart/page/node_variant_attribute.jsp" charEncoding="UTF-8">
		<c:param name="nodeType" value="${param.nodeType}" />
		<c:param name="modelName" value="${param.modelName }" />
	</c:import>
</table>

<script>

AttributeObject.Init.AllModeFuns.unshift(function() {
	var NodeData = AttributeObject.NodeData;
	if (FlowChartObject.ProcessData != null && FlowChartObject.ProcessData.recalculateHandler == null) {
		FlowChartObject.ProcessData.recalculateHandler = "true";
	}
	if (NodeData.recalculateHandler == null && FlowChartObject.ProcessData != null) {
		AttributeObject.NodeObject.Data.recalculateHandler = FlowChartObject.ProcessData.recalculateHandler;
	}
});

var handlerSelectType = AttributeObject.NodeData["handlerSelectType"];
var optHandlerSelectType = AttributeObject.NodeData["optHandlerSelectType"];
var ignoreOnHandlerSame = AttributeObject.NodeData["ignoreOnHandlerSame"];
var onAdjoinHandlerSame = AttributeObject.NodeData["onAdjoinHandlerSame"];

AttributeObject.Init.AllModeFuns.push(function() {

	if(!handlerSelectType || handlerSelectType!="formula"){
		document.getElementById('SPAN_SelectType1').style.display='';
		document.getElementById('SPAN_SelectType2').style.display='none';
	}else{
		document.getElementById('SPAN_SelectType1').style.display='none';
		document.getElementById('SPAN_SelectType2').style.display='';
	}

	if (!optHandlerSelectType || optHandlerSelectType!="formula"){
		document.getElementById('SPAN_OptSelectType1').style.display='';
		document.getElementById('SPAN_OptSelectType2').style.display='none';
		document.getElementById('DIV_OptHandlerCalType').style.display='';
	} else {
		document.getElementById('SPAN_OptSelectType1').style.display='none';
		document.getElementById('SPAN_OptSelectType2').style.display='';
		document.getElementById('DIV_OptHandlerCalType').style.display='none';
	}

	initHandlerSameSelect(ignoreOnHandlerSame,onAdjoinHandlerSame);
	
	AttributeObject.Utils.switchOrgAttributes(document.getElementsByName("wf_handlerIds")[0], handlerSelectType);
	AttributeObject.Utils.switchOrgAttributes(document.getElementsByName("wf_optHandlerIds")[0], optHandlerSelectType);
});

//审批人选择方式
function switchHandlerSelectType(value){
	if(handlerSelectType==value)
		return;
	handlerSelectType = value;
	SPAN_SelectType1.style.display=handlerSelectType!="formula"?"":"none";
	SPAN_SelectType2.style.display=handlerSelectType=="formula"?"":"none";
	document.getElementsByName("wf_handlerIds")[0].value = "";
	document.getElementsByName("wf_handlerNames")[0].value = "";

	AttributeObject.Utils.switchOrgAttributes(document.getElementsByName("wf_handlerIds")[0], handlerSelectType);
}
// 备选审批人选择方式
function switchOptHandlerSelectType(value) {
	if(optHandlerSelectType==value)
		return;
	optHandlerSelectType = value;
	document.getElementById('SPAN_OptSelectType1').style.display=optHandlerSelectType!="formula"?"":"none";
	document.getElementById('SPAN_OptSelectType2').style.display=optHandlerSelectType=="formula"?"":"none";
	document.getElementById('DIV_OptHandlerCalType').style.display=optHandlerSelectType!="formula"?"":"none";
	document.getElementsByName("wf_optHandlerIds")[0].value = "";
	document.getElementsByName("wf_optHandlerNames")[0].value = "";

	AttributeObject.Utils.switchOrgAttributes(document.getElementsByName("wf_optHandlerIds")[0], optHandlerSelectType);
}

//判断是否数字
function isInt(i){
	var re = /\D/gi;
	return !re.test(i);
}

AttributeObject.CheckDataFuns.push(function(data) {
	if(data.useOptHandlerOnly=="true" && data.optHandlerIds==""){
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkOptHandlerEmpty" bundle="sys-lbpmservice" />');
		return false;
	}
	if(!isInt(data.dayOfNotify)){
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkDayOfNotify" bundle="sys-lbpmservice" />');
		return false;
	}
	if(!isInt(data.tranNotifyDraft)){
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkTranNotifyDraft" bundle="sys-lbpmservice" />');
		return false;
	}
	if(!isInt(data.tranNotifyPrivate)){
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkTranNotifyPrivate" bundle="sys-lbpmservice" />');
		return false;
	}
	if(!isInt(data.dayOfPass)){
		alert('<kmss:message key="FlowChartObject.Lang.Node.checkDayOfPass" bundle="sys-lbpmservice" />');
		return false;
	}
	return true;
});
function initHandlerSameSelect(ignoreHandlerSame,adjoinHandlerSame){
	if(ignoreHandlerSame==null){
		ignoreHandlerSame = "true";
	}
	if(adjoinHandlerSame==null){
		adjoinHandlerSame = "true";
	}
	var selected = "1";
	if(ignoreHandlerSame == "true"){//兼容老数据配置
		if(adjoinHandlerSame=="true"){
			selected = "1";//相邻跳过
		}else{
			selected = "2";//跨节点跳过
		}
	}else{
		selected = "0";//不跳过
	}
	$("select[name='handlerSameSelect']").val(selected);
}
function switchHandlerSameSelect(thisObj){
	var selected = $(thisObj).val();
	var ignoreHandlerSameObj = $("input[name='wf_ignoreOnHandlerSame']");
	var adjoinHandlerSameObj = $("input[name='wf_onAdjoinHandlerSame']");
	if(selected=="1"){//相邻处理人重复跳过
		ignoreHandlerSameObj.val("true");
		adjoinHandlerSameObj.val("true");
	}else if(selected=="2"){//跨节点处理人重复跳过
		ignoreHandlerSameObj.val("true");
		adjoinHandlerSameObj.val("false");
	}else{//不跳过
		ignoreHandlerSameObj.val("false");
		adjoinHandlerSameObj.val("false");
	}
}
function selectByFormula(idField, nameField){
	Formula_Dialog(idField,
			nameField,
			FlowChartObject.FormFieldList, 
			"com.landray.kmss.sys.organization.model.SysOrgElement[]",
			null,
			"com.landray.kmss.sys.lbpm.engine.formula.LbpmFunction",
			FlowChartObject.ModelName);
}
</script>