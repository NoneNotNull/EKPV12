<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<%@ include file="/sys/config/resource/htmlhead.jsp"%>
<%@ page import="
	com.landray.kmss.util.KmssMessages,
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%
try{
	KmssReturnPage rtnPage = KmssReturnPage.getInstance(request);
	KmssMessages msgs = new KmssMessages();
	msgs.addError(exception);
	rtnPage.addMessages(msgs);
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
</head>
<BODY style="margin-left:10px">
<br><br>
<table align=center>
	<tr>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
		<td>
			<table width=400 border=0 cellspacing=1 cellpadding=0 bgcolor=#000033>
				<tr> 
					<td height=18 class=barmsg><kmss:message key="return.systemInfo" /></td>
				</tr>
				<tr>
					<td>
						<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
							<tr>
								<td width=20><img src="${KMSS_Parameter_StylePath}icons/blank.gif" height=1 width=20></td>
								<td>
									<br><kmss:message key="return.title" /><br>
									<br style="font-size:10px">
									
									<br style="font-size:10px">
									<div align=center>
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
<%
}catch(Exception e){
	try{
		if(exception != null){
			e.printStackTrace();
			out.println("<br><br>"+exception);
			out.println("<pre>");
			exception.printStackTrace( new java.io.PrintWriter( out ) );
			out.println("</pre>");
		}
	}catch(Exception ex){
		ex.printStackTrace();
	}
}
%>
</html>