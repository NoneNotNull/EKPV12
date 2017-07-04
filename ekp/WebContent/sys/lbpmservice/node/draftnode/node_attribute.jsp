<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
			<table width="100%" class="tb_normal">
				<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.description" bundle="sys-lbpm-engine" /></td>
					<td>
						<textarea name="wf_description" style="width:100%"></textarea>
						<kmss:message key="FlowChartObject.Lang.Node.imgLink" bundle="sys-lbpm-engine" />
					</td>
				</tr>
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.dayOfHandle" bundle="sys-lbpmservice" /></td>
					<td>
					<kmss:message key="FlowChartObject.Lang.Node.rejectNotifyDraft1" bundle="sys-lbpmservice" />
					<input name="wf_rejectNotifyDraft" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.day" bundle="sys-lbpmservice" />
					<input name="wf_hourOfRejectNotifyDraft" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.hour" bundle="sys-lbpmservice" />
					<input name="wf_minuteOfRejectNotifyDraft" class="inputsgl" value="0" size="3" style="text-align:center"><kmss:message key="FlowChartObject.Lang.Node.minute" bundle="sys-lbpmservice" /><kmss:message key="FlowChartObject.Lang.Node.rejectNotifyDraft2" bundle="sys-lbpmservice" /><br>
					<kmss:message key="FlowChartObject.Lang.Node.rejectNotifyDraft3" bundle="sys-lbpmservice" />
					</td>
				</tr>
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