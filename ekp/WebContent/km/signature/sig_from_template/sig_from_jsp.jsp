<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.km.signature.model.KmSignatureDocumentSignature"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.common.dao.HQLInfo"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.km.signature.service.IKmSignatureDocumentSignatureService"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%
String FieldName = request.getParameter("FieldName");
String fileValue = "";
IKmSignatureDocumentSignatureService documentSignatureService = (IDocumentSignatureService) SpringBeanUtil.getBean("kmSignatureDocumentSignatureService");
HQLInfo hqlInfo = new HQLInfo();
hqlInfo.setWhereBlock(" kmSignatureDocumentSignature.fdRecordId = :recordid and kmSignatureDocumentSignature.fdFieldName = :fieldname ");
hqlInfo.setParameter("recordid", request.getParameter("fdId"));
hqlInfo.setParameter("fieldname", FieldName);
List<KmSignatureDocumentSignature> list = documentSignatureService.findList(hqlInfo);
if(list.size()>0){
	fileValue = list.get(0).getFieldvalue();
}
%>
<c:if test="${kmReviewMainForm.docStatus!=30}">
<div style="height=200;width=729">
	<OBJECT name="<%=FieldName %>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="${KMSS_Parameter_ContextPath}HandWrite.cab#version=6,0,0,0" width=100% height=100%>
		<%-- <param name="WebUrl" value="${KMSS_Parameter_ContextPath}km/signature/km_signature_document_main/iWebServer.jsp"> --%>
		<param name="WebUrl" value="${KMSS_Parameter_ContextPath}km/signature/iwebSigAction.do">
		<param name="RecordID" value="${kmReviewMainForm.fdId}">    <!-- RecordID:本文档记录编号 -->
		<param name="FieldName" value="<%=FieldName %>">         <!-- FieldName:签章窗体可以根据实际情况再增加，只需要修改控件属性 FieldName 的值就可以 -->
		<param name="UserName" value="<%=UserUtil.getUser().getFdName()%>">    <!-- UserName:签名用户名称 -->
		<param name="Enabled" value="1">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->
		<param name="PenColor" value="#0099FF">     <!-- PenColor:笔的颜色，采用网页色彩值  默认值:#000000  -->
		<param name="BorderStyle" value="1">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
		<param name="EditType" value="0">    <!-- EditType:默认签章类型，0:签名 1:文字  默认值:0  -->
		<param name="ShowPage" value="0">    <!-- ShowPage:设置默认显示页面，0:电子印章,1:网页签批,2:文字批注  默认值:0  -->
		<param name="InputText" value="">    <!-- InputText:设置署名信息，  为空字符串则默认信息[用户名+时间]内容  -->
		<param name="PenWidth" value="2">     <!-- PenWidth:笔的宽度，值:1 2 3 4 5   默认值:2  -->
		<param name="FontSize" value="11">    <!-- FontSize:文字大小，默认值:11 -->
		<param name="value" value="<%=fileValue%>">
		<param name="SignatureType" value="0">    <!-- SignatureType:签章来源类型，0表示从服务器数据库中读取签章，1表示从硬件密钥盘中读取签章，2表示从本地读取签章，并与ImageName(本地签章路径)属性相结合使用  默认值:0 -->
		<param name="InputList" value="同意
		不同意
		请上级批示
		请速办理">
	</OBJECT>
</div>
</c:if>

<c:if test="${kmReviewMainForm.docStatus==30}">
	<div style="height=200;width=729">
		<OBJECT name="<%=FieldName %>" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439" codebase="iWebRevision.cab#version=6,0,0,0" width=100% height=100%>
			<param name="Enabled" value="0">  <!-- Enabled:是否允许修改，0:不允许 1:允许  默认值:1  -->           
			<param name="BorderStyle" value="0">    <!-- BorderStyle:边框，0:无边框 1:有边框  默认值:1  -->
			<param name="value" value="<%=fileValue%>">
			<param name="FieldName" value="<%=FieldName %>"> 
		</OBJECT>
	</div>
</c:if>

<script>
Com_Parameter.event["submit"][Com_Parameter.event["submit"].length]=myCheck_<%=FieldName%>;
function myCheck_<%=FieldName%>(){
if(kmReviewMainForm.<%=FieldName%>.Modify){
    if (!kmReviewMainForm.<%=FieldName%>.SaveSignature()){
       alert("保存签发签批内容失败！");
      return false;  
    }
  }
return true;
}
</script>