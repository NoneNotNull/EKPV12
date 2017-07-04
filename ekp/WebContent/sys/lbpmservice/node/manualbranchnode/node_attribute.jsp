<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<table width="590px" id="Label_Tabel">
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Base" bundle="sys-lbpm-engine" />">
		<td>
			<table width="100%" class="tb_normal" id="config_table">
				<c:import url="/sys/lbpm/engine/node/common/node_name_attribute.jsp" charEncoding="UTF-8" />
				<!-- 起草节点处理勾选项 -->
				<tr>
					<td width="100px"><kmss:message key="FlowChartObject.Lang.Node.nodeOptions" bundle="sys-lbpmservice" /></td>
					<td>
					<label>
						<input name="wf_decidedBranchOnDraft" type="checkbox" value="true">
						<kmss:message key="FlowChartObject.Lang.Node.manualBarnchNode_decidedBranchOnDraft" bundle="sys-lbpmservice-node-manualbranchnode" />
					</label>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Event" bundle="sys-lbpm-engine" />">
		<td>
		<c:import url="/sys/lbpm/flowchart/page/node_event_attribute.jsp" charEncoding="UTF-8" />
		</td>
	</tr>
</table>