<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>微信配置</title>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
body {
	color: #000;
	font-family: arial;
}
fieldset {
	border: none;
	-webkit-margin-start: 2px;
	-webkit-margin-end: 2px;
	-webkit-padding-before: 0.35em;
	-webkit-padding-start: 0.75em;
	-webkit-padding-end: 0.75em;
	-webkit-padding-after: 0.625em;
}

input[type="submit"] {
	padding: 0 15px;
	border: 0;
	background: #f40;
	text-align: center;
	text-decoration: none;
	color: #fff;
	-webkit-border-radius: 2px;
	text-shadow: 0 -1px 1px #ca3511;
	min-width: 100%;
	height: 40px;
	font-size: 24px;
	text-shadow: 0 -1px 0 #441307;
	background: -webkit-gradient(linear, left top, left bottom, from(#0095cc), to(#00678e));
}

span {
	line-height: 3px;
}

.infos {
	color: red;
}
</style>
<body>
<html:form action="/third/wechat/wechatLoginHelper.do?method=save">

<c:if test="${!empty nickname }">
	昵称：${nickname }
</c:if>
<br><br>
<c:if test="${!empty image}">
	<image src="${image }" style="width:15%" disabled="true"/>
</c:if>

<table class="tb_normal" width=95%>
	<br>
	<fieldset>
	<tr>
		<td class="td_normal_title" width=10%>
			推送待办：
			<xform:radio property="fdPushProcess" showStatus="edit" >
				<xform:simpleDataSource value="1">启用</xform:simpleDataSource>
				<xform:simpleDataSource value="0">禁用</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr>
		<td class="td_normal_title" width=15%>
			推送待阅：
			<xform:radio property="fdPushRead" showStatus="edit" >
				<xform:simpleDataSource value="1">启用</xform:simpleDataSource>
				<xform:simpleDataSource value="0">禁用</xform:simpleDataSource>
			</xform:radio>
		</td>
	</tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr><td></td></tr>
	<tr>
		<td>
		<input type="submit"  value="保存"></td></tr>
	</fieldset>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="fdEkpid" />
<html:hidden property="fdOpenid" />
<html:hidden property="fdNickname"/>
<html:hidden property="fdImage"/>
<html:hidden property="method_GET" />
<script>
	
</script>
</html:form>
</body>
</html>