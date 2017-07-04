<%@ page language="java" contentType="text/html; charset=GB2312"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%@ page
	import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<% response.addHeader("X-UA-Compatible", "IE=edge"); %>
<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js", null, "js");
</script>
</head>
<body>
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
<table align=center  width="100%">
<tr>
<td width="100%" align="center">
	<%= msgWriter.DrawTitle() %>
	<br style="font-size:10px;">
	<%= msgWriter.DrawMessages() %>
</td>
</tr></table>
<hr />
<% } %>
<%
request.setCharacterEncoding("UTF-8");
response.setCharacterEncoding("UTF-8");
%>
<script language=javascript>
	Com_IncludeFile("dialog.js");
</script>
<script>
function Check_add() {
	//debugger;
	var fdMarkName = document.getElementsByName("fdMarkName")[0].value;
	if(fdMarkName == null || fdMarkName == ""){
		alert('<bean:message bundle="km-signature" key="signature.warn7"/>');
		return false;
	}
	var fdTempId = document.getElementsByName("fdTempId")[0].value;
	if(fdTempId == null || fdTempId == ""){
		alert('<bean:message bundle="km-signature" key="signature.warn12"/>');
		return false;
	}
	var fdDocType = document.getElementsByName("fdDocType");
	var flag = true;
	for( var i = 0; i < fdDocType.length;i++){
		if(fdDocType[i].checked){
			flag = false;
		}
	}
	if(fdDocType[0].value == null || fdDocType[0].value == ""){
		if(flag){
			alert('<bean:message bundle="km-signature" key="signature.warn11"/>');
			return false;
		}
	}
	var p1=document.getElementById("fdPassword").value;
	var p2=document.getElementById("fdPassword1").value;
	if(p1 == null || p1 == ""){
		alert('<bean:message bundle="km-signature" key="signature.warn8"/>');
		return false;
	}
	if(p1==p2){
		return true;
	}else{
		alert('<bean:message bundle="km-signature" key="signature.warn2"/>');
		return false;
	}
}
</Script>
<%
	String fdUserName = UserUtil.getUser().getFdName();
%>
<html:form method="post" action="/km/signature/km_signature_main/kmSignatureMain.do" onsubmit="return Check_add();">
	<div id="optBarDiv">
		<input type="button" value="<bean:message key="button.save"/>" onclick="Com_Submit(document.kmSignatureMainForm, 'save');">
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>
	<p class="txttitle"><bean:message bundle="km-signature" key="table.signature"/></p>
	<center>
		<table class="tb_normal" width="95%">
			<!-- 用户名称 -->
			<tr>
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.username"/>
				</td><td width="85%">
					<input type="hidden" name="fdUserName" value="<%=fdUserName%>" disabled="true ">
					<c:out value="<%=fdUserName%>"></c:out>
				</td>
			</tr>
			<!-- 签章名称 -->
			<tr>
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.markname"/>
				</td><td width="85%">
					<xform:text property="fdMarkName" required="true" className="inputsgl" style="width:30%;" />
				</td>
			</tr>
			<!-- 签章分类 -->
			<tr>
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.fdTemp"/>
				</td><td width="85%">
					<xform:select property="fdTempId" value="${param.fdTemplateId}" required="true">
						<xform:beanDataSource serviceBean="kmSignatureCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
					</xform:select>
				</td>
			</tr>
			<!-- 签章类型 -->
			<tr>
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.docType"/>
				</td><td width="85%">
					<c:if test="${docTypeFlag == '1'}">
						<html:hidden property="fdDocType" value="${docTypeFlag }"></html:hidden>
						<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>
					</c:if>
					<c:if test="${docTypeFlag == '2'}">
						<html:hidden property="fdDocType" value="${docTypeFlag }"></html:hidden>
						<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>
					</c:if>
					<c:if test="${docTypeFlag == '3'}">
						<c:if test="${param.docType == 1 || param.docType == 2 }">
						<xform:radio property="fdDocType" subject="签章类型" value="${param.docType }" required="true" >
							<xform:simpleDataSource value="1">
								<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>
							</xform:simpleDataSource>
							<xform:simpleDataSource value="2">
								<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>
							</xform:simpleDataSource>
						</xform:radio>
						</c:if>
						<c:if test="${param.docType != 1 && param.docType != 2 }">
						<xform:radio property="fdDocType" subject="签章类型" value="1" required="true" >
							<xform:simpleDataSource value="1">
								<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>
							</xform:simpleDataSource>
							<xform:simpleDataSource value="2">
								<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>
							</xform:simpleDataSource>
						</xform:radio>
						</c:if>
					</c:if>
				</td>
			</tr>
			<!-- 授权用户 -->
			<tr id="fdUsersArea">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.users"/>
				</td><td width="85%">
					<input name="fdUserIds" type="hidden">
					<input name="fdUserNames" class="inputsgl" style="width: 30%;" type="text" readOnly="" /> 
					<a onclick="Dialog_Address(true, 'fdUserIds','fdUserNames', ';', 'ORG_TYPE_PERSON|ORG_TYPE_POST');" href="#">
						<bean:message key="button.select"/>
					</a>
					<span class="txtstrong">(授权用户为空则只有创建人可用)</span>
				</td>
			</tr>
			<!-- 用户密码 -->
			<tr id="passwordArea">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.password"/>
				</td><td width="85%">
					<input id="fdPassword" type="password" name="fdPassword" size="50" maxlength="32" class="inputsgl">
					<!-- xform:text type="password" property="fdPassword" required="true" size="50" validators="maxLength(32)" className="inputsgl" / -->
					<span class="txtstrong">*</span>
				</td>
			</tr>
			<!-- 确认密码 -->
			<tr id="confirmPasswordArea">
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.confirmPassword"/>
				</td><td width="85%">
					<input id="fdPassword1" type="password" name="fdPassword1" size="50" maxlength="32" class="inputsgl">
					<span class="txtstrong">*</span>
				</td>
			</tr>
			<!-- 签章信息 -->
			<tr>
				<td class="td_normal_title" width="15%">
					<bean:message bundle="km-signature" key="signature.markbody"/>
				</td><td width="85%">
			        <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
						<c:param name="fdModelId" value="${param.fdId}"/>
						<c:param name="fdModelName" value="com.landray.kmss.km.signature.model.KmSignatureMain"/>
						<c:param name="fdKey" value="sigPic"/>
						<c:param name="fdAttType" value="pic"/>
						<c:param name="fdMulti" value="false"/>
						<c:param name="fdShowMsg" value="false"/>
						<c:param name="proportion" value="false" />
						<c:param name="fdLayoutType" value="pic"/>
						<c:param name="fdViewType" value="pic_single"/>
					    <c:param name="picWidth" value="312" />
					    <c:param name="picHeight" value="234" />
						<c:param name="fdRequired" value="true"/>
					    <c:param name="fdPicContentWidth" value="312"/>
					    <c:param name="fdPicContentHeight" value="234"/>
						<c:param name="fdImgHtmlProperty" value="width=312 height=234"/>
			        </c:import>
				</td>
			</tr>
		</table>
	</center>
</html:form>
<script type="text/javascript">
	Com_IncludeFile("calendar.js");
	Com_IncludeFile("common.js");
	Com_IncludeFile("dialog.js");
	Com_IncludeFile("doclist.js");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile("data.js");
	var _validation = $KMSSValidation();
</scritp>
<%@ include file="/resource/jsp/edit_down.jsp"%>