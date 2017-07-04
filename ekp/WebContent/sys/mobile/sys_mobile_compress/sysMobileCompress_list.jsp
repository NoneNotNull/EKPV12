<%@page import="com.landray.kmss.sys.cluster.interfaces.ServerDataSource"%>
<%@page import="com.landray.kmss.sys.cluster.interfaces.DispatcherCenter"%>
<%@page import="com.landray.kmss.sys.cluster.interfaces.ClusterDiscover"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
	<div id="optBarDiv">
	<kmss:auth
		requestURL="/sys/mobile/sys_mobile_compress/sysMobileCompress.do?method=compress"
		requestMethod="GET">
		<input type="button" value="压缩合并"
			onclick="doCompress();">
	</kmss:auth>
	</div>
	<c:if test="${empty queryPage}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	</c:if>
	<c:if test="${not empty queryPage}">
	<table id="List_ViewTable">
		<tr>
			<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
			<td width="40pt"><bean:message key="page.serial" /></td>
			<td>标示名</td>
			<td>目标文件</td>
			<td>源文件目录</td>
			<td>类型</td>
			<td>已经执行</td>
			<td>执行时间</td>
		</tr>
		<c:forEach items="${queryPage}" var="item" varStatus="vstatus">
			<tr>
				<td><input type="checkbox" name="List_Selected"
					value="${item.name}"></td>
				<td>${vstatus.index+1}</td>
				<td><c:out value="${item.name}" /></td>
				<td><c:out value="${item.targetFile}"/></td>
				<td><c:out value="${item.srcFold}" /></td>
				<td><c:out value="${item.type}" /></td>
				<td><sunbor:enumsShow value="${item.done}" enumsType="common_yesno" /></td>
				<td><sunbor:date value="${item.createTime}" /></td>
			</tr>
		</c:forEach>
	</table>
	</c:if>
	<script>Com_IncludeFile('jquery.js')</script>
	<script>
	function getTaskIds() {
		var rtn = [];
		$('[name="List_Selected"]:checked').each(function(i, val) {
			rtn.push( (i > 0 ? "&" : "") + "List_Selected=" + val.value)
		});
		return rtn.join('');
	}
	function showResult(result) {
		alert(result.msg);
		// TODO 进度对话框
	}
	function doCompress() {
		var data = getTaskIds();
		if (data == null || data == '') {
			alert('请选择任务');
			return;
		}
		$.ajax({
			type: 'POST',
			dataType: 'json',
			url: '<c:url value="/sys/mobile/sys_mobile_compress/sysMobileCompress.do?method=compress"/>',
			data: data,
			success: showResult,
			error: showResult
		});
	}
	</script>
<%@ include file="/resource/jsp/list_down.jsp"%>