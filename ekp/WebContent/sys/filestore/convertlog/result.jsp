<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<template:include ref="default.simple">
	<template:replace name="head">
		<style type="text/css">
.result_table {
	border-collapse: collapse;
	border-spacing: 0px;
	width: 100%;
	background-color: #FFF;
	border-bottom: 1px solid #B9D4E5;
	width: 100%;
	background-color: #FFF;
}

.result_table thead {
	background-color: #F8F8F8;
	height: 40px;
}

.result_table thead th {
	padding: 8px 2px;
	text-align: center;
	vertical-align: middle;
	border-bottom: 1px dotted #CCC;
	font-weight: bold;
	white-space: nowrap;
}

.result_table tbody tr {
	border-bottom: 1px dotted #ccc;
}

.result_table tbody tr td {
	padding: 10px 2px;
	text-align: center;
	vertical-align: middle;
	word-break: break-all;
}

.view_error {
	cursor: pointer;
	text-decoration: underline;
}

#errorInfo {
	border: 2px solid gray;
	width: 560px;
	height: 300px;
}
</style>

		<script type="text/javascript">
		Com_IncludeFile("jquery.js");
	function showErrorInfo(num){
		$("#errorContent")[0].innerHTML="<p>"+$("#errorHiddenInfo_"+num)[0].value+"</p>";		
		$("#errorInfo").css("display","block");
	}

	function hiddenErrorInfo(){
		//$("#errorInfo").innerHTML="";
		$("#errorInfo").css("display","none");
	}
</script>
	</template:replace>
	<template:replace name="body">
		<center>
		<table class="result_table">
			<thead>
				<tr>
					<th>序号</th>
					<th>转换器</th>
					<th>转换状态</th>
					<th>状态时间</th>
					<th>错误信息</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${logs }" var="log" varStatus="status">
					<tr>
						<td>${status.count }</td>
						<td>${log[0] }</td>
						<td>${log[1] }</td>
						<td>${log[2] }</td>
						<td
							style="width: 180px; color: red; font-weight: bold; text-align: left;"><input
							id="errorHiddenInfo_${status.count }" type="hidden"
							value="${log[3] }" />
						<div class="view_error" onclick="showErrorInfo(${status.count });">${log[4] }</div>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div id="errorInfo" style="display: none;">
		<div
			style="float: right; cursor: pointer; margin: 2px 2px 2px 0px; border: 2px solid blue; color: blue;"
			onclick="hiddenErrorInfo();">关闭</div>
		<div id="errorContent"
			style="text-align: left; word-break: break-all; overflow: auto; width: 100%; margin-top: 20px;"></div>
		</div>
		</center>
	</template:replace>
</template:include>