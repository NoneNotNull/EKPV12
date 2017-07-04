<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<% 
	String docCreatorId = UserUtil.getUser().getFdId();
	if(!docCreatorId.equals(request.getParameter("fdOrgId"))){
		pageContext.setAttribute("who", "other");
	}else{
		pageContext.setAttribute("who", "me");
	}
%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super />
		<script>
			seajs.use(['theme!list']);
		</script>
	</template:replace>
	<template:replace name="body">
		<div id="wiki_content">
			<%--当前专家是本人 --%>
			<c:if test="${ who =='me' }">
				<c:import url="/kms/wiki/kms_wiki_personal/kmsWikiMain_my.jsp" charEncoding="UTF-8">
				</c:import>
			</c:if>
			<%--当前专家非本人 --%>
			<c:if test="${ who =='other' }">
				<c:import url="/kms/wiki/kms_wiki_personal/kmsWikiMain_other.jsp" charEncoding="UTF-8">
					<c:param name="userId" value="${param.fdOrgId}"></c:param>
				</c:import>
			</c:if>
		</div>
	</template:replace>
</template:include>
<script>
	window.onload = function() {
		setInterval("resizeParent();", 100);
	};
	function resizeParent() {
		try {
			// 调整高度
			var height = LUI.$('#wiki_content').height();
			var iFrame = window.parent.document.getElementById("___content");
			iFrame.style.height = height + "px";
		} catch (e) {
		}
	}
</script>