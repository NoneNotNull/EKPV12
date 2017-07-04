<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp", null, "js");
</script>
<br>
<% if(request.getAttribute("KMSS_RETURNPAGE")==null){ %>
<logic:messagesPresent>
	<table align=center><tr><td>
		<font class="txtstrong"><bean:message key="errors.header.vali"/></font>
		<bean:message key="errors.header.correct"/>
		<html:messages id="error">
			<br><img src='${KMSS_Parameter_StylePath}msg/dot.gif'>&nbsp;&nbsp;<bean:write name="error"/>
		</html:messages>
	</td></tr></table>
	<hr />
</logic:messagesPresent>
<% }else{
	KmssMessageWriter msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
function showMoreErrInfo(index, srcImg){
	var obj = document.getElementById("moreErrInfo"+index);
	if(obj!=null){
		if(obj.style.display=="none"){
			obj.style.display="block";
			srcImg.src = Com_Parameter.StylePath + "msg/minus.gif";
		}else{
			obj.style.display="none";
			srcImg.src = Com_Parameter.StylePath + "msg/plus.gif";
		}
	}
}
</script>
<table align=center style="margin:0 auto"><tr><td>
	<%= msgWriter.DrawTitle() %>
	<br style="font-size:10px">
	<%= msgWriter.DrawMessages() %>
</td></tr></table>
<hr />
<% } %>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<input type=button value="<bean:message  bundle="kms-integral" key="kmsIntegralServer.testConnect"/>"
			onclick="Com_OpenWindow('<c:url value="/kms/integral/kms_integral_server/kmsIntegralServer.do?fdId=${param.fdId}&method=testConnectView"/>','_self');">
		<kmss:auth requestURL="/kms/integral/kms_integral_server/kmsIntegralServer.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmsIntegralServer.do?method=edit&fdId=${param.fdId}&fdDatabaseType=${kmsIntegralServerForm.fdDatabaseType }','_self');">
			<c:if test="${kmsIntegralServerForm.fdStartOrStop==false }">
				<input type="button"
					value="<bean:message key="kmsIntegralServer.fdStart" bundle="kms-integral"/>"
					onclick="Com_OpenWindow('kmsIntegralServer.do?method=start&fdId=${param.fdId}','_self');">
			</c:if>
			<c:if test="${kmsIntegralServerForm.fdStartOrStop==true }">
				<input type="button"
					value="<bean:message key="kmsIntegralServer.fdStop" bundle="kms-integral"/>"
					onclick="Com_OpenWindow('kmsIntegralServer.do?method=stop&fdId=${param.fdId}','_self');">
			</c:if>
		</kmss:auth>
		<kmss:auth requestURL="/kms/integral/kms_integral_server/kmsIntegralServer.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmsIntegralServer.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="kms-integral" key="table.kmsIntegralServer"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden name="kmsIntegralServerForm" property="fdId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdName"/>
		</td><td width=35% colspan="3">
			<bean:write name="kmsIntegralServerForm" property="fdName"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdPrefix"/>
		</td><td width=35%>
			<bean:write name="kmsIntegralServerForm" property="fdPrefix"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdUpdateTime"/>
		</td><td width=35%>
			<bean:write name="kmsIntegralServerForm" property="fdUpdateTime"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-integral" key="kmsIntegralServer.fdDatabaseType"/>
		</td><td width=35%>
			<bean:write name="kmsIntegralServerForm" property="fdDatabaseType"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralServer.fdDatabaseUrl"/>
		</td><td width=35%>
			<bean:write name="kmsIntegralServerForm" property="fdDatabaseUrl"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>       
			<bean:message bundle="kms-integral" key="kmsIntegralServer.fdUserName"/>
		</td><td width=35%>
			<bean:write name="kmsIntegralServerForm" property="fdUserName"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralServer.fdStartOrStop"/>
		</td><td width=35%>
			<font color="red">
				<c:if test="${kmsIntegralServerForm.fdStartOrStop==true }">
					<bean:message bundle="kms-integral" key="kmsIntegralServer.fdStart"/>
				</c:if>
				<c:if test="${kmsIntegralServerForm.fdStartOrStop==false }">
					<bean:message bundle="kms-integral" key="kmsIntegralServer.fdStop"/>
				</c:if>
			</font>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
