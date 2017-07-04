<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<% response.addHeader("X-UA-Compatible", "IE=edge"); %>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js");
</script>
</head>
<body>
<br>
<script>
function confirmDelete(msg){
	var del = confirm('<bean:message key="page.comfirmDelete"/>');
	return del;
}
</script>
<div id="optBarDiv">
	<kmss:auth requestURL="/km/signature/km_signature_main/kmSignatureMain.do?method=chgPwd&fdId=${param.fdId}" requestMethod="GET">
		<input type="button"
			value="<bean:message bundle="km-signature" key="signature.resetPassword"/>"
			onClick="Com_OpenWindow('kmSignatureMain.do?method=chgPwd&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/signature/km_signature_main/kmSignatureMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmSignatureMain.do?method=edit&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<kmss:auth requestURL="/km/signature/km_signature_main/kmSignatureMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('kmSignatureMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-signature" key="table.signature"/></p>

<center>
<table id="Label_Tabel" width=95%>
<!-- 主文档 -->
<tr LKS_LabelName="<bean:message bundle="km-signature" key="signature.mainInfo"/>">
<td>
<center>
<table class="tb_normal" width=100%>
	<!-- 用户名称 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.username"/>
		</td><td width="85%">
			<xform:text property="fdUserName" style="width:85%" />
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
	<!-- 签章分类 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.fdTemp"/>
		</td><td width="85%">
			<xform:select property="fdTempId">
				<xform:beanDataSource serviceBean="kmSignatureCategoryService" selectBlock="fdId,fdName" orderBy="fdOrder" />
			</xform:select>
		</td>
	</tr>
	<!-- 签章信息 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.markbody"/>
		</td><td width="85%">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="sigPic"/>
				<c:param name="fdAttType" value="pic"/>
				<c:param name="fdMulti" value="false"/>
				<c:param name="fdShowMsg" value="false"/>
				<c:param name="formBeanName" value="kmSignatureMainForm" />
				<c:param name="fdModelId" value="${param.fdId}"/>
				<c:param name="fdModelName" value="com.landray.kmss.km.signature.model.KmSignatureMain"/>
				<c:param name="proportion" value="false" />
				<c:param name="fdLayoutType" value="pic"/>
				<c:param name="fdViewType" value="pic_single"/>
			    <c:param name="picWidth" value="312" />
			    <c:param name="picHeight" value="234" />
			    <c:param name="fdPicContentWidth" value="312"/>
			    <c:param name="fdPicContentHeight" value="234"/>
				<c:param name="fdImgHtmlProperty" value="width=312 height=234"/>
	        </c:import>
		</td>
	</tr>
	<!-- 签章类型 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.docType"/>
		</td><td width="85%">
			<c:if test="${kmSignatureMainForm.fdDocType == '1'}">
				<bean:message bundle="km-signature" key="signature.fdDocType.handWrite"/>
			</c:if>
			<c:if test="${kmSignatureMainForm.fdDocType == '2'}">
				<bean:message bundle="km-signature" key="signature.fdDocType.companySignature"/>
			</c:if>
		</td>
	</tr>
	<!-- 授权用户 -->
	<tr>
		<td class="td_normal_title" width="15%">
			<bean:message bundle="km-signature" key="signature.users"/>
		</td><td width="85%">
			${kmSignatureMainForm.fdUsersNames}
		</td>
	</tr>
	<!-- 印章保存时间 -->
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-signature" key="signature.markdate"/>
		</td><td width="85%">
			<xform:datetime property="fdMarkDate" />
		</td>
	</tr>
</table>
</center>
</td>
</tr>
<!-- 使用记录
<tr LKS_LabelName="<bean:message bundle="km-signature" key="signature.historyInfo"/>">
	<td>
		<c:import url="/km/signature/km_signature_document_history/kmSignatureDocumentHistory.do?method=list&fdMarkName=${kmSignatureMainForm.fdMarkName}" charEncoding="UTF-8">
		</c:import>
	</td>
</tr> -->
</table>


</center>
<%@ include file="/resource/jsp/view_down.jsp"%>