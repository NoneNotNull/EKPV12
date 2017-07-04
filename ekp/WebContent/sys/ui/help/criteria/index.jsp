<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="org.dom4j.*,org.dom4j.io.*" %>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>

<%
Collection src = SysUiPluginUtil.getCombins().values();
List list = new ArrayList();
for (Iterator i = src.iterator(); i.hasNext(); ) {
	SysUiCombin suc = (SysUiCombin) i.next();
	if (suc.getFdId().startsWith("criterion.")) {
		list.add(suc);
	}
}
request.setAttribute("list", list);

%>
<template:include file="/sys/ui/help/assembly-help.jsp">

	<template:replace name="elements">
		<script>Com_IncludeFile('jquery.js');</script>
		<ui:content title="标签 uri(/WEB-INF/KmssConfig/sys/ui/list.tld)">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					 <td width="25px">序号</td>
					 <td width="150px">标签</td>
					 <td width="*">描述</td>
				</tr>
				<% 
				SAXReader reader = new SAXReader();
				Document document = null;
				List targs = Collections.emptyList();
				try {
					document = reader.read(request.getSession().getServletContext().getResourceAsStream("/WEB-INF/KmssConfig/sys/ui/list.tld"));
					targs = document.getRootElement().elements("tag");
				} catch (Exception e) {
					e.printStackTrace();
				}
				int index = 1;
				for (Iterator it = targs.iterator(); it.hasNext();) { 
					Element tag = (Element) it.next();
					if (!tag.elementText("tag-class").startsWith("com.landray.kmss.sys.ui.taglib.criteria")) {
						continue;
					}
					String des = null;
					for (Iterator elems = tag.nodeIterator(); elems.hasNext(); ) {
						Node elem = (Node) elems.next();
						if (Node.COMMENT_NODE == elem.getNodeType()) {
							des = elem.getText();
						}
					}
				%>
				<tr  data-tag-btn="<%=tag.elementText("name") %>"
						onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';">
					 <td align="center"><%=index %></td>
					 <td>&lt;list:<%=tag.elementText("name") %>&gt;</td>
					 <td><c:out value="<%=des %>" /></td>
				</tr>
				<tr data-tag-attr="<%=tag.elementText("name") %>" style="display:none;">
					<td colspan="3">
						<table class="tb_normal" width="100%">
						<tr class="tr_normal_title">
							 <td width="25px">序号</td>
							 <td width="100px">属性</td>
							 <td width="50px">是否必须</td>
							 <td width="*">描述</td>
						</tr>
					<%
					int aIndex = 1;
					for (Iterator attrIt = tag.elementIterator("attribute"); attrIt.hasNext(); ) {
						Element attr = (Element) attrIt.next();
						pageContext.setAttribute("description", attr.elementText("description"));
						%>
						<tr onmouseover="this.style.backgroundColor='#F6F6F6';"
							onmouseout="this.style.backgroundColor='#FFFFFF';">
							<td align="center"><%=aIndex %></td>
							<td><%=attr.elementText("name") %></td>
							<td><%=attr.elementText("required") %></td>
							<td><c:out value="${description}" /></td>
						</tr>
						<%
					}
					%>
						</table>
					</td>
				</tr>
				<%
					index ++;
				} 
				%>
			</table> 
		</ui:content>
		
		<script>
		$(document).ready(function() {
			$("tr[data-tag-btn]").click(function() {
				var tag = $(this);
				$('tr[data-tag-attr="' + tag.attr('data-tag-btn') + '"]').each(function() {
					var attr = $(this);
					if (attr.is(":visible")) {
						attr.hide();
					} else {
						attr.show();
					}
				});
			});
		});
		</script>
	</template:replace>

	<template:replace name="detail">
		<textarea style="width: 100%;height: 220px;"><c:import url="example.txt" charEncoding="UTF8"></c:import></textarea>		
	</template:replace>
	
	<template:replace name="more">
		<ui:content title="系统注册的筛选项">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					 <td width="5%">序号</td>
					 <td width="20%">ID</td>
					 <td width="20%">名称</td>
					 <td width="55%">文件路径</td>
				</tr>
				<c:forEach items="${list}" var="combine" varStatus="vstatus">
					<tr onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';">
						<td align="center">${vstatus.index+1}</td>
						<td>${ combine.fdId }</td>
						<td>${ combine.fdName }</td>
						<td>${ combine.fdFile }</td>
					</tr>
				</c:forEach>
			</table> 
		</ui:content>
	</template:replace>
</template:include>