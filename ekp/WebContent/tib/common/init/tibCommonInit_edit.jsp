<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
	Com_IncludeFile("jquery.js|dialog.js|data.js");
	Com_IncludeFile("tibCommonInit.js", "${KMSS_Parameter_ContextPath}tib/common/init/", "js", true);
</script>

<html:messages id="messages" message="true">
	<table style="margin:0 auto" align="center">
		<tr>
			<td>
				<img src='${KMSS_Parameter_ContextPath}resource/style/default/msg/dot.gif'>&nbsp;&nbsp;
				<font color='red'><bean:write name="messages" /></font>
			</td>
		</tr>
	</table><hr />
</html:messages> 
 
<html:form action="/tib/common/init/tibCommonInit.do">
<div id="optBarDiv">
	<input type=button value="<bean:message bundle="tib-common-init" key="init.testConn"/>"
			onclick="if(!submitBefore())return;Com_Submit(document.tibCommonInitForm, 'testConn');">
	<input type="button" value="<bean:message key="init.importStandardPacket" bundle="tib-common-init"/>" onclick="if(!submitBefore())return;Com_Submit(document.tibCommonInitForm, 'importInitStandData');">
</div>

<p class="txttitle"><bean:message bundle="tib-common-init" key="module.init.data"/></p>

	<!-- SAP\EAS\K3 -->
	<xform:radio property="moduleType" style="margin-left:30px" showStatus="edit" onValueChange="chooseType(this.value);" value="${moduleType }">
		<xform:customizeDataSource className="com.landray.kmss.tib.common.init.plugins.taglib.TibCommonInitBean">
		</xform:customizeDataSource>
	</xform:radio>
<center>
<table class="tb_normal" width="95%" id="outterTableId">
	<tr>
		<td>
			<c:forEach items="${jspList }" var="jspPath">
				<jsp:include page="${jspPath }"></jsp:include>
			</c:forEach>
		</td>
	</tr>
</table>

</center>

<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$KMSSValidation();	
	function submitBefore() {
		var moduleType = $("input[name='moduleType']:checked").val();
		if (moduleType == "" || moduleType == undefined) {
			alert("<bean:message key="init.emptyModuleType" bundle="tib-common-init"/>");
			return false;
		} else {
			return true;
		}
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
