<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<form method="post" action="<c:url value="/sys/admin/threadmonitor.do?method=update" />">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
				onclick="Com_Submit(document.forms[0], 'update');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<script>Com_IncludeFile("doclist.js");</script>
<p class="txttitle">
	拦截地址设置
</p>
<xform:config isLoadDataDict="false" showStatus="edit">
<div style="line-height: 30px; text-align:center;">禁止用户访问以下URL地址，超级管理员的所有操作不被拦截</div>
<center>
<table id="TABLE_DocList" class="tb_normal" width="90%">
	<tr class="tr_normal_title">
		<td style="width:5%">序号</td>
		<td style="width:45%">URL前缀</td>
		<td style="width:45%">提示信息</td>
		<td style="width:5%">
			<a href="#" onclick="DocList_AddRow();">添加</a>
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1"></td>
		<td>
			<xform:textarea property="fdUrl" subject="URL前缀" validators="required maxLength(2000)" value="" style="width:100%;height:50px;"/>
		</td>
		<td>
			<xform:textarea property="fdDescription" subject="提示信息" validators="maxLength(2000)" value="" style="width:100%;height:50px;"/>
		</td>
		<td>
			<center><a href="#" onclick="DocList_DeleteRow();">删除</a></center>
		</td>
	</tr>
	<!--内容行-->
	<c:forEach items="${urlBlocks}" var="urlBlock" varStatus="status">
	<tr KMSS_IsContentRow="1">
		<td>${status.index+1}</td>
		<td>
			<xform:textarea property="fdUrl" subject="URL前缀" validators="required maxLength(2000)" value="${urlBlock.fdUrl}" style="width:100%;height:50px;"/>
		</td>
		<td>
			<xform:textarea property="fdDescription" subject="提示信息" validators="maxLength(2000)" value="${urlBlock.fdDescription}" style="width:100%;height:50px;"/>
		</td>
		<td>
			<center><a href="#" onclick="DocList_DeleteRow();">删除</a></center>
		</td>
	</tr>
	</c:forEach>
	<tr>
		<td></td>
		<td style="vertical-align: top;">
			URL前缀不包含DNS，但包含带上下文根路径<br>如：“/ekp/km/review/”，表示要拦截以“/ekp/km/review/”开头的所有请求。
		</td>
		<td style="vertical-align: top;">
			当用户访问设定的地址后，给用户的提示信息，为空则提示：“<bean:message key="global.service.unavalable"/>”
		</td>
		<td></td>
	</tr>
</table>
</center>
</xform:config>
<script>$KMSSValidation(document.forms[0]);</script>
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>