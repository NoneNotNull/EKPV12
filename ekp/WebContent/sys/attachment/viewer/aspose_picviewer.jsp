<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<html>
<style>
<!--
.Pages {
	border-left-style: solid;
	border-left-color: #808080;
	border-right-style: solid;
	border-right-color: #000000;
	border-top-style: solid;
	border-top-color: #808080;
	border-bottom-style: solid;
	border-bottom-color: #000000;
	padding-left: 1;
	padding-right: 2;
	padding-top: 1;
	padding-bottom: 2
}
-->
</style>
<script>
	window.onload = function() {
		setTimeout(dyniFrameSize, 100);
	};
	function dyniFrameSize() {
		try {
			// 调整高度
			var arguObj = document.getElementsByTagName("table")[0];
			if (arguObj != null && window.frameElement != null
					&& window.frameElement.tagName == "IFRAME") {
				window.frameElement.style.height = (arguObj.offsetHeight + 40)
						+ "px";
			}
		} catch (e) {
		}
	};
</script>
<c:set var="viewerParam" value="${viewerParam}" scope="request" />
<body bgcolor=#c0c0c0>
<table broder=0 align=center>
	<tr>
		<td>
		<%
			String totalPage = "0";
			String viewerParam = (String) request.getAttribute("viewerParam");
			String[] paramArray = viewerParam.split(",");
			for (int i = 0; i < paramArray.length; i++) {
				String[] param = paramArray[i].split(":");
				if ("totalPageCount".equals(param[0])) {
					totalPage = param[1];
				}
			}
			for (int i = 0; i < Integer.parseInt(totalPage); i++) {
				String url = request.getContextPath()
						+ "/sys/attachment/sys_att_main/sysAttMain.do?method=view&fdId="
						+ request.getParameter("fdId")
						+ "&filekey=aspose_office2pic_page-" + (i + 1);
		%>
		<table border=0 cellspacing=1 class=Pages bgcolor=#FFFFFF>
			<tr>
				<td><img src=" <%=url%>"></td>
			</tr>
		</table>
		<br>
		<%
			}
		%>
		</td>
	</tr>
</table>
</body>
</html>
