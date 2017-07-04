<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="org.apache.struts.util.MessageResources"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
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
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
function upload(){
	var upload_form = document.getElementsByName("uploadForm")[0];
	document.getElementById("upload_table").style.display="none";
	document.getElementById("bar").style.display="block";	
	Com_Submit(upload_form);
	checkLinkPathLoaded();

}
function checkLinkPathLoaded(){
					if ( 	asynch == null || 
					asynch.document == null || 
					asynch.document.body == null ||
					typeof asynch.document.body.innerHTML == "undefined" ||
					asynch.document.body.innerHTML == "" ||
					asynch.Com_Parameter == null ||
					asynch.Com_Parameter.Loaded != true 
					)
				{
			    	window.setTimeout("checkLinkPathLoaded()", 100);
					return;
				}
				//document.getElementById("mainDiv").style.display="none";
				//document.getElementById("iframeTable").style.display="block";
				//document.body.innerHTML = asynch.document.documentElement.innerHTML;
				var mainDiv = document.getElementById("mainDiv");
				mainDiv.style.display="none";
				var ifTable = document.getElementById("iframeTable");
				ifTable.style.display="block";
				ifTable.style.width="100%";
				ifTable.style.height="100%";
				
				//document.write("<html>"+asynch.document.documentElement.innerHTML+"</html>");
}
</script>

</head>
<body>
<div id="mainDiv">
<br>
<html:form action="/sys/common/upload.do"  method="post" enctype="multipart/form-data" target="asynch">

<div class="txttitle"><bean:message key="common.fileUpLoad.title"/></div>
<center>
<div  id="upload_table">
<table class="tb_normal" width=95%>
	<tr>
		<td width=15% class="td_normal_title">
			<bean:message key="common.fileUpLoad.selectFile"/>
		</td><td width=35%>
			<html:file property="file"  styleClass="upload"/>
			<span class="txtstrong">*</span>
		</td>
		
	</tr>

		
<%

java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("ApplicationResources",request.getLocale());
String msg = bundle.getString(request.getParameter("messageKey"));
if(msg != null) out.print(msg);

%>
</table>
		<input type=button value="<bean:message key="common.fileUpLoad.upload"/>"
			onclick="upload();">
</div>
<div id="bar" style="display:none">
<bean:message key="common.wait"/><br/>
<img src="${KMSS_Parameter_StylePath}icons/wait.gif">
</div>
</center>

</html:form>
</div>
<table id="iframeTable" style="display:none;width:100%;height:100%" border=0 cellpadding=0 cellspacing=0>
  <tr>
    <td><iframe id="asynch" name="asynch" width=100% height=100%></td>
  </tr>
</table>
</body>
</html>