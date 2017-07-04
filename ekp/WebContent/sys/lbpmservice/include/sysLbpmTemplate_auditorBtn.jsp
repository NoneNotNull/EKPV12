<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.config.design.*,java.util.List" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<%
String fdModelName = request.getParameter("fdModelName");
boolean hasTemplate = false;
if (fdModelName != null) {
	List allFlowDef = SysConfigs.getInstance().getAllFlowDef();
	for (int i = 0; i < allFlowDef.size(); i++) {
		SysCfgFlowDef flowDef = (SysCfgFlowDef) allFlowDef.get(i);
		// 判断是否有配置
		if (fdModelName.equals(flowDef.getTemplateModelName())) {
			hasTemplate = true;
			break;
		}
	}
}
if (hasTemplate) {
%>
<c:choose>
<c:when test="${param.isCategory == 'true' or param.isCategory == '1'}">
	<%-- 简单分类 --%>
	<div id="updateTemplateAuditorBtn" style="display:none;">
		<input type="button" value="<bean:message key="lbpmTemplate.updateAuditor.button" bundle="sys-lbpmservice-support"/>"
				onclick="updateCategoryAuditor('<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do" />?method=updateTemplateAuditor&fdModelName=${param.fdModelName}');">
	</div>
</c:when>
<c:when test="${param.byCategory == 'true' or param.byCategory == '1'}">
	<%-- 全局分类 --%>
	<div id="updateTemplateAuditorBtn" style="display:none;">
		<input type="button" value="<bean:message key="lbpmTemplate.updateAuditor.button" bundle="sys-lbpmservice-support"/>"
			onclick="updateCategoryAuditor('<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do" />?method=updateCategoryAuditor&fdModelName=${param.fdModelName}');">
	</div>
</c:when>
<c:otherwise>
	<%-- 业务模板 --%>
	<kmss:auth 
		requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=updateTemplateAuditor&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}&cateid=${param.cateid}" 
		requestMethod="GET">
	<div id="updateTemplateAuditorBtn" style="display:none;">
		<input type="button" value="<bean:message key="lbpmTemplate.updateAuditor.button" bundle="sys-lbpmservice-support"/>"
				onclick="updateTemplateAuditor('<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do" />?method=updateTemplateAuditor&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}&cateid=${param.cateid}');">
	</div>
	<script>
	function updateTemplateAuditor(url) {
		if(!List_CheckSelect()) {
			return;
		}
		var s = "";
		$("input[name='List_Selected']:checked").each(function(i){
			if(i > 0) {
				s += ";";
			}
			s += this.value;
		});
		Com_OpenWindow(url + "&fdIds=" + s);
	}
	</script>
	</kmss:auth>
</c:otherwise>
</c:choose>
<script>
OptBar_AddOptBar("updateTemplateAuditorBtn");
function updateCategoryAuditor(url) {
	if(!List_CheckSelect()){
		return;
	}
	var s = "";
	var selList = LKSTree.GetCheckedNode();
	for(var i = 0; i < selList.length; i++){
		if(i > 0) {
			s += ";";
		}
		s += selList[i].value;
	}
	Com_OpenWindow(url + "&fdIds=" + s);
}
</script>
<%
}
%>