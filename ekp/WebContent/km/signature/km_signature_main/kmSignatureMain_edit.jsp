<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<%@ include file="/resource/jsp/common.jsp"%>
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
<html:form action="/km/signature/km_signature_main/kmSignatureMain.do" onsubmit="return Check_edit();">
<script>
function Check_edit(){
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
	var passOld = '${kmSignatureMainForm.fdPassword}';
	var passOld1 = document.getElementById("password_old").value;
	var pass1 = document.getElementById("password1").value;
	var pass2 = document.getElementById("password2").value;
	if(passOld!=passOld1){
		alert('<bean:message bundle="km-signature" key="signature.warn4"/>');
		return false;
	}else{
		if(pass1 == null || pass1 == ""){
			alert('<bean:message bundle="km-signature" key="signature.warn13"/>');
			return false;
		}else if(pass1!=pass2){
			alert('<bean:message bundle="km-signature" key="signature.warn5"/>');
			return false;
		}else{
			return true;
		}
	}
}
</script>
<div id="optBarDiv">
	<c:if test="${kmSignatureMainForm.method_GET=='edit'}">
		<input type="button" value="<bean:message key='button.save'/>" onclick="Com_Submit(document.kmSignatureMainForm, 'update');"/>
	</c:if>
	<c:if test="${kmSignatureMainForm.method_GET=='add'}">
		<input type="button" value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.kmSignatureMainForm, 'save');">
		<input type="button" value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.kmSignatureMainForm, 'saveadd');">
	</c:if>	
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-signature" key="table.signature"/></p>

<center>
<table class="tb_normal" width=95%>
	<!-- 用户名称 -->
	<tr>
		<intput type="hidden" name="fdUsersIds" value="${kmSignatureMainForm.fdUsersIds}" />
		<intput type="hidden" name="fdUsersNames" value="${kmSignatureMainForm.fdUsersNames}" />
		<intput type="hidden" name="fdPassword" value="${kmSignatureMainForm.fdPassword}" />
		<intput type="hidden"  name="fdMarkPath" value="${kmSignatureMainForm.fdMarkPath}" />
		<intput type="hidden"  name="fdMarkDate" value="${kmSignatureMainForm.fdMarkDate}" />
		<intput type="hidden"  name="fdSignatureId" value="1"/>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="signature.username"/>
		</td>
		<td>
			<input type="hidden" name="fdUserName" value="${kmSignatureMainForm.fdUserName}" />
			${kmSignatureMainForm.fdUserName}
		</td>
	</tr>
	<!-- 签章分类 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.fdTemp"/>
		</td><td width="85%">
			<xform:select property="fdTempId" value="${kmSignatureMainForm.fdTempId}" required="true">
				<xform:beanDataSource serviceBean="kmSignatureCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
			</xform:select>
		</td>
	</tr>
	<!-- 签章名称 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.markname"/>
		</td><td width="85%">
			<xform:text property="fdMarkName" style="width:30%" />
		</td>
	</tr>
	<!-- 原始密码  -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.oldPassword"/>
		</td><td width="85%">
			<input type="password" id="password_old" name="password_old" size="51" maxlength="32" class="inputsgl"> 
		</td>
	</tr>
	<!-- 新密码 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.newPassword"/>
		</td><td width="85%">
			<input type="password" id="password1" name="password1" size="51" maxlength="32" class="inputsgl"> 
		</td>
	</tr>
	<!-- 确认密码 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.confirmPassword"/>
		</td><td width="85%">
			<input type="password" id="password2" name="password2" size="51" maxlength="32" class="inputsgl"> 
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
				<c:if test="${kmSignatureMainForm.fdDocType == 1 || kmSignatureMainForm.fdDocType == 2 }">
				<xform:radio property="fdDocType" subject="签章类型" value="${kmSignatureMainForm.fdDocType }" required="true" >
					<xform:simpleDataSource value="1">
						<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>
					</xform:simpleDataSource>
					<xform:simpleDataSource value="2">
						<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>
					</xform:simpleDataSource>
				</xform:radio>
				</c:if>
				<c:if test="${kmSignatureMainForm.fdDocType != 1 && kmSignatureMainForm.fdDocType != 2 }">
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
			<input name="fdUserIds" value="${kmSignatureMainForm.fdUsersIds }" type="hidden">
			<input name="fdUserNames" class="inputsgl" value="${kmSignatureMainForm.fdUsersNames }" style="width: 30%;" type="text" readOnly="" /> 
			<a onclick="Dialog_Address(true, 'fdUserIds','fdUserNames', ';', 'ORG_TYPE_PERSON|ORG_TYPE_POST');" href="#">
				<bean:message key="button.select"/>
			</a>
			<span class="txtstrong">(授权用户为空则只有创建人可用)</span>
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
<input type="hidden" name="fdId" value="${kmSignatureMainForm.fdId}" />
<input type="hidden" property="method_GET" />
<script>
Com_IncludeFile("calendar.js");
Com_IncludeFile("common.js");
Com_IncludeFile("dialog.js");
Com_IncludeFile("doclist.js");
Com_IncludeFile("jquery.js");
Com_IncludeFile("data.js");
	$KMSSValidation();
	//var marktype = '${kmSignatureMainForm.fdDocType}';
	//if(marktype=="公司印章"){
	//	document.getElementsByName("fdDocType")[1].checked=true;
	//}else{
	//	document.getElementsByName("fdDocType")[0].checked=true;
	//}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>