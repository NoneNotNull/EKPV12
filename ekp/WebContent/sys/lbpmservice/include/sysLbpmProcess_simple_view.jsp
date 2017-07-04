<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
Com_IncludeFile("document.css", "style/"+Com_Parameter.Style+"/doc/");
</script>
<tr id="simpleWorkflowRow" style="display:none">
	<td class="td_normal_title" width="15%">
		<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages" />
	</td>
	<td colspan="3">
		<select name="commonSimpleUsages" onchange="lbpm.globals.setUsages(this);" style="width: 90px; overflow-x: hidden">
		<option value=""><bean:message key="page.firstOption" /></option>
		</select>
		<a href="#" onclick="Com_EventPreventDefault();lbpm.globals.openDefiniateUsageWindow();">
		<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.commonUsages.definite" />
		</a>
	</td>
</tr>
<tr id="simpleWorkflowRow" style="display:none">
	<td class="td_normal_title" width="15%">
		<bean:message bundle="sys-lbpmservice" key="lbpmNode.createDraft.opinion" />
	</td>
	<td colspan="3">
		<table width=100% border=0 class="tb_noborder">
			<tr>
				<td width="85%">
					<textarea name="fdSimpleUsageContent" class="inputMul" style="width:100%;" alertText="" key="auditNode"></textarea>
				</td>
				<td width="15%" align="center">
					<input id="simple_handler_pass" class="btnopt" type="button" value="<bean:message bundle="sys-lbpmservice" key="lbpmOperations.fdOperType.processor.pass" />" onclick="lbpm.globals.simpleFlowSubmitEvent('handler_pass');" style="display:none"/>
					<input id="simple_handler_refuse" class="btnopt" type="button" value="<bean:message bundle="sys-lbpmservice" key="lbpmOperations.fdOperType.processor.refuse" />" onclick="lbpm.globals.simpleFlowSubmitEvent('handler_refuse');" style="display:none"/>
					<input id="simple_handler_sign" class="btnopt" type="button" value="<bean:message bundle="sys-lbpmservice" key="lbpmOperations.fdOperType.processor.sign.submit" />" onclick="lbpm.globals.simpleFlowSubmitEvent('handler_sign');" style="display:none"/>
				</td>
			</tr>
		</table>
	</td>
</tr>