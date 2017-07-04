<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%@ page errorPage="/sys/config/resource/jsperror.jsp" %>
<%@ include file="/sys/config/resource/htmlhead.jsp"%>
<%
KmssMessageWriter msgWriter = null;
if(request.getAttribute("KMSS_RETURNPAGE")!=null){
	msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
}else{
	msgWriter = new KmssMessageWriter(request, null);
}
%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
Com_IncludeFile("docutil.js");
function showMoreErrInfo(index, srcImg){
	var obj = document.getElementById("moreErrInfo"+index);
	if(obj!=null){
		if(obj.style.display=="none"){
			obj.style.display="block";
			srcImg.src = Com_Parameter.StylePath + "msg/minus.gif";
		}else{
			obj.style.display="none";
			srcImg.src = Com_Parameter.StylePath + "msg/plus.gif";
		}
	}
}
</script>
<title>operation success</title>
</head>
<BODY style="margin-left:10px">
<br><br>
<table align=center>
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table width=400 border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=18 class=barmsg><bean:message key="return.systemInfo"/></td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td>
									<br><bean:message key="return.title"/><br>
									<br style="font-size:10px">
									<%= msgWriter.DrawTitle(false) %>
									<br style="font-size:10px">
									<%= msgWriter.DrawMessages() %>
									<div align=center>
										<%= msgWriter.DrawButton() %>
									</div>
									<br style="font-size:10px">
								</td>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
	</tr>
</table>
<br><br>
</BODY>
</html>