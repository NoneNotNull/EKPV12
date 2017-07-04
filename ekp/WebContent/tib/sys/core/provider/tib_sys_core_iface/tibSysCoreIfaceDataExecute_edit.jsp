<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib
	uri="/tib/sys/core/provider/resource/tld/tib-sys-provider.tld"
	prefix="tib"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>


<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.springframework.web.util.HtmlUtils"%>
<%@page import="com.landray.kmss.tib.sys.core.util.TibSysCoreUtil"%>
<html:form
	action="/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do">
	<div id="optBarDiv">
		<!-- 数据执行 -->
		<input type=button value="<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.execute.dataExecute"/>"
			onclick="submit_before('dataExecuteAndBack');">
		<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle">${tibSysCoreIfaceForm.fdIfaceName}</p>

<center>
<table id="Label_Tabel" width="95%" >
	<tr LKS_LabelName="<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.execute.dataFill"/>">
		<td>
			<table class="tb_normal" width="100%">
				<!-- 数据填写 -->
				<tr>
					<td width="100%">
						<textarea name="tibDataFill" id="tibDataFill" 
								style='overflow:scroll;overflow-y:hidden;;overflow-x:hidden;width:100%;'
								onfocus="window.activeobj=this;this.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},200);" 
								onblur="clearInterval(this.clock);">${tibDataFill}</textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<c:if test="${param.method != 'dataExecute'}" >
	<tr LKS_LabelName="<bean:message bundle="tib-sys-core-provider" key="tibSysCoreIface.execute.result"/>">
		<td>
			<table class="tb_normal" width="100%">
				<!-- 执行结果 -->
				<tr>
					<td width="100%">
						<textarea name="tibDataResult" id="tibDataResult" 
								style='overflow:scroll;overflow-y:hidden;;overflow-x:hidden;width:100%;'
								onfocus="window.activeobj=this;this.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},200);" 
								onblur="clearInterval(this.clock);"></textarea>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	</c:if>
</table>
</center>
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />

<script type="text/javascript">
	Com_IncludeFile("dialog.js|jquery.js");
	Com_IncludeFile("tib_sys_util.js","${KMSS_Parameter_ContextPath}tib/sys/core/provider/resource/js/","js",true);
	var tibValidation = $KMSSValidation();
</script>
<script>
	$(function(){
		//var tagdb = "<bean:message bundle="tib-sys-core-provider" key="tibSysCore.lang.tagdb"/>";
		//var headDefinition = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"; 
		var tibDataFillObj = document.getElementById("tibDataFill");
		// 用于长度自动变化 
		window.activeobj = tibDataFillObj;
		tibDataFillObj.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},10);
		var fdIfaceXml = "${fdIfaceXml}";
		<c:if test="${empty tibDataFill}">
			$("#tibDataFill").text(TIB_SysUtil.formatXml(fdIfaceXml, "    "));
		</c:if>
	});

	<c:if test="${param.method == 'dataExecuteAndBack'}">
	$(function(){
		// 默认展现第二个页签
		$("#Label_Tabel").attr("LKS_LabelDefaultIndex", "2");
		var headDefinition = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"; 
		var executeBackXml = "${executeBackXml}";
		var fomatBackXml = TIB_SysUtil.formatXml(executeBackXml, "    ");
		var tibDataResultObj = document.getElementById("tibDataResult");
		// 用于长度自动变化
		window.activeobj = tibDataResultObj;
		tibDataResultObj.clock=setInterval(function(){activeobj.style.height=activeobj.scrollHeight+'px';},10);
		if (executeBackXml.indexOf(headDefinition) != -1) {
			$("#tibDataResult").text(fomatBackXml);
		} else {
			$("#tibDataResult").text((headDefinition +"\r"+ fomatBackXml));
		}
	});
	</c:if>

	function submit_before(method) {
		var tibDataResult = document.getElementById("tibDataResult");
		if (tibDataResult != null) {
			$(tibDataResult).text("");
		}
		Com_Submit(document.tibSysCoreIfaceForm, method);
	}
</script>



</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>