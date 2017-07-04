<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.landray.kmss.util.StringUtil" %>
<%@ page import="com.landray.kmss.util.ResourceUtil" %>
<title>版本检测结果</title>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<center>
<p class="txttitle">版本检测结果</p>
<c:choose>
<c:when test="${not empty differences}">
<table border="0" width=95%>
	<tr>
		<td class="txtStrong">
			产品安装路径：${prodSetupPath }
		</td>
	</tr>
</table>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width="40pt">
			<center><bean:message key="page.serial"/></center>
		</td>	
		<td class="td_normal_title" width=60%>
			<center>文件路径</center>
		</td>
		<td class="td_normal_title" width=15%>
			<center>产品MD5</center>
		</td>
		<td class="td_normal_title" width=15%>
			<center>项目MD5</center>
		</td>
		<td class="td_normal_title" width="8%">
			<center>类型</center>
		</td>	
	</tr>
	<c:forEach items="${differences}" var="difference" varStatus="vstatus">	
		<tr>
			<td>
				<center>${vstatus.index+1}</center>
			</td>		
			<td>
				<c:out value="${difference.filePath}"/>
			</td>
			<td>
				<c:out value="${difference.prodMd5}"/>
			</td>
			<td >
				<c:out value="${difference.projectMd5}"/>
			</td>
			<td>
				<c:out value="${difference.type}" />
			</td>	
		</tr>
	</c:forEach>
</table>
</c:when>
<c:otherwise>
	<span class="txtstrong">${error}</span>
</c:otherwise>
</c:choose>
</center>
</body>
</html>