<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplatePreview"%>
<%@page import="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"%>
<%@page import="java.util.List"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>多维知识库概览</title>
<script language="javascript">
function Search_Simple(){
	var keyField = document.getElementsByName("Search_Keyword")[0];
	if(keyField.value==""){
		alert('<bean:message key="error.search.keywords.required"/>');
		keyField.focus();
		return;
	}  
	var Search_ModelName = "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"
		var url = "<c:url value="/sys/ftsearch/searchBuilder.do?method=search"/>";
		var seq = parseInt(Com_GetUrlParameter(url, "s_seq"));
		seq = isNaN(seq)?1:seq+1; 
		url = Com_SetUrlParameter(url, "s_seq", seq);
		url = Com_SetUrlParameter(url, "modelName", Search_ModelName);
		url = Com_SetUrlParameter(url, "queryString", keyField.value);
		Com_OpenWindow(url,"_blank");

}
function list(categoryId,categoryName){
	var s_pathEncode=encodeURIComponent("按类别>>"+categoryName);
	var url ="kmsMultidocKnowledge.do?method=listChildren&categoryId="+categoryId+"&orderby=docPublishTime&ordertype=down&nodeType=CATEGORY&s_path="+s_pathEncode+"&s_css=default";
	Com_OpenWindow(url,"_self");
}
function openDocWindow(fdId){
	var url="kmsMultidocKnowledge.do?method=view&fdId="+fdId;
	Com_OpenWindow(url,"_blank");
}
</script>
<style type="text/css" media="screen">
@import url("../resource/css/default/preview.css");
</style>
</head>
<body>
<div id="title"><bean:message
					bundle="kms-multidoc"
					key="kmsMultidoc.kmsMultidocKnowledge.preview" /></div>
<%List<KmsMultidocTemplatePreview> kmsMultidocTemplatePreviewList=(List<KmsMultidocTemplatePreview>)request.getAttribute("kmsMultidocTemplatePreviewList");
double top=80;
for(KmsMultidocTemplatePreview kmsMultidocTemplatePreview:kmsMultidocTemplatePreviewList){%>
<div id="contentTitle" style="top:<%=top%>px"><a href='#' onClick="list('<%=kmsMultidocTemplatePreview.getCategoryId()%>','<%=kmsMultidocTemplatePreview.getTempName()%>')">&nbsp&nbsp&nbsp&nbsp<span style="font-size:13px;color:#5a5a5a;font-weight:bold"><%=kmsMultidocTemplatePreview.getTempName()%>（<%=kmsMultidocTemplatePreview.getDocAmount()%>）</span></a></div>
<div id="content" style="top:<%=top+27%>px">
<table width="100%" id="TB_Content" cellspacing="5px">
<%int trAmount=kmsMultidocTemplatePreview.getTrAmount();
List<KmsMultidocTemplatePreview> tempList=kmsMultidocTemplatePreview.getTempList();
for(int i=0;i<trAmount;i++){
%> 
    <tr>
    <%for(int j=i*3;j<3*(i+1);j++){%>
      <td   width="33%" align="left"><%if(j<tempList.size()){%><a href='#' title="<%=tempList.get(j).getTempName()%>" onClick="list('<%=tempList.get(j).getCategoryId()%>','<%=kmsMultidocTemplatePreview.getTempName()+">>"+tempList.get(j).getTempName()%>')">&nbsp&nbsp&nbsp<img alt="" border=0 src="<%=request.getContextPath()%>/kms/common/resource/img/arrow.gif"/>&nbsp<%=tempList.get(j).getTempName().length()>8?tempList.get(j).getTempName().substring(0,8)+"..":tempList.get(j).getTempName()%>（<%=tempList.get(j).getDocAmount()%>）</a></td>
      <%}else{%><td width="25%"></td><% }}%>
    </tr>
    <%}%>
  </table>
</div>
<% top=top+36+(15*trAmount+(trAmount+1)*5)+trAmount*3.1;}
%>
<div id="searchTitle"><span style="font-size:13px;color:#5a5a5a;font-weight:bold">&nbsp&nbsp<bean:message
					bundle="kms-multidoc"
					key="kmsMultidoc.kmsMultidocKnowledge.preview.search" /></span></div>
<div id="search">
  <label>&nbsp&nbsp
  <input size="18" type="text" name="Search_Keyword" id="input_search" onKeyDown="if (event.keyCode == 13 && this.value !='') Search_Simple();" style="">
  <input type="button" class="btn_search" onClick="Search_Simple();" value="<bean:message key="button.search"/>">
 </label>
</div>
<div id="latestDocTitle">
	<span style="font-size:13px;color:#5a5a5a;font-weight:bold">
		&nbsp&nbsp<bean:message
			bundle="kms-multidoc"
			key="kmsMultidoc.kmsMultidocKnowledge.preview.new" />
	</span>
</div>
<div id="latestDoc">
  <table width="100%" id="TB_Content">
  <%List<KmsMultidocKnowledge> latestDocList=(List<KmsMultidocKnowledge>)request.getAttribute("latestDocList");
  for(KmsMultidocKnowledge kmsMultidocKnowledge:latestDocList){%>
     <tr>
	<td>&nbsp;
		<font class=limit_content_icon>·</font>&nbsp;
		<a href="#"
		   onClick="openDocWindow('<%=kmsMultidocKnowledge.getFdId()%>');" title="<%=kmsMultidocKnowledge.getDocSubject() %>"
		   ><%=kmsMultidocKnowledge.getDocSubject().length()>6?kmsMultidocKnowledge.getDocSubject().substring(0,6)+"..":kmsMultidocKnowledge.getDocSubject()%> &nbsp<kmss:showDate value='<%=kmsMultidocKnowledge.getDocPublishTime()%>' type="date"/></a>
	</td>
</tr>
 <%} %>
  </table>
</div>
<div id="hotDocTitle"><span style="font-size:13px;color:#5a5a5a;font-weight:bold">&nbsp&nbsp<bean:message
					bundle="kms-multidoc"
					key="kmsMultidoc.kmsMultidocKnowledge.preview.hot" /></span></div>
<div id="hotDoc">
  <table width="100%" id="TB_Content">
   <%List<KmsMultidocKnowledge> hotDocList=(List<KmsMultidocKnowledge>)request.getAttribute("hotDocList");
  for(KmsMultidocKnowledge kmsMultidocKnowledge:hotDocList){%>
     <tr>
	<td>&nbsp;
		<font class=limit_content_icon>·</font>&nbsp;
		<a href="#"
		   onClick="openDocWindow('<%=kmsMultidocKnowledge.getFdId()%>');" title="<%=kmsMultidocKnowledge.getDocSubject() %>"
		   ><%=kmsMultidocKnowledge.getDocSubject().length()>9?kmsMultidocKnowledge.getDocSubject().substring(0,9)+"..":kmsMultidocKnowledge.getDocSubject()%> &nbsp<%=kmsMultidocKnowledge.getDocReadCount()%>次</a>
	</td>
</tr>
  <%} %>
  </table></div>
</body>
</html>
