<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%
KmssMessageWriter msgWriter = null;
if(request.getAttribute("KMSS_RETURNPAGE")!=null){
	msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
}else{
	msgWriter = new KmssMessageWriter(request, null);
}
	if(request.getHeader("accept")!=null){
		if(request.getHeader("accept").indexOf("application/json") >=0){
			out.write(msgWriter.DrawJsonMessage(false).toString());
			return;
		}
	}
	response.setHeader("lui-status","true");
%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.message">
	<template:replace name="title">${lfn:message('return.systemInfo') }</template:replace>
	<template:replace name="head">
		<script>
			function showMoreErrInfo(index, spanObj){
				var obj = document.getElementById("moreErrInfo"+index);
				if(obj!=null){
					if(obj.style.display=="none"){
						obj.style.display="block";
						spanObj.setAttribute('class','showMoreError_minus');
					}else{
						obj.style.display="none";
						spanObj.setAttribute('class','showMoreError_plus');
					}
				}
			}
			function refreshNotify(){
				try{
					if(window.opener!=null) {
						try {
							if (window.opener.LUI) {
								window.opener.LUI.fire({ type: "topic", name: "successReloadPage" });
								return;
							}
						} catch(e) {}
						if (window.LUI) {
							LUI.fire({ type: "topic", name: "successReloadPage" }, window.opener);
						}
						var hrefUrl= window.opener.location.href;
						var localUrl = location.href;
						if(hrefUrl.indexOf("/sys/notify/")>-1 && localUrl.indexOf("/sys/notify/")==-1)
							window.opener.location.reload();
					} else if(window.frameElement && window.frameElement.tagName=="IFRAME" && window.parent){
						if (window.parent.LUI) {
							window.parent.LUI.fire({ type: "topic", name: "successReloadPage" });
						}
					}
				}catch(e){}
			}
			var time = 0;
			var intvalId =null;
			function timeInteval(){
				var _timeArea = document.getElementById("_timeArea");
				if(time==2){
					Com_CloseWindow();
					return;
				}
				_timeArea.innerHTML = "<bean:message key="return.autoClose"/>".replace('{0}', 2 - time);
				time =time+1;
				intvalId=setTimeout("timeInteval()",1000);
			}
		</script>
	</template:replace>
	<template:replace name="body">
		<div class="prompt_frame">
			<div class="prompt_centerL">
				<div class="prompt_centerR">
					<div class="prompt_centerC">
						<div class="prompt_container clearfloat">
							<div class="prompt_content_success"></div>
							<div class="prompt_content_right">
								<div class="prompt_content_inside">
									<bean:message key="return.title" />
									<%=msgWriter.DrawTitle(false)%>
									<%=msgWriter.DrawMessages()%>
									<span id="_timeArea" class="prompt_content_timer"></span>
								</div>
								<div class="prompt_buttons clearfloat">
									<%=msgWriter.DrawButton()%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</template:replace>
</template:include>
<script>
	Com_AddEventListener(window,"load",refreshNotify);
	<c:if test="${'false'!=SUCCESS_PAGE_AUTO_CLOSE}">
		Com_AddEventListener(window,"load",function(){
			var parentObj=window.parent.document.getElementsByName("viewFrame")[0];
			if(parentObj){
				
			}else{
				timeInteval();
			}
		});
	</c:if>
</script>


