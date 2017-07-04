<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ include file="/resource/jsp/common.jsp"%>

<tr>
	<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.name" bundle="sys-lbpm-engine" /></td>
	<td>
		<input name="wf_name" class="inputsgl" style="width:200px" onkeydown="document.getElementsByName('nodeNameList')[0].selectedIndex=0;">
		<span id="SPAN_NodeNameList">
			<span class="txtstrong">*</span>
			<select name="nodeNameList" onChange="if(selectedIndex>0) document.getElementsByName('wf_name')[0].value=options[selectedIndex].text;"></select>
		</span>
		<script>
		AttributeObject.CheckDataFuns.push(function(data) {
			if(data.name==""){
				alert('<kmss:message key="FlowChartObject.Lang.Node.checkNameEmpty" bundle="sys-lbpm-engine" />');
				return false;
			}
			if(data.name.indexOf(";")>-1){
				alert('<kmss:message key="FlowChartObject.Lang.Node.checkNameSymbol" bundle="sys-lbpm-engine" />');
				return false;
			}
			return true;
		});
		AttributeObject.Init.EditModeFuns.push(function() {
			//加载节点名列表
			var data = new KMSSData();
			var field;
			data.AddBeanData("lbpmBaseInfoService");
			data = data.GetHashMapArray();
			field = document.getElementsByName("nodeNameList")[0];
			field.options[0] = new Option(FlowChartObject.Lang.pleaseSelect, "");
			if(data.length>0 && data[0].nodeNameSelectItem!=null && data[0].nodeNameSelectItem!=""){
				var nodeNameList = data[0].nodeNameSelectItem.split(";");
				for(var i=0; i<nodeNameList.length; i++)
					field.options[i+1] = new Option(nodeNameList[i]);
			}
		});
		AttributeObject.Init.ViewModeFuns.push(function() {
			document.getElementsByName("nodeNameList")[0].style.display = 'none';
		});
		</script>
	</td>
</tr>