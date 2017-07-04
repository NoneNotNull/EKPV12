<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/config/resource/view_top.jsp"%>
<html>
<head>
<title>备份配置文件</title>
</head>
<body>
<html:form action="/admin.do">
<p class="txttitle">备份配置文件</p>
<center>
<table width="95%">
	<tr>
		<td>
			将开始备份以下文件：
		</td>
	</tr>
	<tr>
		<td>
			<c:forEach items="${sysConfigAdminForm.backupMap}" var="backupMap" varStatus="vstatus">
				${vstatus.index+1}、<c:out value="${backupMap.key}"/>：<c:out value="${backupMap.value}"/><br>
			</c:forEach>
			<br><br>
		</td>
	</tr>
	<tr>
		<td align="center">
			<input type="button" class="btnopt" value="备份" onclick="Com_OpenWindow('admin.do?method=backup','_self');"/>
			<input type="button" class="btnopt" value="关闭" onclick="Com_CloseWindow();"/>
		</td>
	</tr>
</table>
</center>
</html:form>
</body>
</html>
