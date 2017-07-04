<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@page import="com.landray.kmss.sys.task.model.SysTaskMain"%>
<script type="text/javascript">
//项目协作其他浏览器中自适应高度用
window.onload =function (){
	setTimeout(dyniFrameSize,100);
}; 
	function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementsByTagName("table")[0];
		if (arguObj != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
			window.frameElement.style.height = (arguObj.offsetHeight + 40) + "px";
		}
	} catch (e) {}
};
</script>
<html:form action="/sys/task/sys_task_main/sysTaskMain.do">
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName" value="com.landray.kmss.sys.task.model.SysTaskMain" />
</c:import>
	<div id="optBarDiv">		
		<kmss:auth requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/task/sys_task_main/sysTaskMain.do" />?method=add&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}');">
		</kmss:auth>
		<c:if test = "${param.flag != 0}">
		<kmss:auth requestURL = "/sys/task/sys_task_main/sysTaskMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysTaskMainForm, 'deleteall');">
		</kmss:auth>
		</c:if>
	<input  type="button" value="<bean:message key="button.search"/>" onclick="Search_Show();">		
	</div>
	<%@ include file="/sys/task/sys_task_main/sysTaskMain_list_content.jsp"%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>