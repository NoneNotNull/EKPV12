<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.StringUtil"%>
<%@ include file="/resource/jsp/index_top.jsp"%>
<%
	String[] keys = new String[]{"http:","https:","javascript:","vbscript:"};
	String[] param = new String[]{"nav","main"};
	for(String p : param){
		String v = request.getParameter(p);
		if(StringUtil.isNotNull(v)){
			for(String k : keys){
				if(v.toLowerCase().startsWith(k)){
					throw new RuntimeException("提交的数据包含非法字符");
				}
			}
		}
	}
%>
<script type="text/javascript">
	Com_IncludeFile("data.js");
	window.onload = function(){
		var KMSS_Style = "${KMSS_Parameter_Style}";
		var mainUrl = "${param.main}";
		var viewFrameObj = document.getElementsByName("viewFrame")[0];
		if(viewFrameObj==null){
			return;
		}
		var prifix = "s_path=!{message(";
		var postfix = ")}";
		if(mainUrl == ""){
			mainUrl = "";
			viewFrameObj.src = "";
		}else{
  			if(mainUrl.indexOf('?')>-1){
  				mainUrl += "&s_css=";
  			}
  			else{
  				mainUrl += "?s_css=";
  			}	
  			mainUrl += KMSS_Style;
			if(mainUrl.indexOf(prifix)>-1){
	  			var startIndex = mainUrl.indexOf(prifix);
	  			var endIndex = mainUrl.indexOf(postfix);
	  			var key=mainUrl.substring(startIndex+17, endIndex);
	  			val = Data_GetResourceString(key);
	  	  		val = encodeURI(val);
	  	  		mainUrl = mainUrl.replace(prifix + key + postfix, "s_path=" + val);
			}
			var cxPath = "${KMSS_Parameter_ContextPath}";
			viewFrameObj.src = cxPath.substring(0, cxPath.length-1) + mainUrl;
		}
	}
</script>

</head>
<frameset name="mainFrameset" frameborder=0 border=0 rows="0,*">
  <frame name="topFrame" noresize scrolling=no src="">
  <frameset name="downFrameset" frameborder=0 border=0 cols="180,8,0,0,*">
    <frame name="treeFrame" src="<c:url value="${param.nav}"/>">
    <frame name="ctrlFrame1" noresize scrolling=no src="${KMSS_Parameter_StylePath}ctrlframe/varrowpage1.html">
    <frame name="orgFrame" src="">
    <frame name="ctrlFrame2" noresize scrolling=no src="${KMSS_Parameter_StylePath}ctrlframe/varrowpage2.html">
    <frameset name="rightFrameset" frameborder=0 border=0 rows="*,0,0">
    	<frame name="viewFrame" src="" id="viewFrameObj">
    	<frame name="ctrlFrame3" noresize scrolling=no src="${KMSS_Parameter_StylePath}ctrlframe/harrowpage.html">
    	<frame name="docFrame" src="">
    </frameset>
  </frameset>
</frameset>
</html>