<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage,
	java.util.List" %>
<%
KmssMessageWriter msgWriter = null;
if(request.getAttribute("KMSS_RETURNPAGE")!=null){
	msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
}else{
	msgWriter = new KmssMessageWriter(request, null);
}

	if(request.getHeader("accept")!=null){
		if(request.getHeader("accept").indexOf("application/json") >=0){
			out.write("{\"status\":false}");
			msgWriter.DrawMessages();
			return;
		}
	}
%>
<template:include ref="default.message">
	<template:replace name="title">${lfn:message('return.systemInfo') }</template:replace>
	<template:replace name="body">
		<div class="prompt_frame">
			<div class="prompt_centerL">
				<div class="prompt_centerR">
					<div class="prompt_centerC">
						<div class="prompt_container clearfloat">
							<div>
								<div class="prompt_content_error"></div>
								<div class="prompt_content_right">
									<div class="prompt_content_inside">
										<bean:message key="return.title" />
										<div class="msgtitle">${lfn:message('global.accessDenied') }</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</template:replace>
</template:include>
