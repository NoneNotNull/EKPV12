<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.util.StringUtil,
	java.util.*
"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%
// 从数据库取得数据
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	RequestContext requestInfo = new RequestContext(request);
	IXMLDataBean bean = (IXMLDataBean) ctx.getBean("kmDocKnowledgeCommonPortlet");
	List dataList = bean.getDataList(requestInfo);
	pageContext.setAttribute("dataList", dataList);
%>
<script type="text/javascript">
	function openDocList(index){
		var url = "${pageContext.request.contextPath}/moduleindex.jsp?nav=/km/doc/tree.jsp&main=/";
		var fdId = document.getElementById("fdId["+index+"]").value;
		var s_path = document.getElementById("s_path["+index+"]").value;
		var s_pathEncode = encodeURIComponent(s_path);
		url += encodeURIComponent("km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listChildren&categoryId="+fdId+"&orderby=docPublishTime&ordertype=down&nodeType=CATEGORY&s_path="+s_pathEncode+"&s_css=default");
		Com_OpenWindow(url);
	}

	function getByLength(words, length) {
		if(length < words.length)
			words = words.substring(0, length-2) + "...";
		return Com_HtmlEscape(words.replace(/&/g, escape("&")));
	}
</script>
<div style="width: 100%;text-align: center;">
	<table style="width: 95%;">
		<tr>
			<td></td>
			<td align="right">
			 	<a href="<c:url value='/km/doc/km_doc_knowledge_config/kmDocKnowledgeConfig.do?method=edit' />" target="_blank"><bean:message bundle="km-doc" key="kmDocTemplate.commonConfig.set" /></a>
			</td>
		</tr>
		<c:forEach items="${dataList}" var="map" varStatus="vstatus">
			<tr>
			<input id="fdId[${vstatus.index}]" value="${map['id']}" type="hidden"/>
			<input id="s_path[${vstatus.index}]" value="${map['s_path']}" type="hidden"/>
				<td title="${map['text']}" onclick="openDocList(${vstatus.index});" style="border-bottom: 1px #F0F0F0 dashed ;cursor: pointer;">
					<script>
			   		document.write(getByLength('${map["text"]}',15))
			  		</script>
				</td>
				<td  align="right" style="border-bottom: 1px #F0F0F0 dashed ;">
					<img title="<bean:message key="button.add"/>" src="${KMSS_Parameter_StylePath}icons/edit.gif" onclick="Com_OpenWindow('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do" />?method=add&fdTemplateId=${map['id']}');" 
						border="0" style="cursor: pointer;">
				</td>
			</tr>
		</c:forEach>
	</table>
</div>
<%@ include file="/resource/jsp/list_down.jsp"%>