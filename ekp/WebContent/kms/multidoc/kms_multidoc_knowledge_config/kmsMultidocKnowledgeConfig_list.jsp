<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/resource/jsp/list_top.jsp"%>
	<%if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {	%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<%} else {%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	
	
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate"%>
<%@page import="com.landray.kmss.kms.multidoc.actions.KmsMultidocKnowledgeConfigAction"%>
<%@page import="com.landray.kmss.kms.multidoc.util.KmsMultidocKnowlegeUtil"%><script>
	
	function openDocList(index){
		var url = "${pageContext.request.contextPath}/moduleindex.jsp?nav=/kms/multidoc/tree.jsp&main=/";
		var fdId = document.getElementById("fdId["+index+"]").value;
		var s_path = document.getElementById("s_path["+index+"]").value;
		var s_pathEncode = encodeURIComponent(s_path);
		url += encodeURIComponent("kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=listChildren&categoryId="+fdId+"&orderby=docPublishTime&ordertype=down&nodeType=CATEGORY&s_path="+s_pathEncode+"&s_css=default");
		Com_OpenWindow(url);
	}

	function kmsMultidocKnowledgeConfig(){
		 window.open('<%=request.getContextPath()%>/kms/multidoc/kms_multidoc_knowledge_config/kmsMultidocKnowledgeConfig.do?method=edit','personConfig','resizable=yes,scrollbars=yes,menubar=no,toolbar=no,status=no,width=800px,height=600px,screenX=10px,screenY=10px,top=10px,left=10px');
	}
	</script>
<div id="optBarDiv">	
	<input type="button" value="<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.set"/>" onClick="kmsMultidocKnowledgeConfig();">
</div>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td>
					<bean:message key="page.serial" />
				</td>
				<sunbor:column property="kmsMultidocTemplate.fdName">
					<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.fdName"/>
				</sunbor:column>
				<td>
					<bean:message bundle="kms-multidoc" key="kmsMultidocTemplate.commonConfig.path"/>
				</td>
				<td>
					<bean:message key="button.add" />
				</td>
			</sunbor:columnHead>
		</tr>
		<%Page templatePage = (Page)request.getAttribute("queryPage");
		  List  templateList = templatePage.getList();
			if (templateList != null && !templateList.isEmpty()) {
				for (int j = 0; j < templateList.size(); j++) {
					KmsMultidocTemplate kmsMultidocTemplate = (KmsMultidocTemplate) templateList
							.get(j);	
					String path = KmsMultidocKnowlegeUtil.getSPath(kmsMultidocTemplate,"");
					%>
					<tr>
						<td width="5%" onclick="openDocList('<%=j+1%>');" style="cursor: pointer;">
							<input id="fdId[<%=j+1 %>]" value="<%=kmsMultidocTemplate.getFdId()%>" type="hidden"/>
							<input id="s_path[<%=j+1 %>]" value="<%=path%>" type="hidden"/>
							<%=j+1 %>
						</td>
						<td onclick="openDocList('<%=j+1%>');" style="cursor: pointer;">
							<%=kmsMultidocTemplate.getFdName() %>
						</td>
						<td onclick="openDocList('<%=j+1%>');" style="cursor: pointer;">
							<%=path%>
						</td>
						<td>
							<img title="<bean:message key="button.add"/>" src="${KMSS_Parameter_StylePath}icons/edit.gif" onclick="Com_OpenWindow('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do" />?method=add&fdTemplateId=<%=kmsMultidocTemplate.getFdId() %>');" 
								border="0" style="cursor: pointer;">
						</td>				
					</tr>
					<%
				}
			}			
			%>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%}	%>
<%@ include file="/resource/jsp/list_down.jsp"%>
