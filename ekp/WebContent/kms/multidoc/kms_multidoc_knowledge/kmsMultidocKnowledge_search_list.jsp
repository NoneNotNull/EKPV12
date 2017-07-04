<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>KMS--组合搜索</title>
<meta name="Keywords" content="" />
<meta name="Description" content="" />
<meta http-equiv="Content-Language" content="zh-cn" />
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ include file="/kms/common/resource/jsp/tags.jsp" %>
<%@ include file="/kms/common/resource/jsp/include_ekp.jsp" %>
<script type="text/javascript" src="<%=request.getContextPath()%>/resource/js/common.js"></script>
<%@ include file="/kms/common/resource/jsp/include.jsp" %>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
window.onload=function(){
  setTimeout("resizeParent();", 500);
	 
}
function resizeParent(){
	 
	var iframe = parent.document.getElementById("searchListFrame");
	//td_evaluation.style.height=document.body.scrollHeight+40 ;
    
	var bHeight = iframe.contentWindow.document.body.scrollHeight;

	var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;

	var height = Math.max(bHeight, dHeight);

	iframe.height =  height;

	
}
function submitForm(action){
	document.getElementById("searchForm").action=action;
    document.getElementById("searchForm").submit() ;
}
function openDoc(fdId){
	var url="kmsMultidocKnowledge.do?method=view&fdId="+fdId;
	Com_OpenWindow(url,"_blank");
}
</script>
</head>
<body> 
<table  border=0 width="100%" ><tr><td>
			<p class="tips m_t10">搜索到约${resultsNum}项结果，用时${searchTime}秒</p>
<form name="KmsMultidocKnowledgeForm" id="searchForm" action="" method="post"></form>
			<div class="box3_3 m_t10">
		 	 <c:if test="${queryPage!=null }">
			     <c:forEach items="${queryPage.list}" var="searchList" varStatus="vstatus">
				     
				    <dl class="dl_g">
					<dt><a href="javascript:void(0)" onclick="openDoc('${searchList.fdId}')" title=""><c:out value="${searchList.docSubject}" /></a></dt>
					<dd> <c:out value="${searchList.fdDescription}"/> </dd>
					<dd  style="color:gray"> <span class="m_l20">知识目录：${searchList.kmsMultidocTemplate.fdName}</span>
					<span class="m_l20">创建人：<c:out value="${searchList.docCreator.fdName}" /></span>
					<span class="m_l20">创建时间：<fmt:formatDate value='${searchList.docCreateTime}' pattern='yyyy-MM-dd' />  </span>
					<span class="m_l20">阅读次数：<c:out value="${searchList.docReadCount}" /></span></dd>
				</dl>
				     
				 </c:forEach>
			</c:if>	 
				 <%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
				 
			</div>

			 
			</td></tr></table>
</body>
</html>