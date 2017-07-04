<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
 
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<script type="text/javascript">
	Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
	Com_IncludeFile("validation.js|plugin.js|eventbus.js|xform.js", null, "js");
</script>
<script type="text/javascript">

function showWord(){
		$("#div1").show();
		$("body").css({
		position:"absolute",
		filter:"alpha(style=0,opacity=50)",
		background:"#DDD"
		});
 } 
</script>
   <style type="text/css">
            #test {
                width:200px;
                height:60px;
                background:#ccc;
                display:none;
                position:absolute;
                left:40%;
                top:40%;
            }
        </style>
</head>
<body>
 
 

<% if(request.getAttribute("KMSS_RETURNPAGE")==null){ %>
<logic:messagesPresent>
	<table align=center><tr><td>
		<font class="txtstrong"><bean:message key="errors.header.vali"/></font>
		<bean:message key="errors.header.correct"/>
		<html:messages id="error">
			<br><img src='${KMSS_Parameter_StylePath}msg/dot.gif'>&nbsp;&nbsp;<bean:write name="error"/>
		</html:messages>
	</td></tr></table>
	 
</logic:messagesPresent>
<% }else{
	KmssMessageWriter msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
%>
<script>
Com_IncludeFile("msg.js", "style/"+Com_Parameter.Style+"/msg/");
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
 <div id=div1 style="position:absolute;display:none;top:100px;left:100px;background:#FFF;width:100px;height:100px;">wait...
 <input type=button></div>
<% } %>
 