<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="
		com.landray.kmss.sys.config.design.SysCfgFlowDef,
		com.landray.kmss.sys.config.design.SysCfgFlowVariant,
		com.landray.kmss.sys.config.design.SysConfigs,
		com.landray.kmss.util.ResourceUtil" %>
<%@ page import="
		java.util.List,
		java.util.Map,
		java.util.ArrayList,
		java.util.HashMap" %>
<%@ include file="/resource/jsp/common.jsp"%>

<%
String nodeType = request.getParameter("nodeType");
String modelName = request.getParameter("modelName");

List rtnList = new ArrayList();

SysCfgFlowDef cfgFlowDef = SysConfigs.getInstance().getFlowDefByMain(modelName);
for (int i = 0; i < cfgFlowDef.getVariants().size(); i++) {
	Map<String, String> node = new HashMap<String, String>();
	SysCfgFlowVariant variant = cfgFlowDef.getVariants().get(i);
	node.put("id", variant.getName());
	node.put("name", ResourceUtil.getString(variant.getKey()));
	rtnList.add(node);
}
pageContext.setAttribute("variants", rtnList);
%>
<c:if test="${not empty variants}">
<tr LKS_LabelName="<kmss:message key="FlowChartObject.Lang.Label_Variant" bundle="sys-lbpm-engine" />">
	<td>
		<table width="100%" class="tb_normal" id="Node_Variant">
			<tr>
				<td>
					<table width="100%" class="tb_noborder">
					<tr>
			<c:forEach items="${variants}" var="variant" varStatus="_index">
					<td width=50%><label><input type="checkbox" name="Var_${variant.id}"><c:out value="${variant.name}" /></label></td>
					<c:if test="${_index.index % 2 == 0}">
					</tr><tr>
					</c:if>
			</c:forEach>
					</tr>
					</table>
				</td>
			</tr>
		</table>
		<script src="<c:url value="/sys/lbpm/flowchart/js/node_variants.js" />"></script>
	</td>
</tr>
</c:if>