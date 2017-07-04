<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
function getLocation(url) {
	window.open(url, "_blank");
	return false;
}
</script>

<center>
<table id="Label_Tabel" width=95%>
	<tr LKS_LabelName="模块信息">
		<td>
			<c:forEach items="${modelList }" var="model" varStatus="vstatus">
			<c:if test="${ model.fdId != 'com.landray.kmss.kms.home' }">
			<table class="tb_normal" width=95% style="table-layout:fixed;word-wrap:break-word;">
				<tr>
					<td class="td_normal_title" width="15%" align="right">模块名</td>
					<td width="35%">${model.title }</td>
					<td class="td_normal_title" width="15%" align="right">主页url</td>
					<td width="35%">/kms/common/kms_common_main/kmsCommonMain.do?fdId=${model.fdId }&method=module</td>
				</tr>
			</table>
			</c:if>
			${vstatus.last ? "" : "<br />"}
			</c:forEach>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>