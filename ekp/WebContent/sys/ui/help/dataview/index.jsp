<%@page import="com.landray.kmss.util.comparator.ChinesePinyinComparator"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiFormat"%>
<%@page import="java.util.Collection"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
List list = new ArrayList(SysUiPluginUtil.getFormats().values());
Collections.sort(list,new Comparator(){
	public int compare(Object a1, Object a2) {
		return ChinesePinyinComparator.compare(((SysUiFormat)a1).getFdName(),((SysUiFormat)a2).getFdName());
	}
});
request.setAttribute("list",list);
%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/sys/ui/help/assembly-help.jsp">
	<template:replace name="elements">
		<ui:content title="数据格式">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title" height="30px">
					 <td width="5%">序号</td>
					 <td width="20%">ID</td>
					 <td width="20%">名称</td>
					 <td width="55%">描述</td>
				</tr>
				<c:forEach items="${list}" var="format" varStatus="vstatus">
					<tr style="cursor:pointer;" height="30px"
						onclick="window.open('<c:url value="/sys/ui/help/dataview/format.jsp" />?fdId=${format.fdId}', '_self');"
						onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';">
						<td><center>${vstatus.index+1}</center></td>
						<td>${ format.fdId }</td>
						<td>${ format.fdName }</td>
						<td>${ format.fdDescription }</td>
					</tr>
				</c:forEach>
			</table> 
		</ui:content>
	</template:replace>
	<template:replace name="detail">
	使用样例代码：
	<textarea style="width: 100%;height: 220px;"><c:import url="example.txt" charEncoding="UTF8"></c:import></textarea>		
	</template:replace>
</template:include>
