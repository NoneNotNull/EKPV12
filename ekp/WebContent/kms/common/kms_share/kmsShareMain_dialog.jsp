<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>

<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/common/kms_share/style/share_view.css" />
<body>
	<div class="share_toolbar" >
		<!-- 分享项 -->
			<%
				JSONArray shareJSON = (JSONArray)request.getAttribute("shareJson");
				for(int i=0;i<shareJSON.size();i++){
					JSONObject shareInf = (JSONObject)shareJSON.get(i);
					String shareMessageKey = (String)shareInf.get("shareMessageKey");
					request.setAttribute("shareIndex",i);
			%>
				<input id="shareBtn" type="button" onclick="shareSelect('shareModule${shareIndex}',this)" 
						value="<%=shareMessageKey%>" class="share_btn_gray <%if(i==0){%>share_btn_on<%} %>">
			<% 
				}
			%>
	</div>
	
	<div id="shareGroup">
		<%
			JSONArray shareJson = (JSONArray)request.getAttribute("shareJson");
			for(int j=0;j<shareJson.size();j++){
				JSONObject shareInfo = (JSONObject)shareJson.get(j);
				String pageUrl = (String)shareInfo.get("pageUrl");
				String shareModelName = (String)shareInfo.get("shareModelName");
				String fdModelId = (String)shareInfo.get("shareModelId");
				String categoryModelName = (String)shareInfo.get("categoryModelName");
		%>
			<div id="shareModule<%=j%>"  <%if(j!=0){%> style="display: none;" <%}%>>
				<c:import url="<%=pageUrl%>" charEncoding="UTF-8" >
					<c:param name="fdModelId" value="<%=fdModelId%>" />
					<c:param name="fdModelName" value="<%=shareModelName%>" />
				</c:import>
			</div>
		<%
			}
		%>
	</div>
</body>
<script>
	window.iframeHeight = parent.$("div[class='lui_dialog_content']").css("height");
	function shareSelect(localId,thisObj){
		$("#shareGroup>div").hide();
		$("#"+localId).show();

		$("input[id='shareBtn']").removeClass("share_btn_on");
		$(thisObj).addClass("share_btn_on");;
		
		var dialogContent = parent.$("div[class='lui_dialog_content']");
		if("shareModule1" == localId){
			dialogContent.css("height","330px");
		}else{
			parent.$("div[class='lui_dialog_content']").css("height",window.iframeHeight);
		}
	}
</script>